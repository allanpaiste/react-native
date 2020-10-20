#!/bin/bash
: <<'COPYRIGHT'
 Copyright © Allan Paiste. All rights reserved.
 See LICENSE.txt for license details.
COPYRIGHT

project_root="${*}"
uid=$(echo "$(date +%s%N)${RANDOM}"|md5sum|cut -d' ' -f1)
status_file=".vscode/.mutagen-sync"
port_file=".vscode/.port"
daemon_script=".vscode/com.mutagen.project-daemon.plist"
port=$(cat "${port_file}")

while [ "$(cat ${status_file} 2>/dev/null)" != "${uid}" ] ; do
    echo "Polling Mutagen (${port}) ..."
    echo "${uid}:${project_root}" > "/dev/tcp/host.docker.internal/${port}"
    sleep 1
done

rm ${port_file} ${status_file} ${daemon_script} 2>/dev/null