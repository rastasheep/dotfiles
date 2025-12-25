#!/usr/bin/env python3
"""
macOS Defaults Management Tool

Drift detection and discovery for macOS system defaults.
Application happens automatically through Nix package installation.
"""

import subprocess
import json
import sys
import re
from pathlib import Path
from typing import Optional, Dict, Any, List, Tuple
from dataclasses import dataclass
from enum import Enum

# Config path injected at build time
CONFIG_PATH = "CONFIG_PATH_PLACEHOLDER"

class ValueType(Enum):
    """Supported macOS defaults value types"""
    BOOL = "bool"
    INT = "int"
    FLOAT = "float"
    STRING = "string"
    ARRAY = "array"
    DICT = "dict"

@dataclass
class Setting:
    """Represents a single macOS default setting"""
    domain: str
    key: str
    value: Any
    value_type: ValueType
    description: str = ""

class ConfigLoader:
    """Handles loading and parsing configuration from Nix store"""

    @staticmethod
    def load(config_path: str = CONFIG_PATH) -> Dict[str, Dict[str, Setting]]:
        """Load configuration from JSON file"""
        try:
            with open(config_path) as f:
                data = json.load(f)

            config = {}
            for domain, settings in data.get("domains", {}).items():
                config[domain] = {}
                for key, meta in settings.items():
                    config[domain][key] = Setting(
                        domain=domain,
                        key=key,
                        value=meta["value"],
                        value_type=ValueType(meta["type"]),
                        description=meta.get("description", "")
                    )

            return config
        except FileNotFoundError:
            print(f"Error: Config file not found at {config_path}", file=sys.stderr)
            sys.exit(1)
        except json.JSONDecodeError as e:
            print(f"Error: Invalid JSON in config file: {e}", file=sys.stderr)
            sys.exit(1)
        except Exception as e:
            print(f"Error loading config: {e}", file=sys.stderr)
            sys.exit(1)


class DefaultsReader:
    """Wrapper around the 'defaults' command for reading system settings"""

    @staticmethod
    def read(domain: str, key: str) -> Optional[str]:
        """Read a single setting using defaults read"""
        try:
            result = subprocess.run(
                ["defaults", "read", domain, key],
                capture_output=True,
                text=True,
                check=False,
                timeout=5
            )
            if result.returncode == 0:
                return result.stdout.strip()
            return None
        except subprocess.TimeoutExpired:
            print(f"Warning: Timeout reading {domain}.{key}", file=sys.stderr)
            return None
        except Exception as e:
            print(f"Warning: Error reading {domain}.{key}: {e}", file=sys.stderr)
            return None

    @staticmethod
    def list_domains() -> List[str]:
        """List all available domains"""
        try:
            result = subprocess.run(
                ["defaults", "domains"],
                capture_output=True,
                text=True,
                check=False,
                timeout=10
            )
            if result.returncode == 0:
                return [d.strip() for d in result.stdout.strip().split(',') if d.strip()]
            return []
        except Exception:
            return []

    @staticmethod
    def read_domain(domain: str) -> Optional[str]:
        """Read all settings from a domain"""
        try:
            result = subprocess.run(
                ["defaults", "read", domain],
                capture_output=True,
                text=True,
                check=False,
                timeout=10
            )
            if result.returncode == 0:
                return result.stdout
            return None
        except Exception:
            return None

    @staticmethod
    def extract_keys(domain_output: str) -> List[str]:
        """Extract keys from 'defaults read domain' output"""
        if not domain_output:
            return []
        return list(set(re.findall(r'^\s+([A-Za-z0-9_.-]+)\s*=', domain_output, re.MULTILINE)))

class ValueParser:
    """Parse and normalize defaults values"""

    @staticmethod
    def parse(raw_value: Optional[str], expected_type: ValueType) -> Any:
        """Parse defaults read output based on expected type"""
        if raw_value is None:
            return None

        value = raw_value.strip()

        if expected_type == ValueType.BOOL:
            return value == "1" or value.lower() == "true"

        elif expected_type == ValueType.INT:
            try:
                return int(value)
            except (ValueError, TypeError):
                return None

        elif expected_type == ValueType.FLOAT:
            try:
                return float(value)
            except (ValueError, TypeError):
                return None

        elif expected_type == ValueType.STRING:
            if value.startswith('"') and value.endswith('"'):
                return value[1:-1]
            return value

        elif expected_type == ValueType.ARRAY:
            # Arrays come as (item1, item2, ...) or ()
            if value == "(\n)" or value == "()":
                return []
            try:
                # Try JSON parsing first
                return json.loads(value)
            except (json.JSONDecodeError, ValueError):
                # Return raw value if parsing fails
                return value

        else:  # DICT or unknown
            return value

    @staticmethod
    def detect_type(value_str: str) -> ValueType:
        """Auto-detect value type from defaults output"""
        value_str = value_str.strip()

        # Boolean
        if value_str in ("1", "0", "true", "false", "YES", "NO"):
            return ValueType.BOOL

        # Array
        if value_str.startswith('(') and value_str.endswith(')'):
            return ValueType.ARRAY

        # Dict (with = sign inside)
        if value_str.startswith('{') and value_str.endswith('}') and '=' in value_str:
            return ValueType.DICT

        # Integer
        try:
            int(value_str)
            return ValueType.INT
        except ValueError:
            pass

        # Float
        try:
            float(value_str)
            return ValueType.FLOAT
        except ValueError:
            pass

        # Default to string
        return ValueType.STRING

    @staticmethod
    def compare(expected: Any, actual: Any, value_type: ValueType) -> bool:
        """Compare expected vs actual values, accounting for type differences"""
        if actual is None:
            return False

        # String comparison with normalization
        if value_type == ValueType.STRING:
            exp_str = str(expected).strip().strip('"')
            act_str = str(actual).strip().strip('"')

            # Normalize variable syntax: both $VAR and ${VAR} should match
            dollar_sign = chr(36)
            exp_str = re.sub(r'\$\{([^}]+)\}', dollar_sign + r'\1', exp_str)
            act_str = re.sub(r'\$\{([^}]+)\}', dollar_sign + r'\1', act_str)

            return exp_str == act_str

        # Array comparison
        if value_type == ValueType.ARRAY:
            if isinstance(expected, list) and isinstance(actual, list):
                return expected == actual
            return False

        # Direct comparison for numbers and bools
        return expected == actual


class NixFormatter:
    """Format values as Nix expressions"""

    @staticmethod
    def format_value(value: Any, value_type: ValueType) -> str:
        """Format value for Nix expression"""
        if value_type == ValueType.BOOL:
            if isinstance(value, bool):
                return "true" if value else "false"
            value_str = str(value)
            return "true" if value_str in ("1", "true", "YES") else "false"

        elif value_type == ValueType.INT:
            return str(value)

        elif value_type == ValueType.FLOAT:
            return str(value)

        elif value_type == ValueType.ARRAY:
            if isinstance(value, list):
                if not value:
                    return "[]"
                # Format array items
                items = [NixFormatter._format_array_item(item) for item in value]
                return f'[ {" ".join(items)} ]'
            return "[]"

        elif value_type == ValueType.DICT:
            return "{}"  # Simplified - dict parsing is complex

        else:  # STRING
            # Escape special characters
            escaped = str(value).replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n')
            return f'"{escaped}"'

    @staticmethod
    def _format_array_item(item: Any) -> str:
        """Format a single array item"""
        if isinstance(item, str):
            escaped = item.replace('\\', '\\\\').replace('"', '\\"')
            return f'"{escaped}"'
        elif isinstance(item, bool):
            return "true" if item else "false"
        else:
            return str(item)

    @staticmethod
    def format_setting(domain: str, key: str, value: Any, value_type: ValueType, description: str = "") -> str:
        """Format complete setting definition for Nix"""
        nix_value = NixFormatter.format_value(value, value_type)

        lines = [
            f'      {key} = {{',
            f'        value = {nix_value};',
            f'        type = "{value_type.value}";',
            f'        description = "{description}";',
            f'      }};'
        ]
        return '\n'.join(lines)


class Commands:
    """CLI command implementations"""

    def __init__(self, config: Dict[str, Dict[str, Setting]]):
        self.config = config
        self.reader = DefaultsReader()
        self.parser = ValueParser()
        self.formatter = NixFormatter()

    def check(self) -> int:
        """Check for drift between config and system"""
        drift_count = 0
        print("Checking for configuration drift...\n")

        for domain in sorted(self.config.keys()):
            settings = self.config[domain]
            domain_has_drift = False

            for key in sorted(settings.keys()):
                setting = settings[key]

                raw_actual = self.reader.read(domain, key)
                actual = self.parser.parse(raw_actual, setting.value_type)

                if not self.parser.compare(setting.value, actual, setting.value_type):
                    if not domain_has_drift:
                        print(f"\n{domain}:")
                        domain_has_drift = True

                    print(f"  {key}")
                    print(f"    Expected: {setting.value} ({setting.value_type.value})")
                    print(f"    Actual:   {actual}")
                    drift_count += 1

        print(f"\n{'='*60}")
        if drift_count == 0:
            print("✓ No drift detected. System matches configuration.")
            return 0
        else:
            print(f"✗ Found {drift_count} setting(s) with drift.")
            print("\nTo reapply configuration:")
            print("  nix profile upgrade '.*'")
            print("  # or manually:")
            print("  macos-defaults-apply")
            return 1

    def list(self) -> int:
        """List all configured domains and settings"""
        print("Configured macOS Defaults:\n")
        total = 0

        for domain in sorted(self.config.keys()):
            settings = self.config[domain]
            count = len(settings)
            total += count
            print(f"{domain}: ({count} settings)")

            for key in sorted(settings.keys()):
                setting = settings[key]

                if setting.value_type == ValueType.BOOL:
                    value_str = "true" if setting.value else "false"
                elif setting.value_type == ValueType.ARRAY:
                    if not setting.value:
                        value_str = "[]"
                    elif isinstance(setting.value, list):
                        value_str = f"[{len(setting.value)} items]"
                    else:
                        value_str = str(setting.value)
                elif setting.value_type == ValueType.STRING and len(str(setting.value)) > 40:
                    value_str = str(setting.value)[:37] + "..."
                else:
                    value_str = str(setting.value)

                print(f"  • {key} = {value_str} ({setting.value_type.value})")
                if setting.description:
                    print(f"    {setting.description}")

            print()

        print(f"Total: {total} settings across {len(self.config)} domains")
        return 0

    def export(self, domain_filter: Optional[str] = None) -> int:
        """Export current system settings as nix expression"""
        if domain_filter:
            domains_to_export = [domain_filter]
        else:
            domains_to_export = self.reader.list_domains()
            if not domains_to_export:
                print("Error: Could not list domains", file=sys.stderr)
                return 1

        print("{")
        print("  domains = {")

        exported_count = 0
        for domain in sorted(domains_to_export):
            domain_output = self.reader.read_domain(domain)
            if not domain_output:
                continue

            keys = self.reader.extract_keys(domain_output)
            if not keys:
                continue

            print(f'    "{domain}" = {{')

            for key in sorted(keys):
                # Read individual value
                raw_value = self.reader.read(domain, key)
                if raw_value is not None:
                    value_type = self.parser.detect_type(raw_value)
                    value = self.parser.parse(raw_value, value_type)

                    nix_value = self.formatter.format_value(value, value_type)

                    print(f'      {key} = {{')
                    print(f'        value = {nix_value};')
                    print(f'        type = "{value_type.value}";')
                    print(f'        description = "";')
                    print(f'      }};')
                    exported_count += 1

            print("    };")

            # Limit output if exporting all domains
            if not domain_filter and exported_count > 200:
                print('    # ... output truncated (use domain filter for full export)')
                break

        print("  };")
        print("}")

        if exported_count == 0:
            print("# No settings found", file=sys.stderr)
            return 1

        return 0

    def discover(self, domain_filter: Optional[str] = None) -> int:
        """Find system settings not in config"""
        configured_domains = self.config

        if domain_filter:
            domains_to_scan = [domain_filter]
            print(f"Scanning {domain_filter}...\n")
        else:
            domains_to_scan = self.reader.list_domains()
            if not domains_to_scan:
                print("Error: Could not list domains", file=sys.stderr)
                return 1
            print(f"Scanning {len(domains_to_scan)} domains...\n")

        new_settings_in_tracked = {}
        new_domains = {}

        for domain in domains_to_scan:
            domain_output = self.reader.read_domain(domain)
            if not domain_output:
                continue

            keys = set(self.reader.extract_keys(domain_output))
            if not keys:
                continue

            if domain in configured_domains:
                configured_keys = set(configured_domains[domain].keys())
                new_keys = keys - configured_keys
                if new_keys:
                    new_settings_in_tracked[domain] = sorted(new_keys)
            else:
                new_domains[domain] = sorted(keys)

        total_new = 0

        if new_settings_in_tracked:
            print("New settings in tracked domains:\n")
            for domain in sorted(new_settings_in_tracked.keys()):
                keys = new_settings_in_tracked[domain]
                print(f"  {domain} ({len(keys)} new)")
                for key in keys:
                    if domain_filter:
                        # Show value when filtering by domain
                        raw_value = self.reader.read(domain, key)
                        if raw_value:
                            value = raw_value.strip()
                            # Truncate long values
                            if len(value) > 100:
                                value = value[:97] + "..."
                            # Replace newlines for compact display
                            value = value.replace('\n', ' ')
                            print(f"    • {key} = {value}")
                        else:
                            print(f"    • {key}")
                    else:
                        print(f"    • {key}")
                total_new += len(keys)
            print()

        if new_domains:
            print(f"Untracked domains ({len(new_domains)} domains):\n")
            for domain in sorted(new_domains.keys()):
                keys = new_domains[domain]
                print(f"  {domain} ({len(keys)} settings)")
                # Show setting names and values when filtering by specific domain
                if domain_filter:
                    for key in keys:
                        raw_value = self.reader.read(domain, key)
                        if raw_value:
                            value = raw_value.strip()
                            # Truncate long values
                            if len(value) > 100:
                                value = value[:97] + "..."
                            # Replace newlines for compact display
                            value = value.replace('\n', ' ')
                            print(f"    • {key} = {value}")
                        else:
                            print(f"    • {key}")
                total_new += len(keys)
            print()

        # Summary
        if total_new == 0:
            print("✓ No new settings discovered")
        else:
            print(f"Summary: {total_new} settings in {len(new_settings_in_tracked) + len(new_domains)} domains")
            if new_settings_in_tracked:
                print(f"  • {sum(len(k) for k in new_settings_in_tracked.values())} new settings in tracked domains")
            if new_domains:
                print(f"  • {sum(len(k) for k in new_domains.values())} settings in {len(new_domains)} untracked domains")

        return 0


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: macos-defaults {check|list|export|discover} [domain]")
        print("")
        print("Commands:")
        print("  check              - Show drift between config and system")
        print("  list               - List all configured domains and settings")
        print("  export [domain]    - Export current system settings as nix")
        print("  discover [domain]  - Find settings not in config")
        print("")
        print("Note: To apply settings, use 'macos-defaults-apply' or rebuild your nix profile.")
        sys.exit(1)

    command = sys.argv[1]

    try:
        config = ConfigLoader.load()
    except SystemExit:
        raise
    except Exception as e:
        print(f"Fatal error: {e}", file=sys.stderr)
        sys.exit(1)

    commands = Commands(config)

    command_map = {
        "check": lambda: commands.check(),
        "list": lambda: commands.list(),
        "export": lambda: commands.export(sys.argv[2] if len(sys.argv) > 2 else None),
        "discover": lambda: commands.discover(sys.argv[2] if len(sys.argv) > 2 else None),
    }

    if command not in command_map:
        print(f"Error: Unknown command '{command}'", file=sys.stderr)
        print("Run 'macos-defaults' for usage.", file=sys.stderr)
        sys.exit(1)

    sys.exit(command_map[command]())

if __name__ == "__main__":
    main()
