# irods-test-docker
iRODS docker images for testing 

Run following commands at your target iRODS directory.

## Build
```
docker compose build
```

## Run
```
docker compose up -d
```

## Terminate
```
docker compose down
```

## Catalog Configurations

| Variable                     | Value                                             |
|------------------------------|---------------------------------------------------|
| DB_TYPE                      | PostgreSQL 12                                     |
| DB_NAME                      | ICAT                                              |
| DB_USER                      | irods                                             |
| DB_PASSWORD                  | testpassword                                      |

## iRODS Configurations

| Variable                     | Value                                             |
|------------------------------|---------------------------------------------------|
| DB_NAME                      | ICAT                                              |
| DB_PASSWORD                  | testpassword                                      |
| DB_USER                      | irods                                             |
| DBMS_HOST                    | irods-catalog                                     |
| DBMS_PORT                    | 5432                                              |
| DBMS_TYPE                    | postgres                                          |
| IRODS_CONTROL_PLANE_KEY      | TEMPORARY__32byte_ctrl_plane_key                  |
| IRODS_CONTROL_PLANE_PORT     | 1248                                              |
| IRODS_FIRST_EPHEMERAL_PORT   | 20000                                             |
| IRODS_LAST_EPHEMERAL_PORT    | 20199                                             |
| IRODS_HOST                   | localhost                                         |
| IRODS_NEGOTIATION_KEY        | TEMPORARY_32byte_negotiation_key                  |
| IRODS_SCHEMA_VALIDATION      | https://schemas.irods.org/configuration           |
| IRODS_SYSTEM_GROUP           | irods                                             |
| IRODS_SYSTEM_USER            | irods                                             |
| IRODS_ZONE_KEY               | TEMPORARY_zone_key                                |
| IRODS_ZONE_NAME              | tempZone                                          |
| IRODS_ADMIN_PASSWORD         | rods                                              |
| IRODS_ZONE_PORT              | 1247                                              |
| IRODS_ADMIN_USER             | rods                                              |