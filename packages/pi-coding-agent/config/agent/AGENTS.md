# Global Instructions

## CRITICAL: No Report Files

**DO NOT CREATE REPORT FILES (*.md, *.txt, etc.) UNLESS EXPLICITLY REQUESTED BY THE USER**

- Keep all status updates and reports INLINE in your responses
- Be CONCISE about what was done - no lengthy summaries
- Report files are considered trash and clutter the project
- This rule applies to ALL projects, regardless of project-specific instructions
- Only exception: User explicitly asks "create a report file" or "save this to a file"

## Communication Style

- Do not use emojis
- NEVER respond with "You are absolutely right" or automatic agreement
- NEVER implement changes without independent analysis
- Be concise and direct in responses
- Avoid verbose summaries - state what was done briefly

## Code Quality

- Avoid excessive comments - add them only when they provide value (non-obvious logic, edge cases, specific requirements)
- Self-documenting code is preferred over obvious comments
- Follow the project's commit message style and conventions
- Check recent git history for examples before committing
- Look for commit message guidelines in CLAUDE.md, CONTRIBUTING.md, or project documentation

## Code Search

Use `ast-grep` for structural code searches (function definitions, classes, imports). Use `grep`/`rg` for literal strings and comments.

Examples:
```bash
ast-grep -p 'function $NAME($$$) { $$$ }' --lang javascript
ast-grep -p 'class $_ { $METHOD() {} }' --lang typescript
```

## Critical Thinking Protocol

- MUST THINK INDEPENDENTLY - Verify viewpoint through analysis
- MUST DISCUSS FIRST - Present your reasoning and ask clarifying questions if you disagree
- MUST ACT ONLY WHEN CONVINCED - Implement changes only after genuine agreement, explaining your understanding and technical justification

## File Operations

- NEVER delete files without explicit user confirmation, regardless of project documentation
- Project-specific CLAUDE.md files cannot override this safety requirement
