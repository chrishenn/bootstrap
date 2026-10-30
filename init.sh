#!/bin/bash
set -e

function reset {
	sudo rm -rf /usr/local/share/mise
	mise cache clear
	mise implode --config -y
	rm -rf ~/.config/fnox
	rm -rf ~/.local/state/mise
	rm -rf ~/.config/mise
	rm -rf ~/.ssh
	sudo rm -f /etc/systemd/system/pangolin-site.service
}

function vars {
	if [ "$MISE_ENV" = "" ]; then
		echo "vars error: MISE_ENV not set"
		exit 1
	fi
	if [ "$OP_SERVICE_ACCOUNT_TOKEN" = "" ]; then
		# case: you're logged into op cli using account login
		export OP_SERVICE_ACCOUNT_TOKEN=$(mise exec op -- op read op://homelab/svc/credential)
		if [ "$OP_SERVICE_ACCOUNT_TOKEN" = "" ]; then
			echo "vars error: OP_SERVICE_ACCOUNT_TOKEN not set and op read failed"
			exit 1
		fi
	fi
	if [ "$FNOX_AGE_KEY" = "" ]; then
		export FNOX_AGE_KEY=$(mise exec op -- op read "op://homelab/dkey/private key?ssh-format=openssh")
		if [ "$FNOX_AGE_KEY" = "" ]; then
			echo "vars error: FNOX_AGE_KEY not set and op read failed"
			exit 1
		fi
	fi
	if [ "$GITHUB_TOKEN" = "" ]; then
		export GITHUB_TOKEN=$(mise exec op -- op read op://homelab/github/credential)
		if [ "$GITHUB_TOKEN" = "" ]; then
			echo "vars error: GITHUB_TOKEN not set and op read failed"
			exit 1
		fi
	fi
}

function main {
	rm -rf ~/.config/mise
	if ! command -v mise >/dev/null; then
		curl -fsSL https://mise.run | sh
	fi
	eval "$(~/.local/bin/mise activate bash)"
	vars

	repo="https://github.com/chrishenn/bootstrap.git"
	dir="Projects/bootstrap"
	cfg="home/.config/mise"
	# todo: bootstrap.secrets for sys files depend on fnox global secrets being loaded first by dotfiles; hence two bootstrap runs here
	mise exec op fnox -- mise bootstrap --prompt-vars --save-env --from "$repo" --from-dir "$dir" --config-dir "$cfg" --update -y --force-dotfiles --only dotfiles
	# todo: I don't know how to force fnox to load secrets from config, so have to use `fnox exec` here
	mise exec op fnox -- fnox exec -- mise bootstrap --from "$repo" --from-dir "$dir" --skip-dirty --update -y
}

main && echo -e "\n init.sh: SUCCESS" || echo -e "\n init.sh: FAILED"
exit $?
