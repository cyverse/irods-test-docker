#!/bin/bash

if [ -z "${POSTGRES_USER}" ]; then
    echo "ERROR: POSTGRES_USER is not defined"
    exit 1
fi

if [ -z "${POSTGRES_PASSWORD}" ]; then
    echo "ERROR: POSTGRES_PASSWORD is not defined"
    exit 1
fi

if [ -z "${POSTGRES_DB}" ]; then
    echo "ERROR: POSTGRES_DB is not defined"
    exit 1
fi

if [ -z "${POSTGRES_HOSTNAME}" ]; then
    echo "ERROR: POSTGRES_HOSTNAME is not defined"
    exit 1
fi

ICAT_IPADDR=$(ifconfig eth0 | grep 'inet' | awk '{print $2}')
ICAT_HOSTNAME=$(hostname)

echo "Updating config file"
sed -i "s/%%POSTGRES_HOSTNAME%%/${POSTGRES_HOSTNAME}/" /tmp/irods_config.json
sed -i "s/%%POSTGRES_DB%%/${POSTGRES_DB}/" /tmp/irods_config.json
sed -i "s/%%POSTGRES_USER%%/${POSTGRES_USER}/" /tmp/irods_config.json
sed -i "s/%%POSTGRES_PASSWORD%%/${POSTGRES_PASSWORD}/" /tmp/irods_config.json
sed -i "s/%%IRODS_ZONE%%/${IRODS_ZONE}/" /tmp/irods_config.json
sed -i "s/%%IRODS_ADMIN_USER%%/${IRODS_ADMIN_USER}/" /tmp/irods_config.json
sed -i "s/%%IRODS_ADMIN_PASSWORD%%/${IRODS_ADMIN_PASSWORD}/" /tmp/irods_config.json
sed -i "s/%%ICAT_IPADDR%%/${ICAT_IPADDR}/" /tmp/irods_config.json
sed -i "s/%%ICAT_HOSTNAME%%/${ICAT_HOSTNAME}/" /tmp/irods_config.json

echo "Waiting for DB"
/wait-for-it.sh -h ${POSTGRES_HOSTNAME} -p 5432 -t 60

echo "Setting up iRODS"
python /var/lib/irods/scripts/setup_irods.py --json_configuration_file=/tmp/irods_config.json

echo "Starting iRODS"
runuser -u irods /var/lib/irods/irodsctl start

echo "iRODS is up..."
tail -f /dev/null