#!/bin/bash

cat ./postgresql/salp.sql | docker exec -i bifrost-monitoring_postgres_1 psql -U postgres -d postgres

cat ./postgresql/vesting.sql | docker exec -i bifrost-monitoring_postgres_1 psql -U postgres -d postgres