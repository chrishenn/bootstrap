# mise bootstrap

The only clunky bit is manually setting the miserc environment(s) for the machine. ~/.config/mise/miserc.toml does not 
support templating, and the only per-machine setting is the `env = [..]` line, which is slightly irritating.

linux/aurora

```bash
export OP_SERVICE_ACCOUNT_TOKEN=
export DOT_ENV='["aurora"]'
curl https://github.com/chrishenn/bootstrap/blob/main/init.sh | bash
```

windows

```pwsh
scoop install mise
mise use -g gh op
$env:OP_SERVICE_ACCOUNT_TOKEN = value
$env:GITHUB_TOKEN = (op read "op://homelab/github/credential")
tee ~/.config/mise/miserc.toml >/dev/null <<- 'END'
env_conf_d = true
auto_env = true
env = ["aurora"]
END
mise bootstrap --from git@github.com:chrishenn/bootstrap.git --from-dir ~/Projects/bootstrap --skip-dirty --update -y
```

general

```bash
mise bootstrap dotfiles apply -E aurora -C ~/Projects/bootstrap -y
mise settings get env
mise settings set env ["aurora"]
mise bootstrap --skip-dirty -y
mise bootstrap dotfiles apply -y
mise bootstrap -E aurora --skip-dirty -y
mbd apply -y -E aurora
```

---

# todo

- bootstrap windows with 'mise bootstrap remote'
- add formatters
