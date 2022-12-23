create user 'mangos'@'%' identified by 'mangos';

create database archive;
create database auth;
create database characters;
create database fusion;
create database world;

grant all privileges on archive.* to 'mangos'@'%';
grant all privileges on auth.* to 'mangos'@'%';
grant all privileges on characters.* to 'mangos'@'%';
grant all privileges on fusion.* to 'mangos'@'%';
grant all privileges on world.* to 'mangos'@'%';

flush privileges;


