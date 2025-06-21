#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_PATH"

podman-compose build --pull

export HOST_WORKDIR="$SCRIPT_PATH"
podman-compose run --rm rake_service "$@"
# the service name is defined in the podman-compose.yml file
