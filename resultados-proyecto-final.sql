SET SERVEROUTPUT ON
DECLARE
    v_num_tablas NUMBER(10,0);
    v_num_total_tablas NUMBER(10,0);
    v_num_tablas_temp NUMBER(10,0);
    v_num_tablas_externas NUMBER(10,0);
    v_num_total_registros NUMBER(10,0) := 0;
    v_num_default NUMBER(10,0);
    v_num_virtual NUMBER(10,0);
    v_num_lobs NUMBER(10,0);
    v_num_directories NUMBER(10,0);
    v_num_constraints_c NUMBER(10,0) := 0;
    v_num_constraints_p NUMBER(10,0) := 0;
    v_num_constraints_u NUMBER(10,0) := 0;
    v_num_constraints_r NUMBER(10,0) := 0;
    v_num_index_non_unique NUMBER(10,0) := 0;
    v_num_index_unique_pk NUMBER(10,0) := 0;
    v_num_index_unique_non_pk NUMBER(10,0) := 0;
    v_num_index_function_based NUMBER(10,0) := 0;
    v_num_index_lob NUMBER(10,0) := 0;

    v_nombre_tabla VARCHAR2(100); -- Aumenta el tamaño
    v_num_registros NUMBER(10,0);
    v_tipo_constraint VARCHAR2(1);
    v_num_constraints NUMBER(10,0);

    v_num_sequences NUMBER(10,0) := 0;
    v_num_private_synonyms NUMBER(10,0) := 0;
    v_num_public_synonyms NUMBER(10,0) := 0;
    v_num_views NUMBER(10,0) := 0;
    v_num_procedures NUMBER(10,0) := 0;
    v_num_triggers NUMBER(10,0) := 0;
    v_num_functions NUMBER(10,0) := 0;
    v_num_invalid NUMBER(10,0) := 0;
    v_username VARCHAR2(100); -- Aumenta el tamaño
    v_created DATE;

    CURSOR cur_tablas IS SELECT table_name FROM user_tables;
    CURSOR cur_constraints IS 
        SELECT constraint_type, COUNT(*) AS user_sequences 
        FROM user_constraints 
        WHERE constraint_type IN ('C', 'P', 'U', 'R') 
        GROUP BY constraint_type;
    CURSOR cur_usuarios IS 
        SELECT username, created 
        FROM all_users 
        WHERE username LIKE '%_PROY_INVITADO%' OR username LIKE '%_PROY_ADMIN%';
BEGIN
    -- Tablas 
    SELECT COUNT(*) INTO v_num_tablas_temp FROM user_tables WHERE temporary = 'Y';
    SELECT COUNT(*) INTO v_num_tablas_externas FROM user_external_tables;
    
    -- Secuencias
    SELECT COUNT(*) INTO v_num_sequences FROM user_sequences;    
    
    -- Columnas
    SELECT COUNT(*) INTO v_num_default FROM user_tab_cols WHERE data_default IS NOT NULL AND virtual_column = 'NO';
    SELECT COUNT(*) INTO v_num_virtual FROM user_tab_cols WHERE data_default IS NOT NULL AND virtual_column = 'YES';
    SELECT COUNT(*) INTO v_num_lobs FROM user_tab_cols WHERE data_type IN ('BLOB', 'CLOB');
    
    -- Índices
    SELECT COUNT(*) INTO v_num_index_non_unique FROM user_indexes WHERE index_type = 'NORMAL' AND uniqueness = 'NONUNIQUE';
    SELECT COUNT(*) INTO v_num_index_lob FROM user_indexes WHERE index_type = 'LOB';
    SELECT COUNT(*) INTO v_num_index_function_based FROM user_indexes WHERE index_type = 'FUNCTION-BASED NORMAL';
    
    -- Índices de PKs
    SELECT COUNT(*) INTO v_num_index_unique_pk 
    FROM user_indexes ix, user_constraints uc
    WHERE ix.index_name = uc.index_name 
    AND uc.constraint_type = 'P'
    AND ix.uniqueness = 'UNIQUE'
    AND ix.index_type = 'NORMAL';
    
    -- Índices únicos no PKs
    SELECT COUNT(*) INTO v_num_index_unique_non_pk
    FROM user_indexes 
    WHERE uniqueness = 'UNIQUE'
    AND index_name NOT IN (SELECT index_name FROM user_constraints WHERE index_name IS NOT NULL) 
    AND index_type = 'NORMAL';

    -- Directorios
    SELECT COUNT(*) INTO v_num_directories FROM all_directories;
    
    -- Sinónimos
    SELECT COUNT(*) INTO v_num_private_synonyms FROM user_synonyms;
    SELECT COUNT(*) INTO v_num_public_synonyms FROM all_synonyms WHERE table_owner = sys_context('USERENV', 'SESSION_USER');
    
    -- Vistas
    SELECT COUNT(*) INTO v_num_views FROM user_views;
    
    -- PL/SQL Objects
    SELECT COUNT(*) INTO v_num_triggers FROM user_procedures WHERE object_type = 'TRIGGER';
    SELECT COUNT(*) INTO v_num_procedures FROM user_procedures WHERE object_type = 'PROCEDURE';
    SELECT COUNT(*) INTO v_num_functions FROM user_procedures WHERE object_type = 'FUNCTION';
    
    -- Inválidos
    SELECT COUNT(*) INTO v_num_invalid FROM user_objects WHERE status = 'INVALID';
    
    -- Registros
    OPEN cur_tablas;
    LOOP 
        FETCH cur_tablas INTO v_nombre_tabla;
        EXIT WHEN cur_tablas%NOTFOUND;
        
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || v_nombre_tabla INTO v_num_registros;

        v_num_total_registros := v_num_registros + v_num_total_registros;
    END LOOP;

    v_num_total_tablas := cur_tablas%ROWCOUNT;
    CLOSE cur_tablas;
    
    -- Constraints
    OPEN cur_constraints;
    LOOP
        FETCH cur_constraints INTO v_tipo_constraint, v_num_constraints;
        EXIT WHEN cur_constraints%NOTFOUND;
        CASE v_tipo_constraint
            WHEN 'C' THEN
                v_num_constraints_c := v_num_constraints;
            WHEN 'P' THEN
                v_num_constraints_p := v_num_constraints;
            WHEN 'U' THEN
                v_num_constraints_u := v_num_constraints;
            WHEN 'R' THEN
                v_num_constraints_r := v_num_constraints;    
            ELSE
                DBMS_OUTPUT.PUT_LINE('Invalid constraint type: ' || v_tipo_constraint);
        END CASE;
    END LOOP;
    CLOSE cur_constraints;
    
    DBMS_OUTPUT.PUT_LINE('-------USERS----');
    OPEN cur_usuarios;
    LOOP
        FETCH cur_usuarios INTO v_username, v_created;
        EXIT WHEN cur_usuarios%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_username || ' - ' || v_created);
    END LOOP;
    CLOSE cur_usuarios;  
    
    DBMS_OUTPUT.PUT_LINE('-------RESULTADOS----');
    DBMS_OUTPUT.PUT_LINE('TABLES             ' || v_num_total_tablas);
    DBMS_OUTPUT.PUT_LINE('TABLE TEMP         ' || v_num_tablas_temp);
    DBMS_OUTPUT.PUT_LINE('TABLE EXT          ' || v_num_tablas_externas);
    DBMS_OUTPUT.PUT_LINE('SEQUENCES          ' || v_num_sequences);
    DBMS_OUTPUT.PUT_LINE('ROWS               ' || v_num_total_registros);
    DBMS_OUTPUT.PUT_LINE('CONSTRAINT CHECK   ' || v_num_constraints_c);
    DBMS_OUTPUT.PUT_LINE('CONSTRAINT PK      ' || v_num_constraints_p);
    DBMS_OUTPUT.PUT_LINE('CONSTRAINT UNIQUE  ' || v_num_constraints_u);
    DBMS_OUTPUT.PUT_LINE('CONSTRAINT REF     ' || v_num_constraints_r);
    DBMS_OUTPUT.PUT_LINE('COL DEFAULT        ' || v_num_default);
    DBMS_OUTPUT.PUT_LINE('COL VIRTUAL        ' || v_num_virtual);
    DBMS_OUTPUT.PUT_LINE('COL LOB            ' || v_num_lobs);
    DBMS_OUTPUT.PUT_LINE('DIRECTORIES        ' || v_num_directories);
    DBMS_OUTPUT.PUT_LINE('INDEX UK (PK)      ' || v_num_index_unique_pk);
    DBMS_OUTPUT.PUT_LINE('INDEX UK           ' || v_num_index_unique_non_pk);
    DBMS_OUTPUT.PUT_LINE('INDEX NON UNIQUE   ' || v_num_index_non_unique);
    DBMS_OUTPUT.PUT_LINE('INDEX LOB          ' || v_num_index_lob);
    DBMS_OUTPUT.PUT_LINE('INDEX F-BASED      ' || v_num_index_function_based);
    DBMS_OUTPUT.PUT_LINE('PUBLIC SYNONYMS    ' || v_num_public_synonyms);
    DBMS_OUTPUT.PUT_LINE('PRIVATE SYNONYMS   ' || v_num_private_synonyms);
    DBMS_OUTPUT.PUT_LINE('VIEWS              ' || v_num_views);
    DBMS_OUTPUT.PUT_LINE('PROCEDURES         ' || v_num_procedures);
    DBMS_OUTPUT.PUT_LINE('TRIGGERS           ' || v_num_triggers);
    DBMS_OUTPUT.PUT_LINE('FUNCTIONS          ' || v_num_functions);
    DBMS_OUTPUT.PUT_LINE('INVALID            ' || v_num_invalid);   
END;
/
