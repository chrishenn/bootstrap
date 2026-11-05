# mise bootstrap

A mise bootstrap project providing my dotfiles, and bootstrap profiles for various machines and roles.

All profiles require a service account token for 1password-cli to render my secrets to disk.

Can be used for {linux,windows} x {desktop,server}, and/or in conjunction with my other windows bootstrapping projects:

- <https://github.com/chrishenn/unattend>
- <https://github.com/chrishenn/chplib>
- <https://github.com/chrishenn/scoops>
- <https://github.com/chrishenn/drivers>

---

## usage

```bash
# required for bootstrapping secrets
export OP_SERVICE_ACCOUNT_TOKEN=<key>

# required becase init.sh calls `mise bootstrap --save-env`
# aurora desktop profile group (fedora atomic)
export MISE_ENV=aurora_set
# rack4 server profile group (fedora atomic)
export MISE_ENV=rack4_set
# vps0 server profile group (ubuntu)
export MISE_ENV=vps0_set

# use process substitution rather than `curl | bash`, so that mise bootstrap prompts for vars/secrets work on stdout
bash <(curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh)
```

```pwsh
# required for bootstrapping secrets
$env:OP_SERVICE_ACCOUNT_TOKEN = "<key>"

# profiles 'windows,nvgpu,amdcpu' active
$env:MISE_ENV = 'nvgpu,amdcpu'
irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1 | iex

# Run with flag `hw_auto` to auto-detect supported hardware types and activate matching mise profiles
# Profiles specified with MISE_ENV are merged with auto-detected profiles in init.ps1
$env:MISE_ENV = 'nvgpu,amdcpu'
iex "& {$(irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1)} -hw_auto"
```

---

## todo

- add bootstrap for windows server
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
Update: programmatic way to write miserc.local.toml is now built into mise. yay. `mise bootstrap --save-env` will err if
there are no envs set, so I guess we'll have to manually check for that in the init.sh script - not the worst thing, and
necessary because ~/.config/mise is wiped out by `mise bootstrap --config-dir`. So --save-env plus --config-dir should
give us the correct ordering, and we just need to make sure MISE_ENV is set on running init.sh.

github caches downloads, so check if the server-side cache is expired when you're debugging the script invoke syntax:

```bash
curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh > tmp.bash
cat tmp.bash
```

mise clones the bootstrap repo with https, setting an https git remote, which cannot accept pushes. To set an ssh url
for pushes:

```bash
git remote set-url --push origin git@github.com:chrishenn/bootstrap.git
```

## ref

- <https://github.com/bassemkaroui/.dotfiles-mise>
- <https://github.com/cicorias/mise-bootstrap>
- <https://github.com/jensdev/mise-bootstrap/>
