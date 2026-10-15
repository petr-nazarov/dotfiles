# /devcontainers update

List the devcontainers, then update and recreate the ones the user picks without losing
their data.

## 1. Inventory

```bash
bash ~/.claude/skills/devcontainers/scripts/inventory.sh
```

Columns: name, state, created, home, folder. `home`:

| home | meaning | recreate |
|---|---|---|
| `folder` | `/home/vscode` is in `../.devcontainer-home/<project>` | keeps logins |
| `volume` | older plain volume under `/var/lib/docker` | keeps logins, but move it: `migrate-home.sh` |
| `none` | home is inside the container | **loses logins**: `migrate-home.sh` first |
| `gone` | project folder doesn't exist | stale, nothing to recreate |

If every FrrCode project shows `gone`, the encrypted vault is probably not mounted (`mount-work`).
Say so instead of calling them stale.

## 2. Ask which ones

Always ask with `AskUserQuestion`, `multiSelect: true`. Never pick for the user, even when only one
container fits.

- Options are the containers whose folder exists. Label: project folder relative to `~/Projects`
  (e.g. `clients/tetrisponse/repos`). Description: state, created date, home kind.
- A question holds at most 4 options. With more, split into up to 4 questions grouped by
  parent folder (client), newest first. Past 16, list the rest in text and let the user name them
  through "Other".
- If there are `gone` containers, add one more multiSelect question: which of them to delete.
  Group them by client when there are more than 4 (`Old tadam (4)`).
- Deleting a container means all of it: `docker rm <name>`, then its image
  (`docker inspect <name> -f '{{.Config.Image}}'`, `docker rmi`), its non-home volumes (such as
  `dind-var-lib-docker-*`), and finally `docker image prune -f`. Never delete a
  `devcontainer-homedir-*` volume or `.devcontainer-home/` folder unless the user names it: that
  is the logins.
- Not part of this: the build cache, unused volumes and images of other projects (`docker system
  df`). Report the numbers if they're large, but leave them; volumes there are databases.

## 3. Per selected project, before touching anything

Run these from the project folder (`cd` into the `folder` column). Report all findings together,
then ask once before going on if any of them needs a decision.

1. **Running work.** Anything but the idle processes means someone is using it:
   ```bash
   docker exec <name> ps -eo etime,args --no-headers |
     grep -vE 'docker-init|tee -a /tmp/vscr|socat|sleep infinity|Container started|ps -eo'
   ```
   A `claude`, `zsh`, dev server or build there: ask before recreating. The recreate kills it.
   MCP servers (`npm exec ...`, `uvx ...`) are children of a `claude`; name the `claude`, not each.
2. **Hand-installed packages**, which live outside the home and will be gone:
   ```bash
   bash ~/.claude/skills/devcontainers/scripts/manual-installs.sh <name>
   ```
   It lists apt commands run after the container was created. Anything there that isn't in
   `packages.txt`: offer to add it to `~/dotfiles/.devcontainer/base/packages.txt` (then it comes
   back on every start).
3. **Logins to check afterwards.** Note which exist in the home folder
   (`.claude.json`, `.config/gh/hosts.yml`, `.docker/config.json`, `.config/gcloud`, ...).

## 4. Update the definitions

**Base:** it is a verbatim copy of the dotfiles one. Show `diff -r .devcontainer/base
~/dotfiles/.devcontainer/base` and copy it over (`cp -r ~/dotfiles/.devcontainer/base/.
.devcontainer/base/`). Local files are newer than GitHub, so don't use the README's `degit` line,
unless the user asks for the pushed version.

**Project's `.devcontainer/devcontainer.json`:** it has project-specific lines (an ssh key name,
extra mounts, ports, features), so never overwrite it. Diff it against
`.devcontainer/base/devcontainer.json`, bring in what the base added (new mounts, env, features,
`initializeCommand`), keep everything project-specific, and show the resulting diff.

The home mount line must use `devcontainer-homedir-${devcontainerId}` with the `.devcontainer-home`
device, as in the base. Check the result parses:

```bash
devcontainer read-configuration --workspace-folder . 2>/dev/null | jq '.configuration | {mounts, containerEnv}'
```

## 5. Recreate

| home | command, from the project folder |
|---|---|
| `folder` | `./.devcontainer/base/host-scripts/base.sh --recreate` |
| `volume` / `none` | `./.devcontainer/base/host-scripts/migrate-home.sh` (copies the home out, then recreates) |

Use `base.sh`, not `shell.sh`/`claude.sh`: those open an interactive session afterwards. Run it in
the foreground with a long timeout. The last line is JSON with `"outcome":"success"`.

## 6. Verify

```bash
devcontainer exec --workspace-folder . zsh -lc 'export PATH=$HOME/.local/bin:$PATH
  claude auth status; gh auth status; echo $WAYLAND_DISPLAY; wl-paste -l | head -2'
```

Check every login noted in step 3. A login whose tool is missing (`command not found`) means the
tool was hand-installed: the login file survived, the binary didn't. Add the package (step 3.2),
run `zsh ~/dotfiles/.devcontainer/base/scripts/refresh.sh` inside, and check again.

## Report

Per project: what changed in the definitions, recreated or not, each login checked, anything
lost and how it was restored. Mention uncommitted changes in `~/dotfiles`.

## Common mistakes

- Recreating a `none` container with `base.sh --recreate`: the logins are gone for good.
- Overwriting the project's `devcontainer.json` with the base one: drops its own key and mounts.
- Running from the wrong folder: `base.sh` acts on `.` (the worktree root for `devshell`, not
  a subfolder).
- Treating the dotfiles repo's own container as `none`-unsafe: it bind-mounts the host's `~/.claude`
  and `~/.claude.json`, so the Claude login is on the host. Other tools' logins in it still die.
