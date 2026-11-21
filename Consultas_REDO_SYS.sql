
-- ARCHIVOS REDO 
-- USUARIO: SYS AS SYSDBA


-- A. CONSULTAR MODO DE ARCHIVADO

SELECT log_mode
FROM v$database;


-- B. CONSULTAR GRUPOS REDO

SELECT group#,
       sequence#,
       status,
       archived
FROM v$log
ORDER BY group#;


-- C. CONSULTAR UBICACION DE LOS ARCHIVOS REDO

SELECT group#,
       member
FROM v$logfile
ORDER BY group#;
