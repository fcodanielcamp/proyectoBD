--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 08/06/2024
--@Descripción: Prueba idempotente de s-11-tr-pedido_ubicacion.sql

--Comentarios de la fecha, autores y descripcion
Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Probando trigger pedido_medicamento_trigger
set serveroutput on
prompt Ejecutando pruebas automáticas

Prompt =======================================
Prompt Prueba 1 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando registrar un pedido con ubicación.
Prompt ========================================
begin
  insert into pedido(pedido_id,fecha_emision,importe,fecha_estado_actual,cliente_id,responsable_id,estado_actual,ubicacion_id)
  values (pedido_seq.nextval,sysdate,300.50,sysdate,15,15,1,15);
  raise_application_error(-20013,'ERROR: El trigger no generó error -20005');
exception
  when others then
    if sqlcode = -20005 then
      dbms_output.put_line('Ok - Prueba exitosa!, se esperaba error -20005');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/

Prompt OK, prueba 1 exitosa.

Prompt =======================================
Prompt Prueba 2 (positiva: La prueba es exitosa si se ejecuta correctamente la sentencia)
prompt Intentando registar un pedido sin ubicación.
Prompt ========================================
begin
  insert into pedido(pedido_id,fecha_emision,importe,fecha_estado_actual,cliente_id,responsable_id,estado_actual,ubicacion_id)
  values (pedido_seq.nextval,sysdate,300.50,sysdate,15,15,1,null);
  dbms_output.put_line('Ok - Prueba exitosa!, el registro váĺido se insertó correctamente.');
exception
  when others then
    if sqlcode = -20005 then
      dbms_output.put_line('Prueba fallida. NO SE ESPERABA ERROR -20005');
    else
      dbms_output.put_line('ERROR: El trigger generó un error inesperado.');
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/

Prompt OK, prueba 2 exitosa.

Prompt =======================================
Prompt Prueba 3 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando actualizar la ubicación de un pedido que no está en tránsito.
Prompt ========================================
begin
  update pedido
  set ubicacion_id = 37
  where pedido_id = 1;
  raise_application_error(-20014,'ERROR: El trigger no generó error -20006');
exception
  when others then
    if sqlcode = -20006 then
      dbms_output.put_line('Ok - Prueba exitosa!, se esperaba error -20006');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/

Prompt OK, prueba 3 exitosa.

Prompt =======================================
Prompt Prueba 4 (positiva: La prueba es exitosa si se ejecuta correctamente la sentencia)
prompt Intentando actualizar la ubicación de un pedido en tránsito.
Prompt ========================================
begin
  update pedido
  set ubicacion_id = 37
  where pedido_id = 4;
  dbms_output.put_line('Ok - Prueba exitosa!, el registro se actualizó correctamente.');
exception
  when others then
    if sqlcode = -20006 then
      dbms_output.put_line('Prueba fallida. NO SE ESPERABA ERROR -20006');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/


Prompt OK, prueba 4 exitosa.

Prompt =======================================
Prompt Prueba 5 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando borrar la ubicación de un pedido en tránsito.
Prompt ========================================
begin
  delete from pedido
	where pedido_id = 4;
  raise_application_error(-20015,'ERROR: El trigger no generó error -20007');
exception
  when others then
    if sqlcode = -20007 then
      dbms_output.put_line('Ok - Prueba exitosa!, se esperaba error -20007');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/


Prompt OK, prueba 5 exitosa.

Prompt =======================================
Prompt Prueba 6 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando borrar un pedido que se entregó.
Prompt ========================================
begin
  insert into pedido (pedido_id, fecha_emision, importe, fecha_estado_actual, cliente_id, responsable_id, estado_actual, ubicacion_id) 
  values (pedido_seq.nextval, TO_DATE('2024-06-04 05:20:54','YYYY-MM-DD HH24:MI:SS'), 1000.00,
    TO_DATE('2024-06-05 07:45:21','YYYY-MM-DD HH24:MI:SS'), 9, 26, 3, null);
  update pedido set estado_actual = 3 where importe=1000.00;
  delete from pedido
	where importe = 1000.00;
  dbms_output.put_line('Ok - Prueba exitosa!, el registro se borró correctamente.');
exception
  when others then
    if sqlcode = -20007 then
      dbms_output.put_line('Prueba fallida. NO SE ESPERABA ERROR -20007');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/

Prompt OK, prueba 6 exitosa.

prompt Haciendo rollback para limpiar los datos de Prueba
rollback;