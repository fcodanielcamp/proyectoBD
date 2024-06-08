--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 05/06/2024
--@Descripción: Creación de usuarios y roles, asignación de permisos.

Prompt Indicar el password de sys
connect sys/system as sysdba
prompt Limpiando
declare
cursor cur_usuarios is
select username from dba_users where username like 'VL_PROY%';
cursor cur_roles is
select role from dba_roles where role like 'ROL%';
begin
for r in cur_usuarios loop
execute immediate 'drop user '||r.username||' cascade';
end loop;
for r in cur_roles loop
execute immediate 'drop role '||r.role;
end loop;
end;
/

prompt Creando usuario vl_proy_admin
create user vl_proy_admin identified by proyecto quota unlimited on users;
prompt Creando usuario vl_proy_invitado
create user vl_proy_invitado identified by proyecto;

prompt Creando roles
create role rol_admin;
grant create session, create table, create view, create procedure, create sequence, create public synonym, create trigger to rol_admin;
create role rol_invitado;
grant create session, create synonym to rol_invitado;

prompt Asignando roles
grant rol_admin to vl_proy_admin;
grant rol_invitado to vl_proy_invitado;

Prompt Listo!
disconnect