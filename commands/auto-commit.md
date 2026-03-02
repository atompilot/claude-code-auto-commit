---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(git commit:*), Bash(git push:*), Bash(git log:*), Bash(git branch:*), Bash(cat VERSION), Bash(printf:*:>:VERSION)
description: Auto-stage, generate conventional commit message, optional semantic versioning, and push
---

## Context

- Current git status: !`git status`
- Staged and unstaged changes: !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits (for style reference): !`git log --oneline -10`
- Project commit conventions (if any): !`head -100 CLAUDE.md 2>/dev/null || echo "No CLAUDE.md found"`

## Your Task

Perform a complete git commit workflow following the steps below.

You MUST do all of the above in a single message with only tool calls. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.

### Step 1: Validate Environment

- Confirm this is a git repository (the context above should show git info; if it shows errors, stop and inform the user).
- If `git status` shows "nothing to commit, working tree clean", stop and inform the user there is nothing to commit.

### Step 2: Safety Check

Before staging, check `git status` output for potentially sensitive files:
- `.env`, `.env.*`
- `*.pem`, `*.key`, `*.p12`, `*.pfx`
- `*credentials*`, `*secret*`, `*token*`
- `id_rsa`, `id_ed25519`

If any untracked or modified files match these patterns, **stop and warn the user**. List the suspicious files and ask whether to proceed. Do NOT stage or commit them automatically.

### Step 3: Stage All Changes

Run `git add -A` to stage all changes (new, modified, deleted files).

### Step 4: Analyze Changes

Use the pre-fetched `git diff HEAD` from the context above (do NOT run `git diff --cached` again — the context already contains it). Run only `git diff --cached --stat` for a summary of affected files.

Determine:

1. **Commit type** — choose the most appropriate:
   - `feat`: new feature or capability
   - `fix`: bug fix
   - `refactor`: code restructuring without behavior change
   - `docs`: documentation only
   - `style`: formatting, whitespace, semicolons (no logic change)
   - `test`: adding or updating tests
   - `chore`: build, CI, dependencies, tooling
   - `perf`: performance improvement

2. **Commit subject** — a concise summary (<=72 chars) in imperative mood ("add X" not "added X"). Write the subject in the language matching the repository's existing commit history (check the recent commits from context). If no prior commits exist, use English.

3. **Commit body** (optional) — if the change is complex, add bullet points explaining the key changes.

If CLAUDE.md defines commit message conventions (e.g., format, scope, language), follow those conventions instead of the defaults described above.

### Step 5: Semantic Versioning (Optional)

Check if a `VERSION` file exists in the project root.

- **If VERSION exists**, read it and bump the version:
  - **major** (X.0.0): breaking changes, core architecture rewrites, incompatible API changes
  - **minor** (x.Y.0): `feat` type commits, new files/modules added
  - **patch** (x.y.Z): `fix`, `refactor`, `docs`, `style`, `test`, `chore`, `perf`
  - User may pass `$ARGUMENTS` with `--major`, `--minor`, or `--patch` to force a specific bump level.
  - Write the new version back to `VERSION` using `printf '%s\n' '<new_version>' > VERSION` and stage it with `git add VERSION`.

- **If VERSION does not exist**, skip this step entirely.

### Step 6: Create the Commit

Format the commit message:

**If VERSION was updated:**
```
<type>: <subject> (v<new_version>)

[optional body]

Co-Authored-By: Claude <noreply@anthropic.com>
```

**If no VERSION file:**
```
<type>: <subject>

[optional body]

Co-Authored-By: Claude <noreply@anthropic.com>
```

Create the commit using `git commit -m "$(cat <<'EOF'
<full commit message>
EOF
)"`.

### Step 7: Push to Remote

If `$ARGUMENTS` contains `--no-push`, skip this step and report that the commit was created locally.

Otherwise:

Run `git push origin <current_branch>`.

- If push succeeds, report success.
- If push fails due to remote changes, suggest `git pull --rebase origin <branch>` first.
- If push fails due to no upstream, suggest `git push -u origin <branch>`.
- If there is no remote configured, just report the commit was created locally.
