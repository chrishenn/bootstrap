#!/bin/bash
set -e

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
	if ! command -v fnox >/dev/null; then
		mise use -g fnox
	fi
	eval "$(~/.local/bin/mise activate bash)"
	eval "$(fnox activate bash)"
	credentials

	# todo: is this being overwritten by mise bootstrap dotfiles with ~/.config/mise symlink-each?
	if [ "$DOT_ENV" != "" ]; then
		echo
		echo "init.sh: writing env ($DOT_ENV) to miserc.local.toml"
		echo
		tee ~/.config/mise/miserc.local.toml >/dev/null <<-END
			env = $DOT_ENV
		END
	fi

	repo="git@github.com:chrishenn/bootstrap.git"
#	if echo "$DOT_ENV" | grep -q "pangolin"; then
#		# sync dotfiles to get latest fnox secrets into env. Then, pangolin site boot should work
#		mise bootstrap --from "$repo" --from-dir ~/Projects/bootstrap --update -y --only dotfiles
#	fi
	mise bootstrap --prompt-vars --from "$repo" --from-dir ~/Projects/bootstrap --skip-dirty --update -y --force-dotfiles "$@"
}

main "$@" && echo -e "\n SUCCESS" || echo -e "\n FAILED"
exit $?
