#!/bin/bash

#curl https://mise.run | sh && eval "$(~/.local/bin/mise activate bash)"
mise use -g gh op
$(op read "op://homelab/github/token bash")
tee ~/.config/mise/miserc.toml >/dev/null <<- END
env_conf_d = true
auto_env = true
env = $DOT_ENV
END
mise bootstrap --from git@github.com:chrishenn/bootstrap.git --from-dir ~/Projects/bootstrap --skip-dirty --update -y