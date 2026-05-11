/**
 * Entry tagging and rewind extension.
 *
 * Tags mark entries with labels for easy navigation.
 * Rewind lets you jump back to any tagged point without summary.
 *
 * Usage:
 *   /tag [label]   - tag the last assistant message
 *   /rewind [label] - jump to a tagged entry without summary
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("tag", {
    description: "Tag last message (usage: /tag [label])",
    handler: async (args, ctx) => {
      const label = args.trim() || `tag-${Date.now()}`;

      // Find the last assistant message entry
      const entries = ctx.sessionManager.getEntries();
      for (let i = entries.length - 1; i >= 0; i--) {
        const entry = entries[i];
        if (entry.type === "message" && entry.message.role === "assistant") {
          pi.setLabel(entry.id, label);
          ctx.ui.notify(`Tagged as: ${label}`, "info");
          return;
        }
      }

      ctx.ui.notify("No assistant message to tag", "warning");
    },
  });

  pi.registerCommand("rewind", {
    description: "Rewind to a tagged entry (usage: /rewind [label])",
    handler: async (args, ctx) => {
      // Collect all labeled entries
      const labeledEntries: Array<{ id: string; label: string }> = [];
      for (const entry of ctx.sessionManager.getEntries()) {
        const label = ctx.sessionManager.getLabel(entry.id);
        if (label) {
          labeledEntries.push({ id: entry.id, label });
        }
      }

      if (labeledEntries.length === 0) {
        ctx.ui.notify("No tagged entries found", "warning");
        return;
      }

      // If label provided, find exact match
      const requestedLabel = args.trim();
      let targetId: string | null = null;

      if (requestedLabel) {
        const match = labeledEntries.find((e) => e.label === requestedLabel);
        if (match) {
          targetId = match.id;
        } else {
          ctx.ui.notify(`Tag not found: ${requestedLabel}`, "warning");
          return;
        }
      } else {
        // No label provided, show selection dialog
        const choices = labeledEntries.map((e) => e.label);
        const selected = await ctx.ui.select("Select tag to rewind to:", choices);

        if (!selected) {
          return; // User cancelled
        }

        const match = labeledEntries.find((e) => e.label === selected);
        if (match) {
          targetId = match.id;
        }
      }

      if (!targetId) {
        ctx.ui.notify("No target entry selected", "warning");
        return;
      }

      // Navigate to the tagged entry without summary
      await ctx.waitForIdle();
      const result = await ctx.navigateTree(targetId, {
        summarize: false,
      });

      if (result.cancelled) {
        ctx.ui.notify("Rewind cancelled", "warning");
      } else {
        ctx.ui.notify(`Rewound to: ${requestedLabel || targetId}`, "success");
      }
    },
  });
}
