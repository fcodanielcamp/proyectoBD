
SET SERVEROUTPUT ON;

Prompt =======================================
Prompt Prueba 1
prompt pedido_id = 4
Prompt ========================================
Prompt consulta con sus correspondientes joins para el pedido deseado
select he.pedido_id, he.fecha, ep.clave, ep.descripcion
        from historico_estado he
        join estado_pedido ep on he.estado_pedido_id = ep.estado_pedido_id
        where he.pedido_id = 4
        order by he.fecha;

Prompt Ejecutando la función para obtener el historial de estados de un pedido específico
SELECT obtener_historial_estados(4) AS obtener_historial_estados_4 FROM DUAL;


Prompt =======================================
Prompt Prueba 2
prompt pedido_id = 9
Prompt ========================================
Prompt consulta con sus correspondientes joins para el pedido deseado
select he.pedido_id, he.fecha, ep.clave, ep.descripcion
        from historico_estado he
        join estado_pedido ep on he.estado_pedido_id = ep.estado_pedido_id
        where he.pedido_id = 9
        order by he.fecha;

Prompt Ejecutando la función para obtener el historial de estados de un pedido específico
SELECT obtener_historial_estados(9) AS obtener_historial_estados_9 FROM DUAL;