#!/usr/bin/env bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" # Change to the directory of this script

substitute() {
    local out_file="$1"
    sed "s|$2|$3|g" "$out_file" -i
}

generate_compose_file() {
    local out_file="$1"
    local mount_socket="$2"
    local client_socket="$3"

    substitute "$out_file" "@MOUNT_SOCKET@"  "$mount_socket"
    substitute "$out_file" "@PODMAN_SOCKET@" "$client_socket"
}

{ # With podman-remote
    DIR="with-podman-remote"
    mkdir -p "$DIR"
    # podman-compose.yml
        cp         source/podman-compose.yml.in "$DIR/podman-compose.yml"
        mount_socket="- /run/user/1000/podman/podman.sock:/run/podman/podman.sock:Z"
        client_socket="PODMAN_SOCKET: /run/podman/podman.sock"
        generate_compose_file "$DIR/podman-compose.yml" "$mount_socket" "$client_socket"
    # Containerfile
	cp         source/Containerfile.in "$DIR/Containerfile"
        substitute "$DIR/Containerfile" "@PODMAN_REMOTE@"  "podman-remote " # Intentional lingering space
    # rake.sh
        cp source/rake.sh "$DIR/rake.sh"
	chmod a+x "$DIR/rake.sh"
    # Rakefile
        cp         source/Rakefile.in     "$DIR/Rakefile"
        substitute "$DIR/Rakefile" "@PODMAN_REMOTE@"  "sh \"podman-remote run --rm hello-world\""
}

{ # Without podman-remote
    DIR="without-podman-remote"
    mkdir -p "$DIR"
    # podman-compose.yml
        cp         source/podman-compose.yml.in "$DIR/podman-compose.yml"
        generate_compose_file "$DIR/podman-compose.yml"
    # Containerfile
	cp         source/Containerfile.in "$DIR/Containerfile"
        substitute "$DIR/Containerfile" "@PODMAN_REMOTE@"  ""
    # rake.sh
        cp         source/rake.sh "$DIR/rake.sh"
	chmod a+x  "$DIR/rake.sh"
    # Rakefile
        cp         source/Rakefile.in "$DIR/Rakefile"
        substitute "$DIR/Rakefile" "@PODMAN_REMOTE@"  ""
}
