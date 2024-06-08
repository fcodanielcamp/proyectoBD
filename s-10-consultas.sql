--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Consultas empleando inner join, natural join, outer join funciones de agregación (group by y having)
--              álgebra relacional, subconsultas, consultas usando sinonimos, vistas, tablas temporales y tablas externas.

Prompt conectando como invitado
connect vl_proy_invitado/proyecto
-- Consulta de una tabla con el uso de un sinonimo
/*
En esta consulta se muestran todos sus datos correspondientes de todos los clientes que tengan una direccion de envio 
en donde aparezca la cadena: 'Naucalpan'. El sinónimo es usado por el usuario invitado.
*/
select * 
from cliente
where lower(direccion_envio) like('%naucalpan%');

Prompt conectado como admin nuevamente para las siguientes consultas
connect vl_proy_admin/proyecto

-- Consulta de una tabla externa
/*
En esta consulta se obtiene la clave, la descripcion y el precio unitario para las entradas de medicamento de la tabla externa 
que ocurrieron entre Marzo 2019 y Junio 2019
*/
select clave,descripcion,precio_unitario
from entradas_medicamento
where fecha_entrega between to_date('01-03-2019','dd-mm-yyyy') and to_date('30-06-2019','dd-mm-yyyy');

-- Consulta de una tabla temporal
/*
Como anteriormente se hizo commit para las inserciones, es necesario volver a llenar la tabla temporal con el merge, 
como se hizo en el script s-03-tablas_temporales.sql. La consulta realiza un conteo de cada tipo de centro de operaciones. 
Ya que existe la situación de que una farmacia puede ser también un almacén, se cuenta 1 para cada tipo de centro, 
por lo que la suma de la cuenta total podría ser mayor al número de establecimientos.
*/
--Llenado de tabla temporal.
merge into centro_operaciones_desnormalizada cod using v_centro_operaciones vco on
(cod.centro_operaciones_desnormalizada_id = vco.centro_operaciones_desnormalizada_id)
when matched then update
set cod.clave=vco.clave,cod.direccion=vco.direccion,cod.latitud=vco.latitud,
  cod.longitud=vco.longitud,cod.telefono=vco.telefono,cod.es_farmacia=vco.es_farmacia,
  cod.es_almacen=vco.es_almacen,cod.es_oficina=vco.es_oficina,cod.nombre_oficina=vco.nombre_oficina,
  cod.telefono_oficina=vco.telefono_oficina,cod.clave_presupuestal_oficina=vco.clave_presupuestal_oficina,
  cod.almacen_contingencia_id=vco.almacen_contingencia_id,cod.tipo_almacen=vco.tipo_almacen,
  cod.capacidad_almacen=vco.capacidad_almacen,cod.documento_almacen=vco.documento_almacen,
  cod.rfc_farmacia=vco.rfc_farmacia,cod.direccion_web_farmacia=vco.direccion_web_farmacia,
  cod.gerente_farmacia_id=vco.gerente_farmacia_id
when not matched then insert
(cod.centro_operaciones_desnormalizada_id,cod.clave,cod.direccion,cod.latitud,cod.longitud,cod.telefono,cod.es_farmacia,
  cod.es_almacen,cod.es_oficina,cod.nombre_oficina,cod.telefono_oficina,cod.clave_presupuestal_oficina,
  cod.almacen_contingencia_id,cod.tipo_almacen,cod.capacidad_almacen,cod.documento_almacen,
  cod.rfc_farmacia,cod.direccion_web_farmacia,cod.gerente_farmacia_id)
values
(vco.centro_operaciones_desnormalizada_id,vco.clave,vco.direccion,vco.latitud,vco.longitud,vco.telefono,vco.es_farmacia,
  vco.es_almacen,vco.es_oficina,vco.nombre_oficina,vco.telefono_oficina,vco.clave_presupuestal_oficina,
  vco.almacen_contingencia_id,vco.tipo_almacen,vco.capacidad_almacen,vco.documento_almacen,
  vco.rfc_farmacia,vco.direccion_web_farmacia,vco.gerente_farmacia_id);
--Consulta
select
  count(nombre_oficina) as numero_oficinas,
  count(tipo_almacen) as numero_almacenes, 
  count(rfc_farmacia) as numero_farmacias 
from centro_operaciones_desnormalizada;

--Consultas de vistas
/*
En esta consulta se pone a prueba el funcionamiento de las vistas creadas en el script s-08-vistas.sql.
*/
select * from v_centro_operaciones;
select * from v_medicamento;
select * from v_operacion;
select * from v_pedido;

--Natural join. 
/*
Se emplea natural join porque se desea extener la información de la operación usando operacion_id como factor de correspondencia.
*/
select operacion_id,o.almacen_id,o.fecha,o.tipo,om.unidades,pm.nombre_medicamento_id
from operacion o
natural join operacion_medicamento om
natural join presentacion_medicamento pm
order by operacion_id;

--Outer join.
/*
Se emplea left outer join porque se desea consultar toda la infomación de los centros de operaciones en una tabla concentrada,
independientemente de su tipo. Esto tiene como consecuencia varios campos completos vacíos, por lo que un inner join no funciona.
*/
select co.centro_operaciones_id,co.clave,co.direccion,co.latitud,co.longitud,
  co.telefono,co.es_farmacia,co.es_almacen,co.es_oficina,o.nombre,o.telefono,
  o.clave_presupuestal,a.almacen_contingencia_id,a.tipo,a.capacidad,a.documento,
  f.rfc,f.direccion_web,f.gerente_id
from centro_operaciones co
left outer join oficina o
on co.centro_operaciones_id=o.centro_operaciones_id
left outer join almacen a
on co.centro_operaciones_id=a.centro_operaciones_id
left outer join farmacia f
on co.centro_operaciones_id=f.centro_operaciones_id;

--Inner join
/*
Esta consulta muestra toda la inforación de todos los clientes que tienen tarjeta.
*/
select *
from cliente c
join tarjeta t
on c.cliente_id=t.cliente_id;

--Group by y having
/*
Esta consulta muestra la cantidad de operaciones de almacén que han realizado los empleados.
Se desea otorgar un incentivo a aquellos que hayan llevado a cabo 3 o más operaciones.
*/
select responsable_id,count(*) as total_operaciones
from operacion
group by responsable_id
having count(*)>=3;

-- Álgebra relacional - minus
/*
Esta consulta muestra a los clientes que no tienen tarjeta registrada.
*/
select *
from cliente
minus
select c.cliente_id,c.nombre,c.apellido_paterno,
  c.apellido_materno,c.email,c.telefono,c.rfc,
  c.curp,c.direccion_envio
from cliente c
join tarjeta t
on c.cliente_id=t.cliente_id;

-- Álgebra relacional - union
/*
Esta consulta muestra a los empleados que han participado en al menos una operación en el almacén o en una venta en la farmacia.
*/
select e.empleado_id,e.rfc
from empleado e
join operacion o
on e.empleado_id=o.responsable_id
union
select e.empleado_id,e.rfc
from empleado e
join pedido p
on e.empleado_id=p.responsable_id;

--Álgebra relacional - intersect
/*
Esta consulta muestra a los empleados que han participado en al menos una operación en el almacén y en una venta en la farmacia.
*/
select e.empleado_id,e.rfc
from empleado e
join operacion o
on e.empleado_id=o.responsable_id
intersect
select e.empleado_id,e.rfc
from empleado e
join pedido p
on e.empleado_id=p.responsable_id;

--Subconsultas - Cláusula where
/*
Esta consulta muestra el id, la fecha de emisión y el importe del pedido con el mayor importe.
*/
select pedido_id,folio,fecha_emision,importe
from pedido
where importe= (
  select max(importe)
  from pedido
);

--Subconsultas - Cláusula select
/*
Esta consulta muestra el importe de cada pedido, para poder compararlo con el promedio de importes de todos los pedidos.
*/
select pedido_id,folio,fecha_emision,importe,(
  select avg(importe)
  from pedido) as promedio_importe
from pedido;

--Subconsultas - Cláusula from
/*
Esta consulta muestra el id y tipo de operacion; el id rfc del responsable; el id,tipo y capacidad del almacen; y el total de unidades que se ingresaron de todas las operaciones de entrada.
*/
select o.operacion_id,o.tipo as tipo_operacion,o.responsable_id,
  e.rfc as rfc_responsable,o.almacen_id,a.tipo as tipo_almacen,
  a.capacidad as capacidad_almacen,q.total_unidades_ingresadas
from (
  select om.operacion_id,sum(om.unidades) as total_unidades_ingresadas
  from operacion_medicamento om
  join operacion o
  on om.operacion_id=o.operacion_id
  where o.tipo = 'E'
  group by om.operacion_id
) q
join operacion o
on o.operacion_id=q.operacion_id
join empleado e
on o.responsable_id=e.empleado_id
join almacen a
on a.centro_operaciones_id=o.almacen_id
order by operacion_id;