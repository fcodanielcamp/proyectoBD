--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Código para la creacion de el procedimiento el cual hace las
--              inserciones correspondientes para cada pedido con su respectivo historial

Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Creando procedimiento s-13-p-crea_actualiza_pedido.sql.

create or replace procedure crea_actualiza_pedido (
  v_pedido_id        in       out         number,
  v_fecha_emision    in       date        default     null,
  v_importe          in       number      default     null,
  v_cliente_id       in       number      default     null,
  v_responsable_id   in       number      default     null,
  v_estado_actual    in       number,
  v_ubicacion_id     in       number      default     null
) is
  -- Variabke que nos permite saber si ya existe el registro o aun no, si existe es mayor a 0
  v_pedido_existe number;
begin
  -- Verificamos si el pedido que se ingreso ya existe verificamos si el pedido ingresado ya existe
  select count(*) into v_pedido_existe
  from pedido
  where pedido_id = v_pedido_id;
  -- Si el pedido no existe, el valor de la variable auxiliar sera cero por lo que se procedera a crear un nuevo pedido
  if v_pedido_existe = 0 then 
    -- Con ayuda de la secuencia creamos el id del siguiente pedido como lo vimos en clase
    select pedido_seq.nextval into v_pedido_id from dual;
    -- Insertamos el nuevo pedido con sus respectivos datos
    insert into pedido (
      pedido_id,fecha_emision,importe,fecha_estado_actual,
      cliente_id,responsable_id,estado_actual,ubicacion_id
    ) values (
      v_pedido_id,sysdate,v_importe,sysdate,v_cliente_id,
      v_responsable_id,v_estado_actual,v_ubicacion_id
    );
  else
    -- En el caso de que ya exista el pedido, solo vamoa a actualizar el estado acual el cual se ingreso y la fecha del estado actual siendo sysdate
    update pedido
    set 
    estado_actual = v_estado_actual,
    fecha_estado_actual = sysdate
    where pedido_id = v_pedido_id;
  end if;
  /*Para ambos casos, se inserte o actualice, se necesita llevar acabo el registro del historial con toda la informacion, como lo es el uso de la secuencia para 
  el nuevo id, la fecha es la misma del estado actual, el estado del pedido es por el que se actualizara y el pedido_id es ya sea el que se creo o el que se actualizo*/
  insert into historico_estado (
    historico_estado_id,fecha,
    estado_pedido_id,pedido_id
  ) values (
    historico_estado_seq.nextval,sysdate,
    v_estado_actual,v_pedido_id
  );
end;
/
-- Mostramos (si existen) errores para la creacion del procedimiento
show errors