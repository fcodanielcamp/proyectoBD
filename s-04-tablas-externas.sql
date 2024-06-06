--@Autor(es): Vigi Garduño Marco Alejandro, López Campillo Francisco Daniel
--@Fecha creación: 05/06/2024
--@Descripción: Creación de una tabla externa extraída mediante un archivo CSV de la entrada de medicamentos
--              en una fecha del 2019-2023 proporcionada por el Gobierno de México. 

Prompt Indicar el password de sys
connect sys/system as sysdba;

prompt Creando el directorio
CREATE OR REPLACE DIRECTORY csv_dir_tabla_externa AS '/unam-bd/proyectoBD/tabla-externa';
prompt Dando permisos al usuario apra el directorio
GRANT READ, WRITE ON DIRECTORY csv_dir_tabla_externa TO vl_proy_admin;

prompt Conectando con el usuario
CONN vl_proy_admin/proyecto

prompt Creando la tabla externa
-- Crear la tabla externa
CREATE TABLE entradas_medicamento (
    clave               NUMBER(10,0),
    descripcion         VARCHAR2(100),
    cantidad_entregada  NUMBER(10,0),
    precio_unitario     VARCHAR2(20),
    fecha_entrega       DATE
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY csv_dir_tabla_externa
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        BADFILE 'entradas_medicamento_bad.log'
        LOGFILE 'entradas_medicamento_ext.log'
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
        LRTRIM
        (
            clave,
            descripcion,
            cantidad_entregada,
            precio_unitario,
            fecha_entrega DATE 'DD-Mon-YY'
        )
    )
    LOCATION ('ENTRADASMEDICAMENTOS2019-21JUNIO2023.csv')
)
REJECT LIMIT UNLIMITED;

-- Cambiar permisos del directorio
!chmod 777 /unam-bd/proyecto/proyectoBD/tabla-externa

-- Seleccionar datos de la tabla externa
SELECT * FROM entradas_medicamento;
