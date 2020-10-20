#!/bin/sh
: <<'COPYRIGHT'
 Copyright © Allan Paiste. All rights reserved.
 See LICENSE.txt for license details.
COPYRIGHT

name="Mutagen Project Daemon"
status_file=".devcontainer/.vscode/.mutagen-sync"
port=${1}

while true; do
  echo "${name}: listening on ${port}"
  response=$(nc -l "${port}")
  echo "${name}: received > ${response}"

  uid=$(echo "${response}"|cut -d':' -f1)
  project_root=$(echo "${response}"|cut -d':' -f2-)

  if [ ! -d "${project_root}" ] ; then
    continue
  fi

  cd "${project_root}" || exit
  
  /usr/local/bin/mutagen project start && \
    echo "${uid}" > "${status_file}"

  launchctl unload .devcontainer/.vscode/com.mutagen.project-daemon.plist
  break
done