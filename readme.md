# mise bootstrap

The only clunky bit is manually setting the miserc environment(s) for the machine. ~/.config/mise/miserc.toml does not 
support templating, and the only per-machine setting is the `env = [..]` line, which is slightly irritating.

## linux/aurora

```bash
export OP_SERVICE_ACCOUNT_TOKEN=<token>
export DOT_ENV='["aurora"]'
curl https://raw.githubusercontent.com/chrishenn/bootstrap/refs/heads/main/init.sh | bash
```

## windows

For now, I don't set `env = [..]` in miserc.toml using DOT_ENV because I'm using the auto_env feature, which activates
the os-named ('windows') environment. To select configurations with more granularity, I'll use the same approach
as the init.sh script above.

```pwsh
$env:OP_SERVICE_ACCOUNT_TOKEN=<token>
irm https://raw.githubusercontent.com/chrishenn/bootstrap/refs/heads/main/init.ps1 | iex
```

## general commands

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

## todo

- bootstrap windows with 'mise bootstrap remote'
- add formatters

## ref

- https://github.com/bassemkaroui/.dotfiles-mise
- https://github.com/cicorias/mise-bootstrap
- https://github.com/jensdev/mise-bootstrap/