#!/bin/bash

# fedora atomic (universalblue/aurora) init config

sdir=$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]:-$0}")")

function installs {
	# todo: read this and see what else I've not handled manually
	# sudo ujust devmode

	# mise, uv, pixi, proto, soar
	curl https://mise.run | sh
	curl -LsSf https://astral.sh/uv/install.sh | sh
	curl -fsSL https://pixi.sh/install.sh | sh
	bash <(curl -fsSL https://moonrepo.dev/install/proto.sh)
	curl -fsSL "https://raw.githubusercontent.com/pkgforge/soar/main/install.sh" | sh

	# mise bootstrap packages: flatpak does not support declarative removal
	flatpak uninstall -y \
		org.mozilla.Thunderbird \
		org.mozilla.firefox \
		org.gnome.DejaDup \
		org.kde.skanpage \
		org.kde.okular \
		org.kde.kontact \
		org.kde.kclock \
		org.fkoehler.KTailctl

	# mise bootstrap packages: tapped casks do not support lifecycle hooks on linux
	brew tap ublue-os/tap
	brew install --cask \
		zed-linux \
		jetbrains-toolbox-linux \
		1password-gui-linux
}

function mise_init {
	export DOT_ENV='["aurora", "nfsclient", "pwr", "stime"]'
	curl https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.sh | bash
	mise i
	soar apply -y
}

function gclone {
	# depends on ("git" "gh" "jq" "tr" "awk" "ssh" "op" "parallel")
	# mise bootstrap could do this, but for initial (unsafe) clones this is much faster
	sudo chmod +x ~/gclone.sh
	~/gclone.sh
}

function zentool_init {
	mise exec -C ~/Projects/zentool -- mise run build release
	mise exec -C ~/Projects/zentool -- sudo target/out/zentool install
}
