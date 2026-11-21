
-- ESQUEMA: HR
-- CONEXION: HR_Local_XE

-- 1. CONSULTA DE LOS INDICES DE EMPLOYEES Y DEPARTMENTS

SELECT i.table_name,
       i.index_name,
       i.uniqueness,
       c.column_name,
       c.column_position
FROM user_indexes i
JOIN user_ind_columns c
    ON i.index_name = c.index_name
WHERE i.table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY i.table_name, i.index_name, c.column_position;


-- 2. CONSULTA DEL ESTADO INICIAL DE LAS RESTRICCIONES

SELECT table_name,
       constraint_name,
       constraint_type,
       status
FROM user_constraints
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, constraint_name;


-- 3. DESACTIVACION DE LAS RESTRICCIONES


-- Se desactivan primero las claves foraneas de JOB_HISTORY
-- que dependen de EMPLOYEES y DEPARTMENTS.

ALTER TABLE job_history
DISABLE CONSTRAINT JHIST_DEPT_FK;

ALTER TABLE job_history
DISABLE CONSTRAINT JHIST_EMP_FK;


-- Se desactivan las claves foraneas relacionadas
-- con las tablas EMPLOYEES y DEPARTMENTS.

ALTER TABLE employees
DISABLE CONSTRAINT EMP_DEPT_FK;

ALTER TABLE departments
DISABLE CONSTRAINT DEPT_MGR_FK;

ALTER TABLE employees
DISABLE CONSTRAINT EMP_MANAGER_FK;


-- Se desactivan las demas restricciones habilitadas
-- de EMPLOYEES y DEPARTMENTS.

BEGIN
    FOR r IN (
        SELECT table_name, constraint_name
        FROM user_constraints
        WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
          AND status = 'ENABLED'
    )
    LOOP
        EXECUTE IMMEDIATE
            'ALTER TABLE ' || r.table_name ||
            ' DISABLE CONSTRAINT ' || r.constraint_name;
    END LOOP;
END;
/

-- Verificacion de las restricciones desactivadas.

SELECT table_name,
       constraint_name,
       constraint_type,
       status
FROM user_constraints
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, constraint_name;


-- 4. INSERCION DE TUPLAS QUE INCUMPLEN LAS RESTRICCIONES

-- EMPLOYEES:
-- Se inserta un empleado cuyo departamento 9999 no existe
-- en la tabla DEPARTMENTS.

INSERT INTO employees
    (employee_id, first_name, last_name, email,
     hire_date, job_id, department_id)
VALUES
    (9999, 'Valentina', 'Rodriguez', 'VALROD999',
     SYSDATE, 'IT_PROG', 9999);


-- DEPARTMENTS:
-- Se inserta un departamento con un manager y una ubicacion
-- que no existen en las tablas relacionadas.

INSERT INTO departments
    (department_id, department_name, manager_id, location_id)
VALUES
    (272, 'Tecnologia', 9998, 9998);


-- Verificacion de la insercion en EMPLOYEES.

SELECT *
FROM employees
WHERE employee_id = 9999;


-- Verificacion de la insercion en DEPARTMENTS.

SELECT *
FROM departments
WHERE department_id = 272;


-- 5. RESTABLECIMIENTO DE LAS RESTRICCIONES

-- Habilitan las restricciones que no son
-- claves foraneas.

BEGIN
    FOR r IN (
        SELECT table_name, constraint_name
        FROM user_constraints
        WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
          AND constraint_type <> 'R'
          AND status = 'DISABLED'
    )
    LOOP
        EXECUTE IMMEDIATE
            'ALTER TABLE ' || r.table_name ||
            ' ENABLE CONSTRAINT ' || r.constraint_name;
    END LOOP;
END;
/

-- Se habilitan las claves foraneas de EMPLOYEES
-- y DEPARTMENTS.

ALTER TABLE employees
ENABLE CONSTRAINT EMP_DEPT_FK;

ALTER TABLE employees
ENABLE CONSTRAINT EMP_JOB_FK;

ALTER TABLE employees
ENABLE CONSTRAINT EMP_MANAGER_FK;

ALTER TABLE departments
ENABLE CONSTRAINT DEPT_LOC_FK;

ALTER TABLE departments
ENABLE CONSTRAINT DEPT_MGR_FK;


-- Se habilitan las claves foraneas de JOB_HISTORY.

ALTER TABLE job_history
ENABLE CONSTRAINT JHIST_DEPT_FK;

ALTER TABLE job_history
ENABLE CONSTRAINT JHIST_EMP_FK;


-- Verificacion del estado final de las restricciones.

SELECT table_name,
       constraint_name,
       constraint_type,
       status
FROM user_constraints
WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS')
ORDER BY table_name, constraint_name;


-- Verificacion de las restricciones de JOB_HISTORY.

SELECT table_name,
       constraint_name,
       status
FROM user_constraints
WHERE table_name = 'JOB_HISTORY'
ORDER BY constraint_name;


-- 6. CREACION DE LA TABLA DEPARTMENTS2

-- Se crea una copia de la estructura y los datos
-- de la tabla DEPARTMENTS.

CREATE TABLE departments2 AS
SELECT *
FROM departments;

-- Verificacion de los registros copiados.

SELECT COUNT(*)
FROM departments2;


-- 7. INSERCION DE TRES REGISTROS EN DEPARTMENTS2

INSERT ALL
    INTO departments2
        VALUES (901, 'Desarrollo de Software', 103, 1700)

    INTO departments2
        VALUES (902, 'Ciberseguridad', 108, 2400)

    INTO departments2
        VALUES (903, 'Analisis de Datos', 114, 2300)

SELECT * FROM dual;

COMMIT;


-- Verificacion de los tres registros insertados.

SELECT department_id,
       department_name,
       manager_id,
       location_id
FROM departments2
WHERE department_id IN (901, 902, 903)
ORDER BY department_id;


-- 8. CONSULTA DESPUES DE CERRAR Y REABRIR LA SESION

-- Cerrar la conexion HR_Local_XE desde SQL Developer.
-- Volver a conectarse como HR y ejecutar esta consulta.

SELECT department_id,
       department_name,
       manager_id,
       location_id
FROM departments2
ORDER BY department_id;


-- 9. BLOQUE PL/SQL: INICIO Y FINALIZACION DE TRANSACCION

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Inicio de la transaccion');

    UPDATE departments2
    SET department_name = 'Desarrollo Tecnologico'
    WHERE department_id = 901;

    DBMS_OUTPUT.PUT_LINE('Finalizacion de la transaccion');

    COMMIT;
END;
/


-- Verificacion del cambio confirmado.

SELECT department_id,
       department_name
FROM departments2
WHERE department_id = 901;


-- 10. EJEMPLO DE ROLLBACK

BEGIN
    UPDATE departments2
    SET department_name = 'Nombre Temporal'
    WHERE department_id = 901;

    DBMS_OUTPUT.PUT_LINE('Cambio temporal realizado');

    ROLLBACK;

    DBMS_OUTPUT.PUT_LINE('Transaccion deshecha');
END;
/


-- Verificacion de que ROLLBACK deshizo el cambio.

SELECT department_id,
       department_name
FROM departments2
WHERE department_id = 901;

