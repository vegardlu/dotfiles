complete -c colima-start -l runtime -a 'docker containerd' -d 'Container runtime'
complete -c colima-start -l disk -d 'Disk size in GiB'
complete -c colima-start -l arch -a 'x86_64 aarch64' -d 'CPU architecture'
complete -c colima-start -l foreground -d 'Run in foreground'
