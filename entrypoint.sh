#!/bin/bash

chmod 666 "$SSH_AUTH_SOCK"

CONTAINER_SHELL=$(getent passwd "$CONTAINER_USER" | cut -d: -f7)

if [ -n "$*" ]; then
    exec su - "$CONTAINER_USER" -s "$CONTAINER_SHELL" -- -c "$*"
else
    exec su - "$CONTAINER_USER" -s "$CONTAINER_SHELL"
fi
