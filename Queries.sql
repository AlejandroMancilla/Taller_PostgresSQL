-- CONSULTAS SOBRE UNA TABLA
-- Consulta 1: 
SELECT apellido1, apellido2, nombre FROM persona WHERE tipo = 'Alumno' ORDER BY apellido1, apellido2, nombre;

-- Consulta 2: 
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'Alumno' AND telefono IS NULL;

-- Consulta 3:
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'Alumno' AND EXTRACT(year FROM fecha_nacimiento) = 1999;

-- Consulta 4:
SELECT * FROM persona WHERE tipo = 'Profesor' AND telefono IS NULL AND nif LIKE '%K';

-- Consulta 5:
SELECT * FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- CONSULTAS MULTITABLA
-- Consulta 1:
SELECT * FROM persona P 
INNER JOIN alumno_se_matricula_asignatura M ON P.id = M.id_alumno 
INNER JOIN asignatura A ON A.id = M.id_asignatura 
INNER JOIN grado G ON G.id = A.id_grado 
INNER JOIN curso_escolar C ON M.id_curso_escolar = C.id 
WHERE G.nombre = 'Ingeniería en Informática' 
AND EXTRACT(year FROM C.anyo_inicio) = 2015
AND P.tipo = 'Alumno'
AND P.sexo = 'M';

-- Consulta 2:
SELECT A.nombre FROM asignatura A
INNER JOIN grado G ON G.id = A.id_grado
WHERE G.nombre = 'Ingeniería en Informática';

-- Consulta 3:
SELECT P.apellido1, P.apellido2, P.nombre, D.nombre FROM persona P
INNER JOIN profesor T ON T.id_profesor = P.id
INNER JOIN departamento D ON D.id = T.id_departamento
ORDER BY P.apellido1, P.apellido2, P.nombre;

-- Consulta 4:
SELECT A.nombre, EXTRACT(year FROM C.anyo_inicio), EXTRACT(year FROM C.anyo_fin) FROM asignatura A
INNER JOIN alumno_se_matricula_asignatura M ON M.id_asignatura = A.id
INNER JOIN persona P ON P.id = M.id_alumno
INNER JOIN curso_escolar C ON C.id = M.id_curso_escolar
WHERE P.nif = '45678901C';

-- Consulta 5:
SELECT D.nombre FROM departamento D 
INNER JOIN profesor T ON D.id = T.id_departamento
INNER JOIN asignatura A ON A.id_profesor = T.id_profesor
INNER JOIN grado G ON G.id = A.id_grado
WHERE G.nombre = 'Ingeniería en Informática';

-- Consulta 6:
SELECT DISTINCT P.apellido1, P.apellido2, P.nombre FROM persona P
INNER JOIN alumno_se_matricula_asignatura M ON M.id_alumno = P.id
INNER JOIN curso_escolar C ON C.id = M.id_curso_escolar
WHERE EXTRACT(year FROM C.anyo_inicio) = 2014;

-- CONSULTAS MULTITABLA (Composición Externa)
-- Consulta 1:
SELECT D.nombre AS Nombre_Del_Departamento,
      P.apellido1 AS Primer_Apellido,
      P.apellido2 AS Segundo_Apellido,
      P.nombre AS Nombre
FROM persona P
INNER JOIN profesor T ON T.id_profesor = P.id
LEFT JOIN departamento D ON T.id_departamento = D.id
ORDER BY D.nombre, P.apellido1, P.apellido2, P.nombre;

-- Consulta 2:
SELECT P.nombre || ' ' || P.apellido1 || ' ' || P.apellido2 FROM persona P
WHERE P.id NOT IN (SELECT id_profesor FROM profesor) AND P.tipo = 'Profesor';

-- Consulta 3:
SELECT nombre FROM departamento
WHERE id NOT IN (SELECT id_departamento FROM profesor);

-- Consulta 4:
SELECT nombre || ' ' || apellido1 || ' ' ||  apellido2 AS Profesor_Sin_Asignatura
FROM persona
WHERE id NOT IN (SELECT id_profesor FROM asignatura WHERE id_profesor IS NOT NULL) AND tipo = 'Profesor';

-- Consulta 5:
SELECT DISTINCT nombre AS Asignatura_Profesor_Sin
FROM asignatura
WHERE id_profesor IS NULL;

-- Consulta 6:
SELECT D.nombre, A.nombre, A.id
FROM asignatura A
LEFT JOIN profesor P ON P.id_profesor = A.id_profesor
INNER JOIN departamento D ON P.id_departamento = D.id
LEFT JOIN alumno_se_matricula_asignatura M ON M.id_asignatura = A.id
WHERE M.id_asignatura IS NULL;

-- CONSULTAS RESUMEN
-- Consulta 1:
SELECT COUNT(*) AS Num_Alumnas FROM persona WHERE sexo = 'M' AND tipo = 'Alumno';

-- Consulta 2:
SELECT COUNT(*) AS Nacidos_2005 FROM persona WHERE tipo = 'Alumno' AND EXTRACT(year FROM fecha_nacimiento) = '2005';

-- Consulta 3:
SELECT D.nombre AS Departamento, COUNT(T.id_profesor) AS Cantidad_Profesores
FROM departamento D
INNER JOIN profesor T ON D.id = T.id_departamento
GROUP BY D.id 
ORDER BY Cantidad_Profesores DESC;

-- Consulta 4:
SELECT D.nombre AS Departamento, COUNT(T.id_profesor) AS Cantidad_Profesores
FROM departamento D
LEFT JOIN profesor T ON D.id = T.id_departamento
GROUP BY D.id 
ORDER BY Cantidad_Profesores DESC, Departamento;

-- Consulta 5:
SELECT G.nombre AS Grado, COUNT(A.id_grado) AS Cantidad_Asignaturas
FROM grado G
LEFT JOIN asignatura A ON G.id = A.id_grado
GROUP BY G.id 
ORDER BY Cantidad_Asignaturas DESC, Grado;

-- Consulta 6:
SELECT G.nombre AS Grado, COUNT(A.id_grado) AS Cantidad_Asignaturas
FROM grado G
LEFT JOIN asignatura A ON G.id = A.id_grado
GROUP BY G.id 
HAVING Cantidad_Asignaturas > 40
ORDER BY Cantidad_Asignaturas DESC, Grado;

-- Consulta 7:
SELECT G.nombre AS Grado, A.tipo, SUM(A.creditos) AS Cantidad_Creditos
FROM grado G
INNER JOIN asignatura A ON G.id = A.id_grado
GROUP BY A.id_grado, A.tipo
ORDER BY Cantidad_Creditos DESC;

-- Consulta 8:
SELECT C.anyo_inicio AS Año_Inicio, COUNT(M.id_asignatura) AS Alumnos_Matriculados
FROM alumno_se_matricula_asignatura M 
INNER JOIN curso_escolar C ON M.id_curso_escolar = C.id
GROUP BY M.id_curso_escolar;

-- Consulta 9:
SELECT P.id, 
      P.nombre as Nombre,
      P.apellido1 AS Primer_Apellido, 
      P.apellido2 AS Segundo_Apellido,
      COUNT(A.id) AS Cantidad_Asignaturas
FROM persona P
INNER JOIN profesor Pr ON P.id = Pr.id_profesor
LEFT JOIN asignatura A ON A.id_profesor = Pr.id_profesor
GROUP BY Pr.id_profesor
ORDER BY Cantidad_Asignaturas DESC;

-- SUBCONSULTAS 
-- Consulta 1:
SELECT *
FROM persona
WHERE fecha_nacimiento = (SELECT MAX(fecha_nacimiento) FROM persona);

-- Consulta 2:
SELECT CONCAT(P.nombre, ' ', P.apellido1, ' ', P.apellido2) FROM persona P
WHERE P.id NOT IN (SELECT id_profesor FROM profesor) AND P.tipo = 1;

-- Consulta 3:
SELECT nombre FROM departamento
WHERE id NOT IN (SELECT id_departamento FROM profesor);

-- Consulta 4:
SELECT CONCAT(P.nombre, ' ', P.apellido1, ' ', P.apellido2) AS Profesor
FROM persona P
INNER JOIN profesor Pr ON Pr.id_profesor = P.id
INNER JOIN departamento D ON Pr.id_departamento = D.id
LEFT JOIN asignatura A ON A.id_profesor = Pr.id_profesor
WHERE A.id_profesor IS NULL
ORDER BY P.apellido1, P.apellido2, P.nombre;

-- Consulta 5:
SELECT nombre 
FROM asignatura
WHERE id_profesor IS NULL;

-- Consulta 6:
SELECT DISTINCT D.nombre
FROM departamento D
LEFT JOIN profesor P ON D.id = P.id_departamento
LEFT JOIN asignatura A ON A.id_profesor = P.id_profesor
LEFT JOIN alumno_se_matricula_asignatura M ON M.id_asignatura = A.id
WHERE M.id_curso_escolar IS NULL AND A.curso IS NULL;