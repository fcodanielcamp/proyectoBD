--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 08/06/2024
--@Descripción: Prueba idempotente de s-11-tr-pedido_medicamento_unidades.sql

--Comentarios de la fecha, autores y descripcion
Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Probando trigger pedido_medicamento_trigger
set serveroutput on
prompt Ejecutando pruebas automáticas

Prompt =======================================
Prompt Prueba 1 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando registrar un pedido que solicita más unidades de las que hay en el inventario de la farmacia
Prompt ========================================
begin
  insert into pedido_medicamento(pedido_medicamento_id,unidades,pedido_id,farmacia_id,presentacion_medicamento_id)
  values (pedido_medicamento_seq.nextval,31,4,1,7);
  raise_application_error(-20010,'ERROR: El trigger no generó error -20001');
exception
  when others then
    if sqlcode = -20001 then
      dbms_output.put_line('Ok - Prueba exitosa!, se esperaba error -20001');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/


Prompt OK, prueba 1 exitosa.


Prompt =======================================
Prompt Prueba 2 (positiva: La prueba es exitosa si se ejecuta correctamente la sentencia)
prompt Intentando registar un pedido que solicita menos unidades de las que hay en el inventario de la farmacia
Prompt ========================================
begin
  insert into pedido_medicamento(pedido_medicamento_id,unidades,pedido_id,farmacia_id,presentacion_medicamento_id)
  values (pedido_medicamento_seq.nextval,30,4,1,7);
  dbms_output.put_line('Ok - Prueba exitosa!, el registro váĺido se insertó correctamente.');
exception
  when others then
    if sqlcode = -20001 then
      dbms_output.put_line('Prueba fallida. NO SE ESPERABA ERROR -20001');
    else
      dbms_output.put_line('ERROR: El trigger generó un error inesperado.');
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/

Prompt OK, prueba 2 exitosa.


Prompt =======================================
Prompt Prueba 3 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando registrar un pedido que solicita un medicamento que no existe en la farmacia.
Prompt ========================================
begin
  insert into pedido_medicamento(pedido_medicamento_id,unidades,pedido_id,farmacia_id,presentacion_medicamento_id)
  values (pedido_medicamento_seq.nextval,30,4,1,40);
exception
  when others then
    if sqlcode = -20001 then
      raise_application_error(-20011,'ERROR: El trigger generó error -20001');
    elsif sqlcode = 100 then
      dbms_output.put_line('Ok - Prueba exitosa! - el error 100 implica que el medicamento no existe en la farmacia solicitiada.');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/

Prompt OK, prueba 3 exitosa.


Prompt =======================================
Prompt Prueba 4 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando actualizar las unidades de un medicamento en un pedido.
Prompt ========================================
begin
  update pedido_medicamento
  set unidades = 10
  where pedido_medicamento_id = 4
  and pedido_id = 4
  and farmacia_id = 6
  and presentacion_medicamento_id=17;
  raise_application_error(-20012,'ERROR: El trigger no generó error -20002');
exception
  when others then
    if sqlcode = -20002 then
      dbms_output.put_line('Ok - Prueba exitosa!, se esperaba error -20002');
    else
      dbms_output.put_line(' ERROR - código no esperado: '|| sqlcode);
      raise; ---importante. El error se relanza para ver la causa real
    end if;
end;
/

Prompt OK, prueba 4 exitosa.


Prompt =======================================
Prompt Prueba 5 (negativa: La prueba es exitosa si el trigger lanza un Error)
prompt Intentando eliminar las unidades de un medicamento en un pedido.
Prompt ========================================
declare
	v_codigo number;
	v_mensaje varchar2(1000);
begin 
	delete from pedido_medicamento
	where pedido_medicamento_id = 4
  and pedido_id = 4
  and farmacia_id = 6
  and presentacion_medicamento_id=17;

  raise_application_error(-20004,
    'ERROR: El trigger permite operaciones delete');

exception
	when others then
    v_codigo := sqlcode;
    v_mensaje := sqlerrm;
    dbms_output.put_line('Codigo:  ' || v_codigo);
    dbms_output.put_line('Mensaje: ' || v_mensaje);
    if v_codigo = -20003 then
    	dbms_output.put_line('Ok - Prueba exitosa!, se esperaba error -20003');
    else
    	dbms_output.put_line('ERROR, se obtuvo excepción no esperada');
    	raise;
    end if;
end;
/

Prompt OK, prueba 5 exitosa.

prompt Haciendo rollback para limpiar los datos de Prueba
rollback;