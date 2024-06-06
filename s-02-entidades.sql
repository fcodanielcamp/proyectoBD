--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 05/06/2024
--@Descripción: Código DDL para crear las entidades del caso de estudio.

--Comentarios de la fecha, autores y descripcion

Prompt Conectando como vl_proy_admin
connect vl_proy_admin/proyecto
prompt Construyendo base

create table centro_operaciones(
  centro_operaciones_id       number(10,0) constraint centro_operaciones_pk primary key,
  clave                       char(6)         not null,
  direccion                   varchar2(100)   not null,
  latitud                     varchar2(10)    not null,
  longitud                    varchar2(10)    not null,
  telefono                    numeric(10,0)   not null,
  es_farmacia                 numeric(1,0)    not null,
  es_almacen                  numeric(1,0)    not null,
  es_oficina                  numeric(1,0)    not null,
  constraint centro_operaciones_clave_uk unique (clave),
  constraint centro_operaciones_tipo_chk check(
    (es_farmacia=1 and es_almacen=0 and es_oficina=0) or
    (es_farmacia=1 and es_almacen=1 and es_oficina=0) or
    (es_farmacia=0 and es_almacen=1 and es_oficina=0) or
    (es_farmacia=0 and es_almacen=0 and es_oficina=1)
  )
);

create table oficina(
  centro_operaciones_id constraint oficina_pk primary key,
  nombre                      varchar2(40)    not null,
  telefono                    numeric(10,0)   not null,
  clave_presupuestal          varchar2(40)    not null,
  constraint oficina_centro_operaciones_id_fk foreign key (centro_operaciones_id)
    references centro_operaciones(centro_operaciones_id),
  constraint oficina_clave_presupuestal_uk unique (clave_presupuestal)              --Interpretación: La clave presupuestal debe ser única.
);

create table almacen(
  centro_operaciones_id constraint almacen_pk primary key,
  almacen_contingencia_id     number(10,0) null constraint almacen_almacen_contingencia_id_fk
    references centro_operaciones(centro_operaciones_id),
  tipo                        char(1)         not null,
  capacidad                   numeric(10,0)   not null,
  documento                   blob            not null,
  constraint almacen_centro_operaciones_id_fk foreign key (centro_operaciones_id)
    references centro_operaciones(centro_operaciones_id),
  constraint almacen_tipo_chk check(
    tipo='C' or tipo='M' or tipo='D'
  )                                     -- C = Convencional, M = Compacto, D = Dinámico
);

create table empleado(
  empleado_id                 number(10,0) constraint empleado_pk primary key,
  nombre                      varchar2(30)    not null,
  apellido_paterno            varchar2(40)    not null,
  apellido_materno            varchar2(40)    not null,
  fecha_ingreso               date            default on null sysdate,
  rfc                         varchar2(13)    not null,
  constraint empleado_rfc_uk unique (rfc)
);

create table farmacia(
  centro_operaciones_id constraint farmacia_pk primary key,
  rfc                         varchar2(13)    not null,
  direccion_web               varchar2(100)   not null,
  gerente_id not null constraint farmacia_empleado_id_fk 
    references empleado(empleado_id),
  constraint farmacia_centro_operaciones_id_fk foreign key (centro_operaciones_id)
    references centro_operaciones(centro_operaciones_id),
  constraint farmacia_rfc_uk unique (rfc)
);

create table operacion(
  operacion_id number(10,0) constraint operacion_pk primary key,
  fecha                       date            default on null sysdate,
  tipo                        char(1)         not null,
  responsable_id not null constraint operacion_responsable_id_fk 
    references empleado(empleado_id),
  almacen_id not null constraint operacion_almacen_id_fk
    references almacen(centro_operaciones_id),
  constraint operacion_tipo_chk check(
    tipo='E' or tipo='S'
  )                                     -- E = Entrada, S = Salida
);

create table medicamento(
  medicamento_id number(10,0) constraint medicamento_pk primary key,
  sustancia_activa            varchar2(40)    not null,
  descripcion                 varchar2(40)    not null
);

create table nombre_medicamento(
  nombre_medicamento_id number(3,0) constraint nombre_medicamento_pk primary key,
  nombre                      varchar2(40)    not null,
  medicamento_id not null constraint nombre_medicamento_medicamento_id_fk 
    references medicamento(medicamento_id)
);

create table presentacion_medicamento(
  presentacion_medicamento_id number(5,0) constraint presentacion_medicamento_pk primary key,
  cantidad                    number(3,0)     not null,
  medicamento_id not null constraint presentacion_medicamento_medicamento_id_fk 
    references medicamento(medicamento_id)
);

create table operacion_medicamento(
  operacion_medicamento_id    number(15,0) constraint operacion_medicamento_pk primary key,
  unidades                    number(5,0)     not null,
  operacion_id not null constraint operacion_medicamento_operacion_id_fk
    references operacion(operacion_id),
  presentacion_medicamento_id not null constraint operacion_medicamento_presentacion_medicamento_id_fk 
    references presentacion_medicamento(presentacion_medicamento_id)
);

create table inventario_medicamento(
  inventario_medicamento_id number(10,0) constraint inventario_medicamento_pk primary key,
  unidades                    number(5,0)     not null,
  farmacia_id not null constraint inventario_medicamento_farmacia_id_fk
    references farmacia(centro_operaciones_id),
  presentacion_medicamento_id not null constraint inventario_medicamento_presentacion_medicamento_id_fk 
    references presentacion_medicamento(presentacion_medicamento_id)
);

create table cliente(
  cliente_id number(15,0) constraint cliente_pk primary key,
  nombre                      varchar2(40)    not null,
  apellido_paterno            varchar2(40)    not null,
  apellido_materno            varchar2(40)    not null,
  email                       varchar2(256)   not null,
  telefono                    number(10,0)    not null,
  rfc                         varchar2(13)    not null,
  curp                        char(18)        null,
  direccion_envio             varchar2(100)   not null,
  constraint cliente_rfc_uk unique (rfc),
  constraint cliente_curp_uk unique (curp)
);

create table tarjeta(
  tarjeta_id number(15,0) constraint tarjeta_pk primary key,
  numero_tarjeta              number(16,0)    not null,
  mes_expiracion              number(2,0)     not null,
  anio_expiracion             number(2,0)     not null,
  cliente_id not null constraint tarjeta_cliente_id_fk
    references cliente(cliente_id),
  constraint tarjeta_numero_tarjeta_uk unique (numero_tarjeta)
);

create table ubicacion(
  ubicacion_id number(10,0) constraint ubicacion_pk primary key,
  latitud                     varchar2(10)    not null,
  longitud                    varchar2(10)    not null
);

create table estado_pedido(
  estado_pedido_id number(1,0) constraint estado_pedido_pk primary key,
  clave                       varchar2(11)     not null,
  descripcion                 varchar2(100)    not null
);

create table pedido(
  pedido_id number(15,0) constraint pedido_pk primary key,
  folio generated always as ('P'
    ||extract(year from fecha_emision)
    ||to_char(substr(to_char(pedido_id),1,1))
    ||to_char(fecha_emision,'mm')
    ||to_char(substr(to_char(cliente_id),1,1))
    ||to_char(fecha_emision,'dd')
    ||to_char(fecha_emision,'ss')
  ) virtual,      --Se propuso que el folio sea la columna virtual solicitada
  fecha_emision               date            default on null sysdate,   
  importe                     number(10,0)    not null,
  fecha_estado_actual         date            default on null sysdate,
  cliente_id not null constraint pedido_cliente_id_fk
    references cliente(cliente_id),
  responsable_id not null constraint pedido_responsable_id_fk
    references empleado(empleado_id),
  estado_actual not null constraint pedido_estado_pedido_id_fk
    references estado_pedido(estado_pedido_id),
  ubicacion_id null constraint pedido_ubicacion_id_fk
    references ubicacion(ubicacion_id),
  constraint pedido_folio_uk unique (folio)
);

create table pedido_medicamento(
  pedido_medicamento_id number(20,0) constraint pedido_medicamento_pk primary key,
  unidades                    numeric(2,0)    not null,
  pedido_id not null constraint pedido_medicamento_pedido_id_fk
    references pedido(pedido_id),
  farmacia_id not null constraint pedido_medicamento_farmacia_id_fk
    references farmacia(centro_operaciones_id),
  presentacion_medicamento_id not null constraint pedido_medicamento_presentacion_medicamento_id_fk
    references presentacion_medicamento(presentacion_medicamento_id)
);

create table historico_estado(
  historico_estado_id number(20,0) constraint historico_estado_pk primary key,
  fecha                       date            default on null sysdate,
  estado_pedido_id not null constraint historico_estado_estado_pedido_id_fk
    references estado_pedido(estado_pedido_id),
  pedido_id not null constraint historico_estado_pedido_id_fk
    references pedido(pedido_id)
);

create table historico_ubicacion(
  historico_ubicacion_id number(10,0) constraint historico_ubicacion_pk primary key,
  fecha                       date            default on null sysdate,
  pedido_id not null constraint historico_ubicacion_pedido_id_fk references
    pedido(pedido_id),
  ubicacion_id not null constraint historico_ubicacion_ubicacion_id_fk references
    ubicacion(ubicacion_id)
);

Prompt Listo!
disconnect