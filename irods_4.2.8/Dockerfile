FROM irods-docker-deploy-centos7

### Install ansible support
RUN yum --assumeyes install \
      jq python-pip python-requests python-virtualenv \
      ### Install software needed build image
      python3 \
      ### Install PostgreSQL ODBC connector
      https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
      rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG && \
      yum --assumeyes install postgresql12-odbc

### Install iRODS 
ADD https://packages.irods.org/renci-irods.yum.repo /etc/yum.repos.d/renci-irods.yum.repo

RUN rpm --import https://packages.irods.org/irods-signing-key.asc && \
      yum --assumeyes install \
      irods-server-4.2.8 irods-database-plugin-postgres-4.2.8 \
      http://people.renci.org/~dmoore/irods_netcdf/packages_2021_03_24/irods-netcdf-client_modules-4.2.8.0-centos-7-x86_64.rpm \
      http://people.renci.org/~dmoore/irods_netcdf/packages_2021_03_24/irods-netcdf-icommands-4.2.8.0-centos-7-x86_64.rpm \
      http://people.renci.org/~dmoore/irods_netcdf/packages_2021_03_24/irods-netcdf-server_modules-4.2.8.0-centos-7-x86_64.rpm

ARG DB_NAME=ICAT
ARG DB_PASSWORD=testpassword
ARG DB_USER=irods
ARG DBMS_HOST=dbms
ARG DBMS_PORT=5432
ARG DBMS_TYPE=postgres
ARG IRODS_CONTROL_PLANE_KEY=TEMPORARY__32byte_ctrl_plane_key
ARG IRODS_CONTROL_PLANE_PORT=1248
ARG IRODS_DEFAULT_RESOURCE=demoResc
ARG IRODS_FIRST_EPHEMERAL_PORT=20000
ARG IRODS_LAST_EPHEMERAL_PORT=20199
ARG IRODS_HOST=ies
ARG IRODS_NEGOTIATION_KEY=TEMPORARY_32byte_negotiation_key
ARG IRODS_SCHEMA_VALIDATION=https://schemas.irods.org/configuration
ARG IRODS_SYSTEM_GROUP=irods
ARG IRODS_SYSTEM_USER=irods
ARG IRODS_ZONE_KEY=TEMPORARY_zone_key
ARG IRODS_ZONE_NAME=tempZone
ARG IRODS_ADMIN_PASSWORD=rods
ARG IRODS_ZONE_PORT=1247
ARG IRODS_ADMIN_USER=rods

### Configure ODBC and iRODS
COPY irods_4.2.8/scripts/config-irods.sh /tmp/config-irods
RUN /tmp/config-irods

### Create service script
COPY irods_4.2.8/scripts/service.sh.template /tmp/
COPY irods_4.2.8/scripts/prep-svc-script.sh /tmp/prep-svc-script
RUN /tmp/prep-svc-script

### Install iRODS Rules
COPY irods_4.2.8/rules/pre-config.re /etc/irods/

RUN mkdir /repl1 /repl2
RUN chown irods:irods /repl1 /repl2

CMD [ "/service.sh" ]