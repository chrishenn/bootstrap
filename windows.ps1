$cfgf = "C:/ProgramData/ssh/sshd_config"
$cfg = '
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no
PubkeyAuthentication yes
'
mkdir -p C:/ProgramData/ssh -ea 0 | out-null
set-content $cfgf $cfg

if ([bool](gcm scoop -ea 0)) {
    $apps = (scoop export | ConvertFrom-Json).apps
    if (! ( $apps | ? {$_.name -eq 'chplib'} | measure).count -gt 0) {
        scoop install chplib
    }
    if (! ( $apps | ? {$_.name -eq 'pwsh'} | measure).count -gt 0) {
        scoop install pwsh
    }
    rprop 'HKLM:\SOFTWARE\OpenSSH' 'DefaultShell' 'String' ((scoop shim info pwsh).path)
}

restart-service sshd
