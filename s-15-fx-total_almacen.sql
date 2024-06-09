--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 09/06/2024
--@Descripción: Código para la creación de una función que devuelve la cantidad de cajas que están en un almacén particular.
Prompt conectado como admin
connect vl_proy_admin/proyecto
Prompt Creando función s-15-fx-total_almacen.sql

create or replace function total_almacen(
  p_almacen_id number
) return number is 
pragma autonomous_transaction;
v_total number (10,0) := 0;
v_almacen_id number := p_almacen_id;
v_unidades number := 0;

cursor cur_operacion_almacen is
select o.almacen_id,om.presentacion_medicamento_id,o.tipo,om.unidades
from operacion o
natural join operacion_medicamento om
where o.almacen_id = v_almacen_id;

begin
  for p in cur_operacion_almacen loop
    v_unidades := p.unidades;
    if p.tipo = 'E' then
      v_total := v_total + v_unidades;
    else
      v_total := v_total - v_unidades;
    end if; 
  end loop;
  return v_total;
end;
/
show errors

  --select o.almacen_id,sum(om.unidades) as total_unidades_ingresadas
  --from operacion_medicamento om
  --natural join operacion o
  --where o.tipo = 'E'
  --group by o.almacen_id;