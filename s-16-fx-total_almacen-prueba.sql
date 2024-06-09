--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 09/06/2024
--@Descripción: Prueba para la función s-15-fx-total_almacen.sql
Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Probando función s-15-fx-total_almacen.sql
set serveroutput on

Prompt =======================================
Prompt Prueba 1
prompt almacen_id = 1
Prompt ========================================
Prompt Consulta con sum(unidades) para operaciones de entrada
select o.almacen_id,sum(om.unidades) as total_unidades_entrada
from operacion_medicamento om
natural join operacion o
where o.tipo = 'E'
and o.almacen_id=1
group by o.almacen_id;
Prompt Consulta con sum(unidades) para operaciones de salida
select o.almacen_id,sum(om.unidades) as total_unidades_salida
from operacion_medicamento om
natural join operacion o
where o.tipo = 'S'
and o.almacen_id=1
group by o.almacen_id;
Prompt Probando función (2850-25=2825)
select total_almacen(1) as total_alamcen_1 from dual;

Prompt =======================================
Prompt Prueba 2
prompt almacen_id = 9
Prompt ========================================
Prompt Consulta con sum(unidades) para operaciones de entrada
select o.almacen_id,sum(om.unidades) as total_unidades_entrada
from operacion_medicamento om
natural join operacion o
where o.tipo = 'E'
and o.almacen_id=9
group by o.almacen_id;
Prompt Consulta con sum(unidades) para operaciones de salida
select o.almacen_id,sum(om.unidades) as total_unidades_salida
from operacion_medicamento om
natural join operacion o
where o.tipo = 'S'
and o.almacen_id=9
group by o.almacen_id;
Prompt Probando función (1500-65=1435)
select total_almacen(9) as total_alamcen_9 from dual;

Prompt =======================================
Prompt Prueba 3
prompt almacen_id = 17
Prompt ========================================
Prompt Consulta con sum(unidades) para operaciones de entrada
select o.almacen_id,sum(om.unidades) as total_unidades_entrada
from operacion_medicamento om
natural join operacion o
where o.tipo = 'E'
and o.almacen_id=17
group by o.almacen_id;
Prompt Consulta con sum(unidades) para operaciones de salida
select o.almacen_id,sum(om.unidades) as total_unidades_salida
from operacion_medicamento om
natural join operacion o
where o.tipo = 'S'
and o.almacen_id=17
group by o.almacen_id;
Prompt Probando función (1200-35=1165)
select total_almacen(17) as total_alamcen_17 from dual;