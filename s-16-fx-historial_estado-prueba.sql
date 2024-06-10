
--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 09/06/2024
--@Descripción: Prueba para la función s-15-fx-historial_estado.sql

set serveroutput on;

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
select obtener_historial_estados(4) as obtener_historial_estados_4 from DUAL;


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
select obtener_historial_estados(9) as obtener_historial_estados_9 from DUAL;