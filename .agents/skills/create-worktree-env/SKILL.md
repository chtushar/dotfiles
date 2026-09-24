---
name: create-worktree-env
description: Create an isolated Git linked worktree and symlink local environment files into it while preserving repository-relative paths. Use when an agent needs to create a worktree for a parallel task, PR fix, or experiment and the checkout must share uncommitted local configuration named .local.env, .env, .env.local, or .dev.vars without copying secret contents.
---

# Create Worktree with Env

Use the bundled script for deterministic worktree creation and environment-file linking.

## Workflow

1. Confirm the source repository and intended branch, target path, and start point.
2. Inspect `git status --short` before creating the worktree. Do not treat unrelated source changes as part of the new task.
3. Run:

   ```bash
   scripts/create-worktree-with-env.sh \
     --source /path/to/repo \
     --branch feat/example \
     --path /path/to/worktrees/example \
     --start-point HEAD
   ```

4. Use `--existing` when checking out an existing branch instead of creating one.
5. Verify the result with `git worktree list` and `find <path> -type l -print`.
6. Report the created worktree and linked filenames. Never print environment-file contents.

## Safety

- Link only files named `.local.env`, `.env`, `.env.local`, or `.dev.vars`.
- Preserve each file's path relative to the source repository.
- Refuse a target inside the source worktree.
- Refuse to overwrite an existing destination, including a different symlink.
- Leave a successfully created worktree in place if linking later fails; report the conflict for manual resolution.
- Before cleanup, confirm the linked worktree is clean. Remove it with `git worktree remove <exact-path>`; do not recursively delete broad paths.

## Script

Read `scripts/create-worktree-with-env.sh --help` for all options. The script supports new and existing branches and a dry-run mode.

To link env files into a worktree that already exists, run `scripts/link-worktree-env.sh --target <path>`. The source defaults to the repository's main worktree. The Herdr `worktree-env` plugin runs this same script on `worktree.created`.
