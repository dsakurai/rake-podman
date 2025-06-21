#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_PATH"

export SERVICE_NAME="rake_service"

podman-compose build --pull

export HOST_WORKDIR="$SCRIPT_PATH"
podman-compose run --rm $SERVICE_NAME "$@"
