# mise bootstrap/dotfiles: ssh keys

Apply ssh keys as dotfiles templates, rendering secrets from op.

Problem:

- rendered file matches permissions of .tera template file
- git does not track permissions of files (including .tera template files)
- have to set permissions manually with a hook

Solution:

- mise bootstrap added a 'permissions' key for dotfiles files

Solution (deprecated):

- use mise.bootstrap.files to apply secrets with correct permissions

```toml
[bootstrap.hooks]
pre-dotfiles = """
sudo chmod 600 \
~/Projects/bootstrap/home/.ssh/authorized_keys.tera \
~/Projects/bootstrap/home/.ssh/id_ed25519.tera \
~/Projects/bootstrap/home/.ssh/known_hosts.tera
"""

[dotfiles]
"~/.ssh/authorized_keys" = { source = "~/Projects/bootstrap/home/.ssh/authorized_keys.tera", mode = "template" }
"~/.ssh/id_ed25519.pub" = { source = "~/Projects/bootstrap/home/.ssh/id_ed25519.pub.tera", mode = "template" }
"~/.ssh/id_ed25519" = { source = "~/Projects/bootstrap/home/.ssh/id_ed25519.tera", mode = "template" }
"~/.ssh/known_hosts" = { source = "~/Projects/bootstrap/home/.ssh/known_hosts.tera", mode = "template" }
```
