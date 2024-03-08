-- CREACIÓN DE BASE DE DATOS
DROP DATABASE IF EXISTS bd_universidad;
CREATE DATABASE bd_universidad;

CREATE TYPE sexo AS ENUM ('H', 'M');
CREATE TYPE tipo AS ENUM ('Alumno', 'Profesor');
CREATE TYPE tipo_asg AS ENUM ('Básica', 'Obligatoria', 'Optativa');

DROP TABLE IF EXISTS departamento;
CREATE TABLE departamento (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(50)
);

DROP TABLE IF EXISTS grado;
CREATE TABLE grado (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(100)
);

DROP TABLE IF EXISTS persona;
CREATE TABLE persona  (
	id SERIAL PRIMARY KEY,
	nif VARCHAR(9),
	nombre VARCHAR(25),
	apellido1 VARCHAR(50),
	apellido2 VARCHAR(50),
	ciudad VARCHAR(25),
	direccion VARCHAR(50),
	telefono VARCHAR(9),
	fecha_nacimiento DATE,
	sexo sexo,
	tipo tipo
);

DROP TABLE IF EXISTS profesor;
CREATE TABLE profesor (
	id_profesor INTEGER REFERENCES persona(id) UNIQUE,
	id_departamento INTEGER REFERENCES departamento(id)
);

DROP TABLE IF EXISTS asignatura;
CREATE TABLE asignatura (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(100),
	creditos FLOAT,
	tipo tipo_asg,
	curso INTEGER,
	cuatrimestre INTEGER,
	id_profesor INTEGER REFERENCES profesor(id_profesor),
	id_grado INTEGER REFERENCES grado(id)
);

DROP TABLE IF EXISTS curso_escolar;
CREATE TABLE curso_escolar (
	id SERIAL PRIMARY KEY,
	anyo_inicio DATE,
	anyo_fin DATE
);

DROP TABLE IF EXISTS alumno_se_matricula_asignatura;
CREATE TABLE alumno_se_matricula_asignatura (
	id_alumno INTEGER REFERENCES persona(id),
	id_asignatura INTEGER REFERENCES asignatura(id),
	id_curso_escolar INTEGER REFERENCES curso_escolar(id)
);