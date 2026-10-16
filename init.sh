#!/bin/bash
set -eu

function credentials {
	if [ "$OP_SERVICE_ACCOUNT_TOKEN" = "" ]; then
		export OP_SERVICE_ACCOUNT_TOKEN=$(op read op://homelab/svc/credential)
		if [ "$OP_SERVICE_ACCOUNT_TOKEN" = "" ]; then
			echo "credentials error: OP_SERVICE_ACCOUNT_TOKEN not set and op read failed"
			exit 1
		fi
	fi
	if [ "$GITHUB_TOKEN" = "" ]; then
		export GITHUB_TOKEN=$(op read op://homelab/github/credential)
		if [ "$GITHUB_TOKEN" = "" ]; then
			echo "credentials error: GITHUB_TOKEN not set and op read failed"
			exit 1
		fi
	fi
}

function main {
	if ! command -v mise >/dev/null; then
		curl https://mise.run | sh
	fi
	if ! command -v op >/dev/null; then
		mise use -g op
	fi
	eval "$(~/.local/bin/mise activate bash)"
	credentials

	if [ "$DOT_ENV" = "" ]; then
		tee ~/.config/mise/miserc.local.toml >/dev/null <<-END
			env = $DOT_ENV
		END
	fi

	repo="git@github.com:chrishenn/bootstrap.git"
	mise bootstrap --from "$repo" --from-dir ~/Projects/bootstrap --skip-dirty --update -y --force-dotfiles "$@"
}

main "$@" && echo -e "\n SUCCESS" || echo -e "\n FAILED"
exit $?
