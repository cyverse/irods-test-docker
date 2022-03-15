FROM centos:7

### Install dumb-init
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 \
  /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

### Install iRODS
ADD https://packages.irods.org/renci-irods.yum.repo /etc/yum.repos.d/renci-irods.yum.repo
RUN rpm --import https://packages.irods.org/irods-signing-key.asc && \
    rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum --assumeyes install epel-release && \
    rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && \
    yum --assumeyes install irods-server-4.2.11 && \
    yum --assumeyes install irods-database-plugin-postgres && \
    mkdir /var/lib/irods/.irods && \
    adduser --system --comment 'iRODS Administrator' --home-dir /var/lib/irods --shell /bin/bash \
      irods && \
    chown --recursive irods:irods /etc/irods /var/lib/irods && \
### Installing undocumented dependency, unixODBC
    yum --assumeyes install unixODBC && \
### Install iRODS management script dependencies
    yum --assumeyes install jq sysvinit-tools net-tools nc && \
### Clear yum cache for smaller image
    yum --assumeyes clean all && \
    rm --force --recursive /var/cache/yum

### Copy Configuration File
ADD ./irods_config.json /tmp/irods_config.json
RUN chown irods:irods /tmp/irods_config.json

### Copy Wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    /wait-for-it.sh
RUN chown irods:irods /wait-for-it.sh && \
    chmod ug+x /wait-for-it.sh

### Copy Start Script
ADD ./start_irods.sh /start_irods.sh
RUN chown irods:irods /start_irods.sh && \
    chmod ug+x /start_irods.sh

WORKDIR /var/lib/irods

EXPOSE 1247

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/start_irods.sh"]