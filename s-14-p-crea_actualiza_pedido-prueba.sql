--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Código para la prueba de el procedimiento


set serveroutput on
-- Declaramos la variable
variable v_pedido_id number

--Primera prueba

exec dbms_output.put_line('Prueba para la creacion de un nuevo pedido sin asignar un id');
-- Ejecutamos el procedimiento que realizamos 
declare
begin
  crea_actualiza_pedido(:v_pedido_id, sysdate, 100.50, 44, 68, 1, null);
  commit; -- Todo se realizó de forma correcta
exception
  when others then
  -- Algo salió mal por lo que aplicamos rollback
  rollback;
end;
/
-- mostrar el id del pedido insertado
exec dbms_output.put_line('Nuevo pedido creado/actualizado con el id: ' || :v_pedido_id);

-- Segunda prueba
exec dbms_output.put_line('Prueba para la actualizacion de un pedido existente con un id');
exec :v_pedido_id := 6;

-- Ejecutamos el procedimiento que realizamos 
begin
  crea_actualiza_pedido(:v_pedido_id, v_estado_actual => 2);
  commit; -- todo se realizó de forma correcta
exception
  when others then
    -- algo salió mal por lo que aplicamos rollback
    rollback;
end;
/
-- mostrar el id del pedido actualizado
exec dbms_output.put_line('Se actualizo el pedido con id: ' || :v_pedido_id);

prompt Haciendo rollback para limpiar los datos de Prueba
rollback;