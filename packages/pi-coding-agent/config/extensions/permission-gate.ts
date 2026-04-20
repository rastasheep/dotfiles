/**
 * Permission Gate Extension
 *
 * Prompts for confirmation before running potentially dangerous commands.
 * Customized for rastasheep's dotfiles with extended patterns including git operations.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	const destructivePatterns = [
		// File system operations
		/\brm\s+(-[rf]+|--recursive|--force)/i,
		/\bdd\b/i,
		/\bmkfs\./i,
		/\bfdisk\b/i,
		
		// Permissions
		/\bsudo\b/i,
		/\b(chmod|chown)\b.*777/i,
		
		// Process management
		/\bkill\s+-9/i,
		/\bpkill\b/i,
		
		// Git operations (require approval)
		/\bgit\s+commit\b/i,
		/\bgit\s+push\s+(--force|-f)\b/i,
		/\bgit\s+reset\s+--hard\b/i,
		/\bgit\s+clean\s+-[fd]/i,
		/\bgit\s+rebase\s+--continue\b/i,
		
		// Package managers
		/\bnpm\s+(uninstall|remove)\s+-g\b/i,
		/\bbrew\s+uninstall\b/i,
		/\bnix\s+profile\s+remove\b/i,
		
		// System configuration (macOS)
		/\bdefaults\s+write\b/i,
	];

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;

		const command = event.input.command as string;
		const isDangerous = destructivePatterns.some((p) => p.test(command));

		if (isDangerous) {
			if (!ctx.hasUI) {
				// In non-interactive mode, block by default
				return { block: true, reason: "Potentially destructive command blocked (no UI for confirmation)" };
			}

			const choice = await ctx.ui.select(
				`⚠️  Potentially destructive command:\n\n  ${command}\n\nAllow execution?`,
				["Yes, execute", "No, block"]
			);

			if (choice !== "Yes, execute") {
				ctx.ui.notify("Command blocked by user", "info");
				return { block: true, reason: "Blocked by user" };
			}
			
			ctx.ui.notify("Command approved", "success");
		}

		return undefined;
	});
}
