# bootstrap

bash 

```bash
mise use -g gh op
export OP_SERVICE_ACCOUNT_TOKEN=value
export GITHUB_TOKEN=$(op read "op://homelab/github/credential")
export KNOWN_HOSTS=$(op read "op://homelab/known_hosts/text")
export DKEY_PRIVATE=$(op read "op://homelab/dkey/private key?ssh-format=openssh")
export DKEY_PUBLIC=$(op read "op://homelab/dkey/public key")
export AUTHORIZED_KEYS=$(op read "op://homelab/authorized_keys/text")
mise bootstrap --from git@github.com:chrishenn/bootstrap.git --skip-dirty
```

pwsh

```pwsh
scoop install mise
mise use -g gh op

$env:OP_SERVICE_ACCOUNT_TOKEN = value
$env:GITHUB_TOKEN = op read "op://homelab/github/credential"
$env:KNOWN_HOSTS = op read "op://homelab/known_hosts/text"
$env:DKEY_PRIVATE = ((op read "op://homelab/dkey/private key?ssh-format=openssh") -join "`n") + "`n"
$env:DKEY_PUBLIC = op read "op://homelab/dkey/public key"
$env:AUTHORIZED_KEYS = op read "op://homelab/authorized_keys/text"

mkdir -p ~/Projects
cd ~/Projects
gh repo clone chrishenn/bootstrap
cd boostrap
mise bootstrap -y --skip-dirty

# mise bootstrap --from git@github.com:chrishenn/bootstrap.git --skip-dirty
```

---

# todo

- bootstrap from repo, set diff profiles for linux/windows, desktop/server, pass from cli
    - https://github.com/bassemkaroui/.dotfiles-mise/tree/main
    - https://github.com/cicorias/mise-bootstrap/tree/main
    - https://github.com/jensdev/mise-bootstrap/tree/main
    - format the bootstrap project such that those 'global mise config settings' warnings don't show on bootstrap 
    - merge aurora bootstrap mise.toml into some 'linux+desktop+fedora' dotfiles setup
        - may be too many switches for cli
- bootstrap windows with 'mise bootstrap remote'
- add formatters
