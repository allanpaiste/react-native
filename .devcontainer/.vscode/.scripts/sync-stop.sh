#!/bin/bash
: <<'COPYRIGHT'
 Copyright © Allan Paiste. All rights reserved.
 See LICENSE.txt for license details.
COPYRIGHT

project_id=$(pwd|md5)
project_root="${*}"
conf_root="${project_root}/.devcontainer/.vscode"
status_file="${conf_root}/.mutagen-sync"
port_file="${conf_root}/.port"
daemon_script="${conf_root}/com.mutagen.project-daemon.plist"

rm "${daemon_script}" "${port_file}" "${status_file}" 2>/dev/null
make bootstrap
mutagen project terminate

if [ "${OSTYPE:0:6}" = "darwin" ]; then
  port=42000

  while [ "$(lsof -ti:${port})" != "" ] ; do
    port=$((port + 1))  
  done

  service_name="com.mutagen.project-daemon.${project_id}"

  echo ${port} > "${port_file}"

cat <<EOT >> "${daemon_script}"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>${service_name}</string>
    <key>KeepAlive</key>
    <dict>
      <key>Crashed</key>
      <true/>
      <key>SuccessfulExit</key>
      <false/>
     </dict>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/sh</string>
        <string>${conf_root}/.scripts/mutagen-starter.sh</string>
        <string>${port}</string>
    </array>
    <key>StandardOutPath</key>
    <string>${project_root}/mutagen.log</string>
    <key>StandardErrorPath</key>
    <string>${project_root}/mutagen.log</string>
  </dict>
</plist>
EOT

  while launchctl list|grep -q "${service_name}\$" ; do
    launchctl unload "${daemon_script}"
    sleep 1
  done

  launchctl load "${daemon_script}"
fi