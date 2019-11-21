-- CASO 1
SELECT
   ATE_ID AS "Id Atención",
   TO_CHAR(FECHA_ATENCION, 'DD-MM-YYYY') AS "Fecha Atención",
   TO_CHAR(PAC_RUT, '99G999G999') || '-' || P.DV_RUT AS "Rut",
   INITCAP(P.APATERNO) || ' ' || INITCAP(P.AMATERNO) || ' ' || INITCAP(P.PNOMBRE) || ' ' || INITCAP(P.SNOMBRE) AS "Nombre Paciente",
   TRUNC((FECHA_ATENCION - FECHA_NACIMIENTO) / 365) AS "Edad",
   TO_CHAR(FECHA_NACIMIENTO, 'DD-MM-YYYY') AS "Fecha Nacimiento",
   CASE WHEN M.PNOMBRE LIKE ('%a')
      OR M.PNOMBRE LIKE ('Gladys')
      OR M.PNOMBRE LIKE ('Maureen') THEN
      'Dra'
   ELSE
      'Dr'
END || ' ' || M.APATERNO AS "Médico Tratante",
NOMBRE AS "Especialidad"
FROM
   PACIENTE P
   LEFT JOIN ATENCION A USING (PAC_RUT)
   JOIN MEDICO M USING (MED_RUT)
   LEFT JOIN ESPECIALIDAD E USING (ESP_ID)
WHERE
   EXTRACT(YEAR FROM FECHA_NACIMIENTO) = (
      SELECT
         EXTRACT(YEAR FROM FECHA_NACIMIENTO)
      FROM
         ATENCION
         JOIN PACIENTE USING (PAC_RUT)
      GROUP BY
         EXTRACT(YEAR FROM FECHA_NACIMIENTO)
      HAVING
         COUNT(*) = (
            SELECT
               MAX(COUNT(*))
            FROM
               ATENCION
            NATURAL JOIN PACIENTE
         GROUP BY
            EXTRACT(YEAR FROM FECHA_NACIMIENTO)))
   ORDER BY
      1;

------------------------------------------------------
-- CASO 2 ALTERNATIVA 1
SELECT
   TO_CHAR(E.MED_RUT, '999G999G999') || '-' || E.DV_RUT AS "Rut Médico",
   INITCAP(E.PNOMBRE) || ' ' || INITCAP(E.APATERNO) || ' ' || INITCAP(E.AMATERNO) AS "Nombre Médico",
   '+' || LPAD(E.TELEFONO, 11, '56') AS "Teléfono",
   TO_CHAR(E.FECHA_CONTRATO, 'DD-fmmonth-YYYY') AS "Fecha Contrato",
   NOMBRE AS "Cargo",
   INITCAP(J.PNOMBRE) || ' ' || INITCAP(J.APATERNO) || ' ' || INITCAP(J.AMATERNO) AS "Nombre Jefe Directo"
FROM
   CARGO C
   JOIN MEDICO E USING (CAR_ID)
   FULL
   OUTER JOIN MEDICO J ON (E.JEFE_RUT = J.MED_RUT)
   WHERE
      E.MED_RUT IN (
         SELECT
            MED_RUT
         FROM
            MEDICO MINUS
            SELECT
               MED_RUT
            FROM
               ATENCION
            GROUP BY
               MED_RUT)
         ORDER BY
            E.FECHA_CONTRATO ASC,
            E.APATERNO ASC;

-------------------------------------------------
-- CASO 3:
-- RESPALDO TABLA PARA POSTERIORES AUDITORÌAS
CREATE TABLE REPALDO_MEDICO (
   SELECT
      *
   FROM
      MEDICO
);

-- SOLUCION 1
UPDATE
   MEDICO
SET
   COMISION = (NVL (COMISION,
         0) + 0.1)
WHERE
   MED_RUT NOT IN (
      SELECT
         MED_RUT
      FROM
         MEDICO MINUS
         SELECT
            MED_RUT
         FROM
            ATENCION
         GROUP BY
            MED_RUT);

-- SOLUCION 2
UPDATE
   MEDICO
SET
   COMISION = (NVL (COMISION,
         0) + 0.1)
WHERE
   MED_RUT IN (
      SELECT
         MED_RUT
      FROM
         ATENCION);

-- ELIMINAR FUNCIONARIOS SIN ATENCIONES MÉDICAS
DELETE FROM MEDICO
WHERE MED_RUT IN (
      SELECT
         MED_RUT FROM MEDICO MINUS
         SELECT
            MED_RUT FROM ATENCION
         GROUP BY
            MED_RUT);

-- CÁLCULO VALOR COMISIONES
SELECT
   TO_CHAR((NVL (J.MED_RUT, E.MED_RUT)),
      '99G999G999') || ' - ' || NVL (J.DV_RUT,
      E.DV_RUT) AS "Jefe Médico",
   TO_CHAR(E.MED_RUT, '99G999G999') || ' - ' || E.DV_RUT AS "Médico",
   COUNT(E.MED_RUT) AS "Atenciones",
   TO_CHAR((SUM(COSTO)),
      '$999G999G999') AS "Monto Total",
   '0' || E.COMISION || '%' AS "Comisión",
   TO_CHAR((ROUND((E.COMISION / 100) * SUM(COSTO) * COUNT(E.MED_RUT))),
      '$999G999G999') AS "Valor Comisión"
FROM
   ATENCION A
   JOIN MEDICO E ON (A.MED_RUT = E.MED_RUT)
   LEFT JOIN MEDICO J ON (E.JEFE_RUT = J.MED_RUT)
WHERE
   EXTRACT(YEAR FROM FECHA_ATENCION) = EXTRACT(YEAR FROM SYSDATE)
GROUP BY
   E.MED_RUT,
   E.DV_RUT,
   J.MED_RUT,
   J.DV_RUT,
   E.COMISION
ORDER BY
   1 ASC,
   2 ASC;
