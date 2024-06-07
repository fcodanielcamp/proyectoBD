--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 05/06/2024
--@Descripción: Creación de un escenario donde se desea visualizar la información completo de los centros de operaciones, indpendientemente de la jerarquía.

--Comentarios de la fecha, autores y descripcion

prompt Conectando como vl_proy_admin
connect vl_proy_admin/proyecto
prompt 

create global temporary table centro_operaciones_desnormalizada(
  centro_operaciones_desnormalizada_id       number(10,0)
    constraint centro_operaciones_desnormalizada_pk primary key,
  clave                       char(6)         not null,
  direccion                   varchar2(100)   not null,
  latitud                     varchar2(20)    not null,
  longitud                    varchar2(20)    not null,
  telefono                    numeric(10,0)   not null,
  es_farmacia                 numeric(1,0)    not null,
  es_almacen                  numeric(1,0)    not null,
  es_oficina                  numeric(1,0)    not null,
  nombre_oficina              varchar2(40)    null,
  telefono_oficina            numeric(10,0)   null,
  clave_presupuestal_oficina  varchar2(40)    null,
  almacen_contingencia_id     number(10,0)    null,
  tipo_almacen                char(1)         null,
  capacidad_almacen           numeric(10,0)   null,
  documento_almacen           blob            null,
  rfc_farmacia                varchar2(13)    null,
  direccion_web_farmacia      varchar2(100)   null,
  gerente_farmacia_id         number(10,0)    null,
  constraint centro_operaciones_desnormalizada_clave_uk unique (clave),
  constraint centro_operaciones_desnormalizada_tipo_chk check(
    (es_farmacia=1 and es_almacen=0 and es_oficina=0) or
    (es_farmacia=1 and es_almacen=1 and es_oficina=0) or
    (es_farmacia=0 and es_almacen=1 and es_oficina=0) or
    (es_farmacia=0 and es_almacen=0 and es_oficina=1)
  ),
  constraint centro_operaciones_desnormalizada_clave_presupuestal_oficina_uk
    unique (clave_presupuestal_oficina),
  constraint centro_operaciones_desnormalizada_tipo_almacen_chk check(
    tipo_almacen='C' or tipo_almacen='M' or tipo_almacen='D' or tipo_almacen is null
  ),
  constraint centro_operaciones_desnormalizada_rfc_farmacia_uk unique (rfc_farmacia)
) on commit delete rows;

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

prompt Listo!
disconnect