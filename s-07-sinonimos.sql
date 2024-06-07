--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Creación de sinonimos empleados para la lectura de tablas tanto por parte del admin
--              como por parte del invitado así como tambien la implementacion de un programa PL/SQL
--              para crear cada sinonimo de forma dinámica

Prompt conectando con el usuario admin
-- Conectando con el usuario admin
conn vl_proy_admin/proyecto

Prompt creando sinonimos publicos por parte del admin
-- Creando el sinónimo público para la tabla empleado y proporcionando permiso de lectura al usuario invitado
create or replace public synonym empleado for vl_proy_admin.empleado;
grant select on empleado to vl_proy_invitado;
-- Creando el sinónimo público para la tabla cliente y proporcionando permiso de lectura al usuario invitado
create or replace public synonym cliente for vl_proy_admin.cliente;
grant select on cliente to vl_proy_invitado;
-- Creando el sinónimo público para la tabla presentacion_medicamento y proporcionando permiso de lectura al usuario invitado
create or replace public synonym presentacion_medicamento for vl_proy_admin.presentacion_medicamento;
grant select on presentacion_medicamento to vl_proy_invitado;

Prompt dando permisos de lectura al usuario invitado
-- Dando permisos de lectura de la tabla centro_operaciones para el usuario invitado
grant select on vl_proy_admin.centro_operaciones to vl_proy_invitado;
-- Dando permisos de lectura de la tabla operacion para el usuario invitado
grant select on vl_proy_admin.operacion to vl_proy_invitado;
-- Dando permisos de lectura de la tabla nombre_medicamento para el usuario invitado
grant select on vl_proy_admin.nombre_medicamento to vl_proy_invitado;


Prompt conectando con el usuario invitado
-- Conectando con el usuario invitado
conn vl_proy_invitado/proyecto


Prompt probando la consulta de los sinonimos publicos
-- Probando la consulta a través del sinónimo para empleado
select * from empleado;
--Probando la consulta a traves del sinonimo para cliente
select * from cliente;
--Probando la consulta a traves del sinonimo para presentacion_medicamento
select * from presentacion_medicamento;


Prompt probando la consulta de las tablas del usuario admin quien proporcionó permisos de lectura al usuario invitado
--Probando el uso de la tabla centro_operaciones
select * from vl_proy_admin.centro_operaciones;
--Probando el uso de la tabla centro_operaciones
select * from vl_proy_admin.operacion;
--Probando el uso de la tabla centro_operaciones
select * from vl_proy_admin.nombre_medicamento;


Prompt creando sinonimos con el usuario invitado
-- Creando el sinonimo para la tabla centro_operaciones la cual tuvo permisos el usuario invitado
create synonym centro_operaciones for vl_proy_admin.centro_operaciones;
-- Creando el sinonimo para la tabla centro_operaciones la cual tuvo permisos el usuario invitado
create synonym operacion for vl_proy_admin.operacion;
-- Creando el sinonimo para la tabla centro_operaciones la cual tuvo permisos el usuario invitado
create synonym nombre_medicamento for vl_proy_admin.nombre_medicamento;


Prompt probando los sinonimos creados para el uso de las tablas permitidas por el usuario admin
--Probando el uso de la tabla centro_operaciones
select * from centro_operaciones;
--Probando el uso de la tabla centro_operaciones
select * from operacion;
--Probando el uso de la tabla centro_operaciones
select * from nombre_medicamento;


Prompt creando los sinonimos de todas las tablas con el prefijo de nuestros apellidos 'Vigi' y 'López' - 'vl'
-- Programa anónimo PL/SQL para generar sinónimos privados para todas las tablas del proyecto
declare
    v_prefijo varchar2(2) := 'vl'; -- Prefijo de los apellidos 'Vigi' y 'López'
begin
    -- Se itera por todas las tablas del proyecto
    for tabla in (select table_name from user_tables) loop
        -- Creamos el nombre del sinónimo con el prefijo, seguido de '_' y luego el nombre de la tabla
        execute immediate 'create synonym ' || v_prefijo || '_' || tabla.table_name || ' FOR vl_proy_admin.' || tabla.table_name;
    end loop;

    -- Se confirma si todo salio bien
    dbms_output.put_line('LOs sinónimos se crearon correctamente');
exception
    when others then
        -- En caso de algún error, se muestra el mensaje de error
        dbms_output.put_line('Error: ' || SQLERRM);
end;
/

Prompt Listo!
disconnect