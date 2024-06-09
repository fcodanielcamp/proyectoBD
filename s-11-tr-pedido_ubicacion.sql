--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 08/06/2024
--@Descripción: Trigger que se dispara cuando se intenta ingresar una ubicación.

--Comentarios de la fecha, autores y descripcion
Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Creando trigger pedido_ubicacion_trigger
create or replace trigger pedido_ubicacion_trigger
  before insert or update or delete of ubicacion_id on pedido
  for each row
  begin
    case
      when inserting then
        if :new.ubicacion_id is not null then
          dbms_output.put_line('No se puede asignar una ubicación a un pedido que se está insertando, ya que su estado no es EN TRÁNSITO');
          raise_application_error(-20005,'No se permite ingresar una ubicación en un nuevo pedido.');
        end if;
      when updating then
        if :new.estado_actual != 2 then
          dbms_output.put_line('No se puede asignar una ubicación a un pedido que tiene un estado_actual que no es EN TRÁNSITO');
          raise_application_error(-20006,'No se permite ingresar una ubicación a un pedido que no está en tránsito.');
        end if;
      when deleting then
        if (:old.estado_actual != 3 and :old.estado_actual != 4) then
          dbms_output.put_line('No se puede borrar un pedido que tiene un estado_actual EN TRÁNSITO');
          raise_application_error(-20007,'No se permite borrar un pedido que está en tránsito.');
        end if;
    end case;
  end;
/
show errors