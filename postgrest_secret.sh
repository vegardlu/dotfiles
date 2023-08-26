#!/bin/sh

BLUE='\033[0;36m'
NC='\033[0m'


create_secret() {
  LC_CTYPE=C tr -dc A-Za-z0-9 < /dev/urandom | head -c 32 | xargs
}

add_secret_to_config() {
    local secret="$1"
    local config_file="/Users/christian/workspace/postgrest/postgrest.config"

    # Filter lines that don't start with "jwt-secret" and create a new file
    grep -v '^jwt-secret' "$config_file" > temp_config
    mv temp_config "$config_file"

    # Add the new "jwt-secret" line
    echo "jwt-secret = \"$secret\"" >> "$config_file"
}

simple_request() {
    export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidG9kb191c2VyIn0.U_cWS9TMG-Fr5vOeKnznuj4kkJ0-jeq9jNq1wnrXQHU"
    curl http://localhost:3000/todos -X POST \
         -H "Authorization: Bearer $TOKEN"   \
         -H "Content-Type: application/json" \
         -d '{"task": "learn how to auth"}'
}

if [ "$1" = "create" ]; then
    create_secret
elif [ "$1" = "request" ]; then
    simple_request
elif [ "$1" = "add_secret" ] && [ "$2" ]; then
    add_secret_to_config "$2"
elif [ "$1" = "all" ]; then
    my_secret=$(create_secret)
    echo "secret created: " $my_secret
    add_secret_to_config "$my_secret"
else
    echo "Usage: $0 {all|create|add_secret '$secret'}"
fi

