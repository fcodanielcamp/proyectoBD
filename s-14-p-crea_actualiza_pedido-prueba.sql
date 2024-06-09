--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Código para la prueba de el procedimiento


--Le damos permisos al usuario admin desde system para poder esperar para poder ejecutar otra instruccion
Prompt Indicar el password de sys
connect sys/system as sysdba
prompt Limpiando
grant execute on dbms_lock to vl_proy_admin;

Prompt Probando procedimiento s-13-p-crea_actualiza_pedido.sql.
--Nos volvemos a conectar como usuarios admin
connect vl_proy_admin/proyecto


Prompt =======================================
Prompt Prueba 1 (La prueba es exitosa si el procedimiento se ejecuta de forma correcta)
prompt Intentando registrar un pedido nuevo con el uso del procedimiento
Prompt ========================================

set serveroutput on
-- Declaramos la variable
variable v_pedido_id number

exec dbms_output.put_line('Prueba para la creacion de un nuevo pedido');
-- Ejecutamos el procedimiento que realizamos 
declare
begin
    begin
        crea_actualiza_pedido(:v_pedido_id, sysdate, 100.50, 44, 68, 1, null);
        commit; -- Todo se realizó de forma correcta
        dbms_output.put_line('Nuevo pedido creado con el id: ' || :v_pedido_id);
    exception
        when others then
            -- Algo salió mal por lo que aplicamos rollback, se visualiza el error del procedimiento
            rollback;
            dbms_output.put_line('Error: ' || SQLERRM);
    end;
    -- Espera de 5 segundos antes de la siguiente instrucción en donde vamos a actualizar para visualizar las fechas en el historial ya que se creo bien el pedido
    dbms_lock.sleep(5);
end;
/
show errors


Prompt =======================================
Prompt Prueba 2 (La prueba es exitosa si el procedimiento se ejecuta de forma incorrecta y se muestra un error por falta de parametros)
prompt Intentando registrar un pedido nuevo con el uso del procedimiento sin parametros completos
Prompt ========================================

set serveroutput on
-- Declaramos la variable
variable v_pedido_id number

exec dbms_output.put_line('Prueba para la creacion de un nuevo pedido con falta de parametros');
-- Ejecutamos el procedimiento que realizamos 
declare
begin
    begin
        crea_actualiza_pedido(:v_pedido_id, v_cliente_id => 34, v_responsable_id => 21, v_estado_actual => 1);
        commit; -- Todo se realizó de forma correcta
        dbms_output.put_line('Nuevo pedido creado con el id: ' || :v_pedido_id);
    exception
        when others then
            -- Algo salió mal por lo que aplicamos rollback, se visualiza el error del procedimiento
            rollback;
            dbms_output.put_line('Error: ' || SQLERRM);
    end;
    -- Espera de 5 segundos antes de la siguiente instrucción
    dbms_lock.sleep(5);
end;
/
show errors


Prompt =======================================
Prompt Prueba 3 (La prueba es exitosa si el procedimiento se ejecuta de forma correcta al actualizar el estado del pedido existente)
prompt Intentando actualizar un pedido con el uso del procedimiento en donde el id a actualizar si existe
Prompt ========================================

set serveroutput on
-- Declaramos la variable
variable v_pedido_id number

exec dbms_output.put_line('Prueba para la actualizacion de un pedido existente con un id');
exec :v_pedido_id := 9;

-- Ejecutamos el procedimiento que realizamos 
declare
begin
    begin
        crea_actualiza_pedido(:v_pedido_id, v_estado_actual => 2);
        commit; -- todo se realizó de forma correcta
        dbms_output.put_line('Se actualizo el pedido con id: ' || :v_pedido_id);
    exception
        when others then
            -- Algo salió mal por lo que aplicamos rollback, se visualiza el error del procedimiento
            rollback;
            dbms_output.put_line('Error: ' || SQLERRM);
    end;
    -- Espera de 5 segundos antes de la siguiente instrucción
    dbms_lock.sleep(5);
end;
/
show errors


Prompt =======================================
Prompt Prueba 4 (La prueba es exitosa si el procedimiento se ejecuta de forma incorrecta al no actualizar el estado del pedido no existente)
prompt Intentando actualizar un pedido con el uso del procedimiento en donde el id a actualizar no existe
Prompt ========================================

set serveroutput on
-- Declaramos la variable
variable v_pedido_id number

exec dbms_output.put_line('Prueba para la actualizacion de un pedido no existente');
exec :v_pedido_id := 13;

-- Ejecutamos el procedimiento que realizamos 
declare
begin
    begin
        crea_actualiza_pedido(:v_pedido_id, v_estado_actual => 2);
        commit; -- todo se realizó de forma correcta
        dbms_output.put_line('Se actualizo el pedido con id: ' || :v_pedido_id);
    exception
        when others then
            -- Algo salió mal por lo que aplicamos rollback, se visualiza el error del procedimiento
            rollback;
            dbms_output.put_line('Error: ' || SQLERRM);
    end;
    -- Espera de 5 segundos antes de la siguiente instrucción
    dbms_lock.sleep(5);
end;
/
show errors