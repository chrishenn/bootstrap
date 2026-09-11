$cfgf = "C:/ProgramData/ssh/sshd_config"
$cfg = '
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no
PubkeyAuthentication yes

'
mkdir -p C:/ProgramData/ssh -ea 0 | out-null
# set-content automatically appends a newline, which makes this comparison a pain
if ((cat $cfgf -raw) -eq $cfg) {
    write-host "sshd_config: no change needed"
    return
}
[System.IO.File]::WriteAllBytes($cfgf, [System.Text.Encoding]::UTF8.GetBytes($cfg))

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
