# aliases
alias j = just
alias p = pixi
alias m = mise
alias k = kubectl
alias cm = chezmoi

alias grep = grep --color=always
alias bat = bat --color=always

alias ls = ls -a
alias ll = ls -al
alias lf = ls -af

alias ka = kubeadm
alias ksys = kubectl -n kube-system
alias kcal = kubectl -n calico-system

alias kf = kubectl apply -f
alias kd = kubectl delete -f

alias pcat = python3 -m json.tool

alias get_svc = kubectl get svc -A -o wide
alias get_pod = kubectl get pods -A -o wide
alias get_node = kubectl get nodes -A -o wide

alias watch_svc = watch 'kubectl get svc -A -o wide'
alias watch_pod = watch 'kubectl get pods -A -o wide'
alias watch_node = watch 'kubectl get nodes -o wide'

alias dc = docker compose
alias dlogs = docker compose logs

alias t = talosctl
alias pup = pulumi up -y

# settings
use std/config dark-theme
$env.config = {
    buffer_editor: 'nano'
    show_banner: false
    table: {mode: 'none'}
    hooks: {display_output: 'table'}
    color_config: (dark-theme)
    completions: {algorithm: 'fuzzy'}
}

# env
$env.EDITOR = 'nano'
$env.SSH_AUTH_SOCK = ('~/.1password/agent.sock' | path expand)
if (which vivid | is-not-empty) {$env.LS_COLORS = (vivid generate tokyonight-night)}

# functions
def watch [cmd: string, interval: duration = 1sec] {
    loop {
        clear
        nu -c $cmd
        sleep $interval
    }
}

def newrepo [] {
    ^git init
    ^git add --all
    ^git commit -m "init"
    try {gh auth status} catch {
        gh auth refresh
    }
    ^gh newrepo
}

# tools
use std/util "path add"
mkdir ($nu.data-dir | path join 'vendor/autoload')

if ('~/.local/share/pnpm' | path exists) {
    path add '~/.local/share/pnpm'
    $env.PNPM_HOME = ('~/.local/share/pnpm' | path expand)
}
if ('~/.cargo/bin' | path exists) { path add '~/.cargo/bin' }
if ('~/.pixi/bin' | path exists) { path add '~/.pixi/bin' }
if ('~/.local/share/JetBrains/Toolbox/scripts' | path exists) { path add '~/.local/share/JetBrains/Toolbox/scripts' }
if ('/home/linuxbrew/.linuxbrew/bin/brew' | path exists) { path add '/home/linuxbrew/.linuxbrew/bin/brew' }
if ('~/.local/share/soar/bin' | path exists) { path add '~/.local/share/soar/bin' }

# package managers; load first
if (which pixi | is-not-empty) { pixi completion --shell nushell | save -f ($nu.data-dir | path join 'vendor/autoload/pixi.nu') }
if (which mise | is-not-empty) { ^mise activate nu | save -f ($nu.data-dir | path join 'vendor/autoload/mise.nu') }

# provided by mise; load mise first
if (which zoxide | is-not-empty) { zoxide init nushell | save -f ($nu.data-dir | path join 'vendor/autoload/zoxide.nu') }
if (which starship | is-not-empty) { starship init nu | save -f ($nu.data-dir | path join 'vendor/autoload/starship.nu') }
if (which fnox | is-not-empty) { fnox activate nu | save -f ($nu.data-dir | path join 'vendor/autoload/fnox.nu') }
if (which atuin | is-not-empty) { atuin init nu --disable-up-arrow  | save -f ($nu.data-dir | path join 'vendor/autoload/atuin.nu') }
