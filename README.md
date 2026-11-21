# Índices y restricciones en Oracle

Práctica desarrollada con Oracle Database 21c XE y el esquema HR.

## Descripción

El proyecto contiene las consultas y operaciones SQL realizadas para analizar los índices, administrar restricciones de integridad y trabajar con transacciones en Oracle.

## Archivos

| Archivo | Descripción |
|---|---|
| `Indices_Restricciones_HR.sql` | Consultas de índices, desactivación y restablecimiento de restricciones, inserciones, creación de DEPARTMENTS2 y pruebas con COMMIT y ROLLBACK. |
| `Consultas_REDO_SYS.sql` | Consultas para identificar el modo de archivado, los grupos REDO y la ubicación de sus archivos físicos. |

## Tecnologías utilizadas

- Oracle Database 21c XE
- Oracle SQL Developer
- SQL y PL/SQL

## Contenidos desarrollados

- Consulta de índices de EMPLOYEES y DEPARTMENTS.
- Administración de restricciones de integridad.
- Inserción de registros con restricciones desactivadas.
- Creación y consulta de la tabla DEPARTMENTS2.
- Gestión de transacciones mediante COMMIT y ROLLBACK.
- Consulta de archivos REDO y verificación del modo NOARCHIVELOG.

## Ejecución

Las instrucciones deben ejecutarse por secciones desde Oracle SQL Developer:

- `Indices_Restricciones_HR.sql`: iniciar sesión con el usuario HR.
- `Consultas_REDO_SYS.sql`: iniciar sesión con SYS y privilegios SYSDBA.

**Nota:** El primer archivo documenta el procedimiento completo. Algunas instrucciones, como CREATE TABLE e INSERT, no deben ejecutarse nuevamente si los objetos o registros ya existen.
