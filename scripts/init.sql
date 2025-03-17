CREATE DATABASE  ${DATABASE};

DO $$
DECLARE
    server_user text := '${SERVER_USER}';
    admin_role_password text := '${ADMIN_ROLE_PASSWORD}';
    database text := '${DATABASE}';
    schema text := '${SCHEMA}';
BEGIN


    -- Create the role (user) for the database if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = server_user) THEN
        EXECUTE format('CREATE ROLE %I LOGIN PASSWORD %L', server_user, admin_role_password);
    END IF;

    -- Grant the user privileges on the database
    EXECUTE format('GRANT ALL PRIVILEGES ON DATABASE %I TO %I', database, server_user);

    -- Create the schema if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM information_schema.schemata WHERE schema_name = schema) THEN
        EXECUTE format('CREATE SCHEMA %I AUTHORIZATION %I', schema, server_user);
    END IF;
END $$;
