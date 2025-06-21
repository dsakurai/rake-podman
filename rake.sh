#!/usr/bin/env bash

set -e

podman-compose build --pull
podman-compose run rake_service "$@"
