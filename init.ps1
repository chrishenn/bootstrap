function inst_gcm (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $name
) {
    return [bool](gcm $name -ea 0)
}

function init {
    if (! $env:OP_SERVICE_ACCOUNT_TOKEN) {
        write-host -f r "abort: OP_SERVICE_ACCOUNT_TOKEN not set"
        return
    }
    if (! $env:GITHUB_TOKEN) {
        $env:GITHUB_TOKEN = (op read "op://homelab/github/credential")
        if (! $env:GITHUB_TOKEN) {
            write-host -f r "abort: GITHUB_TOKEN not set"
            return
        }
    }
    if (! (inst_gcm mise)) {
        write-host -f c 'mise not installed; attempting scoop install'
        if (! (inst_gcm scoop)) {
            write-host -f c 'scoop not installed: installing scoop'
            iex "& {$(irm get.scoop.sh -useb)} -RunAsAdmin"
        }
        scoop install mise
        (&mise activate pwsh) | Out-String | Invoke-Expression
    }

    mise use -g gh op
    $cnt = '
    env_conf_d = true
    auto_env = true
    '
    set-content ~/.config/mise/miserc.toml $cnt.replace(' ', '')
    mise bootstrap --from git@github.com:chrishenn/bootstrap.git --from-dir ~/Projects/bootstrap --skip-dirty --update -y
}

init
