# usage:
#
# $env:OP_SERVICE_ACCOUNT_TOKEN = <token>
# $env:DOT_ENV = 'nvgpu, amdapu'
# irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1 | iex
#
# or, enable hardware detection for some hardware types; profiles in DOT_ENV are merged with auto-detected profiles
# $env:DOT_ENV = 'nvgpu, amdcpu'
# iex "& {$(irm https://raw.githubusercontent.com/chrishenn/bootstrap/main/init.ps1)} -hw_auto"

param (
    [switch] $hw_auto
)

function inst_gcm (
    [parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string] $name
) {
    return [bool](gcm $name -ea 0)
}

function init (
    [bool] $hw_auto = $false
) {
    if (! $env:OP_SERVICE_ACCOUNT_TOKEN) {
        write-host -f r "abort: OP_SERVICE_ACCOUNT_TOKEN not set"
        return
    }
    if (! (inst_gcm mise)) {
        write-host -f c 'mise not installed; attempting scoop install'
        if (! (inst_gcm scoop)) {
            write-host -f c 'scoop not installed: installing scoop'
            iex "& {$(irm get.scoop.sh -useb)} -RunAsAdmin"
        }
        scoop install mise
    }
    mise use -g op
    (&mise activate pwsh) | Out-String | Invoke-Expression
    if (! $env:GITHUB_TOKEN) {
        $env:GITHUB_TOKEN = (op read "op://homelab/github/credential")
        if (! $env:GITHUB_TOKEN) {
            write-host -f r "abort: GITHUB_TOKEN not set and op read failed"
            return
        }
    }

    $profs = @()
    if ($env:DOT_ENV) {
        $profs += $env:DOT_ENV.split(',').trim()
    }
    if ($hw_auto) {
        if (! (inst_gcm hw_cpu)) {
            scoop install chplib
            import-module chplib -force
            if (! (inst_gcm hw_cpu)) {
                write-host -f r "abort: chplib function 'hw_cpu' not findable with pwsh get-command"
                return
            }
        }
        # functions from chplib are found automatically, but types don't appear until you touch the chplib module
        # 'touch' in this case could mean `get-command hw_cpu`, or `import-module chplib`, etc
        import-module chplib -force
        $cput = hw_cpu
        if ($cput -eq [Cpu]::amd) {
            $profs += "amdcpu"
        }
        if ($cput -eq [Cpu]::intel) {
            $profs += "intelcpu"
        }
        if (hw_amdapu) {
            $profs += "amdapu"
        }
        if (hw_intelapu) {
            $profs += "intelapu"
        }
        if (hw_intelwifi) {
            $profs += "intelwifi"
        }
        if (hw_nvgpu) {
            $profs += "nvgpu"
        }
    }
    if ($profs) {
        $profs = $profs | select -unique | % { "`"" + $_ + "`"" }
        $profs = $profs -join (", ")
    }

    $cfg = "
env_conf_d = true
auto_env = true
"
    $cfg = $cfg + "env = [$profs]"
    set-content ~/.config/mise/miserc.toml $cfg

    mise bootstrap --from git@github.com:chrishenn/bootstrap.git --from-dir ~/Projects/bootstrap --skip-dirty --update -y
}

init $hw_auto
