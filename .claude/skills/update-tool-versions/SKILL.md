---
name: update-tool-versions
description: Upgrade the pinned CLI tool versions in ~/.local/bin/install_software.sh to their latest upstream releases, or add a new tool to it. Use when asked to "upgrade everything", "update the tools", "bump versions", "check for new versions", or to "install <tool> latest" in that script.
---

# Update tool versions in install_software.sh

Target file: `~/.local/bin/install_software.sh`. It pins each tool to a version
variable, installs into `/usr/local/bin/<tool>-<version>`, and flips a symlink.
Helper `install_from_archive.sh` (at `/usr/local/bin/`) takes
`<url> <path-inside-archive> <dest>`; `install_from_url` in the script itself
fetches a bare binary.

Every pin carries a `# renovate:` annotation naming its datasource — that
annotation is what tells you where to look the version up. Renovate also manages
this file, so mention that manual bumps may collide with an open Renovate PR.

## Procedure

**1. Collect the pins.** Read the file with the Read tool (do not grep/awk it —
the pin block is short). Note each `_VERSION` variable, its current value, and
the `datasource=`/`depName=` on the line above.

**2. Look up latest.** Never answer from memory — these are external services.
Batch the lookups into as few parallel Bash calls as possible.

| Annotation | Command |
|---|---|
| `datasource=golang-version` | `curl -sSL "https://go.dev/dl/?mode=json" \| jq -r '[.[]\|select(.stable==true)][0].version'` |
| `datasource=github-releases depName=O/R` | `curl -sSL "https://api.github.com/repos/O/R/releases/latest" \| jq -r .tag_name` |

Two pins lie about their source and need a different endpoint:

- **kubectl** (`depName=kubernetes/kubectl`): that repo publishes no releases.
  Use `curl -sSL https://dl.k8s.io/release/stable.txt`.
- **node** (`depName=nodejs/node`): binaries come from nodejs.org, not GitHub.
  Latest: `curl -sSL https://nodejs.org/dist/index.json | jq -r '.[0].version'`.
  Latest LTS: `... | jq -r '[.[]|select(.lts != false)][0].version'`.

Strip the leading `v`/`go` when writing the value back — the script adds any
prefix the URL needs. Quote every URL containing `?`; zsh globs it otherwise.

**3. Report, then ask about the judgment calls.** Show a table of
current → latest, listing unchanged tools separately so the real diff is
visible. Before editing, use AskUserQuestion for:

- **Any major-version jump** (breaking changes), and
- **Any pin deliberately held back.** Check `git log` for intent. Helm is the
  standing example: commit "Downgrade Helm to 3.x" means Helm stays on the
  latest **3.x**, not the latest overall. Get the 3.x tag with
  `curl -sSL "https://api.github.com/repos/helm/helm/releases?per_page=100" | jq -r '[.[]|select(.prerelease==false)|.tag_name|select(startswith("v3."))][0]'`.
- **Node**, where "latest" and "latest LTS" differ — offer both.

**4. Edit** only the version values, one Edit per pin. Nothing else changes.

**5. Verify** with `bash -n ~/.local/bin/install_software.sh`, then spot-check
one changed URL resolves, e.g.
`curl -sSIL -o /dev/null -w '%{http_code}\n' "<url>"` (expect 200).

## Adding a new tool

Match the surrounding style exactly; add it in four places, in file order:

1. The pin, with a `# renovate:` annotation, grouped with related tools.
2. An `install_<tool>()` function — copy the nearest structural sibling
   (`install_skopeo` for a bare binary, `install_cilium` for a `.tar.gz`).
   Keep the `if ! [ -f ... ]` guard and trailing `ln -sfn`.
3. The no-arg install list.
4. The `case "$1"` dispatcher.

Confirm the real asset names before writing the URL — the tag and the filename
often disagree:

```
curl -sSL "https://api.github.com/repos/O/R/releases/latest" | jq -r '.tag_name, (.assets[].name)'
```

Seen in practice: `just` tags without a `v` at all; `kubeseal` tags `v0.38.4`
but names the file `kubeseal-0.38.4-<os>-<arch>.tar.gz`. The script's `$GOOS`
and `$GOARCH` are Go-style (`darwin`/`linux`, `amd64`/`arm64`) — tools using
other spellings (`x64`, `aarch64`, `apple-darwin`, or raw `uname` output) need
their own local `case` block, as `install_node`, `install_just`, and
`install_k9s` each do.
