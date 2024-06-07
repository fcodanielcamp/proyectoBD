--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 06/06/2024
--@Descripción: Creación de índices.

--Comentarios de la fecha, autores y descripcion

prompt Conectando como vl_proy_admin
connect vl_proy_admin/proyecto
prompt Empezando a crear indices
--El id del gerente que aparezca en una farmacia debe ser único, por el caso de estudio.
create unique index farmacia_gerente_id_iuk
on farmacia(gerente_id);
--Se suele hacer un join de operacion con empleado.
create index operacion_responsable_id_ix
on operacion(responsable_id);
--Se suele hacer un join de operacion con almacén.
create index operacion_almacen_id_ix
on operacion(almacen_id);
--Se suele hacer un join del medicamento con sus nombres correspondientes.
create index nombre_medicamento_medicamento_id_ix
on nombre_medicamento(medicamento_id);
--Se suele hacer un join del medicamento con sus presentaciones correspondientes.
create index presentacion_medicamento_nombre_medicamento_id_ix
on presentacion_medicamento(nombre_medicamento_id);
--Por una parte, sirve para los joins comunes.
--Por otra, existe el atributo cantidad para evitar esta duplicidad.
create unique index operacion_medicamento_iuk
on operacion_medicamento(operacion_id,presentacion_medicamento_id);
--Se suele hacer un join del cliente con su tarjeta, para ver la información completa.
create index tarjeta_cliente_id_ix
on tarjeta(cliente_id);
--No se debe repetir un par de latitud y longitud en el catálogo de ubicaciones.
create unique index ubicacion_iuk
on ubicacion(latitud,longitud);
--Se crea este índice porque es común filtrar los pedidos por día, mes y anio.
create index pedido_fecha_emision_ifx
on pedido(to_char(fecha_emision,'dd/mm/yyyy'));
--Se suele buscar el estado actual del pedido.
create index pedido_estado_actual_ix
on pedido(estado_actual);
--Se suele buscar la ubicacion actual del pedido.
create index pedido_ubicacion_id_ix
on pedido(ubicacion_id);
--Se suele mostrar el histórico del estado en las consultas del cliente.
create index historico_estado_estado_pedido_id_ix
on historico_estado(estado_pedido_id);
--Se suele mostrar el hisstórico de ubicaciones en las consultas del cliente.
create index historico_ubicacion_pedido_id_ix
on historico_ubicacion(pedido_id);

prompt Listo!
--disconnect