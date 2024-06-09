--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 07/06/2024
--@Descripción: Código para la prueba de el procedimiento

Prompt Probando procedimiento s-13-p-actualiza_pedido_ubicacion.sql.

Prompt =======================================
Prompt Prueba 1 (La prueba es exitosa si el procedimiento se ejecuta de forma correcta)
prompt Intentando actualizar la ubicacion de un pedido existente con el uso del procedimiento
Prompt ========================================

set serveroutput on
-- Declaramos la variable
variable v_pedido_id number
exec :v_pedido_id := 9;

exec dbms_output.put_line('Prueba para la actualizacion de la ubicacion de un pedido');
-- Ejecutamos el procedimiento que realizamos 
declare
begin
    begin
        actualiza_pedido_ubicacion(:v_pedido_id, 31);
        commit; -- Todo se realizó de forma correcta
        dbms_output.put_line('Ubicacion actualizada del pedido con id: ' || :v_pedido_id);
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
Prompt Prueba 2 (La prueba es exitosa si el procedimiento se ejecuta de forma incorrecta)
prompt Intentando actualizar la ubicacion de un pedido no existente con el uso del procedimiento
Prompt ========================================

set serveroutput on
-- Declaramos la variable
variable v_pedido_id number
exec :v_pedido_id := 15;

exec dbms_output.put_line('Prueba para la actualizacion de la ubicacion de un pedido');
-- Ejecutamos el procedimiento que realizamos 
declare
begin
    begin
        actualiza_pedido_ubicacion(:v_pedido_id, 16);
        commit; -- Todo se realizó de forma correcta
        dbms_output.put_line('Ubicacion actualizada del pedido con id: ' || :v_pedido_id);
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
Prompt Prueba 3 (La prueba es exitosa si el procedimiento se ejecuta de forma correcta)
prompt Intentando actualizar la ubicacion de un pedido existente con el uso del procedimiento
Prompt ========================================

set serveroutput on
-- Declaramos la variable
variable v_pedido_id number
exec :v_pedido_id := 9;

exec dbms_output.put_line('Prueba para la actualizacion de la ubicacion de un pedido');
-- Ejecutamos el procedimiento que realizamos 
declare
begin
    begin
        actualiza_pedido_ubicacion(:v_pedido_id, 25);
        commit; -- Todo se realizó de forma correcta
        dbms_output.put_line('Ubicacion actualizada del pedido con id: ' || :v_pedido_id);
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