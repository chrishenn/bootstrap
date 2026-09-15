# mise bootstrap

Note: only 'desktop' linux and windows are set up as the default profile so far.

This bootstrap project needs to merge with chrishenn/homelab/aurora, with appropriate flags to choose linux, windows, 
server, and desktop configuration chunks. See the 'todo' section below.

---

bash 

```bash
mise use -g gh op
export OP_SERVICE_ACCOUNT_TOKEN=value
mise bootstrap --from git@github.com:chrishenn/bootstrap.git --skip-dirty
```

pwsh

```pwsh
scoop install mise
mise use -g gh op

$env:OP_SERVICE_ACCOUNT_TOKEN = value
mkdir -p ~/Projects
cd ~/Projects
gh repo clone chrishenn/bootstrap
cd boostrap
mise bootstrap -y --skip-dirty

# mise bootstrap --from git@github.com:chrishenn/bootstrap.git --skip-dirty
```

general

```bash
mise bootstrap dotfiles apply -y
```

---

# todo

- mise bootstrap a windows machine: setup system files
    - github keys into C:\ProgramData\ssh\administrators_authorized_keys
    - https://github.com/chrishenn/dotfiles/blob/main/home/.chezmoiscripts/windows/run_onchange_keys.ps1.tmpl
- bootstrap from repo, set diff profiles for linux/windows, desktop/server, pass from cli
    - https://github.com/bassemkaroui/.dotfiles-mise/tree/main
    - https://github.com/cicorias/mise-bootstrap/tree/main
    - https://github.com/jensdev/mise-bootstrap/tree/main
    - format the bootstrap project such that those 'global mise config settings' warnings don't show on bootstrap 
    - merge aurora bootstrap mise.toml into some 'linux+desktop+fedora' dotfiles setup
        - may be too many switches for cli
- bootstrap windows with 'mise bootstrap remote'
- add formatters
