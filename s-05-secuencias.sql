--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Creación de secuencias.

--Comentarios de la fecha, autores y descripcion

prompt Conectando como vl_proy_admin
connect vl_proy_admin/proyecto
prompt Empezando a crear secuencias

create sequence centro_operaciones_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache
noorder;

create sequence empleado_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
noorder;

create sequence operacion_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
order;

create sequence medicamento_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 1000
noorder;

create sequence nombre_medicamento_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache
order;

create sequence presentacion_medicamento_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache
order;

create sequence operacion_medicamento_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
order;

create sequence inventario_medicamento_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 1000
order;

create sequence cliente_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
noorder;

create sequence tarjeta_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache
noorder;

create sequence ubicacion_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 200
order;

create sequence estado_pedido_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache
noorder;

create sequence pedido_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
order;

create sequence pedido_medicamento_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
order;

create sequence historico_estado_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
order;

create sequence historico_ubicacion_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
cache 100
order;

prompt Listo!
disconnect