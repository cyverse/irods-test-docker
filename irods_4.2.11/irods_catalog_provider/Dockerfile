FROM centos:7

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/CentOS-*.repo && \
    sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/CentOS-*.repo && \
    sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/CentOS-*.repo

RUN rpm --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 
RUN yum --assumeyes install epel-release

RUN rpm --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
RUN yum --assumeyes \
    install ca-certificates iproute iptables-services libselinux-python openssh-server sudo

RUN yum --assumeyes install \
    jq python-pip python-requests \
    python3 \
    ### Install PostgreSQL ODBC connector
    https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/PGDG-RPM-GPG-KEY-RHEL7 && \
    yum --assumeyes install postgresql12-odbc postgresql12


### Install iRODS 
ADD https://packages.irods.org/renci-irods.yum.repo /etc/yum.repos.d/renci-irods.yum.repo

RUN rpm --import https://packages.irods.org/irods-signing-key.asc && \
    yum --assumeyes install \
    irods-server-4.2.11 irods-database-plugin-postgres-4.2.11 \
    irods-icommands-4.2.11

ARG DB_NAME=ICAT
ARG DB_PASSWORD=testpassword
ARG DB_USER=irods
ARG DBMS_HOST=irods-catalog
ARG DBMS_PORT=5432
ARG DBMS_TYPE=postgres
ARG IRODS_CONTROL_PLANE_KEY=TEMPORARY__32byte_ctrl_plane_key
ARG IRODS_CONTROL_PLANE_PORT=1248
ARG IRODS_FIRST_EPHEMERAL_PORT=20000
ARG IRODS_LAST_EPHEMERAL_PORT=20199
ARG IRODS_HOST=localhost
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
COPY scripts/config-irods.sh /tmp/config-irods
RUN /tmp/config-irods

### Create service script
COPY scripts/service.sh.template /tmp/
COPY scripts/prep-svc-script.sh /tmp/prep-svc-script
RUN /tmp/prep-svc-script

### Install iRODS Rules
COPY rules/pre-config.re /etc/irods/

RUN mkdir /repl1 /repl2
RUN chown irods:irods /repl1 /repl2

CMD [ "/service.sh" ]