create user 'mangos'@'%' identified by 'mangos';

create database characters;
create database logs;
create database mangos;
create database realmd;

grant all privileges on characters.* to 'mangos'@'%';
grant all privileges on logs.* to 'mangos'@'%';
grant all privileges on mangos.* to 'mangos'@'%';
grant all privileges on realmd.* to 'mangos'@'%';

flush privileges;


