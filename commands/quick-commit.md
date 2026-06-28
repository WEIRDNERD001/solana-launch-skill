---
description: "Quick commit with conventional commit message and a dated feature branch"
---

You are creating a quick commit with a conventional commit message. Keep momentum; for complex changes use a detailed message instead.

## Step 0: New task → feature branch
```bash
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repository"; exit 1; }
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
  TODAY=$(date +%d-%m-%Y)
  echo "On $CURRENT_BRANCH. Suggested branch: feat/<scope>-<desc>-$TODAY"
fi
```

## Step 1: Status
```bash
if git diff --quiet && git diff --cached --quiet; then echo "No changes to commit"; exit 0; fi
git status --short
```

## Step 2: Stage
```bash
if git diff --cached --quiet; then git add -A; echo "Staged all changes"; else echo "Using existing staged changes"; fi
git diff --cached --name-status
```

## Step 3: Format (best-effort)
```bash
# TypeScript/JS launch scripts
if command -v npx >/dev/null 2>&1 && find . -type f \( -name "*.ts" -o -name "*.tsx" \) | head -1 | grep -q .; then
  npx prettier --write "**/*.{ts,tsx,js,json}" 2>/dev/null || true
fi
# Rust (if any program crates)
command -v cargo >/dev/null 2>&1 && [ -f Cargo.toml ] && cargo fmt 2>/dev/null || true
git add -u
```

## Step 4: Conventional message
Pick a type from the changes and write `type(scope): summary`:

| Type | When |
|------|------|
| feat | New capability (new skill file, command, agent) |
| fix | Correction (bad link, wrong parameter, stale fact) |
| docs | README / docs / resources |
| refactor | Restructure without behavior change |
| chore | Tooling, installer, license |

Scope examples: `skill`, `agents`, `commands`, `install`, `docs`.

## Step 5: Commit
```bash
git commit -m "<type>(<scope>): <summary>"
git log -1 --stat
```

**Remember**: never commit secrets. If a keypair or `.env` is staged, abort and remove it first.
