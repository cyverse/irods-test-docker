#!/bin/bash

# Adapted from "Initialization script" in documentation for official Postgres dockerhub:
#   https://hub.docker.com/_/postgres/
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "ICAT";
    CREATE USER irods WITH PASSWORD 'testpassword';
    GRANT ALL PRIVILEGES ON DATABASE "ICAT" to irods;
EOSQL


psql -v ON_ERROR_STOP=1 --username "irods" --dbname "ICAT" <<-EOSQL
    create table R_ZONE_MAIN
    (
    zone_id              bigint not null,
    zone_name            varchar(250) not null,
    zone_type_name       varchar(250) not null,
    zone_conn_string     varchar(1000),
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_USER_MAIN
    (
    user_id              bigint not null,
    user_name            varchar(250) not null,
    user_type_name       varchar(250) not null,
    zone_name            varchar(250) not null,
    user_info            varchar(1000),
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RESC_MAIN
    (
    resc_id              bigint not null,
    resc_name            varchar(250) not null,
    zone_name            varchar(250) not null,
    resc_type_name       varchar(250) not null,
    resc_class_name      varchar(250) not null,
    resc_net             varchar(250) not null,
    resc_def_path        varchar(1000) not null,
    free_space           varchar(250),
    free_space_ts        varchar(32),
    resc_info            varchar(1000),
    r_comment            varchar(1000),
    resc_status          varchar(32),
    create_ts            varchar(32),
    modify_ts            varchar(32),
    resc_children        varchar(1000),
    resc_context         varchar(1000),
    resc_parent          varchar(1000),
    resc_objcount        bigint DEFAULT 0
    ) ;

    create table R_COLL_MAIN
    (
    coll_id              bigint not null,
    parent_coll_name     varchar(2700) not null,
    coll_name            varchar(2700) not null,
    coll_owner_name      varchar(250) not null,
    coll_owner_zone      varchar(250) not null,
    coll_map_id          bigint DEFAULT 0,
    coll_inheritance     varchar(1000),
    coll_type            varchar(250) DEFAULT '0',
    coll_info1           varchar(2700) DEFAULT '0',
    coll_info2           varchar(2700) DEFAULT '0',
    coll_expiry_ts       varchar(32),
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_DATA_MAIN
    (
    data_id              bigint not null,
    coll_id              bigint not null,
    data_name            varchar(1000) not null,
    data_repl_num        INTEGER not null,
    data_version         varchar(250) DEFAULT '0',
    data_type_name       varchar(250) not null,
    data_size            bigint not null,
    resc_group_name      varchar(250),
    resc_name            varchar(250) not null,
    data_path            varchar(2700) not null,
    data_owner_name      varchar(250) not null,
    data_owner_zone      varchar(250) not null,
    data_is_dirty        INTEGER  DEFAULT 0,
    data_status          varchar(250),
    data_checksum        varchar(1000),
    data_expiry_ts       varchar(32),
    data_map_id          bigint DEFAULT 0,
    data_mode            varchar(32),
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32),
    resc_hier            varchar(1000)
    ) ;

    create table R_META_MAIN
    (
    meta_id              bigint not null,
    meta_namespace       varchar(250),
    meta_attr_name       varchar(2700) not null,
    meta_attr_value      varchar(2700) not null,
    meta_attr_unit       varchar(250),
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_TOKN_MAIN
    (
    token_namespace      varchar(250) not null,
    token_id             bigint not null,
    token_name           varchar(250) not null,
    token_value          varchar(250),
    token_value2         varchar(250),
    token_value3         varchar(250),
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RULE_MAIN
    (
    rule_id              bigint not null,
    rule_version         varchar(250) DEFAULT '0',
    rule_base_name       varchar(250) not null,
    rule_name            varchar(2700) not null,
    rule_event           varchar(2700) not null,
    rule_condition       varchar(2700),
    rule_body            varchar(2700) not null,
    rule_recovery        varchar(2700) not null,
    rule_status          bigint DEFAULT 1,
    rule_owner_name      varchar(250) not null,
    rule_owner_zone      varchar(250) not null,
    rule_descr_1         varchar(2700),
    rule_descr_2         varchar(2700),
    input_params         varchar(2700),
    output_params        varchar(2700),
    dollar_vars          varchar(2700),
    icat_elements        varchar(2700),
    sideeffects          varchar(2700),
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RULE_BASE_MAP
    (
    map_version          varchar(250) DEFAULT '0',
    map_base_name        varchar(250) not null,
    map_priority         INTEGER not null,
    rule_id              bigint not null,
    map_owner_name       varchar(250) not null,
    map_owner_zone       varchar(250) not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RULE_DVM
    (
    dvm_id               bigint not null,
    dvm_version          varchar(250) DEFAULT '0',
    dvm_base_name        varchar(250) not null,
    dvm_ext_var_name     varchar(250) not null,
    dvm_condition        varchar(2700),
    dvm_int_map_path     varchar(2700) not null,
    dvm_status           INTEGER DEFAULT 1,
    dvm_owner_name       varchar(250) not null,
    dvm_owner_zone       varchar(250) not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RULE_DVM_MAP
    (
    map_dvm_version      varchar(250) DEFAULT '0',
    map_dvm_base_name    varchar(250) not null,
    dvm_id               bigint not null,
    map_owner_name       varchar(250) not null,
    map_owner_zone       varchar(250) not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RULE_FNM
    (
    fnm_id               bigint not null,
    fnm_version          varchar(250) DEFAULT '0',
    fnm_base_name        varchar(250) not null,
    fnm_ext_func_name    varchar(250) not null,
    fnm_int_func_name    varchar(2700) not null,
    fnm_status           INTEGER DEFAULT 1,
    fnm_owner_name       varchar(250) not null,
    fnm_owner_zone       varchar(250) not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RULE_FNM_MAP
    (
    map_fnm_version      varchar(250) DEFAULT '0',
    map_fnm_base_name    varchar(250) not null,
    fnm_id               bigint not null,
    map_owner_name       varchar(250) not null,
    map_owner_zone       varchar(250) not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_MICROSRVC_MAIN
    (
    msrvc_id             bigint not null,
    msrvc_name           varchar(250) not null,
    msrvc_module_name    varchar(250) not null,
    msrvc_signature      varchar(2700) not null,
    msrvc_doxygen        varchar(2500) not null,
    msrvc_variations     varchar(2500) not null,
    msrvc_owner_name     varchar(250) not null,
    msrvc_owner_zone     varchar(250) not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_MICROSRVC_VER
    (
    msrvc_id             bigint not null,
    msrvc_version        varchar(250) DEFAULT '0',
    msrvc_host           varchar(250) DEFAULT 'ALL',
    msrvc_location       varchar(500),
    msrvc_language       varchar(250) DEFAULT 'C',
    msrvc_type_name      varchar(250) DEFAULT 'IRODS COMPILED',
    msrvc_status         bigint DEFAULT 1,
    msrvc_owner_name     varchar(250) not null,
    msrvc_owner_zone     varchar(250) not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_RULE_EXEC
    (
    rule_exec_id         bigint not null,
    rule_name            varchar(2700) not null,
    rei_file_path        varchar(2700),
    user_name            varchar(250),
    exe_address          varchar(250),
    exe_time             varchar(32),
    exe_frequency        varchar(250),
    priority             varchar(32),
    estimated_exe_time   varchar(32),
    notification_addr    varchar(250),
    last_exe_time        varchar(32),
    exe_status           varchar(32),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_USER_GROUP
    (
    group_user_id        bigint not null,
    user_id              bigint not null,
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_USER_SESSION_KEY
    (
    user_id              bigint not null,
    session_key          varchar(1000) not null,
    session_info         varchar(1000) ,
    auth_scheme          varchar(250) not null,
    session_expiry_ts    varchar(32) not null,
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_USER_PASSWORD
    (
    user_id              bigint not null,
    rcat_password        varchar(250) not null,
    pass_expiry_ts       varchar(32) not null,
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;



    create table R_RESC_GROUP
    (
    resc_group_id        bigint not null,
    resc_group_name      varchar(250) not null,
    resc_id              bigint not null,
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_OBJT_METAMAP
    (
    object_id            bigint not null,
    meta_id              bigint not null,
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_OBJT_ACCESS
    (
    object_id            bigint not null,
    user_id              bigint not null,
    access_type_id       bigint not null,
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_OBJT_DENY_ACCESS
    (
    object_id            bigint not null,
    user_id              bigint not null,
    access_type_id       bigint not null,
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_OBJT_AUDIT
    (
    object_id            bigint not null,
    user_id              bigint not null,
    action_id            bigint not null,
    r_comment            varchar(1000),
    create_ts            varchar(32),
    modify_ts            varchar(32)
    ) ;

    create table R_SERVER_LOAD
    (
    host_name            varchar(250) not null,
    resc_name            varchar(250) not null,
    cpu_used             INTEGER,
    mem_used             INTEGER,
    swap_used            INTEGER,
    runq_load            INTEGER,
    disk_space           INTEGER,
    net_input            INTEGER,
    net_output           INTEGER,
    create_ts            varchar(32)
    ) ;

    create table R_SERVER_LOAD_DIGEST
    (
    resc_name            varchar(250) not null,
    load_factor          INTEGER,
    create_ts            varchar(32)
    ) ;

    create table R_USER_AUTH
    (
    user_id              bigint not null,
    user_auth_name       varchar(1000),
    create_ts            varchar(32)
    ) ;




    create table R_QUOTA_MAIN
    (
    user_id              bigint,
    resc_id              bigint,
    quota_limit          bigint,
    quota_over           bigint,
    modify_ts            varchar(32)
    ) ;

    create table R_QUOTA_USAGE
    (
    user_id              bigint,
    resc_id              bigint,
    quota_usage          bigint,
    modify_ts            varchar(32)
    ) ;

    create table R_SPECIFIC_QUERY
    (
    alias                varchar(1000),
    sqlStr               varchar(2700),
    create_ts            varchar(32)
    ) ;

    create table R_TICKET_MAIN
    (
    ticket_id           bigint not null,
    ticket_string       varchar(100),
    ticket_type         varchar(20),
    user_id             bigint not null,
    object_id           bigint not null,
    object_type         varchar(16),
    uses_limit          int  DEFAULT 0,
    uses_count          int  DEFAULT 0,
    write_file_limit    int  DEFAULT 10,
    write_file_count    int  DEFAULT 0,
    write_byte_limit    int  DEFAULT 0,
    write_byte_count    int  DEFAULT 0,
    ticket_expiry_ts    varchar(32),
    restrictions        varchar(16),
    create_ts           varchar(32),
    modify_ts           varchar(32)
    );

    create table R_TICKET_ALLOWED_HOSTS
    (
    ticket_id           bigint not null,
    host                varchar(32)
    );

    create table R_TICKET_ALLOWED_USERS
    (
    ticket_id           bigint not null,
    user_name           varchar(250) not null
    );

    create table R_TICKET_ALLOWED_GROUPS
    (
    ticket_id           bigint not null,
    group_name           varchar(250) not null
    );

    create table R_GRID_CONFIGURATION
    (
    namespace varchar(2700),
    option_name varchar(2700),
    option_value varchar(2700)
    );

    create sequence R_ObjectId increment by 1 start with 10000;

    create unique index idx_zone_main1 on R_ZONE_MAIN (zone_id);
    create unique index idx_zone_main2 on R_ZONE_MAIN (zone_name);
    create index idx_user_main1 on R_USER_MAIN (user_id);
    create unique index idx_user_main2 on R_USER_MAIN (user_name,zone_name);
    create index idx_resc_main1 on R_RESC_MAIN (resc_id);
    create unique index idx_resc_main2 on R_RESC_MAIN (zone_name,resc_name);
    create unique index idx_coll_main3 on R_COLL_MAIN (coll_name);
    create index idx_coll_main1 on R_COLL_MAIN (coll_id);
    create unique index idx_coll_main2 on R_COLL_MAIN (parent_coll_name,coll_name);
    create index idx_data_main1 on R_DATA_MAIN (data_id);
    create unique index idx_data_main2 on R_DATA_MAIN (coll_id,data_name,data_repl_num,data_version);
    create index idx_data_main3 on R_DATA_MAIN (coll_id);
    create index idx_data_main4 on R_DATA_MAIN (data_name);
    create index idx_data_main5 on R_DATA_MAIN (data_type_name);
    create index idx_data_main6 on R_DATA_MAIN (data_path);
    create unique index idx_meta_main1 on R_META_MAIN (meta_id);
    create index idx_meta_main2 on R_META_MAIN (meta_attr_name);
    create index idx_meta_main3 on R_META_MAIN (meta_attr_value);
    create index idx_meta_main4 on R_META_MAIN (meta_attr_unit);
    create unique index idx_rule_main1 on R_RULE_MAIN (rule_id);
    create unique index idx_rule_exec on R_RULE_EXEC (rule_exec_id);
    create unique index idx_user_group1 on R_USER_GROUP (group_user_id,user_id);
    create unique index idx_resc_logical1 on R_RESC_GROUP (resc_group_name,resc_id);
    create unique index idx_objt_metamap1 on R_OBJT_METAMAP (object_id,meta_id);
    create index idx_objt_metamap2 on R_OBJT_METAMAP (object_id);
    create index idx_objt_metamap3 on R_OBJT_METAMAP (meta_id);
    create unique index idx_objt_access1 on R_OBJT_ACCESS (object_id,user_id);
    create unique index idx_objt_daccs1 on R_OBJT_DENY_ACCESS (object_id,user_id);
    create index idx_tokn_main1 on R_TOKN_MAIN (token_id);
    create index idx_tokn_main2 on R_TOKN_MAIN (token_name);
    create index idx_tokn_main3 on R_TOKN_MAIN (token_value);
    create index idx_tokn_main4 on R_TOKN_MAIN (token_namespace);
    create index idx_specific_query1 on R_SPECIFIC_QUERY (sqlStr);
    create index idx_specific_query2 on R_SPECIFIC_QUERY (alias);


    create unique index idx_ticket on R_TICKET_MAIN (ticket_string);
    create unique index idx_ticket_host on R_TICKET_ALLOWED_HOSTS (ticket_id, host);
    create unique index idx_ticket_user on R_TICKET_ALLOWED_USERS (ticket_id, user_name);
    create unique index idx_ticket_group on R_TICKET_ALLOWED_GROUPS (ticket_id, group_name);

    create unique index idx_grid_configuration on R_GRID_CONFIGURATION (namespace, option_name);


    insert into R_GRID_CONFIGURATION values ( 'database', 'schema_version', '1' );

    insert into R_TOKN_MAIN values ('token_namespace',0,'zone_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',1,'user_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',2,'data_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',3,'resc_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',4,'action_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',5,'rulexec_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',6,'access_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',7,'object_type','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',8,'resc_class','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',9,'coll_map','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('token_namespace',10,'auth_scheme_type','','','','','1170000000','1170000000');


    insert into R_TOKN_MAIN values ('zone_type',100,'local','','native zone of this iCAT','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('zone_type',101,'remote','','foreign zone','','','1170000000','1170000000');

    insert into R_TOKN_MAIN values ('user_type',200,'rodsgroup','','rods group users','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('user_type',201,'rodsadmin','','rods administrators','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('user_type',202,'rodsuser','','normal rods user','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('user_type',204,'groupadmin','','user group administrators','','','1170000000','1170000000');

    insert into R_TOKN_MAIN values ('object_type',300,'data','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('object_type',301,'resource','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('object_type',302,'user','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('object_type',303,'rule','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('object_type',304,'metadata','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('object_type',305,'zone','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('object_type',306,'collection','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('object_type',307,'token','','','','','1170000000','1170000000');

    insert into R_TOKN_MAIN values ('resc_type',400,'unixfilesystem','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('resc_type',401,'hpss file system','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('resc_type',402,'windows file system','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('resc_type',403,'s3','','','','','1250100000','1250100000');
    insert into R_TOKN_MAIN values ('resc_type',404,'MSS universal driver','','','','','1250100000','1250100000');
    insert into R_TOKN_MAIN values ('resc_type',405,'database','','','','','1288631300','1288631300');
    insert into R_TOKN_MAIN values ('resc_type',406,'mso','','','','','1312910000','1312910000');

    insert into R_TOKN_MAIN values ('rulexec_type',600,'immediate','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('rulexec_type',601,'delayed','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('rulexec_type',602,'queued','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('rulexec_type',603,'before','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('rulexec_type',604,'after','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('rulexec_type',605,'concurrent','','','','','1170000000','1170000000');

    insert into R_TOKN_MAIN values ('access_type',1000,'null','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1010,'execute','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1020,'read annotation','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1030,'read system metadata','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1040,'read metadata','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1050,'read object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1060,'write annotation','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1070,'create metadata','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1080,'modify metadata','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1090,'delete metadata','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1100,'administer object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1110,'create object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1120,'modify object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1130,'delete object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1140,'create token','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1150,'delete token','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1160,'curate','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('access_type',1200,'own','','','','','1170000000','1170000000');


    insert into R_TOKN_MAIN values ('coll_map',1400,'generic','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('coll_map',1401,'direct','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('coll_map',1402,'hard link','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('coll_map',1403,'soft link','','','','','1170000000','1170000000');

    insert into R_TOKN_MAIN values ('auth_scheme_type',1500,'SPASSWORD','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('auth_scheme_type',1501,'GSI','','','','','1170000000','1170000000');

    insert into R_TOKN_MAIN values ('data_type',1600,'generic','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1601,'text','text/text','|.txt|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1602,'ascii text','text/text','|.txt|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1603,'ascii compressed Lempel-Ziv','','|.z|.zip|.gz|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1604,'ascii compressed Huffman','','|.z|.zip|.gz|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1605,'ebcdic text','text/text','|.txt|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1606,'ebcdic compressed Lempel-Ziv','','|.z|.zip|.gz|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1607,'ebcdic compressed Huffman','','|.z|.zip|.gz|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1608,'image','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1609,'tiff image','image/tiff','|.tif|.tiff|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1610,'uuencoded tiff','text/text','|.uu|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1611,'gif image','image/gif','|.gif|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1612,'jpeg image','image/jpeg','|.jpeg|.jpg|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1613,'pbm image','image/pbm','|.pbm|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1614,'fig image','image/fig','|.fig|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1615,'FITS image','application/x-fits','|.fits|.fit|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1616,'DICOM image','application/dicom','|.IMA|.ima|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1617,'print-format','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1618,'LaTeX format','text/text','|.tex|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1619,'Troff format','text/text','|.trf|.trof|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1620,'Postscript format','application/postscript','|.ps|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1621,'DVI format','application/dvi','|.dvi|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1622,'Word format','application/msword','|.doc|.rtf|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1623,'program code','text/text','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1624,'SQL script','text/text','|.sql|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1625,'C code','text/text','|.c|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1626,'C include file','text/text','|.c|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1627,'fortran code','text/text','|.f|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1628,'object code','','|.o|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1629,'library code','','|.a|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1630,'data file','','|.dat|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1631,'html','text/html','|.htm|.html|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1632,'SGML File','text/sgml','|.sgm|.sgml|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1633,'Wave Audio','audio/x-wav','|.wav|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1634,'tar file','text/text','|.tar|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1635,'compressed tar file','|.tz|.tgz|.zip|','','','','1170000000','1170000000'  ); 
    insert into R_TOKN_MAIN values ('data_type',1636,'java code','text/text','|.jav|.java|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1637,'perl script','text/text','|.pl|','','','1170000000','1170000000'  );             
    insert into R_TOKN_MAIN values ('data_type',1638,'tcl script','text/text','|.tcl|','','','1170000000','1170000000'  );
    insert into R_TOKN_MAIN values ('data_type',1639,'link code','','|.o|','','','1170000000','1170000000'); 
    insert into R_TOKN_MAIN values ('data_type',1640,'shadow object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1641,'database shadow object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1642,'directory shadow object','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1643,'database','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1644,'streams','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1645,'audio streams','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1646,'realAudio','audio/x-pn-realaudio','|.ra|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1647,'video streams','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1648,'realVideo','audio/x-pn-realaudio','|.rv|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1649,'MPEG','video/mpeg','|.mpeg|.mpg|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1650,'AVI','video/msvideo','|.avi|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1651,'PNG-Portable Network Graphics','image/png','|.png|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1652,'MP3 - MPEG Audio','audio/x-mpeg','|.mp3|.mpa|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1653,'WMV-Windows Media Video','video/x-wmv','|.wmv|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1654,'BMP -Bit Map','image/bmp','|.bmp|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1655,'CSS-Cascading Style Sheet','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1656,'xml','text/xml','|.xml|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1657,'Slide','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1658,'Power Point Slide','application/vnd.ms-powerpoint','|.ppt|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1659,'Spread Sheet','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1660,'Excel Spread Sheet','application/x-msexcel','|.xls|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1661,'Document','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1622,'MSWord Document','application/msword','|.doc|.rtf|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1663,'PDF Document','application/pdf','|.pdf|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1664,'Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1665,'NT Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1666,'Solaris Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1667,'AIX Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1668,'Mac Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1669,'Mac OSX Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1670,'Cray Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1671,'SGI Executable','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1672,'DLL','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1673,'NT DLL','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1674,'Solaris DLL','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1675,'AIX DLL','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1676,'Mac DLL','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1677,'Cray DLL','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1678,'SGI DLL','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1679,'Movie','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1680,'MPEG Movie','video/mpeg','|.mpeg|.mpg|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1681,'MPEG 3 Movie','video/mpeg','|.mpeg|.mpg|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1682,'Quicktime Movie','video/quicktime','|.mov|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1683,'compressed file','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1684,'compressed mmCIF file','','|.cif|.mmcif|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1685,'compressed PDB file','','|.pdb|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1686,'binary file','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1687,'URL','text/html','|.htm|.html|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1688,'NSF Award Abstracts','text/text','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1689,'email','text/text','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1690,'orb data','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1691,'datascope data','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1692,'DICOM header','','','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1693,'XML Schema','text/xml','|.xsd|','','','1170000000','1170000000');
    insert into R_TOKN_MAIN values ('data_type',1694,'tar bundle','','','','','1250100000','1250100000');
    insert into R_TOKN_MAIN values ('data_type',1695,'database object','text','','','','1288631300','1288631300');
    insert into R_TOKN_MAIN values ('data_type',1696,'mso','','','','','1312910000','1312910000');
    insert into R_TOKN_MAIN values ('data_type',1697,'gzipTar','','|.tar.gz|','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1698,'bzip2Tar','','|.tar.bz2|','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1699,'gzipFile','','|.gz|','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1700,'bzip2File','','|.bz2|','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1701,'zipFile','','|.zip|','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1702,'gzipTar bundle','','','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1703,'bzip2Tar bundle','','','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1704,'zipFile bundle','','','','','1324000000','1324000000');
    insert into R_TOKN_MAIN values ('data_type',1705,'msso file','','','','','1324000000','1324000000');


    insert into R_TOKN_MAIN values ('action_type',1800,'generic','','','','','1170000000','1170000000');



    insert into R_SPECIFIC_QUERY (alias, sqlStr, create_ts) values ('ls', 'select alias, sqlStr from R_SPECIFIC_QUERY', '01292940000');
    insert into R_SPECIFIC_QUERY (alias, sqlStr, create_ts) values ('lsl', 'select alias, sqlStr from R_SPECIFIC_QUERY where sqlStr like ?', '01292940000');
    insert into R_SPECIFIC_QUERY (alias, sqlStr, create_ts) values ('ShowCollAcls', 'select distinct R_USER_MAIN.user_name, R_USER_MAIN.zone_name, R_TOKN_MAIN.token_name, R_USER_MAIN.user_type_name from R_USER_MAIN, R_TOKN_MAIN, R_OBJT_ACCESS, R_COLL_MAIN where R_OBJT_ACCESS.object_id = R_COLL_MAIN.coll_id AND R_COLL_MAIN.coll_name = ? AND R_TOKN_MAIN.token_namespace = ''access_type'' AND R_USER_MAIN.user_id = R_OBJT_ACCESS.user_id AND R_OBJT_ACCESS.access_type_id = R_TOKN_MAIN.token_id', '01342019000');

    insert into R_ZONE_MAIN values (9000,'localhost','local','','','1170000000','1170000000');

    insert into R_USER_MAIN values (9001,'rodsadmin','rodsgroup','tempZone','','','1170000000','1170000000');
    insert into R_USER_MAIN values (9002,'public','rodsgroup','tempZone','','','1170000000','1170000000');

    insert into R_USER_MAIN values (9010,'rods','rodsadmin','tempZone','','','1170000000','1170000000');

    insert into R_USER_GROUP values (9001,9010,'1170000000','1170000000');
    insert into R_USER_GROUP values (9002,9002,'1170000000','1170000000');
    insert into R_USER_GROUP values (9002,9010,'1170000000','1170000000');
    insert into R_USER_GROUP values (9010,9010,'1170000000','1170000000');
    insert into R_USER_GROUP values (9001,9011,'1170000000','1170000000');
    insert into R_USER_GROUP values (9002,9011,'1170000000','1170000000');
    insert into R_USER_GROUP values (9003,9011,'1170000000','1170000000');
    insert into R_USER_GROUP values (9011,9011,'1170000000','1170000000');

    insert into R_USER_PASSWORD values (9010,'rods','9999-12-31-23.59.00','1170000000','1170000000');

    insert into R_COLL_MAIN values (9020,'/','/','rods','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9021,'/','/tempZone','rods','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9022,'/tempZone','/tempZone/home','rods','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9023,'/tempZone','/tempZone/trash','rods','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9024,'/tempZone/trash','/tempZone/trash/home','rods','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9025,'/tempZone/home','/tempZone/home/public','public','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9026,'/tempZone/trash/home','/tempZone/trash/home/public','public','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9027,'/tempZone/home','/tempZone/home/rods','rods','tempZone',0,'','','','','','','1170000000','1170000000');
    insert into R_COLL_MAIN values (9028,'/tempZone/trash/home','/tempZone/trash/home/rods','rods','tempZone',0,'','','','','','','1170000000','1170000000');

    insert into R_OBJT_ACCESS values (9020,9001,1130,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9020,9010,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9021,9010,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9022,9010,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9023,9010,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9024,9010,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9025,9002,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9026,9002,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9027,9010,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9028,9010,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9029,9011,1200,'1170000000','1170000000');
    insert into R_OBJT_ACCESS values (9030,9011,1200,'1170000000','1170000000');

    insert into R_RESC_MAIN (resc_id, resc_name, zone_name, resc_type_name, resc_class_name,  resc_net, resc_def_path, free_space, free_space_ts, resc_info, r_comment, resc_status, create_ts, modify_ts) values (10000, 'demoResc', 'tempZone', 'replication', 'cache', 'EMPTY_RESC_HOST', 'EMPTY_RESC_PATH', '', '', '', '', '', '1170000000','1170000000');
    insert into R_RESC_MAIN (resc_id, resc_name, zone_name, resc_type_name, resc_class_name,  resc_net, resc_def_path, free_space, free_space_ts, resc_info, r_comment, resc_status, create_ts, modify_ts, resc_parent) values (10001, 'replResc1', 'tempZone', 'unixfilesystem', 'cache', 'localhost', '/repl1', '', '', '', '', '', '1170000000','1170000000', 10000);
    insert into R_RESC_MAIN (resc_id, resc_name, zone_name, resc_type_name, resc_class_name,  resc_net, resc_def_path, free_space, free_space_ts, resc_info, r_comment, resc_status, create_ts, modify_ts, resc_parent) values (10002, 'replResc2', 'tempZone', 'unixfilesystem', 'cache', 'localhost', '/repl2', '', '', '', '', '', '1170000000','1170000000', 10000);

    insert into R_TOKN_MAIN values ('user_type', 10000, 'ucsb-irods-service', '', 'a UCSB iRODS service', '', '', '1170000000','1170000000');
EOSQL