#!/bin/bash

su - irods -c '/var/lib/irods/irodsctl start'

# create s3 resource
su - irods -c 'iadmin mkresc s3resc s3 irods-catalog-provider:/demobucket/thevault "S3_DEFAULT_HOSTNAME=minio:19000;S3_AUTH_FILE=/var/lib/irods/s3.keypair;S3_REGIONNAME=us-east-1;S3_RETRY_COUNT=1;S3_WAIT_TIME_SECONDS=3;S3_PROTO=HTTP;ARCHIVE_NAMING_POLICY=consistent;HOST_MODE=cacheless_attached"'

# enable SSL by modifying irods_environment.json
su - irods -c 'sed -i "s/CS_NEG_REFUSE/CS_NEG_REQUIRE/g" /var/lib/irods/.irods/irods_environment.json'
su - irods -c 'sed -i "s/CS_NEG_REFUSE/CS_NEG_REQUIRE/g" /etc/irods/core.re'

# enable pam authentication
echo "auth sufficient pam_permit.so" > /etc/pam.d/irods

su - irods -c '/var/lib/irods/irodsctl restart'

su - irods -c '/var/lib/irods/irodsctl stop'
