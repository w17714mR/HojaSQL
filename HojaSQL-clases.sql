-- 5.1
SELECT
    TO_CHAR(Max(salario), '$999G999G999') AS "SALARIO MÁXIMO",
    TO_CHAR(Min(salario), '$999G999G999') AS "SALARIO MÍNIMO",
    TO_CHAR(Sum(salario), '$999G999G999') AS "SUMATORIA DE LOS SALARIOS",
    TO_CHAR(Avg(salario), '$999G999G999') AS "SALARIO PROMEDIO"
FROM
    EMPLEADO;

-- 5.2
SELECT
    TITULOID AS "CÓDIGO DEL LIBRO",
    Count(*) AS "TOTAL DE EJEMPLARES"
FROM
    EJEMPLAR
GROUP BY
    TITULOID
ORDER BY
    2 ASC,
    1;

-- 5.3
SELECT
    CARRERAID AS "CÓDIGO DE LA CARRERA",
    Count(*) AS "TOTAL DE ALUMNOS"
FROM
    ALUMNO
GROUP BY
    CARRERAID
HAVING
    Count(CARRERAID) > 4
ORDER BY
    2 DESC,
    1 ASC;

-- 5.4
SELECT
    TO_CHAR(RUN_JEFE, '99G999G999') AS "RUN JEFE",
    Count(*) AS "TOTAL DE EMPLEADOS A SU CARGO",
    Max(SALARIO) AS "SALARIO MAXIMO",
    Max(SALARIO) * Count(*) / 100 AS "BONIFICACIÓN"
FROM
    EMPLEADO
WHERE
    RUN_JEFE IS NOT NULL
GROUP BY
    RUN_JEFE
ORDER BY
    1 ASC;

-- 5.5
SELECT
    EM.ID_ESCOLARIDAD AS "ESCOLARIDAD",
    ES.DESC_ESCOLARIDAD AS "DESCRIPCIÓN ESCOLARIDAD",
    Count(*) AS "TOTAL DE EMPLEADOS",
    TO_CHAR(Max(SALARIO), '$999G999G999') AS "SALARIO MÁXIMO",
    TO_CHAR(Min(SALARIO), '$999G999G999') AS "SALARIO MINIMO",
    TO_CHAR(Sum(SALARIO), '$999G999G999') AS "SALARIO TOTAL",
    TO_CHAR(Avg(SALARIO), '$999G999G999') AS "SALARIO PROMEDIO"
FROM
    EMPLEADO EM,
    ESCOLARIDAD_EMP ES
WHERE
    EM.ID_ESCOLARIDAD = ES.ID_ESCOLARIDAD
GROUP BY
    EM.ID_ESCOLARIDAD,
    ES.DESC_ESCOLARIDAD
ORDER BY
    3 DESC;

-- 5.6
SELECT
    TITULOID,
    Count(*),
    'SE REQUIERE COMPRAR ' || Count(*) || ' NUEVOS EJEMPLARES' AS "OBS PRESUPUESTARIA"
FROM
    PRESTAMO
WHERE
    FECHA_INI_PRESTAMO > TRUNC(SYSDATE - 365 * 1, 'YEAR')
GROUP BY
    TITULOID
ORDER BY
    1 ASC;

-- 5.7
SELECT
    RUN_EMP,
    TO_CHAR(P.FECHA_INI_PRESTAMO, 'MM/YYYY'),
    COUNT(*)
FROM
    PRESTAMO P
WHERE
    TO_CHAR(P.FECHA_INI_PRESTAMO, 'YYYY') = 2019
GROUP BY
    RUN_EMP,
    TO_CHAR(P.FECHA_INI_PRESTAMO, 'MM/YYYY')
ORDER BY
    2,
    1;

SELECT
    *
FROM
    PRESTAMO;

-- 6.1
SELECT
    A.CARRERAID AS "CÓDIGO CARRERA",
    C.DESCRIPCION AS "NOMBRE CARRERA",
    A.NOMBRE || ' ' || A.APATERNO || ' ' || A.AMATERNO AS "NOMBRE ALUMNO"
FROM
    CARRERA C,
    ALUMNO A
WHERE
    C.CARRERAID = A.CARRERAID
ORDER BY
    2,
    A.APATERNO;

SELECT
    C.CARRERAID AS "CÓDIGO DE CARRERA",
    C.DESCRIPCION AS "NOMBRE DE CARRERA",
    A.NOMBRE || ' ' || A.APATERNO || ' ' || A.AMATERNO AS "NOMBRE ALUMNO"
FROM
    ALUMNO A
    JOIN CARRERA C ON A.CARRERAID = C.CARRERAID
ORDER BY
    2,
    A.APATERNO;

-- 6.2
SELECT
    Upper(E.DESCRIPCION),
    Count(*)
FROM
    ESCUELA E
    JOIN CARRERA C ON C.ESCUELAID = E.ESCUELAID
GROUP BY
    E.DESCRIPCION
ORDER BY
    2 DESC,
    1 ASC;

-- 6.3
SELECT
    C.DESCRIPCION,
    Count(*)
FROM
    CARRERA C
    JOIN ALUMNO A ON C.CARRERAID = A.CARRERAID
GROUP BY
    C.DESCRIPCION
ORDER BY
    2 DESC;

-- 6.4
SELECT
    A.NOMBRE || ' ' || A.APATERNO || ' ' || A.AMATERNO AS "NOMBRE ALUMNO",
    P.FECHA_INI_PRESTAMO AS "FECHA INICIO PRESTAMO",
    P.FECHA_TER_PRESTAMO AS "FECHA TERMINO PRESTAMO",
    P.FECHA_DEVOLUCION AS "FECHA DEVOLUCION",
    P.FECHA_DEVOLUCION - P.FECHA_TER_PRESTAMO AS "DIAS DE ATRASO",
    TO_CHAR(((P.FECHA_DEVOLUCION - P.FECHA_TER_PRESTAMO) * 1000),
        '$999G999G999') AS "VALOR MULTA"
FROM
    ALUMNO A
    JOIN PRESTAMO P ON A.ALUMNOID = P.ALUMNOID
WHERE
    TO_CHAR(P.FECHA_DEVOLUCION, 'MM') = 07
    AND TO_CHAR(P.FECHA_DEVOLUCION, 'YYYY') = 2018
    AND (P.FECHA_DEVOLUCION - P.FECHA_TER_PRESTAMO) > 0
ORDER BY
    A.APATERNO,
    6 DESC;

-- 6.5
-- 7.1
SELECT
    TO_CHAR(A.JEFE_RUT, '99G999G999') AS "RUT JEFE",
    B.PNOMBRE || ' ' || B.SNOMBRE || ' ' || B.APATERNO || ' ' || B.AMATERNO AS "NOMBRE JEFE",
    TO_CHAR(B.SUELDO_BASE, '$999G999G999') AS "SUELDO BASE",
    COUNT(*) AS "TOTAL MÉDICOS A SU CARGO",
    TO_CHAR(ROUND(B.SUELDO_BASE * COUNT(*) * 0.01), '$999G999G999') AS "ASIGNACIÓN JEFE"
FROM
    MEDICO A
    JOIN MEDICO B ON A.JEFE_RUT = B.MED_RUT
GROUP BY
    A.JEFE_RUT,
    B.PNOMBRE,
    B.SNOMBRE,
    B.APATERNO,
    B.AMATERNO,
    B.SUELDO_BASE
ORDER BY
    B.APATERNO;

-- 7.2
SELECT
    TO_CHAR(MED_RUT, '999G999G999') || '-' || DV_RUT AS "RUT MÉDICO",
    PNOMBRE || ' ' || SNOMBRE || ' ' || APATERNO || ' ' || AMATERNO AS "MÉDICO",
    EXTRACT(MONTH FROM FECHA_ATENCION) AS "MES ATENCIONES MÉDICAS",
    TO_CHAR(SUELDO_BASE * COUNT(*) * 0.01, '$999G999G999') AS "BONIF. POR ATENCIONES MÉDICAS"
FROM
    ATENCION
    NATURAL JOIN MEDICO
WHERE
    EXTRACT(MONTH FROM FECHA_ATENCION) = EXTRACT(MONTH FROM SYSDATE) - 1
    AND EXTRACT(YEAR FROM FECHA_ATENCION) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY
    MED_RUT,
    PNOMBRE,
    SNOMBRE,
    APATERNO,
    AMATERNO,
    MED_RUT,
    DV_RUT,
    EXTRACT(MONTH FROM FECHA_ATENCION),
    SUELDO_BASE
HAVING
    COUNT(*) > 1
ORDER BY
    4 DESC,
    APATERNO ASC;

-- 7.3
SELECT
    U.NOMBRE,
    C.NOMBRE,
    NVL (COUNT(ESP_ID),
        0)
FROM
    CARGO C
    JOIN MEDICO M ON C.CAR_ID = M.CAR_ID
    JOIN UNIDAD U ON M.UNI_ID = U.UNI_ID
    RIGHT JOIN ATENCION A ON A.MED_RUT = M.MED_RUT
GROUP BY
    C.NOMBRE,
    U.NOMBRE
ORDER BY
    1 ASC,
    COUNT(C.NOMBRE)
    DESC;

-- 7.4
SELECT
    ATE_ID,
    FECHA_ATENCION,
    PAC_RUT,
    P.PNOMBRE || ' ' || SNOMBRE || ' ' || APATERNO || ' ' || AMATERNO,
    S.TIPO_SAL_ID || ', ' || S.DESCRIPCION
FROM
    ATENCION
    NATURAL JOIN PACIENTE P
    NATURAL JOIN SALUD S
WHERE
    EXTRACT(MONTH FROM FECHA_ATENCION) = 7
    AND EXTRACT(YEAR FROM FECHA_ATENCION) = EXTRACT(YEAR FROM SYSDATE) - 1
ORDER BY
    FECHA_ATENCION ASC;

-- 7.5
SELECT
    PNOMBRE || ' ' || SNOMBRE || ' ' || APATERNO || ' ' || AMATERNO AS "MÉDICO",
    NOMBRE AS "UNIDAD",
    SUBSTR(U.NOMBRE, 0, 2) || SUBSTR(APATERNO, LENGTH(APATERNO) - 2, 2) || SUBSTR(TELEFONO, 0, 3) || EXTRACT(YEAR FROM FECHA_CONTRATO) || '@MEDICOCKTK.CL' AS "CORREO MÉDICO",
    COUNT(MED_RUT) AS "ATENCIONES MÉDICAS"
FROM
    MEDICO M
    NATURAL JOIN UNIDAD U
    NATURAL JOIN ATENCION A
GROUP BY
    PNOMBRE,
    SNOMBRE,
    APATERNO,
    AMATERNO,
    NOMBRE,
    TELEFONO,
    FECHA_CONTRATO
ORDER BY
    COUNT(MED_RUT) ASC,
    APATERNO ASC;

-- 7.6
SELECT
    PNOMBRE || ' ' || SNOMBRE || ' ' || APATERNO || ' ' || AMATERNO AS "NOMBRE DEL PACIENTE",
    COUNT(PAC_RUT)
FROM
    PACIENTE
    NATURAL JOIN ATENCION
GROUP BY
    PAC_RUT,
    PNOMBRE,
    SNOMBRE,
    APATERNO,
    AMATERNO
ORDER BY
    APATERNO,
    PNOMBRE;

-- 7.7
SELECT
    TO_CHAR(PAC_RUT, '99G999G999') || '-' || DV_RUT AS "RUT PACIENTE",
    PNOMBRE || ' ' || SNOMBRE || ' ' || APATERNO || ' ' || AMATERNO AS "NOMBRE PACIENTE",
    TRUNC((SYSDATE - FECHA_NACIMIENTO) / 365) AS "AÑOS",
    FECHA_ATENCION || ' ' || HR_ATENCION AS "FECHA Y HORA DE ATENCIÓN",
    TO_CHAR(COSTO, '$999G999G999') AS "COSTO ATENCION S/DESCUENTO",
    TO_CHAR(COSTO - ROUND(PORCENTAJE_DESCTO * 0.01 * COSTO), '$999G999G999') AS "COSTO ATENCIÓN C/DESCUENTO",
    TO_CHAR(ROUND(PORCENTAJE_DESCTO * 0.01 * COSTO), '$999G999G999') AS "MONTO A DEVOLVER"
FROM
    ATENCION
    NATURAL JOIN PACIENTE
    JOIN PORC_DESCTO_3RA_EDAD P ON (TRUNC((SYSDATE - FECHA_NACIMIENTO) / 365))
    BETWEEN ANNO_INI
    AND ANNO_TER
WHERE
    TRUNC((SYSDATE - FECHA_NACIMIENTO) / 365) > 65
ORDER BY
    FECHA_ATENCION ASC,
    TRUNC((SYSDATE - FECHA_NACIMIENTO) / 365)
    DESC;

-- 8.1

SELECT
    NOMBRE,
    PNOMBRE || ' ' || SNOMBRE || ' ' || APATERNO || ' ' || AMATERNO AS "MEDICO",
    SUBSTR(U.NOMBRE, 0, 2) || SUBSTR(APATERNO, LENGTH(APATERNO) - 2, 2) || SUBSTR(TELEFONO, 0, 3) || EXTRACT(YEAR FROM FECHA_CONTRATO) || '@MEDICOCKTK.CL' AS "CORREO MÉDICO",
    COUNT(MED_RUT)
FROM
    ATENCION
    NATURAL JOIN MEDICO
    NATURAL JOIN UNIDAD U
WHERE
    EXTRACT(YEAR FROM FECHA_ATENCION) = 2017
GROUP BY
    PNOMBRE,
    SNOMBRE,
    APATERNO,
    AMATERNO,
    TELEFONO,
    FECHA_CONTRATO,
    MED_RUT,
    NOMBRE
ORDER BY
    1,
    APATERNO;
