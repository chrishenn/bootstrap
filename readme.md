# mise bootstrap

Note: only 'desktop' linux and windows are set up as the default profile so far.

This bootstrap project needs to merge with chrishenn/homelab/aurora, with appropriate flags to choose linux, windows, 
server, and desktop configuration chunks. See the 'todo' section below.

---

bash 

```bash
rm -rf ~/.local/share/mise/bootstrap-repo
mise use -g gh op
export OP_SERVICE_ACCOUNT_TOKEN=value
mise bootstrap -E aurora --from git@github.com:chrishenn/bootstrap.git --skip-dirty --update -y --from-dir ~/Projects/bootstrap
```

pwsh

```pwsh
scoop install mise
mise use -g gh op
echo 'env = ["windows"]' > ~/.config/mise/miserc.local.toml
$env:OP_SERVICE_ACCOUNT_TOKEN = value
mise bootstrap -E windows --from git@github.com:chrishenn/bootstrap.git --skip-dirty --update -y --from-dir ~/Projects/bootstrap
```

general

```bash
mise bootstrap dotfiles apply -y
mise bootstrap -E aurora --skip-dirty -y
mbd apply -y -E aurora
```

---

# todo

- mise bootstrap a windows machine: setup system files
    - github keys into C:\ProgramData\ssh\administrators_authorized_keys
    - https://github.com/chrishenn/dotfiles/blob/main/home/.chezmoiscripts/windows/run_onchange_keys.ps1.tmpl
- bootstrap from repo, set diff profiles for linux/windows, desktop/server, pass from cli
    - https://github.com/bassemkaroui/.dotfiles-mise/
    - https://github.com/cicorias/mise-bootstrap/
    - https://github.com/jensdev/mise-bootstrap/
    - format the bootstrap project such that those 'global mise config settings' warnings don't show on bootstrap 
    - merge aurora bootstrap mise.toml into some 'linux+desktop+fedora' dotfiles setup
        - may be too many switches for cli
- bootstrap windows with 'mise bootstrap remote'
- add formatters
