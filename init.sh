#!/bin/bash
set -eu

if [[ -z "${OP_SERVICE_ACCOUNT_TOKEN:-}" ]]; then
	echo 'abort: OP_SERVICE_ACCOUNT_TOKEN not set'
	exit 1
fi
if ! command -v mise >/dev/null; then
	curl https://mise.run | sh
	eval "$(~/.local/bin/mise activate bash)"
fi

mise use -g op

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
	"$(op read "op://homelab/github/token bash")"
	if [[ -z "${GITHUB_TOKEN:-}" ]]; then
		echo 'abort: GITHUB_TOKEN not set and op read failed'
		exit 1
	fi
fi

if [[ -z "${DOT_ENV:-}" ]]; then
	tee ~/.config/mise/miserc.toml >/dev/null <<-END
		env_conf_d = true
		auto_env = true
	END
else
	tee ~/.config/mise/miserc.toml >/dev/null <<-END
		env_conf_d = true
		auto_env = true
		env = $DOT_ENV
	END
fi

mise bootstrap --from git@github.com:chrishenn/bootstrap.git --from-dir ~/Projects/bootstrap --skip-dirty --update -y
