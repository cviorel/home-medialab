#!/bin/bash

export $(grep -v '^#' .env | xargs -d '\n')
find . -type f -name docker-compose.yml | cut -d/ -f2 | xargs -I {} echo "cd {} && docker-compose pull && cd .."
