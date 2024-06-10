--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 09/06/2024
--@Descripción: Código para la creación de una función que devuelve el historial de estados de un pedido.

Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Creando función s-15-fx-historial_estado.sql


-- Crear la función para obtener el historial de estados de un pedido
create or replace function obtener_historial_estados(
    p_pedido_id number
) 
    return sys_refcursor  -- Va a devolver un cursor de referencia del sistema esto para traer todos los regisros
is 
    v_historial sys_refcursor; -- Aqui almacenamos el resultado de la consulta (en esta variable)
begin
    -- Abrimos el cursor para seleccionar el historial de estados del pedido especificado empleando una consulta
    open v_historial for
        select he.pedido_id, he.fecha, ep.clave, ep.descripcion
        from historico_estado he
        join estado_pedido ep on he.estado_pedido_id = ep.estado_pedido_id
        where he.pedido_id = p_pedido_id
        order by he.fecha;
    
    -- Devolvemos el cursor que trae todos los estados
    return v_historial;
exception
    when others then
        dbms_output.put_line('Error: ' || SQLERRM);
        -- relanzar cualquier excepción en caso de que haya ocurrido algun error
        raise;
end;
/


