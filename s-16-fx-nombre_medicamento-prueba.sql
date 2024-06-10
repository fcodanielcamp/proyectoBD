--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 09/06/2024
--@Descripción: Prueba para la función s-15-fx-nombre_medicamento.sql

Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Probando función s-15-fx-nombre_medicamento.sql
set serveroutput on

Prompt =======================================
Prompt Prueba 1
prompt nombre del medicamento = Brontiflex
Prompt ========================================

select m.medicamento_id, nm.nombre, pm.cantidad
        from nombre_medicamento nm
        join medicamento m on m.medicamento_id = nm.medicamento_id
        join presentacion_medicamento pm on nm.nombre_medicamento_id = pm.nombre_medicamento_id
        where lower(nm.nombre) like '%brontiflex%'
        order by nm.nombre;

Prompt Ejecutando la función para obtener los medicamentos con nombre Brontiflex
select obtener_nombre_medicamento('Brontiflex') AS obtener_medicamentos_Brontiflex from dual;



Prompt =======================================
Prompt Prueba 2
prompt nombre del medicamento Lipozine
Prompt ========================================

select m.medicamento_id, nm.nombre, pm.cantidad as pastillas_por_caja
        from nombre_medicamento nm
        join medicamento m on m.medicamento_id = nm.medicamento_id
        join presentacion_medicamento pm on nm.nombre_medicamento_id = pm.nombre_medicamento_id
        where lower(nm.nombre) like '%lipozine%'
        order by nm.nombre;

Prompt Ejecutando la función para obtener los medicamentos con nombre Brontiflex
select obtener_nombre_medicamento('Lipozine') AS obtener_medicamentos_Brontiflex from dual;