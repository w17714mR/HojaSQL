﻿


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
    APATERNO,
    AMATERNO;

-- 8.2

SELECT * FROM ALUMNOS;