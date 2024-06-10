--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 09/06/2024
--@Descripción: Código para la creación de una función que devuelve medicamentos buscados por nombre.


Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Creando función s-15-fx-nimbre_medicamento.sql

-- Crear la función para obtener el historial de estados de un pedido
create or replace function obtener_nombre_medicamento(
    p_nombre varchar2
) 
    return sys_refcursor  -- Va a devolver un cursor de referencia del sistema esto para traer todos los regisros
is 
    v_medicamento sys_refcursor; -- Aqui almacenamos el resultado de la consulta (en esta variable)
begin
    -- Abrimos el cursor para seleccionar el historial de estados del pedido especificado empleando una consulta
    open v_medicamento for
        select m.medicamento_id, nm.nombre, pm.cantidad as pastillas_por_caja
        from nombre_medicamento nm
        join medicamento m on m.medicamento_id = nm.medicamento_id
        join presentacion_medicamento pm on nm.nombre_medicamento_id = pm.nombre_medicamento_id
        where lower(nm.nombre) like '%' || lower(p_nombre) || '%'
        order by nm.nombre;
    
    -- Devolvemos el cursor que trae todos los estados
    return v_medicamento;
exception
    when others then
        dbms_output.put_line('Error: ' || SQLERRM);
        -- relanzar cualquier excepción en caso de que haya ocurrido algun error
        raise;
end;
/