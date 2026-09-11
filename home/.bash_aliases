alias j='just'
alias p='pixi'
alias m='mise'
alias mr='mise run'
alias k='kubectl'
alias cm='chezmoi'

alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'

alias ls='eza -aalo'
alias l='eza -aalo'
alias ll='eza -aalFo'
alias la='eza -Aao'

alias ka='kubeadm'
alias ksys='kubectl -n kube-system'
alias kcal='kubectl -n calico-system'

alias kf='kubectl apply -f'
alias kd='kubectl delete -f'

alias pcat='python3 -m json.tool'

alias get_svc='kubectl get svc -A -o wide'
alias get_pod='kubectl get pods -A -o wide'
alias get_node='kubectl get nodes -A -o wide'

alias watch_svc='watch -n 1 kubectl get svc -A -o wide'
alias watch_pod='watch -n 1 kubectl get pods -A -o wide'
alias watch_node='watch -n 1 kubectl get nodes -o wide'

alias dc='docker compose'
alias dlogs='docker compose logs'

alias t='talosctl'
alias pup='pulumi up -y'

# todo: for these below, allow overrides for env-vars and pat token paths

function ghlogin {
    echo $(op read "op://homelab/github/credential") | gh auth login -h github.com -p ssh --skip-ssh-key --with-token
}

function newrepo {
    if ! gh auth status; then
        ghlogin
    fi

    git init && git add --all && git commit -m "init"
    gh newrepo
}

# todo: for these below, add checks for the env-vars they rely on

function glogin {
	glab auth login --hostname $GITLAB_HOST -g ssh -a $GITLAB_HOST -p https --token $(op read "op://homelab/gitlab/pat")
}

function gnewrepo {
    if ! glab auth status &>/dev/null; then
        glogin
    fi

    git init && git add --all && git commit -m "init"
    glab newrepo
}

function bauth {
    auth=$(berg auth list --output-mode json)

    # if we know of any hosts, the top object will be an array
    toptype=$(echo "$auth" | jq -r '. | type')
    if [ "$toptype" != "array" ]; then
        false; return
    fi

    # checks login status for only the first host - assumes I will only ever use one
    status=$(echo "$auth" | jq -r '.[0]["logged_in"]')
    if [ $status = true ]; then
        true; return
    fi
    false; return
}

function blogin {
	berg auth login --token $(op read "op://homelab/forgejo/pat")
}

function bnewrepo {
	# "create on push" is NOT enabled - create repo using codeberg-cli
	if ! (bauth); then
    	blogin
    fi

    git init && git add --all && git commit -m "init"

    repo=$(basename $PWD)
    berg repo create --default-branch main -p private -n $repo -d $repo || return 1
    git remote add origin "ssh://git@$BERG_BASE_URL:$BERG_SSH_PORT/$BERG_USR/$repo.git"
    git push --set-upstream origin --all || return 1
}

function flogin {
    fj auth add-key $BERG_USR $(op read "op://homelab/forgejo/pat") -H $BERG_BASE_URL
}

function fnewrepo {
    # "create on push" is enabled
    git init && git add --all && git commit -m "init"
    repo=$(basename $PWD)
    git remote add origin "ssh://git@$BERG_BASE_URL:$BERG_SSH_PORT/$BERG_USR/$repo.git"
    git push --set-upstream origin --all || return 1
}

function dlogin_gitlab {
	echo $(op read "op://homelab/gitlab/pat") | docker login -u chris  $(op read "op://homelab/gitlab/host") --password-stdin
}
