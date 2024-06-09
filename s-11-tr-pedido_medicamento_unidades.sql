--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 08/06/2024
--@Descripción: Trigger que se dispara cuando se solicita un medicamento en un pedido.

--Comentarios de la fecha, autores y descripcion
Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Creando trigger pedido_medicamento_trigger
create or replace trigger pedido_medicamento_trigger
  before insert or update or delete of unidades on pedido_medicamento
  for each row
  declare
    v_unidades_disponibles inventario_medicamento.unidades%type;
    v_medicamento_existe number(1,0);
  begin
    case
      when inserting then
        select count(*) into v_medicamento_existe
        from inventario_medicamento
        where presentacion_medicamento_id=:new.presentacion_medicamento_id
          and farmacia_id=:new.farmacia_id;
        if v_medicamento_existe = 1 then
          select unidades into v_unidades_disponibles
          from inventario_medicamento
          where farmacia_id = :new.farmacia_id
            and presentacion_medicamento_id= :new.presentacion_medicamento_id;
          if :new.unidades > v_unidades_disponibles then
            dbms_output.put_line('No hay unidades suficientes del medicamento con presentacion_medicamento_id = '
              || :new.presentacion_medicamento_id
              || ' en la farmacia con centro_operaciones_id = '
              || :new.farmacia_id
              || '.'
            );
            raise_application_error(-20001, 'No hay suficiente stock del medicamento en la farmacia solicitada.');
          end if;
        else
          dbms_output.put_line('El medicamento con presentacion_medicamento_id = '
              || :new.presentacion_medicamento_id
              || ' no existe en la farmacia con centro_operaciones_id = '
              || :new.farmacia_id
              || '.'
            );
            raise_application_error(-20020, 'No hay unidades del medicamento solicitado en la farmacia solicitada.');
        end if;
      when updating then
        if :new.unidades != :old.unidades then
          dbms_output.put_line('No se puede actualizar las unidades solicitadas en un pedido');
          raise_application_error(-20002,'No se permiten actualizaciones en las unidades solicitadas de un medicamento.');
        end if;
      when deleting then
        dbms_output.put_line('No se puede eliminar un registro de un medicamento en un pedido');
        raise_application_error(-20003,'No se permiten eliminaciones del registro de un medicamento en un pedido.');
    end case;
  end;
/
show errors