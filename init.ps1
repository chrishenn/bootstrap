param (
    [switch] $hw_auto
)
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

function inst_gcm (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $name
) {
    return [bool](gcm $name -ea 0)
}

function credentials {
    if (! $env:OP_SERVICE_ACCOUNT_TOKEN) {
        $env:OP_SERVICE_ACCOUNT_TOKEN = (op read op://homelab/svc/credential)
        if (! $env:OP_SERVICE_ACCOUNT_TOKEN) {
            write-host -f r "abort: OP_SERVICE_ACCOUNT_TOKEN not set and op read failed"
            return 1
        }
    }
    if (! $env:GITHUB_TOKEN) {
        $env:GITHUB_TOKEN = (op read op://homelab/github/credential)
        if (! $env:GITHUB_TOKEN) {
            write-host -f r "abort: GITHUB_TOKEN not set and op read failed"
            return 1
        }
    }
}

function hw_detect {
    # functions from chplib are found automatically, but types don't appear until you touch the chplib module
    # 'touch' in this case could mean `get-command hw_cpu`, or `import-module chplib -force`, etc
    scoop install chplib
    import-module chplib -force
    $envs = @()
    $cput = hw_cpu
    if ($cput -eq [Cpu]::amd) {
        $envs += "amdcpu"
    }
    if ($cput -eq [Cpu]::intel) {
        $envs += "intelcpu"
    }
    if (hw_amdapu) {
        $envs += "amdapu"
    }
    if (hw_intelapu) {
        $envs += "intelapu"
    }
    if (hw_intelwifi) {
        $envs += "intelwifi"
    }
    if (hw_nvgpu) {
        $envs += "nvgpu"
    }
    return $envs
}

function init (
    [bool] $hw_auto = $false
) {
    # todo: it would be nice to use the mise install script here, but the pwsh installer appears to take ~60s to activate mise?
    if (! (inst_gcm mise)) {
        write-host -f c 'mise not installed; attempting scoop install'
        if (! (inst_gcm scoop)) {
            write-host -f c 'scoop not installed: installing scoop'
            iex "& {$(irm get.scoop.sh -useb)} -RunAsAdmin"
        }
        scoop install mise
        (&mise activate pwsh) | Out-String | Invoke-Expression
    }
    credentials

    $envs = @()
    if ($env:MISE_ENV) {
        $envs += $env:MISE_ENV.split(',').trim()
    }
    if ($hw_auto) {
        $envs += hw_detect
        $envs = $envs | select -unique
        $env:MISE_ENV = $envs -join ","
    }

    $repo = "https://github.com/chrishenn/bootstrap.git"
    $dir = "Projects/bootstrap"
    $cfg = "home/.config/mise"
    rm -r -force ~/.config/mise
    mise bootstrap --prompt-vars --from "$repo" --from-dir "$dir" --config-dir "$cfg" --update -y --force-dotfiles --only dotfiles
    fnox exec -- mise bootstrap --from "$repo" --from-dir "$dir" --skip-dirty --update -y

    if ($envs) {
        $envs = $envs | % { "`"" + $_ + "`"" }
        $envs = $envs -join ","
        set-content ~/.config/mise/miserc.local.toml "env = [$envs]"
    }
}

init $hw_auto
