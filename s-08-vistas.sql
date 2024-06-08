--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Creación de vistas de escenarios concretos.

--Comentarios de la fecha, autores y descripcion

prompt Conectando como vl_proy_admin
connect vl_proy_admin/proyecto
prompt Creando vistas.
--Vista que representa a toda la jerarquía de centros de operaciones en un concentrado.
create or replace view v_centro_operaciones(
  centro_operaciones_desnormalizada_id,clave,direccion,latitud,
  longitud,telefono,es_farmacia,es_almacen,es_oficina,nombre_oficina,
  telefono_oficina,clave_presupuestal_oficina,almacen_contingencia_id,
  tipo_almacen,capacidad_almacen,documento_almacen,rfc_farmacia,
  direccion_web_farmacia,gerente_farmacia_id
) as
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

--Vista que permite a los empleados visualizar toda la información del catálogo en una tabla.
create or replace view v_medicamento(
  medicamento_id,nombre_medicamento_id,sustancia_activa,nombre,cantidad
) as
  select medicamento_id,nombre_medicamento_id,m.sustancia_activa,nm.nombre,pm.cantidad
  from medicamento m
  natural join nombre_medicamento nm
  natural join presentacion_medicamento pm;

--Vista que permite a los empleados visualizar información importante de las operaciones internas en una tabla.
create or replace view v_operacion(
    operacion_id,almacen_id,fecha,tipo,unidades,medicamento_id
) as
  select operacion_id,o.almacen_id,o.fecha,o.tipo,om.unidades,pm.nombre_medicamento_id
  from operacion o
  natural join operacion_medicamento om
  natural join presentacion_medicamento pm;

--Vista que permite a los empleados visualizar información importante de los pedidos en una tabla concentrada.
create or replace view v_pedido(
    pedido_id,folio,fecha_emision,importe,cliente_id,presentacion_medicamento_id,farmacia_id,unidades
) as
  select pedido_id,p.folio,p.fecha_emision,p.importe,p.cliente_id,pm.presentacion_medicamento_id,pm.farmacia_id,pm.unidades
  from pedido p
  natural join pedido_medicamento pm;
prompt Listo!
disconnect