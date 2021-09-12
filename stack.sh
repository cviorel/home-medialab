#!/bin/bash

case "${1}" in
"")
    echo ":: No action was specified."
    echo ":: Usage: $0 [up|down]"
    exit 1
    ;;
up)
    echo ":: Starting stack..."
    find . -type f -name docker-compose.yml | xargs -I {} docker-compose -f {} up -d
    ;;
down)
    echo ":: Stopping stack..."
    find . -type f -name docker-compose.yml | xargs -I {} docker-compose -f {} down
    ;;
*)
    echo ":: Unknown action '${1}'."
    echo ":: Usage: $0 [up|down]"
    exit 1
    ;;
esac
