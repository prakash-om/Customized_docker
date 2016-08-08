#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	
	CREATE ROLE netseva LOGIN PASSWORD 'n3ts3va' NOINHERIT VALID UNTIL 'infinity';
	CREATE DATABASE netseva WITH ENCODING='UTF8' OWNER=netseva;
EOSQL
