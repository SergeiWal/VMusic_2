--создание табличного пространства
create tablespace vmusic_space
    datafile 'C:\app\Oracle\oradata\orcl\VMUSIC.DBF'
    size 10m
    autoextend on next 500K
    maxsize unlimited
    extent management local;

--создание временного табличного пространства
create temporary tablespace vmusic_tmp_space
    tempfile 'C:\app\Oracle\oradata\orcl\VMUSIC_TMP.DBF'
    size 10m
    autoextend on next 500K
    maxsize unlimited
    extent management local;

--создание роли и выдача привелегий
alter session set "_ORACLE_SCRIPT"=true;

create role app_role;

grant create session, execute any procedure
    to app_role;

--создание профайла

create profile  vmusic_pf limit
    password_life_time unlimited
    sessions_per_user 5
    failed_login_attempts 7
    password_lock_time  1
    password_reuse_time 2
    password_grace_time  default
    connect_time 130
    idle_time 30;


--создание пользователя - администратора базы данных приложения
create user db_admin
    identified by a$vMusic123
    default tablespace vmusic_space
    quota unlimited on vmusic_space
    temporary tablespace vmusic_tmp_space
    profile vmusic_pf
    account unlock ;

--создание пользователя - клиент базы данных приложения

create user app_user
    identified by  u$vMusic123
    default tablespace vmusic_space
    quota unlimited on vmusic_space
    temporary tablespace vmusic_tmp_space
    profile vmusic_pf
    account unlock ;

--выдача привелегий

grant all privileges to db_admin;
grant app_role to app_user;




