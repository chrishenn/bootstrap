# mise bootstrap

A mise bootstrap project providing my dotfiles, and bootstrap profiles for various machines and roles.

All profiles require a service account token for 1password-cli to render my secrets to disk.

Can be used for {linux,windows} x {desktop,server}, and/or in conjunction with my other windows bootstrapping projects:

- <https://github.com/chrishenn/unattend>
- <https://github.com/chrishenn/chplib>
- <https://github.com/chrishenn/scoops>
- <https://github.com/chrishenn/drivers>

---

## bugs

--promp-vars does not work in script

fnox cannot reload in script

## usage

```bash
# required
export OP_SERVICE_ACCOUNT_TOKEN=<token>

# aurora desktop profiles (fedora atomic)
export MISE_ENV=aurora,nfsclient,pwr,stime,unsleep,sshd_fedora
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash

# todo: pangolin uses mise vars, but --prompt-vars doesn't work in scripts. Run manually
# rack4 server profiles (fedora atomic)
export MISE_ENV=rack4,nfsserver,smbserver,pangolin,pwr,stime,unsleep,sshd_fedora
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash

# todo: pangolin uses mise vars, but --prompt-vars doesn't work in scripts. Run manually
# vps0 server profiles (ubuntu)
export MISE_ENV=vps0,pangolin,unsleep,sshd_ubuntu
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash

# just the automatic platform profiles ("unix,linux,windows", etc) are active
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash

# pass other flags to mise bootstrap
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash -s -- --other-flag
```

```pwsh
# required
$env:OP_SERVICE_ACCOUNT_TOKEN = <token>

# profiles 'windows,nvgpu,amdcpu' active
$env:MISE_ENV = 'nvgpu,amdcpu'
irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1 | iex

# Run with flag `hw_auto` to auto-detect supported hardware types and activate matching mise profiles
# Profiles specified with MISE_ENV are merged with auto-detected profiles
$env:MISE_ENV = 'nvgpu,amdcpu'
iex "& {$(irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1)} -hw_auto"
```

---

## todo

- bootstrap windows with 'mise bootstrap remote'
- bootstrap vps0 with root user account, setting up 'chris' user and ssh login
- write a vfox package(?) or a homebrew cask for firefox
- write a vfox package(?) or a homebrew cask for chrome
- write a vfox package(?) or a homebrew cask for zen-browser

## notes

The only clunky bit is manually setting the miserc environment(s) for the machine. ~/.config/mise/miserc.toml does not
support templating, and the only per-machine setting is the `env = [..]` line, which is slightly irritating.
Update: mise added per-machine ~/.config/mise/miserc.local.toml, as I had originally expected to be present - irritation
above still stands. Afaik there's no programmatic way to write miserc.local.toml built into mise, so the scripts will
have to stay

## ref

- <https://github.com/bassemkaroui/.dotfiles-mise>
- <https://github.com/cicorias/mise-bootstrap>
- <https://github.com/jensdev/mise-bootstrap/>
