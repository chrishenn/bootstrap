# mise bootstrap

A mise bootstrap project providing my dotfiles, and bootstrap profiles for various machines and roles.

All profiles require a service account token for 1password-cli to render my secrets to disk.

Can be used for linux desktop/server, or in conjunction with my other windows bootstrapping projects:

- <https://github.com/chrishenn/unattend>
- <https://github.com/chrishenn/chplib>
- <https://github.com/chrishenn/scoops>
- <https://github.com/chrishenn/drivers>

## usage

```bash
# profiles 'linux, aurora' active
export OP_SERVICE_ACCOUNT_TOKEN=<token>
export DOT_ENV='["aurora"]'
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash

# just the automatic platform profiles ("unix", "linux", "windows", etc) are active
export OP_SERVICE_ACCOUNT_TOKEN=<token>
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash
```

```pwsh
# profiles 'windows, nvgpu, amdcpu' active. Note the different list format for pwsh as opposed to bash
$env:OP_SERVICE_ACCOUNT_TOKEN = <token>
$env:DOT_ENV = 'nvgpu, amdcpu'
irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1 | iex

# run with flag `hw_auto` to auto-detect select hardware types, and activate matching mise profiles
# profiles specified manually with DOT_ENV are merged with auto-detected profiles
$env:DOT_ENV = 'nvgpu, amdcpu'
iex "& {$(irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1)} -hw_auto"
```

```bash
# general commands
mise bootstrap dotfiles apply -E aurora -C ~/Projects/bootstrap -y
mise settings get env
mise settings set env ["aurora"]
mise bootstrap --skip-dirty -y
mise bootstrap dotfiles apply -y
mise bootstrap -E aurora --skip-dirty -y
mbd apply -y -E aurora
```

---

## todo

- bootstrap windows with 'mise bootstrap remote'

## notes

The only clunky bit is manually setting the miserc environment(s) for the machine. ~/.config/mise/miserc.toml does not
support templating, and the only per-machine setting is the `env = [..]` line, which is slightly irritating.

## ref

- <https://github.com/bassemkaroui/.dotfiles-mise>
- <https://github.com/cicorias/mise-bootstrap>
- <https://github.com/jensdev/mise-bootstrap/>
