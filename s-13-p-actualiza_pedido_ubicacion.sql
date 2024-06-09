--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 07/06/2024
--@Descripción: Código para la creacion de el procedimiento el cual hace las
--              inserciones correspondientes para cada pedido con su respectivo historial de ubicaciones


Prompt Creando procedimiento s-13-p-actualiza_pedido_ubicacion.sql.

create or replace procedure actualiza_pedido_ubicacion (
    v_pedido_id     in      number,
    v_ubicacion_id  in      number
) is
    -- Variable que nos permite saber si ya existe el registro o aun no, si existe es mayor a 0
    v_pedido_existe number;
begin
    -- Verificamos si el pedido que se ingreso ya existe verificamos si el pedido ingresado ya existe
    select count(*) into v_pedido_existe
    from pedido
    where pedido_id = v_pedido_id;
    -- Si el pedido no existe, el valor de la variable auxiliar sera cero por lo que se procedera a crear un nuevo pedido
    if v_pedido_existe = 0 then
        raise_application_error(-20007, 'El id de el pedido ingresado no se encuentra registrado');
    else
        -- En el caso de que ya exista el pedido, solo vamos a actualizar la ubicacion
        update
        pedido
    set 
        ubicacion_id = v_ubicacion_id
    where 
        pedido_id = v_pedido_id;

        --Al actualizar la ubicacion, tenemos que meterlo al historial de ubicaciones
        insert into historico_ubicacion (
          historico_ubicacion_id, fecha,
          pedido_id, ubicacion_id
        ) values (
            historico_ubicacion_seq.nextval, sysdate,
            v_pedido_id, v_ubicacion_id
        );
    end if;
end;
/
show errors