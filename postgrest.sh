#!/bin/sh

BLUE='\033[0;36m'
NC='\033[0m'

postgrest_init () {
    sudo docker run --name postgrest -p 5433:5432 \
                    -e POSTGRES_PASSWORD=hemmeligheten \
                    -d postgres
}

postgrest_setup_database() {
    sleep 10
    # Run psql commands to setup database schemas, roles, and tables
    sudo docker exec -i postgrest psql -U postgres <<EOF
    -- Create your database schemas, roles, and tables here
    create schema api;

    create table api.todos (
      id serial primary key,
      done boolean not null default false,
      task text not null,
      due timestamptz
    );

    insert into api.todos (task) values
      ('finish tutorial 0'), ('pat self on back');

    create role web_anon nologin;

    grant usage on schema api to web_anon;
    grant select on api.todos to web_anon;

    create role authenticator noinherit login password 'hemmeligheten';
    grant web_anon to authenticator;

    create role todo_user nologin;
    grant todo_user to authenticator;

    grant usage on schema api to todo_user;
    grant all on api.todos to todo_user;
    grant usage, select on sequence api.todos_id_seq to todo_user;
    \q
EOF
}


postgrest_setup_config() {
    # Create a file in ~/workspace/postgrest directory
    mkdir -p ~/workspace/postgrest

    # Write content to the config.txt file
    cat <<EOF > ~/workspace/postgrest/postgrest.config
db-uri = "postgres://authenticator:hemmeligheten@0.0.0.0:5433/postgres"
db-schemas = "api"
db-anon-role = "web_anon"
EOF

    echo "config created successfully."
}

postgrest_start_database() {
  cd ~/workspace/postgrest/
  postgrest postgrest.config
}

if [ "$1" = "init" ]; then
    postgrest_init
elif [ "$1" = "initdb" ]; then
    postgrest_setup_database
elif [ "$1" = "initconfig" ]; then
    postgrest_setup_config
elif [ "$1" = "start" ]; then
    postgrest_start_database
elif [ "$1" = "all" ]; then
    postgrest_init
    postgrest_setup_database
    postgrest_setup_config
    postgrest_start_database
else
    echo "Usage: $0 {all|init|initdb|initconfig|start}"
fi
