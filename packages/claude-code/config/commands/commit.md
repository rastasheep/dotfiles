Intelligently organize git add and commit operations by unit/feature with similar purpose

# Context
Git repository with staged and/or unstaged changes to commit:
$ARGUMENTS

# Requirements
1. **Change Analysis**: Analyze current git repository state:
   - Parse `git status` output for staged/unstaged files
   - Use `git diff` to understand change content and scope
   - Identify file types, domains, and architectural layers
   - Detect related changes that should be grouped together

2. **Logical Grouping**: Group changes by logical units:
   - **Domain/Feature boundaries**: Changes within same business domain
   - **Architectural layers**: API, UseCase, Infrastructure, Model layers
   - **Change types**: New features, bug fixes, refactoring, configuration
   - **Dependencies**: Changes that depend on each other
   - **Scope isolation**: Separate concerns (tests, docs, config, core logic)

3. **Commit Message Generation**: Create meaningful commit messages:
   - Use conventional commit format: `type(scope): description`
   - Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `config`
   - Include scope based on domain/module affected
   - Focus on "why" rather than "what" in descriptions
   - Keep first line under 50 characters, detailed explanation if needed

4. **Safety and Validation**: Ensure clean commit history:
   - Preview all changes before executing
   - Validate no conflicts between grouped changes
   - Provide rollback instructions
   - Suggest testing strategy between commits

# Output Format
## Repository Analysis
[Current git status summary and change overview]

## Change Grouping Strategy
[Explanation of how changes will be grouped and why]

## Proposed Commit Sequence
### Commit 1: [Type and brief description]
**Files to add:**
- `file1.ext` - [brief description of changes]
- `file2.ext` - [brief description of changes]

**Commit message:**
```
type(scope): brief description

Optional detailed explanation of why this change
was made and its impact.
```

**Git commands:**
```bash
git add file1.ext file2.ext
git commit -m "type(scope): brief description

Optional detailed explanation of why this change
was made and its impact."
```

[Repeat for each logical commit]

## Execution Plan
1. **Preview**: Review all proposed changes
2. **Execute**: Run git commands in sequence
3. **Validate**: Test after each commit (if applicable)
4. **Rollback**: Instructions if issues arise

## Validation Strategy
[How to test changes after each commit]

## Rollback Procedure
[Instructions to undo commits if problems occur]

# Usage Examples
- `/commit` - Analyze current repository state and propose commit structure
- `/commit "focus on user authentication feature"` - Group commits around specific feature
- `/commit --preview` - Show analysis without executing commands
