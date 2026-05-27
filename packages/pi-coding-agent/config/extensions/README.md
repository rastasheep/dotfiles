# Pi Extensions

This directory contains custom extensions for pi coding agent.

## Extensions

### permission-gate.ts

Prompts for confirmation before executing potentially dangerous commands:

**File System:**
- `rm -rf`, `dd`, `mkfs.*`, `fdisk`

**Permissions:**
- `sudo`, `chmod/chown 777`

**Process Management:**
- `kill -9`, `pkill`

**Git Operations:**
- `git commit`
- `git push --force`
- `git reset --hard`
- `git clean -fd`
- `git rebase --continue`

**Package Managers:**
- `npm uninstall -g`, `brew uninstall`, `nix profile remove`

**System Configuration:**
- `defaults write` (macOS)

### protected-paths.ts

Blocks write and edit operations to protected files and directories:
- `.env`, `.env.local`
- `.git/`
- `node_modules/`
- `.ssh/`
- `flake.lock`

### done-bell.ts

Rings a terminal bell when the agent finishes processing:
- Audible notification for task completion
- Only rings in interactive mode with UI
- Only when no pending messages (agent truly finished)
- Only when output is a TTY (terminal)

Useful for long-running tasks when you've switched away from the terminal.

### tag.ts

Tags the last assistant message and allows rewinding to tagged points:
- **Usage:** `/tag [label]` - tags the last assistant message
- **Usage:** `/rewind [label]` - jumps back to a tagged entry without summary
- If no label provided for `/tag`, generates one automatically (e.g., `tag-1234567890`)
- If no label provided for `/rewind`, shows interactive selection dialog
- Tags appear in the tree view for quick navigation to important points
- Rewind navigates without creating a summary (fast, no LLM call)
- Useful for marking checkpoints and quickly returning to them during development

### qna.ts

Extracts questions from assistant responses for review and answering:
- Analyzes the last assistant message for questions
- Uses LLM to identify questions requiring user input
- Presents questions in an interactive list
- Helps ensure no questions are missed in long responses

### handoff.ts

Transfers context to a new focused session:
- **Usage:** `/handoff <goal for new thread>`
- Analyzes current conversation and generates a focused prompt
- Creates new session with generated context
- Prompt appears in editor for review before submission
- Alternative to compaction that preserves what matters for next task

### subagent/

Delegates tasks to specialized subagents with isolated context windows:

**Modes:**
- **Single:** One agent handles one task
- **Parallel:** Multiple agents run concurrently (max 8 tasks, 4 concurrent)
- **Chain:** Sequential execution with `{previous}` placeholder for passing context

**Usage examples:**
```
Use scout to find all authentication code
Run 2 scouts in parallel: one to find models, one to find providers
Use a chain: first have scout find the read tool, then have planner suggest improvements
```

**Workflow commands:**
- `/implement <task>` - scout → planner → worker workflow
- `/scout-and-plan <task>` - scout → planner (no implementation)
- `/implement-and-review <task>` - worker → reviewer → worker workflow

**Sample agents:**
- `scout` - Fast codebase reconnaissance (Haiku)
- `planner` - Implementation planning (Sonnet)
- `reviewer` - Code review (Sonnet)
- `worker` - General-purpose agent (Sonnet)

**Custom agents:**
Create `.md` files in `~/.pi/agent/agents/` with YAML frontmatter:
```markdown
---
name: my-agent
description: What this agent does
tools: read, grep, find, ls
model: claude-haiku-4-5
---

System prompt for the agent goes here.
```

**Security:**
- By default, only loads user-level agents from `~/.pi/agent/agents/`
- Project-level agents (`.pi/agents/`) require `agentScope: "both"` parameter
- Interactive confirmation prompts when using project agents

## Customization

To add or remove patterns:

1. Edit the extension file directly
2. For `permission-gate.ts`, add/remove patterns in the `destructivePatterns` array
3. For `protected-paths.ts`, add/remove paths in the `protectedPaths` array
4. Rebuild dotfiles: `nix profile upgrade aleksandars-mbp`

## Testing

Test the extensions by trying potentially dangerous commands:

```bash
pi
# In chat:
# "Remove this test file with rm -rf /tmp/test"
# "Commit these changes"
# "Write to .env file"
```

You should see confirmation prompts for dangerous operations and blocks for protected paths.

## Disabling Extensions

To temporarily disable an extension, rename it:

```bash
mv ~/.pi/agent/extensions/permission-gate.ts ~/.pi/agent/extensions/permission-gate.ts.disabled
```

## Official Documentation

For more information on pi extensions:
- Extensions: https://shittycodingagent.ai/ (see docs/extensions.md)
- Official examples: Available in pi installation under `examples/extensions/`
