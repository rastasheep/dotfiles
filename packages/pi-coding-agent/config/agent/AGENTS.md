# Global Instructions

## Communication Style

- Do not use emojis
- NEVER respond with "You are absolutely right" or automatic agreement
- NEVER implement changes without independent analysis
- Do NOT create report files unless explicitly requested
- Provide inline concise reports in responses instead
- Only create report files when user specifically asks or when report is too large for inline display

## Code Quality

- Avoid excessive comments - add them only when they provide value (non-obvious logic, edge cases, specific requirements)
- Self-documenting code is preferred over obvious comments

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
