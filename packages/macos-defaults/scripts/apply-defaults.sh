#!/usr/bin/env bash
#
# macOS Defaults Apply Script
# Applies system defaults configuration with proper error handling
#
# Environment variables:
#   DRY_RUN=1     - Show what would be done without making changes
#   VERBOSE=1     - Show detailed output for each setting

set -euo pipefail

readonly SCRIPT_NAME=$(basename "$0")
readonly DRY_RUN=${DRY_RUN:-0}
readonly VERBOSE=${VERBOSE:-0}

if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m'  # No Color
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly NC=''
fi

declare -i SUCCESS_COUNT=0
declare -i FAIL_COUNT=0
declare -i TOTAL_COUNT=0

log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_verbose() {
    if [[ $VERBOSE -eq 1 ]]; then
        echo -e "${BLUE}[DEBUG]${NC} $*"
    fi
}

validate_platform() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This script only runs on macOS"
        exit 1
    fi
    log_verbose "Platform check: macOS ✓"
}

check_dependencies() {
    if ! command -v defaults &> /dev/null; then
        log_error "defaults command not found"
        exit 1
    fi
    log_verbose "Dependencies check: defaults command ✓"
}

# Apply a single setting with error handling
# Args: $1=domain $2=key $3=type_flag $4=value
apply_setting() {
    local domain=$1
    local key=$2
    local type_flag=$3
    shift 3
    local value="$*"

    TOTAL_COUNT=$((TOTAL_COUNT + 1))

    log_verbose "Setting ${domain} ${key} ${type_flag} ${value}"

    if [[ $DRY_RUN -eq 1 ]]; then
        echo "  Would run: defaults write ${domain} ${key} ${type_flag} ${value}"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        return 0
    fi

    if defaults write "${domain}" "${key}" "${type_flag}" ${value} 2>/dev/null; then
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        return 0
    else
        log_warn "Failed to set ${domain}.${key}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        return 1
    fi
}

restart_services() {
    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Would restart system services (Dock, Finder, SystemUIServer)"
        return 0
    fi

    log_info "Restarting affected services..."

    local services=("Dock" "Finder" "SystemUIServer")
    local restarted=0

    for service in "${services[@]}"; do
        if killall "${service}" 2>/dev/null; then
            log_verbose "Restarted ${service}"
            restarted=$((restarted + 1))
        else
            log_verbose "${service} not running or could not be restarted"
        fi
    done

    if [[ $restarted -eq 0 ]]; then
        log_warn "No services could be restarted"
    else
        log_verbose "Restarted ${restarted}/${#services[@]} services"
    fi
}

print_summary() {
    local failed=$1

    echo ""
    echo "================================================================"
    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "DRY RUN: Would apply ${TOTAL_COUNT} settings"
    else
        log_info "Applied ${SUCCESS_COUNT}/${TOTAL_COUNT} settings successfully"

        if [[ $failed -gt 0 ]]; then
            log_warn "${failed} setting(s) failed to apply"
        fi
    fi
    echo "================================================================"
}

main() {
    if [[ $DRY_RUN -eq 1 ]]; then
        log_info "Running in DRY RUN mode (no changes will be made)"
    fi

    if [[ $VERBOSE -eq 1 ]]; then
        log_info "Verbose mode enabled"
    fi

    log_verbose "Running pre-flight checks..."
    validate_platform
    check_dependencies

    log_info "Applying macOS defaults..."
    echo ""

    # === Commands will be injected here by Nix ===
    @COMMANDS@
    # === End of injected commands ===

    echo ""

    restart_services

    print_summary $FAIL_COUNT

    if [[ $DRY_RUN -eq 0 ]]; then
        log_info "Done! Some changes may require logout/login to take full effect."
    fi

    if [[ $FAIL_COUNT -gt 0 ]]; then
        exit 1
    fi
}

main "$@"
