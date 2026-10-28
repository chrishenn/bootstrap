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

	# todo: on fresh bootstrap the pangolin site service requires dotfiles be applied first, because it uses secrets from fnox
	repo="git@github.com:chrishenn/bootstrap.git"
	dir="~/Projects/bootstrap"
	cfg="home/.config/mise"
	# mise bootstrap --from "$repo" --from-dir "$dir" --update -y --force-dotfiles --only dotfiles
	mise bootstrap --prompt-vars --from "$repo" --from-dir "$dir" --config-dir "$cfg" --skip-dirty --update -y --force-dotfiles "$@"

	if [ "$MISE_ENV" != "" ]; then
		IFS=',' read -ra envs <<<"$MISE_ENV"
		envs_rc=$(printf '"%s",' "${envs[@]}")
		envs_rc="[${envs_rc%,}]"

		echo
		echo "init.sh: writing env ($MISE_ENV) to miserc.local.toml"
		echo
		tee ~/.config/mise/miserc.local.toml >/dev/null <<-END
			env = $envs_rc
		END
	fi
}

main "$@" && echo -e "\n init.sh: SUCCESS" || echo -e "\n init.sh: FAILED"
exit $?
