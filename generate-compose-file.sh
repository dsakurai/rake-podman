#!/usr/bin/env bash

set -e

read -p "Do you want to use podman-remote in Rakefile? [y/N]: " use_remote
if [[ "$use_remote" =~ ^[y]$ ]]; then
    echo "Using podman-remote in Rakefile."
    MOUNT_SOCKET="- /run/user/1000/podman/podman.sock:/run/podman/podman.sock:Z"
    PODMAN_SOCKET="PODMAN_SOCKET: /run/podman/podman.sock"
    TASK="hello_podman"

else
    echo "Not using podman-remote in Rakefile."
fi

sed 's|@MOUNT_SOCKET@|'"$MOUNT_SOCKET"'|g'   templates/podman-compose.yml.in > podman-compose.yml
sed 's|@PODMAN_SOCKET@|'"$PODMAN_SOCKET"'|g' podman-compose.yml -i

./rake.sh $TASK