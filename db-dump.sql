--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE courses_app;
ALTER ROLE courses_app WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT 10 PASSWORD 'SCRAM-SHA-256$4096:wFj8uB9VFC9jsY1LrXJsVw==$asUyEPHsyaUYt2biLIW9EiGO7lwLGnSNrtuAi12NN14=:nWI+ThvqgQoq3z/P4P6ma1NUIceEdRfpgCffUQU4UEk=';
CREATE ROLE g_register_people_app;
ALTER ROLE g_register_people_app WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE moodle_super;
ALTER ROLE moodle_super WITH SUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:4YhUh5DU1t8UkBy8GpWTQA==$IUQ1Ngind/PVevvV8MV/FRadxmIS2SuHtQELe4sHTZg=:g7YYh10mmSJuZZZmPj9lrf+QwWkh+MwojK48f3ugGOM=';
CREATE ROLE register_people_app;
ALTER ROLE register_people_app WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT 10 PASSWORD 'SCRAM-SHA-256$4096:9NcTTmMF2oGDuT5JVxp6XA==$TcBai8ThqB86Dv64zi5oRb+iTZ6U5V40cQIqTHlrYY0=:riOrMNtK/645MIi5zou0soIWluOwl0aNdkTNP4oFezY=';

--
-- User Configurations
--

--
-- User Config "register_people_app"
--

ALTER ROLE register_people_app SET role TO 'g_register_people_app';


--
-- Role memberships
--

GRANT g_register_people_app TO register_people_app WITH INHERIT FALSE GRANTED BY postgres;






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "moodle" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: moodle; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE moodle WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE moodle OWNER TO postgres;

\connect moodle

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: faculty; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA faculty;


ALTER SCHEMA faculty OWNER TO postgres;

--
-- Name: general; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA general;


ALTER SCHEMA general OWNER TO postgres;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: class_code; Type: DOMAIN; Schema: faculty; Owner: postgres
--

CREATE DOMAIN faculty.class_code AS character(14)
	CONSTRAINT class_code_check CHECK ((VALUE ~ '^[A-Z]{3}\d{3}\d{4}[1|2][M|T|N]\d{2}$'::text));


ALTER DOMAIN faculty.class_code OWNER TO postgres;

--
-- Name: classify_grade_state; Type: TYPE; Schema: faculty; Owner: postgres
--

CREATE TYPE faculty.classify_grade_state AS (
	status_a_quantity integer,
	status_b_quantity integer,
	status_c_quantity integer,
	status_d_quantity integer,
	status_e_quantity integer,
	status_a_percent numeric(3,2),
	status_b_percent numeric(3,2),
	status_c_percent numeric(3,2),
	status_d_percent numeric(3,2),
	status_e_percent numeric(3,2)
);


ALTER TYPE faculty.classify_grade_state OWNER TO postgres;

--
-- Name: course_code; Type: DOMAIN; Schema: faculty; Owner: postgres
--

CREATE DOMAIN faculty.course_code AS character(6)
	CONSTRAINT course_code_check CHECK ((VALUE ~ '^[A-Z]{3}\d{3}$'::text));


ALTER DOMAIN faculty.course_code OWNER TO postgres;

--
-- Name: session; Type: TYPE; Schema: faculty; Owner: postgres
--

CREATE TYPE faculty.session AS ENUM (
    'M',
    'T',
    'N'
);


ALTER TYPE faculty.session OWNER TO postgres;

--
-- Name: create_class_input; Type: TYPE; Schema: faculty; Owner: postgres
--

CREATE TYPE faculty.create_class_input AS (
	class_session faculty.session,
	initial_date date,
	final_date date,
	course_id integer,
	instructor_id integer
);


ALTER TYPE faculty.create_class_input OWNER TO postgres;

--
-- Name: degree_program_code; Type: DOMAIN; Schema: faculty; Owner: postgres
--

CREATE DOMAIN faculty.degree_program_code AS character(5) NOT NULL
	CONSTRAINT degree_program_code_check CHECK ((VALUE ~ '^[A-Z]{5}$'::text));


ALTER DOMAIN faculty.degree_program_code OWNER TO postgres;

--
-- Name: department_code; Type: DOMAIN; Schema: faculty; Owner: postgres
--

CREATE DOMAIN faculty.department_code AS character(3) NOT NULL
	CONSTRAINT department_code_check CHECK ((VALUE ~ '^[A-Z]{3}$'::text));


ALTER DOMAIN faculty.department_code OWNER TO postgres;

--
-- Name: enroll_student_in_class_input; Type: TYPE; Schema: faculty; Owner: postgres
--

CREATE TYPE faculty.enroll_student_in_class_input AS (
	student_id integer,
	class_id integer
);


ALTER TYPE faculty.enroll_student_in_class_input OWNER TO postgres;

--
-- Name: instructor_enrollment_code; Type: DOMAIN; Schema: faculty; Owner: postgres
--

CREATE DOMAIN faculty.instructor_enrollment_code AS character(9)
	CONSTRAINT instructor_enrollment_code_check CHECK ((VALUE ~ '^[A-Z]{3}\d{6}$'::text));


ALTER DOMAIN faculty.instructor_enrollment_code OWNER TO postgres;

--
-- Name: request_material_input; Type: TYPE; Schema: faculty; Owner: postgres
--

CREATE TYPE faculty.request_material_input AS (
	material_id integer,
	lesson_id integer,
	quantity integer
);


ALTER TYPE faculty.request_material_input OWNER TO postgres;

--
-- Name: return_material_input; Type: TYPE; Schema: faculty; Owner: postgres
--

CREATE TYPE faculty.return_material_input AS (
	material_id integer,
	lesson_id integer
);


ALTER TYPE faculty.return_material_input OWNER TO postgres;

--
-- Name: student_enrollment_code; Type: DOMAIN; Schema: faculty; Owner: postgres
--

CREATE DOMAIN faculty.student_enrollment_code AS character(13)
	CONSTRAINT student_enrollment_code_check CHECK ((VALUE ~ '^[A-Z]{5}\d{4}[1|2]\d{3}$'::text));


ALTER DOMAIN faculty.student_enrollment_code OWNER TO postgres;

--
-- Name: format_address_input; Type: TYPE; Schema: general; Owner: postgres
--

CREATE TYPE general.format_address_input AS (
	street text,
	number integer,
	addressline2 text,
	neighborhood text,
	city text,
	state text,
	zipcode text,
	country text
);


ALTER TYPE general.format_address_input OWNER TO postgres;

--
-- Name: classify_grade_final(faculty.classify_grade_state); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.classify_grade_final(state faculty.classify_grade_state) RETURNS faculty.classify_grade_state
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    total_grades numeric(3, 2);
BEGIN
    total_grades := state.status_a_quantity + state.status_b_quantity + state.status_c_quantity + state.status_d_quantity + state.status_e_quantity;
    state.status_a_percent := round(state.status_a_quantity / total_grades, 2);
    state.status_b_percent := round(state.status_b_quantity / total_grades, 2);
    state.status_c_percent := round(state.status_c_quantity / total_grades, 2);
    state.status_d_percent := round(state.status_d_quantity / total_grades, 2);
    state.status_e_percent := round(state.status_e_quantity / total_grades, 2);
    RETURN state;
END;
$$;


ALTER FUNCTION faculty.classify_grade_final(state faculty.classify_grade_state) OWNER TO postgres;

--
-- Name: classify_grade_state(faculty.classify_grade_state, double precision); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.classify_grade_state(state faculty.classify_grade_state, grade double precision) RETURNS faculty.classify_grade_state
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    IF grade < 20 THEN
        state.status_e_quantity := state.status_e_quantity + 1;
    ELSIF grade < 40 THEN
        state.status_d_quantity := state.status_d_quantity + 1;
    ELSIF grade < 60 THEN
        state.status_c_quantity := state.status_c_quantity + 1;
    ELSIF grade < 80 THEN
        state.status_b_quantity := state.status_b_quantity + 1;
    ELSE
        state.status_a_quantity := state.status_a_quantity + 1;
    END IF;
    RETURN state;
END;
$$;


ALTER FUNCTION faculty.classify_grade_state(state faculty.classify_grade_state, grade double precision) OWNER TO postgres;

--
-- Name: create_class(faculty.create_class_input); Type: PROCEDURE; Schema: faculty; Owner: postgres
--

CREATE PROCEDURE faculty.create_class(IN input faculty.create_class_input)
    LANGUAGE plpgsql
    SET default_transaction_isolation TO 'serializable'
    AS $$
DECLARE
    instructor_is_active boolean;
    instructor_department int;
    course_department int;
    instructor_teaches_course boolean;
    course_load_used int;
    max_course_load int;
    new_course_load int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    -- gets instructor data
    SELECT
        i.active,
        i.max_course_load,
        i.department_id INTO instructor_is_active,
        max_course_load,
        instructor_department
    FROM
        faculty.instructors i
    WHERE
        i.instructor_id = input.instructor_id;
    -- checks if the instructor is active
    IF NOT instructor_is_active THEN
        RAISE EXCEPTION 'instructor % is not active', input.instructor_id;
    END IF;
    -- gets course department
    SELECT
        c.department_id INTO course_department
    FROM
        faculty.courses c
    WHERE
        c.course_id = input.course_id;
    -- checks instructor and course departments
    IF instructor_department <> course_department THEN
        RAISE EXCEPTION 'the instructor can only teach classes from his department, instructor_department: %, course_department: %', instructor_department, course_department;
    END IF;
    -- gets instructor_course
    SELECT
        TRUE INTO instructor_teaches_course
    FROM
        faculty.instructors_courses ic
    WHERE
        ic.instructor_id = input.instructor_id
        AND ic.course_id = input.course_id;
    -- checks if instructor teaches course
    IF instructor_teaches_course IS NULL OR NOT instructor_teaches_course THEN
        RAISE EXCEPTION 'the instructor % does not teach the course %', input.instructor_id, input.course_id;
    END IF;
    -- gets course load used by instructor
    SELECT
        coalesce(sum(co.course_load), 0) INTO course_load_used
    FROM
        faculty.classes cl
        INNER JOIN faculty.courses co USING (course_id)
    WHERE
        general.class_is_in_progress(cl.year_semester)
        AND cl.instructor_id = input.instructor_id;
    -- gets new course load of the instructor
    SELECT
        c.course_load INTO new_course_load
    FROM
        faculty.courses c
    WHERE
        c.course_id = input.course_id;
    -- checks whether the course load exceeds the limit
    IF course_load_used + new_course_load > max_course_load THEN
        RAISE EXCEPTION 'course load exceeded for instructor_id %', input.instructor_id;
    END IF;
    -- inserts new class
    INSERT INTO faculty.classes(class_session, initial_date, final_date, course_id, instructor_id)
        VALUES (input.class_session, input.initial_date, input.final_date, input.course_id, input.instructor_id);
    -- updates instructor course load
    UPDATE
        faculty.instructors
    SET
        current_course_load = current_course_load + new_course_load
    WHERE
        instructor_id = input.instructor_id;
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS _sqlstate = returned_sqlstate,
        _message = message_text,
        _context = pg_exception_context;
    RAISE EXCEPTION 'sqlstate: %, message: %, context: %', _sqlstate, _message, _context;
ROLLBACK;
END;

$$;


ALTER PROCEDURE faculty.create_class(IN input faculty.create_class_input) OWNER TO postgres;

--
-- Name: create_class_code_counter(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.create_class_code_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.class_code_counters(course_id, session)
        VALUES(NEW.course_id, 'M'),
(NEW.course_id, 'T'),
(NEW.course_id, 'N');
    RETURN NULL;
END;
$$;


ALTER FUNCTION faculty.create_class_code_counter() OWNER TO postgres;

--
-- Name: create_course_code_counter(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.create_course_code_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.course_code_counters(department_id)
        VALUES(NEW.department_id);
    RETURN NULL;
END;
$$;


ALTER FUNCTION faculty.create_course_code_counter() OWNER TO postgres;

--
-- Name: create_instructor_enrollment_code_counter(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.create_instructor_enrollment_code_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.instructor_enrollment_code_counters(department_id)
        VALUES(NEW.department_id);
    RETURN NULL;
END;
$$;


ALTER FUNCTION faculty.create_instructor_enrollment_code_counter() OWNER TO postgres;

--
-- Name: create_new_counters(); Type: PROCEDURE; Schema: faculty; Owner: postgres
--

CREATE PROCEDURE faculty.create_new_counters()
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_year_semester char(5);
    course record;
    degree_program record;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    current_year_semester := general.get_year_semester(CURRENT_DATE);
    -- creates new counters for class codes
    FOR course IN
    SELECT
        c.course_id
    FROM
        faculty.courses c LOOP
            INSERT INTO faculty.class_code_counters(course_id, session, year_semester)
                VALUES (course.course_id, 'M', current_year_semester),
(course.course_id, 'T', current_year_semester),
(course.course_id, 'N', current_year_semester);
        END LOOP;
    -- creates new counters for student entollment codes
    FOR degree_program IN
    SELECT
        d.degree_program_id
    FROM
        faculty.degree_programs d LOOP
            INSERT INTO faculty.student_enrollment_code_counters(degree_program_id, year_semester)
                VALUES (degree_program.degree_program_id, current_year_semester);
        END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS _sqlstate = returned_sqlstate,
        _message = message_text,
        _context = pg_exception_context;
    RAISE EXCEPTION 'sqlstate: %, message: %, context: %', _sqlstate, _message, _context;
ROLLBACK;
END;

$$;


ALTER PROCEDURE faculty.create_new_counters() OWNER TO postgres;

--
-- Name: create_student_enrollment_code_counter(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.create_student_enrollment_code_counter() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.student_enrollment_code_counters(degree_program_id)
        VALUES(NEW.degree_program_id);
    RETURN NULL;
END;
$$;


ALTER FUNCTION faculty.create_student_enrollment_code_counter() OWNER TO postgres;

--
-- Name: enroll_student_in_class(faculty.enroll_student_in_class_input); Type: PROCEDURE; Schema: faculty; Owner: postgres
--

CREATE PROCEDURE faculty.enroll_student_in_class(IN input faculty.enroll_student_in_class_input)
    LANGUAGE plpgsql
    SET default_transaction_isolation TO 'serializable'
    AS $$
DECLARE
    student_is_active boolean;
    prerequisite record;
    final_status text;
    course_load_used int;
    max_course_load int;
    new_course_load int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    -- gets student data
    SELECT
        s.active,
        s.max_course_load INTO student_is_active,
        max_course_load
    FROM
        faculty.students s
    WHERE
        s.student_id = input.student_id;
    -- checks if the students is active
    IF NOT student_is_active THEN
        RAISE EXCEPTION 'student % is not active', input.student_id;
    END IF;
    -- checks if the course prerequisites have been completed
    FOR prerequisite IN
    SELECT
        pr.prerequisite_id
    FROM
        faculty.classes cl
        INNER JOIN faculty.prerequisites pr USING (course_id)
    WHERE
        cl.class_id = input.class_id LOOP
            SELECT
                a.final_status INTO final_status
            FROM
                faculty.academic_transcripts a
            WHERE
                a.student_id = input.student_id
                AND a.course_id = prerequisite.prerequisite_id;
            IF final_status IS NULL OR final_status <> 'passed' THEN
                RAISE EXCEPTION 'student % did not pass the course %', input.student_id, prerequisite.prerequisite_id;
            END IF;
        END LOOP;
    -- gets course load used by student
    SELECT
        coalesce(sum(co.course_load), 0) INTO course_load_used
    FROM
        faculty.students_classes sc
        INNER JOIN faculty.classes cl USING (class_id)
        INNER JOIN faculty.courses co USING (course_id)
    WHERE
        general.class_is_in_progress(cl.year_semester)
        AND sc.student_id = input.student_id;
    -- gets new course load of the student
    SELECT
        co.course_load INTO new_course_load
    FROM
        faculty.classes cl
        INNER JOIN faculty.courses co USING (course_id)
    WHERE
        cl.class_id = input.class_id;
    -- checks whether the course load exceeds the limit
    IF course_load_used + new_course_load > max_course_load THEN
        RAISE EXCEPTION 'course load exceeded for student_id %', input.student_id;
    END IF;
    -- inserts new enrollment
    INSERT INTO faculty.students_classes(student_id, class_id)
        VALUES (input.student_id, input.class_id);
    -- updates student course load
    UPDATE
        faculty.students
    SET
        current_course_load = current_course_load + new_course_load
    WHERE
        student_id = input.student_id;
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS _sqlstate = returned_sqlstate,
        _message = message_text,
        _context = pg_exception_context;
    RAISE EXCEPTION 'sqlstate: %, message: %, context: %', _sqlstate, _message, _context;
ROLLBACK;
END;

$$;


ALTER PROCEDURE faculty.enroll_student_in_class(IN input faculty.enroll_student_in_class_input) OWNER TO postgres;

--
-- Name: generate_class_code(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.generate_class_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    course_code char(6);
    class_year_semester char(5);
    class_code_counter int;
BEGIN
    -- gets course code
    SELECT
        c.code INTO course_code
    FROM
        faculty.courses c
    WHERE
        c.course_id = NEW.course_id;
    -- gets class year_semester
    class_year_semester := general.get_year_semester(NEW.initial_date);
    -- gets and increments counter
    UPDATE
        faculty.class_code_counters
    SET
        counter = counter + 1
    WHERE
        course_id = NEW.course_id
        AND year_semester = class_year_semester
        AND session = NEW.class_session
    RETURNING
        counter INTO class_code_counter;
    -- generates class code
    NEW.code := course_code || class_year_semester || NEW.class_session || lpad(class_code_counter::text, 2, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.generate_class_code() OWNER TO postgres;

--
-- Name: generate_course_code(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.generate_course_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department_code char(3);
    course_code_counter int;
BEGIN
    -- gets department code
    SELECT
        d.code INTO department_code
    FROM
        faculty.departments d
    WHERE
        d.department_id = NEW.department_id;
    -- gets and increments counter
    UPDATE
        faculty.course_code_counters
    SET
        counter = counter + 1
    WHERE
        department_id = NEW.department_id
    RETURNING
        counter INTO course_code_counter;
    -- generates course code
    NEW.code := department_code || lpad(course_code_counter::text, 3, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.generate_course_code() OWNER TO postgres;

--
-- Name: generate_instructor_enrollment_code(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.generate_instructor_enrollment_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    department_code char(3);
    instructor_enrollment_code_counter int;
BEGIN
    -- gets department code
    SELECT
        d.code INTO department_code
    FROM
        faculty.departments d
    WHERE
        d.department_id = NEW.department_id;
    -- gets and increments counter
    UPDATE
        faculty.instructor_enrollment_code_counters
    SET
        counter = counter + 1
    WHERE
        department_id = NEW.department_id
    RETURNING
        counter INTO instructor_enrollment_code_counter;
    -- generates instructor enrollment_code
    NEW.enrollment_code := department_code || lpad(instructor_enrollment_code_counter::text, 6, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.generate_instructor_enrollment_code() OWNER TO postgres;

--
-- Name: generate_student_enrollment_code(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.generate_student_enrollment_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_year_semester char(5);
    degree_program_code char(5);
    student_enrollment_code_counter int;
BEGIN
    -- gets current year semester
    current_year_semester := general.get_year_semester(CURRENT_DATE);
    -- gets degree program code
    SELECT
        d.code INTO degree_program_code
    FROM
        faculty.degree_programs d
    WHERE
        d.degree_program_id = NEW.degree_program_id;
    -- gets and increments counter
    UPDATE
        faculty.student_enrollment_code_counters
    SET
        counter = counter + 1
    WHERE
        degree_program_id = NEW.degree_program_id
        AND year_semester = current_year_semester
    RETURNING
        counter INTO student_enrollment_code_counter;
    -- generates student enrollment code
    NEW.enrollment_code := degree_program_code || current_year_semester || lpad(student_enrollment_code_counter::text, 3, '0');
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.generate_student_enrollment_code() OWNER TO postgres;

--
-- Name: increment_lessons_in_class(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.increment_lessons_in_class() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE
        faculty.classes
    SET
        total_lessons = total_lessons + 1
    WHERE
        class_id = NEW.class_id;
    RETURN NULL;
END;
$$;


ALTER FUNCTION faculty.increment_lessons_in_class() OWNER TO postgres;

--
-- Name: increment_score_in_class(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.increment_score_in_class() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE
        faculty.classes
    SET
        total_score = total_score + NEW.total_score
    WHERE
        class_id = NEW.class_id;
    RETURN NULL;
END;
$$;


ALTER FUNCTION faculty.increment_score_in_class() OWNER TO postgres;

--
-- Name: request_global_material(faculty.request_material_input); Type: PROCEDURE; Schema: faculty; Owner: postgres
--

CREATE PROCEDURE faculty.request_global_material(IN input faculty.request_material_input)
    LANGUAGE plpgsql
    AS $$
DECLARE
    available_quantity int;
    new_available_quantity int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    -- gets material info
    SELECT
        m.available_quantity INTO available_quantity
    FROM
        faculty.materials m
    WHERE
        m.material_id = input.material_id
        AND m.department_id IS NULL
    FOR UPDATE;
    -- checks if stock is available
    new_available_quantity := available_quantity - input.quantity;
    IF new_available_quantity IS NULL OR new_available_quantity < 0 THEN
        RAISE EXCEPTION 'material % without available stock', input.material_id;
    END IF;
    -- updates stock
    UPDATE
        faculty.materials
    SET
        available_quantity = new_available_quantity
    WHERE
        material_id = input.material_id;
    -- inserts material request
    INSERT INTO faculty.material_requests(material_id, lesson_id, quantity)
        VALUES (input.material_id, input.lesson_id, input.quantity);
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS _sqlstate = returned_sqlstate,
        _message = message_text,
        _context = pg_exception_context;
    RAISE EXCEPTION 'sqlstate: %, message: %, context: %', _sqlstate, _message, _context;
ROLLBACK;
END;

$$;


ALTER PROCEDURE faculty.request_global_material(IN input faculty.request_material_input) OWNER TO postgres;

--
-- Name: request_material_from_department(faculty.request_material_input); Type: PROCEDURE; Schema: faculty; Owner: postgres
--

CREATE PROCEDURE faculty.request_material_from_department(IN input faculty.request_material_input)
    LANGUAGE plpgsql
    SET default_transaction_isolation TO 'repeatable read'
    AS $$
DECLARE
    lesson_department_id int;
    material_department_id int;
    available_quantity int;
    new_available_quantity int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    -- gets lesson deparment
    SELECT
        co.department_id INTO lesson_department_id
    FROM
        faculty.lessons le
        INNER JOIN faculty.classes cl USING (class_id)
        INNER JOIN faculty.courses co USING (course_id)
    WHERE
        le.lesson_id = input.lesson_id;
    -- gets material info
    SELECT
        m.department_id,
        m.available_quantity INTO material_department_id,
        available_quantity
    FROM
        faculty.materials m
    WHERE
        m.material_id = input.material_id;
    -- checks lesson and material department
    IF lesson_department_id <> material_department_id THEN
        RAISE EXCEPTION 'lesson and material must be from the same department';
    END IF;
    -- checks if stock is available
    new_available_quantity := available_quantity - input.quantity;
    IF new_available_quantity IS NULL OR new_available_quantity < 0 THEN
        RAISE EXCEPTION 'material % without available stock', input.material_id;
    END IF;
    -- updates stock
    UPDATE
        faculty.materials
    SET
        available_quantity = new_available_quantity
    WHERE
        material_id = input.material_id;
    -- inserts material request
    INSERT INTO faculty.material_requests(material_id, lesson_id, quantity)
        VALUES (input.material_id, input.lesson_id, input.quantity);
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS _sqlstate = returned_sqlstate,
        _message = message_text,
        _context = pg_exception_context;
    RAISE EXCEPTION 'sqlstate: %, message: %, context: %', _sqlstate, _message, _context;
ROLLBACK;
END;

$$;


ALTER PROCEDURE faculty.request_material_from_department(IN input faculty.request_material_input) OWNER TO postgres;

--
-- Name: return_material(faculty.return_material_input); Type: PROCEDURE; Schema: faculty; Owner: postgres
--

CREATE PROCEDURE faculty.return_material(IN input faculty.return_material_input)
    LANGUAGE plpgsql
    AS $$
DECLARE
    used_quantity int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    -- updates material request
    UPDATE
        faculty.material_requests
    SET
        return_timestamp = CURRENT_TIMESTAMP
    WHERE
        material_id = input.material_id
        AND lesson_id = input.lesson_id
    RETURNING
        quantity INTO used_quantity;
    -- updates stock
    UPDATE
        faculty.materials
    SET
        available_quantity = available_quantity + used_quantity
    WHERE
        material_id = input.material_id;
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS _sqlstate = returned_sqlstate,
        _message = message_text,
        _context = pg_exception_context;
    RAISE EXCEPTION 'sqlstate: %, message: %, context: %', _sqlstate, _message, _context;
ROLLBACK;
END;

$$;


ALTER PROCEDURE faculty.return_material(IN input faculty.return_material_input) OWNER TO postgres;

--
-- Name: set_available_quantity(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.set_available_quantity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.available_quantity = NEW.total_quantity;
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.set_available_quantity() OWNER TO postgres;

--
-- Name: set_class_id(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.set_class_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    class_id int;
BEGIN
    IF NEW.exam_id IS NOT NULL THEN
        SELECT
            e.class_id INTO class_id
        FROM
            faculty.exams e
        WHERE
            e.exam_id = NEW.exam_id;
    ELSIF NEW.activity_id IS NOT NULL THEN
        SELECT
            a.class_id INTO class_id
        FROM
            faculty.activities a
        WHERE
            a.activity_id = NEW.activity_id;
    ELSE
        RAISE EXCEPTION 'missing exam_id or activity_id';
    END IF;
    NEW.class_id := class_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.set_class_id() OWNER TO postgres;

--
-- Name: set_course_code(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.set_course_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT
        c.code INTO NEW.course_code
    FROM
        faculty.courses c
    WHERE
        c.course_id = NEW.course_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.set_course_code() OWNER TO postgres;

--
-- Name: set_degree_program_code(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.set_degree_program_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT
        d.code INTO NEW.degree_program_code
    FROM
        faculty.degree_programs d
    WHERE
        d.degree_program_id = NEW.degree_program_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.set_degree_program_code() OWNER TO postgres;

--
-- Name: set_department_code(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.set_department_code() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT
        d.code INTO NEW.department_code
    FROM
        faculty.departments d
    WHERE
        d.department_id = NEW.department_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.set_department_code() OWNER TO postgres;

--
-- Name: set_material_request_fields(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.set_material_request_fields() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT
        c.instructor_id,
        l.date,
        l.initial_time::interval - interval '30 min',
        l.final_time::interval + interval '30 min' INTO NEW.instructor_id,
        NEW.date,
        NEW.initial_time,
        NEW.final_time
    FROM
        faculty.lessons l
        INNER JOIN faculty.classes c USING(class_id)
    WHERE
        l.lesson_id = NEW.lesson_id;
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.set_material_request_fields() OWNER TO postgres;

--
-- Name: set_year_semester(); Type: FUNCTION; Schema: faculty; Owner: postgres
--

CREATE FUNCTION faculty.set_year_semester() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.year_semester := general.get_year_semester(NEW.initial_date);
    RETURN NEW;
END;
$$;


ALTER FUNCTION faculty.set_year_semester() OWNER TO postgres;

--
-- Name: class_is_in_progress(character); Type: FUNCTION; Schema: general; Owner: postgres
--

CREATE FUNCTION general.class_is_in_progress(class_year_semester character) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    current_year_semester char(5);
BEGIN
    current_year_semester := general.get_year_semester(CURRENT_DATE);
    RETURN class_year_semester = current_year_semester;
END;
$$;


ALTER FUNCTION general.class_is_in_progress(class_year_semester character) OWNER TO postgres;

--
-- Name: created_at(); Type: FUNCTION; Schema: general; Owner: postgres
--

CREATE FUNCTION general.created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.created_at := CURRENT_TIMESTAMP;
    NEW.updated_at := NULL;
    RETURN NEW;
END;
$$;


ALTER FUNCTION general.created_at() OWNER TO postgres;

--
-- Name: format_address(general.format_address_input); Type: FUNCTION; Schema: general; Owner: postgres
--

CREATE FUNCTION general.format_address(address_input general.format_address_input) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    address_output text;
BEGIN
    address_output := address_input.street || ', ' || address_input.number;
    IF trim(address_input.addressLine2) <> '' THEN
        address_output := address_output || ', ' || address_input.addressLine2;
    END IF;
    address_output := address_output || ', ' || address_input.neighborhood || ' - ' || address_input.city || ', ' || address_input.state || ', ' || address_input.zipCode || ', ' || address_input.country;
    RETURN address_output;
END;
$$;


ALTER FUNCTION general.format_address(address_input general.format_address_input) OWNER TO postgres;

--
-- Name: format_telephone(character, character); Type: FUNCTION; Schema: general; Owner: postgres
--

CREATE FUNCTION general.format_telephone(ddd character, number character) RETURNS character
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN '(' || ddd || ') ' || substring(number FROM 1 FOR 5) || '-' || substring(number FROM 6 FOR 4);
END;
$$;


ALTER FUNCTION general.format_telephone(ddd character, number character) OWNER TO postgres;

--
-- Name: get_year_semester(date); Type: FUNCTION; Schema: general; Owner: postgres
--

CREATE FUNCTION general.get_year_semester(input_date date) RETURNS character
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    year char(4);
    semester char(1);
BEGIN
    year := extract(year FROM input_date);
    SELECT
        CASE WHEN extract(month FROM input_date)::int8 <@ '[1,6]'::int8range THEN
            '1'
        ELSE
            '2'
        END INTO semester;
    RETURN year || semester;
END;
$$;


ALTER FUNCTION general.get_year_semester(input_date date) OWNER TO postgres;

--
-- Name: updated_at(); Type: FUNCTION; Schema: general; Owner: postgres
--

CREATE FUNCTION general.updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION general.updated_at() OWNER TO postgres;

--
-- Name: classify_grades(double precision); Type: AGGREGATE; Schema: faculty; Owner: postgres
--

CREATE AGGREGATE faculty.classify_grades(grade double precision) (
    SFUNC = faculty.classify_grade_state,
    STYPE = faculty.classify_grade_state,
    INITCOND = '(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)',
    FINALFUNC = faculty.classify_grade_final
);


ALTER AGGREGATE faculty.classify_grades(grade double precision) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: classes; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.classes (
    class_id integer NOT NULL,
    code faculty.class_code NOT NULL,
    class_session faculty.session NOT NULL,
    initial_date date NOT NULL,
    final_date date NOT NULL,
    year_semester character(5) NOT NULL,
    course_id integer NOT NULL,
    instructor_id integer NOT NULL,
    total_score real DEFAULT 0 NOT NULL,
    minimum_grade real DEFAULT 60 NOT NULL,
    total_lessons integer DEFAULT 0 NOT NULL,
    minimum_lessons integer DEFAULT 10 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT classes_check CHECK ((final_date > initial_date))
);


ALTER TABLE faculty.classes OWNER TO postgres;

--
-- Name: courses; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.courses (
    course_id integer NOT NULL,
    code faculty.course_code NOT NULL,
    name character varying(50) NOT NULL,
    syllabus public.hstore,
    department_id integer NOT NULL,
    course_load integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.courses OWNER TO postgres;

--
-- Name: grades; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.grades (
    grade_id integer NOT NULL,
    grade_value real NOT NULL,
    student_id integer NOT NULL,
    exam_id integer,
    activity_id integer,
    class_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT grades_grade_value_check CHECK ((grade_value >= (0)::double precision))
);


ALTER TABLE faculty.grades OWNER TO postgres;

--
-- Name: lessons; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.lessons (
    lesson_id integer NOT NULL,
    date date NOT NULL,
    initial_time time without time zone NOT NULL,
    final_time time without time zone NOT NULL,
    content_code character(5),
    description text,
    class_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT lessons_check CHECK ((final_time > initial_time))
);


ALTER TABLE faculty.lessons OWNER TO postgres;

--
-- Name: students; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.students (
    student_id integer NOT NULL,
    person_id integer NOT NULL,
    enrollment_code faculty.student_enrollment_code NOT NULL,
    degree_program_id integer NOT NULL,
    max_course_load integer DEFAULT 400 NOT NULL,
    current_course_load integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.students OWNER TO postgres;

--
-- Name: students_classes; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.students_classes (
    student_id integer NOT NULL,
    class_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.students_classes OWNER TO postgres;

--
-- Name: students_lessons; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.students_lessons (
    student_id integer NOT NULL,
    lesson_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.students_lessons OWNER TO postgres;

--
-- Name: people; Type: TABLE; Schema: general; Owner: postgres
--

CREATE TABLE general.people (
    person_id integer NOT NULL,
    entity_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(50) NOT NULL,
    birth_date date NOT NULL,
    document character varying(30) NOT NULL,
    details jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE general.people OWNER TO postgres;

--
-- Name: academic_transcripts; Type: MATERIALIZED VIEW; Schema: faculty; Owner: postgres
--

CREATE MATERIALIZED VIEW faculty.academic_transcripts AS
 WITH base AS (
         SELECT st.student_id,
            st.enrollment_code AS student_enrollment_code,
            pe.name AS student_name,
            cl.year_semester,
            co.course_id,
            co.code AS course_code,
            co.name AS course_name,
            cl.class_id,
            cl.code AS class_code,
            cl.total_score,
            cl.minimum_grade,
            sum(COALESCE(gr.grade_value, (0)::real)) AS student_grade,
            cl.total_lessons,
            cl.minimum_lessons
           FROM (((((faculty.students st
             JOIN general.people pe USING (person_id))
             JOIN faculty.students_classes sc USING (student_id))
             JOIN faculty.classes cl USING (class_id))
             JOIN faculty.courses co USING (course_id))
             LEFT JOIN faculty.grades gr USING (class_id, student_id))
          GROUP BY st.student_id, st.enrollment_code, pe.name, cl.year_semester, co.course_id, co.code, co.name, cl.class_id, cl.code, cl.total_score, cl.minimum_grade, cl.total_lessons, cl.minimum_lessons
        )
 SELECT base.student_id,
    base.student_enrollment_code,
    base.student_name,
    base.year_semester,
    base.course_id,
    base.course_code,
    base.course_name,
    base.class_id,
    base.class_code,
    base.total_score,
    base.minimum_grade,
    base.student_grade,
    round((avg(base.student_grade) OVER (PARTITION BY base.class_id))::numeric, 2) AS class_average_grade,
    base.total_lessons,
    base.minimum_lessons,
    count(sl.*) AS student_lessons,
        CASE
            WHEN ((base.student_grade >= base.minimum_grade) AND (count(sl.*) >= base.minimum_lessons)) THEN 'passed'::text
            ELSE 'failed'::text
        END AS final_status
   FROM ((base
     LEFT JOIN faculty.lessons le USING (class_id))
     LEFT JOIN faculty.students_lessons sl USING (student_id, lesson_id))
  GROUP BY base.student_id, base.student_enrollment_code, base.student_name, base.year_semester, base.course_id, base.course_code, base.course_name, base.class_id, base.class_code, base.total_score, base.minimum_grade, base.student_grade, base.total_lessons, base.minimum_lessons
  ORDER BY base.student_name, base.year_semester, base.course_name
  WITH NO DATA;


ALTER MATERIALIZED VIEW faculty.academic_transcripts OWNER TO postgres;

--
-- Name: activities; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.activities (
    activity_id integer NOT NULL,
    date date NOT NULL,
    initial_time time without time zone NOT NULL,
    final_time time without time zone NOT NULL,
    total_score real NOT NULL,
    class_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT activities_check CHECK ((final_time > initial_time)),
    CONSTRAINT activities_total_score_check CHECK ((total_score > (0)::double precision))
);


ALTER TABLE faculty.activities OWNER TO postgres;

--
-- Name: activities_activity_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.activities_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.activities_activity_id_seq OWNER TO postgres;

--
-- Name: activities_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.activities_activity_id_seq OWNED BY faculty.activities.activity_id;


--
-- Name: class_code_counters; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.class_code_counters (
    course_id integer NOT NULL,
    year_semester character(5) DEFAULT general.get_year_semester(CURRENT_DATE) NOT NULL,
    session faculty.session NOT NULL,
    course_code character(6) NOT NULL,
    counter integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT class_code_counters_counter_check CHECK (((counter >= 0) AND (counter <= 99)))
);


ALTER TABLE faculty.class_code_counters OWNER TO postgres;

--
-- Name: class_schedules; Type: VIEW; Schema: faculty; Owner: postgres
--

CREATE VIEW faculty.class_schedules AS
 SELECT co.course_id,
    co.code AS course_code,
    co.name AS course_name,
    cl.class_id,
    cl.code AS class_code,
    cl.initial_date AS class_initial_date,
    cl.final_date AS class_final_date,
    le.lesson_id,
    le.date AS lesson_date,
    le.initial_time AS lesson_initial_time,
    le.final_time AS lesson_final_time,
    COALESCE(co.syllabus[le.content_code], '-'::text) AS lesson_content,
    le.description AS lesson_description
   FROM ((faculty.lessons le
     JOIN faculty.classes cl USING (class_id))
     JOIN faculty.courses co USING (course_id))
  ORDER BY co.name, cl.initial_date, le.date, le.initial_time;


ALTER VIEW faculty.class_schedules OWNER TO postgres;

--
-- Name: classes_class_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.classes_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.classes_class_id_seq OWNER TO postgres;

--
-- Name: classes_class_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.classes_class_id_seq OWNED BY faculty.classes.class_id;


--
-- Name: course_code_counters; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.course_code_counters (
    department_id integer NOT NULL,
    department_code character(3) NOT NULL,
    counter integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT course_code_counters_counter_check CHECK (((counter >= 0) AND (counter <= 999)))
);


ALTER TABLE faculty.course_code_counters OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.courses_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.courses_course_id_seq OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.courses_course_id_seq OWNED BY faculty.courses.course_id;


--
-- Name: degree_programs; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.degree_programs (
    degree_program_id integer NOT NULL,
    code faculty.degree_program_code NOT NULL,
    name character varying(50) NOT NULL,
    curriculum xml,
    department_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.degree_programs OWNER TO postgres;

--
-- Name: degree_programs_courses; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.degree_programs_courses (
    degree_program_id integer NOT NULL,
    course_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.degree_programs_courses OWNER TO postgres;

--
-- Name: courses_of_degree_programs; Type: VIEW; Schema: faculty; Owner: postgres
--

CREATE VIEW faculty.courses_of_degree_programs AS
 SELECT d.degree_program_id,
    d.code AS degree_program_code,
    d.name AS degree_program_name,
    c.course_id,
    c.code AS course_code,
    c.name AS course_name
   FROM ((faculty.degree_programs d
     JOIN faculty.degree_programs_courses dc USING (degree_program_id))
     JOIN faculty.courses c USING (course_id))
  ORDER BY d.name, c.name;


ALTER VIEW faculty.courses_of_degree_programs OWNER TO postgres;

--
-- Name: curriculums; Type: VIEW; Schema: faculty; Owner: postgres
--

CREATE VIEW faculty.curriculums AS
 WITH stage3 AS (
         WITH stage2 AS (
                 WITH stage1 AS (
                         SELECT degree_programs.degree_program_id,
                            degree_programs.code AS degree_program_code,
                            degree_programs.name AS degree_program_name,
                            unnest(xpath('//curriculum/*'::text, degree_programs.curriculum)) AS curriculum
                           FROM faculty.degree_programs
                        )
                 SELECT stage1.degree_program_id,
                    stage1.degree_program_code,
                    stage1.degree_program_name,
                    stage1.curriculum,
                    SUBSTRING(((xpath('name(//*[1])'::text, stage1.curriculum))[1])::text FROM 8 FOR 2) AS period
                   FROM stage1
                )
         SELECT stage2.degree_program_id,
            stage2.degree_program_code,
            stage2.degree_program_name,
            stage2.period,
            unnest(xpath('//*/course'::text, stage2.curriculum)) AS curriculum
           FROM stage2
        )
 SELECT degree_program_id,
    degree_program_code,
    degree_program_name,
    period,
    ((xpath('/course/course_code/text()'::text, curriculum))[1])::text AS course_code,
    ((xpath('/course/course_name/text()'::text, curriculum))[1])::text AS course_name
   FROM stage3
  ORDER BY degree_program_name, period, ((xpath('/course/course_name/text()'::text, curriculum))[1])::text;


ALTER VIEW faculty.curriculums OWNER TO postgres;

--
-- Name: degree_programs_degree_program_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.degree_programs_degree_program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.degree_programs_degree_program_id_seq OWNER TO postgres;

--
-- Name: degree_programs_degree_program_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.degree_programs_degree_program_id_seq OWNED BY faculty.degree_programs.degree_program_id;


--
-- Name: departments; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.departments (
    department_id integer NOT NULL,
    code faculty.department_code NOT NULL,
    name character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.departments OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.departments_department_id_seq OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.departments_department_id_seq OWNED BY faculty.departments.department_id;


--
-- Name: exams; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.exams (
    exam_id integer NOT NULL,
    date date NOT NULL,
    initial_time time without time zone NOT NULL,
    final_time time without time zone NOT NULL,
    total_score real NOT NULL,
    class_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT exams_check CHECK ((final_time > initial_time)),
    CONSTRAINT exams_total_score_check CHECK ((total_score > (0)::double precision))
);


ALTER TABLE faculty.exams OWNER TO postgres;

--
-- Name: exams_exam_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.exams_exam_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.exams_exam_id_seq OWNER TO postgres;

--
-- Name: exams_exam_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.exams_exam_id_seq OWNED BY faculty.exams.exam_id;


--
-- Name: grade_intervals; Type: VIEW; Schema: faculty; Owner: postgres
--

CREATE VIEW faculty.grade_intervals AS
 WITH base AS (
         SELECT a.course_id,
            a.course_code,
            a.course_name,
            a.class_id,
            a.class_code,
            a.year_semester,
            faculty.classify_grades((a.student_grade)::double precision) AS classified_grades
           FROM faculty.academic_transcripts a
          GROUP BY a.course_id, a.course_code, a.course_name, a.class_id, a.class_code, a.year_semester
        )
 SELECT course_id,
    course_code,
    course_name,
    class_id,
    class_code,
    year_semester,
    (classified_grades).status_a_quantity AS status_a_quantity,
    (classified_grades).status_b_quantity AS status_b_quantity,
    (classified_grades).status_c_quantity AS status_c_quantity,
    (classified_grades).status_d_quantity AS status_d_quantity,
    (classified_grades).status_e_quantity AS status_e_quantity,
    (((classified_grades).status_a_percent * (100)::numeric) || '%'::text) AS status_a_percent,
    (((classified_grades).status_b_percent * (100)::numeric) || '%'::text) AS status_b_percent,
    (((classified_grades).status_c_percent * (100)::numeric) || '%'::text) AS status_c_percent,
    (((classified_grades).status_d_percent * (100)::numeric) || '%'::text) AS status_d_percent,
    (((classified_grades).status_e_percent * (100)::numeric) || '%'::text) AS status_e_percent
   FROM base
  ORDER BY course_name, class_id;


ALTER VIEW faculty.grade_intervals OWNER TO postgres;

--
-- Name: grades_grade_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.grades_grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.grades_grade_id_seq OWNER TO postgres;

--
-- Name: grades_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.grades_grade_id_seq OWNED BY faculty.grades.grade_id;


--
-- Name: instructor_enrollment_code_counters; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.instructor_enrollment_code_counters (
    department_id integer NOT NULL,
    department_code character(3) NOT NULL,
    counter integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT instructor_enrollment_code_counters_counter_check CHECK (((counter >= 0) AND (counter <= 999999)))
);


ALTER TABLE faculty.instructor_enrollment_code_counters OWNER TO postgres;

--
-- Name: instructors; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.instructors (
    instructor_id integer NOT NULL,
    person_id integer NOT NULL,
    enrollment_code faculty.instructor_enrollment_code NOT NULL,
    department_id integer NOT NULL,
    max_course_load integer DEFAULT 800 NOT NULL,
    current_course_load integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.instructors OWNER TO postgres;

--
-- Name: instructors_courses; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.instructors_courses (
    instructor_id integer NOT NULL,
    course_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.instructors_courses OWNER TO postgres;

--
-- Name: instructors_instructor_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.instructors_instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.instructors_instructor_id_seq OWNER TO postgres;

--
-- Name: instructors_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.instructors_instructor_id_seq OWNED BY faculty.instructors.instructor_id;


--
-- Name: lessons_lesson_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.lessons_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.lessons_lesson_id_seq OWNER TO postgres;

--
-- Name: lessons_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.lessons_lesson_id_seq OWNED BY faculty.lessons.lesson_id;


--
-- Name: material_requests; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.material_requests (
    material_id integer NOT NULL,
    lesson_id integer NOT NULL,
    instructor_id integer NOT NULL,
    quantity integer NOT NULL,
    date date NOT NULL,
    initial_time time without time zone NOT NULL,
    final_time time without time zone NOT NULL,
    return_timestamp timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.material_requests OWNER TO postgres;

--
-- Name: materials; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.materials (
    material_id integer NOT NULL,
    name character varying(30) NOT NULL,
    department_id integer,
    total_quantity integer NOT NULL,
    available_quantity integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.materials OWNER TO postgres;

--
-- Name: materials_material_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.materials_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.materials_material_id_seq OWNER TO postgres;

--
-- Name: materials_material_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.materials_material_id_seq OWNED BY faculty.materials.material_id;


--
-- Name: prerequisites; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.prerequisites (
    course_id integer NOT NULL,
    prerequisite_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE faculty.prerequisites OWNER TO postgres;

--
-- Name: student_enrollment_code_counters; Type: TABLE; Schema: faculty; Owner: postgres
--

CREATE TABLE faculty.student_enrollment_code_counters (
    degree_program_id integer NOT NULL,
    year_semester character(5) DEFAULT general.get_year_semester(CURRENT_DATE) NOT NULL,
    degree_program_code character(5) NOT NULL,
    counter integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT student_enrollment_code_counters_counter_check CHECK (((counter >= 0) AND (counter <= 999)))
);


ALTER TABLE faculty.student_enrollment_code_counters OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: faculty; Owner: postgres
--

CREATE SEQUENCE faculty.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE faculty.students_student_id_seq OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: faculty; Owner: postgres
--

ALTER SEQUENCE faculty.students_student_id_seq OWNED BY faculty.students.student_id;


--
-- Name: people_info; Type: VIEW; Schema: general; Owner: postgres
--

CREATE VIEW general.people_info AS
 SELECT person_id,
    name,
    birth_date,
    document,
    COALESCE((details ->> 'gender'::text), '-'::text) AS gender,
    COALESCE((details ->> 'race'::text), '-'::text) AS race,
    COALESCE((details ->> 'email'::text), '-'::text) AS email,
    COALESCE(general.format_telephone((TRIM(BOTH FROM ((details -> 'telephone'::text) ->> 'ddd'::text)))::character(2), (TRIM(BOTH FROM ((details -> 'telephone'::text) ->> 'number'::text)))::character(9)), '-'::bpchar) AS telephone,
    COALESCE(general.format_address(ROW(((details -> 'address'::text) ->> 'street'::text), (((details -> 'address'::text) ->> 'number'::text))::integer, ((details -> 'address'::text) ->> 'addressLine2'::text), ((details -> 'address'::text) ->> 'neighborhood'::text), ((details -> 'address'::text) ->> 'city'::text), ((details -> 'address'::text) ->> 'state'::text), ((details -> 'address'::text) ->> 'zipCode'::text), ((details -> 'address'::text) ->> 'country'::text))::general.format_address_input), '-'::text) AS address
   FROM general.people
  ORDER BY name
  WITH CASCADED CHECK OPTION;


ALTER VIEW general.people_info OWNER TO postgres;

--
-- Name: people_person_id_seq; Type: SEQUENCE; Schema: general; Owner: postgres
--

CREATE SEQUENCE general.people_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE general.people_person_id_seq OWNER TO postgres;

--
-- Name: people_person_id_seq; Type: SEQUENCE OWNED BY; Schema: general; Owner: postgres
--

ALTER SEQUENCE general.people_person_id_seq OWNED BY general.people.person_id;


--
-- Name: activities activity_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.activities ALTER COLUMN activity_id SET DEFAULT nextval('faculty.activities_activity_id_seq'::regclass);


--
-- Name: classes class_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.classes ALTER COLUMN class_id SET DEFAULT nextval('faculty.classes_class_id_seq'::regclass);


--
-- Name: courses course_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.courses ALTER COLUMN course_id SET DEFAULT nextval('faculty.courses_course_id_seq'::regclass);


--
-- Name: degree_programs degree_program_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.degree_programs ALTER COLUMN degree_program_id SET DEFAULT nextval('faculty.degree_programs_degree_program_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.departments ALTER COLUMN department_id SET DEFAULT nextval('faculty.departments_department_id_seq'::regclass);


--
-- Name: exams exam_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.exams ALTER COLUMN exam_id SET DEFAULT nextval('faculty.exams_exam_id_seq'::regclass);


--
-- Name: grades grade_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.grades ALTER COLUMN grade_id SET DEFAULT nextval('faculty.grades_grade_id_seq'::regclass);


--
-- Name: instructors instructor_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors ALTER COLUMN instructor_id SET DEFAULT nextval('faculty.instructors_instructor_id_seq'::regclass);


--
-- Name: lessons lesson_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.lessons ALTER COLUMN lesson_id SET DEFAULT nextval('faculty.lessons_lesson_id_seq'::regclass);


--
-- Name: materials material_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.materials ALTER COLUMN material_id SET DEFAULT nextval('faculty.materials_material_id_seq'::regclass);


--
-- Name: students student_id; Type: DEFAULT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students ALTER COLUMN student_id SET DEFAULT nextval('faculty.students_student_id_seq'::regclass);


--
-- Name: people person_id; Type: DEFAULT; Schema: general; Owner: postgres
--

ALTER TABLE ONLY general.people ALTER COLUMN person_id SET DEFAULT nextval('general.people_person_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.activities (activity_id, date, initial_time, final_time, total_score, class_id, created_at, updated_at) VALUES (1, '2024-10-15', '10:00:00', '12:00:00', 10, 1, '2024-10-01 01:40:21.503964+00', NULL);
INSERT INTO faculty.activities (activity_id, date, initial_time, final_time, total_score, class_id, created_at, updated_at) VALUES (2, '2024-10-30', '10:00:00', '12:00:00', 10, 1, '2024-10-01 01:40:21.515785+00', NULL);
INSERT INTO faculty.activities (activity_id, date, initial_time, final_time, total_score, class_id, created_at, updated_at) VALUES (3, '2024-09-30', '14:00:00', '16:00:00', 50, 4, '2024-10-02 23:40:58.772177+00', NULL);


--
-- Data for Name: class_code_counters; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (1, '20242', 'T', 'DCC001', 0, '2024-10-01 01:28:56.452112+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (1, '20242', 'N', 'DCC001', 0, '2024-10-01 01:28:56.452112+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (2, '20242', 'T', 'DCC002', 0, '2024-10-01 01:29:11.647472+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (2, '20242', 'N', 'DCC002', 0, '2024-10-01 01:29:11.647472+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (3, '20242', 'M', 'DCC003', 0, '2024-10-01 01:29:12.982119+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (3, '20242', 'N', 'DCC003', 0, '2024-10-01 01:29:12.982119+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (4, '20242', 'M', 'DCC004', 0, '2024-10-01 01:29:14.394366+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (4, '20242', 'T', 'DCC004', 0, '2024-10-01 01:29:14.394366+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (4, '20242', 'N', 'DCC004', 0, '2024-10-01 01:29:14.394366+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (5, '20242', 'M', 'DCC005', 0, '2024-10-01 01:29:15.642029+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (5, '20242', 'T', 'DCC005', 0, '2024-10-01 01:29:15.642029+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (5, '20242', 'N', 'DCC005', 0, '2024-10-01 01:29:15.642029+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (6, '20242', 'T', 'DAF001', 0, '2024-10-01 01:29:16.376918+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (6, '20242', 'N', 'DAF001', 0, '2024-10-01 01:29:16.376918+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (7, '20242', 'M', 'DAF002', 0, '2024-10-01 01:29:17.206166+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (7, '20242', 'T', 'DAF002', 0, '2024-10-01 01:29:17.206166+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (7, '20242', 'N', 'DAF002', 0, '2024-10-01 01:29:17.206166+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (8, '20242', 'M', 'DAF003', 0, '2024-10-01 01:29:17.936665+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (8, '20242', 'T', 'DAF003', 0, '2024-10-01 01:29:17.936665+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (8, '20242', 'N', 'DAF003', 0, '2024-10-01 01:29:17.936665+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (9, '20242', 'M', 'DAF004', 0, '2024-10-01 01:29:18.680405+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (9, '20242', 'T', 'DAF004', 0, '2024-10-01 01:29:18.680405+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (9, '20242', 'N', 'DAF004', 0, '2024-10-01 01:29:18.680405+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (1, '20242', 'M', 'DCC001', 1, '2024-10-01 01:28:56.452112+00', '2024-10-01 01:33:57.906451+00');
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (2, '20242', 'M', 'DCC002', 1, '2024-10-01 01:29:11.647472+00', '2024-10-01 01:34:35.748688+00');
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (3, '20242', 'T', 'DCC003', 1, '2024-10-01 01:29:12.982119+00', '2024-10-01 01:34:38.062342+00');
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (6, '20242', 'M', 'DAF001', 1, '2024-10-01 01:29:16.376918+00', '2024-10-01 01:35:00.864609+00');
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (1, '20251', 'M', 'DCC001', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (1, '20251', 'T', 'DCC001', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (1, '20251', 'N', 'DCC001', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (2, '20251', 'M', 'DCC002', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (2, '20251', 'T', 'DCC002', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (2, '20251', 'N', 'DCC002', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (3, '20251', 'M', 'DCC003', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (3, '20251', 'T', 'DCC003', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (3, '20251', 'N', 'DCC003', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (4, '20251', 'T', 'DCC004', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (4, '20251', 'N', 'DCC004', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (5, '20251', 'M', 'DCC005', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (5, '20251', 'T', 'DCC005', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (5, '20251', 'N', 'DCC005', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (6, '20251', 'M', 'DAF001', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (6, '20251', 'T', 'DAF001', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (6, '20251', 'N', 'DAF001', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (7, '20251', 'M', 'DAF002', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (7, '20251', 'T', 'DAF002', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (7, '20251', 'N', 'DAF002', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (8, '20251', 'T', 'DAF003', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (8, '20251', 'N', 'DAF003', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (9, '20251', 'M', 'DAF004', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (9, '20251', 'T', 'DAF004', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (9, '20251', 'N', 'DAF004', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (4, '20251', 'M', 'DCC004', 1, '2024-10-01 01:36:02.117064+00', '2024-10-01 01:36:32.931741+00');
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (8, '20251', 'M', 'DAF003', 1, '2024-10-01 01:36:02.117064+00', '2024-10-01 01:36:35.758646+00');
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (10, '20242', 'M', 'DAF005', 0, '2024-10-01 03:37:50.542135+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (10, '20242', 'T', 'DAF005', 0, '2024-10-01 03:37:50.542135+00', NULL);
INSERT INTO faculty.class_code_counters (course_id, year_semester, session, course_code, counter, created_at, updated_at) VALUES (10, '20242', 'N', 'DAF005', 0, '2024-10-01 03:37:50.542135+00', NULL);


--
-- Data for Name: classes; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.classes (class_id, code, class_session, initial_date, final_date, year_semester, course_id, instructor_id, total_score, minimum_grade, total_lessons, minimum_lessons, created_at, updated_at) VALUES (2, 'DCC00220242M01', 'M', '2024-07-01', '2024-12-15', '20242', 2, 1, 0, 60, 0, 10, '2024-10-01 01:34:35.748688+00', NULL);
INSERT INTO faculty.classes (class_id, code, class_session, initial_date, final_date, year_semester, course_id, instructor_id, total_score, minimum_grade, total_lessons, minimum_lessons, created_at, updated_at) VALUES (3, 'DCC00320242T01', 'T', '2024-07-01', '2024-12-15', '20242', 3, 1, 0, 60, 0, 10, '2024-10-01 01:34:38.062342+00', NULL);
INSERT INTO faculty.classes (class_id, code, class_session, initial_date, final_date, year_semester, course_id, instructor_id, total_score, minimum_grade, total_lessons, minimum_lessons, created_at, updated_at) VALUES (6, 'DCC00420251M01', 'M', '2025-02-01', '2025-06-01', '20251', 4, 1, 0, 60, 0, 10, '2024-10-01 01:36:32.931741+00', NULL);
INSERT INTO faculty.classes (class_id, code, class_session, initial_date, final_date, year_semester, course_id, instructor_id, total_score, minimum_grade, total_lessons, minimum_lessons, created_at, updated_at) VALUES (7, 'DAF00320251M01', 'M', '2025-02-01', '2025-06-01', '20251', 8, 2, 0, 60, 0, 10, '2024-10-01 01:36:35.758646+00', NULL);
INSERT INTO faculty.classes (class_id, code, class_session, initial_date, final_date, year_semester, course_id, instructor_id, total_score, minimum_grade, total_lessons, minimum_lessons, created_at, updated_at) VALUES (1, 'DCC00120242M01', 'M', '2024-07-01', '2024-12-15', '20242', 1, 1, 100, 60, 4, 2, '2024-10-01 01:33:57.906451+00', '2024-10-01 01:45:37.013997+00');
INSERT INTO faculty.classes (class_id, code, class_session, initial_date, final_date, year_semester, course_id, instructor_id, total_score, minimum_grade, total_lessons, minimum_lessons, created_at, updated_at) VALUES (4, 'DAF00120242M01', 'M', '2024-07-01', '2024-12-15', '20242', 6, 2, 100, 60, 1, 10, '2024-10-01 01:35:00.864609+00', '2024-10-02 23:40:58.772177+00');


--
-- Data for Name: course_code_counters; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.course_code_counters (department_id, department_code, counter, created_at, updated_at) VALUES (1, 'DCC', 5, '2024-10-01 01:25:02.706833+00', '2024-10-01 01:29:15.642029+00');
INSERT INTO faculty.course_code_counters (department_id, department_code, counter, created_at, updated_at) VALUES (2, 'DAF', 5, '2024-10-01 01:25:02.718699+00', '2024-10-01 03:37:50.542135+00');


--
-- Data for Name: courses; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (1, 'DCC001', 'algoritmos 1', '"ARV"=>"arvores", "BUS"=>"busca", "GRF"=>"grafos", "ORD"=>"ordenacao"', 1, 90, '2024-10-01 01:28:56.452112+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (2, 'DCC002', 'redes de computadores 1', NULL, 1, 90, '2024-10-01 01:29:11.647472+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (3, 'DCC003', 'arquitetura de computadores 1', NULL, 1, 90, '2024-10-01 01:29:12.982119+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (4, 'DCC004', 'arquitetura de computadores 2', NULL, 1, 90, '2024-10-01 01:29:14.394366+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (5, 'DCC005', 'gerencia de projetos de software', NULL, 1, 90, '2024-10-01 01:29:15.642029+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (6, 'DAF001', 'fundamentos de mecanica', NULL, 2, 90, '2024-10-01 01:29:16.376918+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (7, 'DAF002', 'fundamentos de eletromagnetismo', NULL, 2, 90, '2024-10-01 01:29:17.206166+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (8, 'DAF003', 'fisica quantica 1', NULL, 2, 90, '2024-10-01 01:29:17.936665+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (9, 'DAF004', 'fisica quantica 2', NULL, 2, 90, '2024-10-01 01:29:18.680405+00', NULL);
INSERT INTO faculty.courses (course_id, code, name, syllabus, department_id, course_load, created_at, updated_at) VALUES (10, 'DAF005', 'mecanica 1', NULL, 2, 90, '2024-10-01 03:37:50.542135+00', NULL);


--
-- Data for Name: degree_programs; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.degree_programs (degree_program_id, code, name, curriculum, department_id, created_at, updated_at) VALUES (3, 'FISBA', 'fisica bacharelado', NULL, 2, '2024-10-01 01:26:39.539451+00', NULL);
INSERT INTO faculty.degree_programs (degree_program_id, code, name, curriculum, department_id, created_at, updated_at) VALUES (4, 'FISLI', 'fisica licenciatura', NULL, 2, '2024-10-01 01:26:39.569631+00', NULL);
INSERT INTO faculty.degree_programs (degree_program_id, code, name, curriculum, department_id, created_at, updated_at) VALUES (2, 'CCOMP', 'ciencia da computacao', '<curriculum degree_program_code="CCOMP" degree_program_name="ciencia da computacao">
    <period_1>
        <course>
            <course_code>DCC001</course_code>
            <course_name>algoritmos 1</course_name>
        </course>

        <course>
            <course_code>DAF001</course_code>
            <course_name>fundamentos de mecanica</course_name>
        </course>
    </period_1>

    <period_2>
        <course>
            <course_code>DCC003</course_code>
            <course_name>arquitetura de computadores 1</course_name>
        </course>

        <course>
            <course_code>DAF002</course_code>
            <course_name>fundamentos de eletromagnetismo</course_name>
        </course>
    </period_2>
    
    <period_3>
        <course>
            <course_code>DCC002</course_code>
            <course_name>redes de computadores 1</course_name>
        </course>
    </period_3>
    
    <period_4>
        <course>
            <course_code>DCC004</course_code>
            <course_name>arquitetura de computadores 2</course_name>
        </course>
    </period_4>
</curriculum>
', 1, '2024-10-01 01:26:39.614865+00', NULL);
INSERT INTO faculty.degree_programs (degree_program_id, code, name, curriculum, department_id, created_at, updated_at) VALUES (1, 'EGSFT', 'eng software', '<curriculum degree_program_code="EGSFT" degree_program_name="eng software">
    <period_1>
        <course>
            <course_code>DCC001</course_code>
            <course_name>algoritmos 1</course_name>
        </course>
    </period_1>

    <period_2>
        <course>
            <course_code>DCC003</course_code>
            <course_name>arquitetura de computadores 1</course_name>
        </course>
    </period_2>
    
    <period_3>
        <course>
            <course_code>DCC002</course_code>
            <course_name>redes de computadores 1</course_name>
        </course>
    </period_3>
    
    <period_4>
        <course>
            <course_code>DCC005</course_code>
            <course_name>gerencia de projetos de software</course_name>
        </course>
    </period_4>
</curriculum>
', 1, '2024-10-01 01:26:39.635554+00', NULL);


--
-- Data for Name: degree_programs_courses; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (1, 1, '2024-10-01 01:30:57.371991+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (1, 3, '2024-10-01 01:30:57.380314+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (1, 2, '2024-10-01 01:30:57.386496+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (1, 5, '2024-10-01 01:30:57.390863+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (2, 1, '2024-10-01 01:30:57.394252+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (2, 2, '2024-10-01 01:30:57.397198+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (2, 3, '2024-10-01 01:30:57.399964+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (2, 4, '2024-10-01 01:30:57.402319+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (2, 6, '2024-10-01 01:30:57.404305+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (2, 7, '2024-10-01 01:30:57.406412+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (3, 6, '2024-10-01 01:30:57.408568+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (3, 7, '2024-10-01 01:30:57.4109+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (3, 8, '2024-10-01 01:30:57.413006+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (3, 9, '2024-10-01 01:30:57.415506+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (4, 6, '2024-10-01 01:30:57.418182+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (4, 7, '2024-10-01 01:30:57.420735+00', NULL);
INSERT INTO faculty.degree_programs_courses (degree_program_id, course_id, created_at, updated_at) VALUES (4, 8, '2024-10-01 01:30:57.424066+00', NULL);


--
-- Data for Name: departments; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.departments (department_id, code, name, created_at, updated_at) VALUES (1, 'DCC', 'depto ciencia computacao', '2024-10-01 01:25:02.706833+00', NULL);
INSERT INTO faculty.departments (department_id, code, name, created_at, updated_at) VALUES (2, 'DAF', 'depto de fisica', '2024-10-01 01:25:02.718699+00', NULL);


--
-- Data for Name: exams; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.exams (exam_id, date, initial_time, final_time, total_score, class_id, created_at, updated_at) VALUES (1, '2024-10-20', '10:00:00', '12:00:00', 40, 1, '2024-10-01 01:40:21.520265+00', NULL);
INSERT INTO faculty.exams (exam_id, date, initial_time, final_time, total_score, class_id, created_at, updated_at) VALUES (2, '2024-11-20', '10:00:00', '12:00:00', 40, 1, '2024-10-01 01:40:21.524887+00', NULL);
INSERT INTO faculty.exams (exam_id, date, initial_time, final_time, total_score, class_id, created_at, updated_at) VALUES (3, '2024-10-12', '14:00:00', '16:00:00', 50, 4, '2024-10-02 23:39:54.121926+00', NULL);


--
-- Data for Name: grades; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (1, 10, 1, NULL, 1, 1, '2024-10-01 01:40:21.527451+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (2, 10, 1, NULL, 2, 1, '2024-10-01 01:40:21.532656+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (3, 38, 1, 1, NULL, 1, '2024-10-01 01:40:21.535923+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (4, 37.5, 1, 2, NULL, 1, '2024-10-01 01:40:21.540746+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (5, 9, 3, NULL, 1, 1, '2024-10-02 03:50:30.327622+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (6, 9.5, 3, NULL, 2, 1, '2024-10-02 03:50:30.332348+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (7, 40, 3, 1, NULL, 1, '2024-10-02 03:50:30.335049+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (8, 35, 3, 2, NULL, 1, '2024-10-02 03:50:30.338984+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (9, 8, 4, NULL, 1, 1, '2024-10-02 03:51:05.958872+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (10, 7, 4, NULL, 2, 1, '2024-10-02 03:51:05.961887+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (11, 20, 4, 1, NULL, 1, '2024-10-02 03:51:05.965319+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (12, 24, 4, 2, NULL, 1, '2024-10-02 03:51:05.96802+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (13, 48, 1, 3, NULL, 4, '2024-10-02 23:40:19.526394+00', NULL);
INSERT INTO faculty.grades (grade_id, grade_value, student_id, exam_id, activity_id, class_id, created_at, updated_at) VALUES (14, 45, 1, NULL, 3, 4, '2024-10-02 23:41:20.580018+00', NULL);


--
-- Data for Name: instructor_enrollment_code_counters; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.instructor_enrollment_code_counters (department_id, department_code, counter, created_at, updated_at) VALUES (1, 'DCC', 1, '2024-10-01 01:25:02.706833+00', '2024-10-01 01:29:54.204686+00');
INSERT INTO faculty.instructor_enrollment_code_counters (department_id, department_code, counter, created_at, updated_at) VALUES (2, 'DAF', 1, '2024-10-01 01:25:02.718699+00', '2024-10-01 01:29:55.00639+00');


--
-- Data for Name: instructors; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.instructors (instructor_id, person_id, enrollment_code, department_id, max_course_load, current_course_load, active, created_at, updated_at) VALUES (1, 1, 'DCC000001', 1, 800, 360, true, '2024-10-01 01:29:54.204686+00', '2024-10-01 01:36:32.931741+00');
INSERT INTO faculty.instructors (instructor_id, person_id, enrollment_code, department_id, max_course_load, current_course_load, active, created_at, updated_at) VALUES (2, 2, 'DAF000001', 2, 800, 180, true, '2024-10-01 01:29:55.00639+00', '2024-10-01 01:36:35.758646+00');


--
-- Data for Name: instructors_courses; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (1, 1, '2024-10-01 01:30:21.602086+00', NULL);
INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (1, 2, '2024-10-01 01:30:21.612186+00', NULL);
INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (1, 3, '2024-10-01 01:30:21.621062+00', NULL);
INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (1, 4, '2024-10-01 01:30:21.625856+00', NULL);
INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (2, 6, '2024-10-01 01:30:21.629282+00', NULL);
INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (2, 7, '2024-10-01 01:30:21.632053+00', NULL);
INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (2, 8, '2024-10-01 01:30:21.634961+00', NULL);
INSERT INTO faculty.instructors_courses (instructor_id, course_id, created_at, updated_at) VALUES (2, 9, '2024-10-01 01:30:21.637656+00', NULL);


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.lessons (lesson_id, date, initial_time, final_time, content_code, description, class_id, created_at, updated_at) VALUES (1, '2024-09-01', '10:00:00', '12:00:00', 'ORD  ', NULL, 1, '2024-10-01 01:39:41.293035+00', NULL);
INSERT INTO faculty.lessons (lesson_id, date, initial_time, final_time, content_code, description, class_id, created_at, updated_at) VALUES (2, '2024-09-08', '10:00:00', '12:00:00', 'BUS  ', NULL, 1, '2024-10-01 01:39:41.308926+00', NULL);
INSERT INTO faculty.lessons (lesson_id, date, initial_time, final_time, content_code, description, class_id, created_at, updated_at) VALUES (3, '2024-09-15', '10:00:00', '12:00:00', 'ARV  ', NULL, 1, '2024-10-01 01:39:41.312941+00', NULL);
INSERT INTO faculty.lessons (lesson_id, date, initial_time, final_time, content_code, description, class_id, created_at, updated_at) VALUES (4, '2024-09-22', '10:00:00', '12:00:00', 'GRF  ', NULL, 1, '2024-10-01 01:39:41.316085+00', NULL);
INSERT INTO faculty.lessons (lesson_id, date, initial_time, final_time, content_code, description, class_id, created_at, updated_at) VALUES (5, '2024-09-10', '08:00:00', '10:00:00', NULL, NULL, 4, '2024-10-01 03:41:57.596617+00', NULL);


--
-- Data for Name: material_requests; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.material_requests (material_id, lesson_id, instructor_id, quantity, date, initial_time, final_time, return_timestamp, created_at, updated_at) VALUES (3, 5, 2, 1, '2024-09-10', '07:30:00', '10:30:00', NULL, '2024-10-02 03:01:54.051777+00', NULL);
INSERT INTO faculty.material_requests (material_id, lesson_id, instructor_id, quantity, date, initial_time, final_time, return_timestamp, created_at, updated_at) VALUES (1, 5, 2, 1, '2024-09-10', '07:30:00', '10:30:00', '2024-10-02 03:03:12.703305+00', '2024-10-02 03:02:17.217427+00', '2024-10-02 03:03:12.703305+00');


--
-- Data for Name: materials; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.materials (material_id, name, department_id, total_quantity, available_quantity, created_at, updated_at) VALUES (2, 'router', 1, 3, 3, '2024-10-02 02:56:08.304058+00', '2024-10-02 02:59:40.430471+00');
INSERT INTO faculty.materials (material_id, name, department_id, total_quantity, available_quantity, created_at, updated_at) VALUES (4, 'multimeter', 2, 2, 2, '2024-10-02 02:56:10.971679+00', '2024-10-02 02:59:40.434924+00');
INSERT INTO faculty.materials (material_id, name, department_id, total_quantity, available_quantity, created_at, updated_at) VALUES (5, 'multimeter', 1, 5, 5, '2024-10-02 02:56:11.879102+00', '2024-10-02 02:59:40.436546+00');
INSERT INTO faculty.materials (material_id, name, department_id, total_quantity, available_quantity, created_at, updated_at) VALUES (3, 'inclined plane', 2, 2, 1, '2024-10-02 02:56:08.943674+00', '2024-10-02 03:01:54.051777+00');
INSERT INTO faculty.materials (material_id, name, department_id, total_quantity, available_quantity, created_at, updated_at) VALUES (1, 'datashow', NULL, 10, 10, '2024-10-02 02:56:05.490259+00', '2024-10-02 03:03:12.703305+00');


--
-- Data for Name: prerequisites; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (3, 1, '2024-10-01 01:30:36.734086+00', NULL);
INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (2, 3, '2024-10-01 01:30:36.741682+00', NULL);
INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (4, 2, '2024-10-01 01:30:36.745991+00', NULL);
INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (4, 3, '2024-10-01 01:30:36.749095+00', NULL);
INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (5, 1, '2024-10-01 01:30:36.752342+00', NULL);
INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (7, 6, '2024-10-01 01:30:36.755209+00', NULL);
INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (8, 7, '2024-10-01 01:30:36.758038+00', NULL);
INSERT INTO faculty.prerequisites (course_id, prerequisite_id, created_at, updated_at) VALUES (9, 8, '2024-10-01 01:30:36.760542+00', NULL);


--
-- Data for Name: student_enrollment_code_counters; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (4, '20242', 'FISLI', 0, '2024-10-01 01:26:39.569631+00', NULL);
INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (1, '20242', 'EGSFT', 0, '2024-10-01 01:26:39.635554+00', NULL);
INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (3, '20242', 'FISBA', 1, '2024-10-01 01:26:39.539451+00', '2024-10-01 01:31:41.602265+00');
INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (3, '20251', 'FISBA', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (4, '20251', 'FISLI', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (2, '20251', 'CCOMP', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (1, '20251', 'EGSFT', 0, '2024-10-01 01:36:02.117064+00', NULL);
INSERT INTO faculty.student_enrollment_code_counters (degree_program_id, year_semester, degree_program_code, counter, created_at, updated_at) VALUES (2, '20242', 'CCOMP', 3, '2024-10-01 01:26:39.614865+00', '2024-10-02 03:47:28.848913+00');


--
-- Data for Name: students; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.students (student_id, person_id, enrollment_code, degree_program_id, max_course_load, current_course_load, active, created_at, updated_at) VALUES (2, 4, 'FISBA20242001', 3, 400, 0, true, '2024-10-01 01:31:41.602265+00', NULL);
INSERT INTO faculty.students (student_id, person_id, enrollment_code, degree_program_id, max_course_load, current_course_load, active, created_at, updated_at) VALUES (1, 3, 'CCOMP20242001', 2, 400, 180, true, '2024-10-01 01:31:39.612311+00', '2024-10-01 01:38:46.82657+00');
INSERT INTO faculty.students (student_id, person_id, enrollment_code, degree_program_id, max_course_load, current_course_load, active, created_at, updated_at) VALUES (3, 5, 'CCOMP20242002', 2, 400, 90, true, '2024-10-01 01:31:42.386875+00', '2024-10-02 03:48:58.346468+00');
INSERT INTO faculty.students (student_id, person_id, enrollment_code, degree_program_id, max_course_load, current_course_load, active, created_at, updated_at) VALUES (4, 6, 'CCOMP20242003', 2, 400, 90, true, '2024-10-02 03:47:28.848913+00', '2024-10-02 03:49:06.614219+00');


--
-- Data for Name: students_classes; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.students_classes (student_id, class_id, created_at, updated_at) VALUES (1, 1, '2024-10-01 01:38:43.151295+00', NULL);
INSERT INTO faculty.students_classes (student_id, class_id, created_at, updated_at) VALUES (1, 4, '2024-10-01 01:38:46.82657+00', NULL);
INSERT INTO faculty.students_classes (student_id, class_id, created_at, updated_at) VALUES (3, 1, '2024-10-02 03:48:58.346468+00', NULL);
INSERT INTO faculty.students_classes (student_id, class_id, created_at, updated_at) VALUES (4, 1, '2024-10-02 03:49:06.614219+00', NULL);


--
-- Data for Name: students_lessons; Type: TABLE DATA; Schema: faculty; Owner: postgres
--

INSERT INTO faculty.students_lessons (student_id, lesson_id, created_at, updated_at) VALUES (1, 3, '2024-10-01 01:39:56.063584+00', NULL);
INSERT INTO faculty.students_lessons (student_id, lesson_id, created_at, updated_at) VALUES (1, 4, '2024-10-01 01:39:56.070289+00', NULL);
INSERT INTO faculty.students_lessons (student_id, lesson_id, created_at, updated_at) VALUES (1, 1, '2024-10-01 01:39:56.073746+00', NULL);
INSERT INTO faculty.students_lessons (student_id, lesson_id, created_at, updated_at) VALUES (1, 2, '2024-10-01 01:39:56.076672+00', NULL);


--
-- Data for Name: people; Type: TABLE DATA; Schema: general; Owner: postgres
--

INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (2, 'ec860ea5-59e6-4d73-8561-b1511523728a', 'gilberto braga', '1965-02-02', 'MKALK69A31', NULL, '2024-10-01 01:24:23.767301+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (4, '980312e4-fec7-4e5d-8505-d514f2117d63', 'bruno costa', '2001-03-25', 'ALOKL65112', NULL, '2024-10-01 01:24:23.778183+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (5, '9a4107e5-4f70-40af-a668-4397069c8732', 'alice guimaraes', '2000-04-07', 'PRIAL61592', NULL, '2024-10-01 01:24:23.781325+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (1, '9ca38588-b273-47b7-b501-54061af974fc', 'gaspar otacilio', '1970-01-01', 'MKALKL3131', '{"race": "mixed", "email": "email@teste.com", "gender": "male", "address": {"city": "belo horizonte", "state": "MG", "number": 156, "street": "av amazonas", "country": "brasil", "zipCode": "12345750", "addressLine2": "", "neighborhood": "centro"}, "telephone": {"ddd": "31", "number": "912345678"}}', '2024-10-01 01:24:23.78497+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (3, '52af0024-90f4-434c-8409-3f9ba08ed0f1', 'joao silva', '1999-01-07', 'HHDKL65164', NULL, '2024-10-01 01:24:23.773898+00', '2024-10-01 01:47:39.253665+00');
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (6, '84e55c09-bc11-496a-b756-be5fbd03d871', 'otavio moreira', '1995-10-01', 'IAOLAA6974', NULL, '2024-10-02 03:47:01.843143+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (7, '5051a0f4-2d6c-4209-a02a-2db6ecdfb6f4', 'John Doe', '1990-01-15', '12345678901', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (8, 'e6ace9f2-2ded-4400-9023-7b0e649b3a8a', 'Jane Smith', '1985-02-20', '98765432102', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (9, '611482a3-eb19-49ad-9e7e-cc0d8405770d', 'Alice Johnson', '1992-03-10', '12345678902', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (10, '427c186a-9951-4b66-9b59-4485e1463a71', 'Bob Williams', '1995-04-18', '98765432103', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (11, 'cc98dd8e-860b-45be-9c42-69f7fcd9411c', 'Charlie Brown', '1993-05-21', '12345678903', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (12, '6307d909-b16f-4971-8158-b4c91912afeb', 'Diana Prince', '1989-06-11', '98765432104', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (13, '24b2ac67-346c-41a7-924f-f241298d1622', 'Eve Davis', '1994-07-25', '12345678904', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (14, 'a83beaf5-46e2-43cf-8817-475a2de37874', 'Frank Moore', '1996-08-14', '98765432105', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (15, '6423c3f4-9088-41ec-bdc4-3bf42913ae35', 'Grace King', '1987-09-30', '12345678905', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (16, 'c50066bc-4736-467c-a3cb-68c4411aff00', 'Hank Miller', '1991-10-04', '98765432106', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (17, '259fda64-1217-4d98-8428-3716a3c0b047', 'Ivy Adams', '1997-11-20', '12345678906', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (18, '80074253-fb74-45a8-8c28-bf55fd2b5971', 'Jack White', '1986-12-15', '98765432107', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (19, '20463819-1b13-4426-b77c-cf1bc02a958b', 'Kim Johnson', '1990-01-28', '12345678907', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (20, '5297885a-ddbc-4ee9-b257-c6d4442c8c36', 'Liam Green', '1995-02-14', '98765432108', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (21, 'cfc19c24-d48b-4ceb-8e51-6c35bacaf091', 'Mia Clark', '1992-03-05', '12345678908', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (22, 'af5db17a-b58f-4415-929c-9038026b745c', 'Noah Lewis', '1991-04-10', '98765432109', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (23, 'ed3eca1b-e8fe-4581-99dc-eec55bc2ecc5', 'Olivia Scott', '1989-05-29', '12345678909', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (24, 'b1dbf17e-e56e-4f0b-94ed-7bda3354f47f', 'Paul Harris', '1994-06-23', '98765432110', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (25, 'ae69a5ce-2e59-4db3-9510-4b2123971e41', 'Quinn Young', '1993-07-18', '12345678910', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (26, 'f7a52338-556e-46fc-9652-d0604970c3ce', 'Rachel Turner', '1990-08-07', '98765432111', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (27, 'a7ed5acf-8f5a-4a81-bfa5-518efc244fae', 'Sam Thompson', '1992-09-12', '12345678911', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (28, '8a58f858-057f-487b-b17a-98c136d6d008', 'Tina Baker', '1991-10-21', '98765432112', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (29, 'a8056c35-83e5-4d0e-9475-9ab116d5fde1', 'Uma Perez', '1990-11-30', '12345678912', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (30, '529b8978-6352-4056-8e12-5417dd2030a5', 'Victor Hill', '1993-12-03', '98765432113', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (31, 'a05ea355-7898-4d87-baac-97f21212bf9b', 'Wendy Allen', '1987-01-17', '12345678913', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (32, 'e44e40c5-a9ec-47d6-9a13-8a5bc5b84144', 'Xander Bell', '1992-02-24', '98765432114', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (33, '8d54885e-60c6-43db-83e0-80e54cb03ae0', 'Yara Mitchell', '1996-03-30', '12345678914', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (34, '537a80e2-546c-44db-a553-f4d535edc2eb', 'Zoe Ramirez', '1994-04-19', '98765432115', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (35, '7ffc0925-8e8b-4018-ac5c-a1e54e4f9ce7', 'Arthur Griffin', '1989-05-09', '12345678915', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (36, '324dee18-48e6-419a-a2fa-097d75bb0a59', 'Bella Stewart', '1990-06-12', '98765432116', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (37, '8a693cf5-ad04-4539-a809-c8ba5c12867d', 'Chris Rogers', '1991-07-25', '12345678916', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (38, '4c500361-1c1f-4860-9c57-d096ae342950', 'Dana Cooper', '1995-08-14', '98765432117', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (39, '7ddf3f84-e54f-457a-8366-518009252b39', 'Elliot Reed', '1993-09-03', '12345678917', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (40, '815fcfc3-f524-4920-bdc5-9d3121494b75', 'Fiona Collins', '1992-10-10', '98765432118', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (41, '11172f2a-0f66-43b4-9f53-f1ec0b2bbaf7', 'George Bryant', '1990-11-05', '12345678918', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (42, '4858870b-0d33-4bae-87fa-678d047af761', 'Holly Ward', '1988-12-20', '98765432119', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (43, '61382f5c-9fb9-40b8-9fdb-5a1fae2feff2', 'Ian Peterson', '1991-01-06', '12345678919', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (44, 'cdf35ab5-2677-4956-99fe-507799c9bfe1', 'Julia Bailey', '1993-02-13', '98765432120', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (45, '9fbaca3e-61f7-40c2-87f5-561295898e39', 'Kyle Carter', '1994-03-28', '12345678920', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (46, '34c92c2a-7cc6-4377-abf2-fbf07f6bb032', 'Lily Edwards', '1992-04-09', '98765432121', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (47, '4160b96f-c9d7-487a-8acc-fbfe2ba9bbfb', 'Michael Parker', '1989-05-16', '12345678921', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (48, 'fd2602f3-28bb-4c40-88a5-559a244d3515', 'Nina Morris', '1990-06-22', '98765432122', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (49, '07db0763-4a44-403a-8bb4-79feafa44155', 'Oscar Sanders', '1991-07-30', '12345678922', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (50, 'e0b1e2a0-e07c-4134-9b9e-d5f5cb09f463', 'Penny Roberts', '1993-08-05', '98765432123', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (51, 'fc99a15d-9fea-4663-b9a0-6f1298ab61f8', 'Quincy Ward', '1994-09-11', '12345678923', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (52, '02383bbd-6467-4618-ac16-392dce05af1d', 'Ruby Hughes', '1987-10-19', '98765432124', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (53, 'f9f81522-dee6-485b-9207-9088abf72775', 'Steve Brooks', '1995-11-25', '12345678924', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (54, '2721ddf9-9c5c-40c6-bb74-12ddd3a07c81', 'Tara Kelly', '1992-12-06', '98765432125', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (55, '64a2c904-dec0-4eb6-bb53-45b18a40ec8c', 'Ulysses Price', '1990-01-22', '12345678925', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (56, 'bec07566-b813-4388-a174-67494322088d', 'Violet Bennett', '1993-02-27', '98765432126', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (57, '2e6ea343-ec18-419e-a7d7-9bc088168e57', 'Will Johnston', '1994-03-15', '12345678926', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (58, '71df8a39-b65e-4cdd-a2b4-4c5a7b8fafe2', 'Xena Lawson', '1988-04-21', '98765432127', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (59, '0aab84b3-98d2-469e-b773-c3da650cf77c', 'Yvonne James', '1991-05-18', '12345678927', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (60, '8c5a48f6-728b-420b-9c52-27a2efa56ef6', 'Zack Martinez', '1995-06-25', '98765432128', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (61, '8050e651-de27-452a-b6a4-517318fc91b4', 'Aaron Barnes', '1992-07-31', '12345678928', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (62, '472b1946-a9ef-485d-b490-d5aee72b4db6', 'Brianna Fisher', '1993-08-26', '98765432129', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (63, 'ab2c84d6-292e-4d2a-bcbd-b3efb1656600', 'Carl Simmons', '1990-09-05', '12345678929', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (64, '536af423-eb66-44b2-bc0d-0917d2c51465', 'Daisy Jordan', '1994-10-13', '98765432130', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (65, 'ff659199-b59a-40e5-b32b-1df9b3d1ae10', 'Ethan Spencer', '1991-11-20', '12345678930', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (66, 'efb568b4-5aaf-4c5f-b524-6d7fa9879cc9', 'Faith Greene', '1988-12-18', '98765432131', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (67, 'b01235cc-c05b-4378-9b04-afa50f4f9787', 'Gavin Burns', '1993-01-15', '12345678931', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (68, '1d2e07b8-5b8f-4db3-b1e6-fc7d19c3fbfd', 'Haley Hunt', '1991-02-22', '98765432132', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (69, '251d0320-a2b1-4ab1-b83b-97a61153c355', 'Irene Murphy', '1995-03-11', '12345678932', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (70, '69c4089f-485c-4174-b97f-e727caaefd47', 'Jackson Sullivan', '1989-04-17', '98765432133', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (71, 'd1e53a6d-0259-4da9-b709-1019d1c564c2', 'Kelly West', '1992-05-29', '12345678933', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (72, 'a554b294-6b05-4b37-83c1-ba7a6ce6577b', 'Leo Powell', '1991-06-14', '98765432134', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (73, '476acc9f-0505-4341-a1ba-413367f60934', 'Megan Bryant', '1994-07-10', '12345678934', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (74, '29f32bc1-f5f6-452b-bd92-6a26e2aaf627', 'Nathan Cook', '1990-08-25', '98765432135', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (75, 'cab50e70-3390-41e1-8ecb-6decfe2d0cca', 'Olga Turner', '1989-09-11', '12345678935', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (76, '5b513bd2-dbf9-4616-8f92-12e0883769ae', 'Patrick Cox', '1995-10-22', '98765432136', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (77, 'd762742d-f923-49dc-b0f5-60cc1cf79ec8', 'Rebecca Adams', '1993-11-05', '12345678936', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (78, '353b34b8-799a-4b1f-ae13-796db0e2fb40', 'Sarah Foster', '1991-12-16', '98765432137', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (79, 'f33261d6-1fd9-4c21-972a-3f7510958e4f', 'Timothy Jenkins', '1987-01-09', '12345678937', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (80, '12829b11-1768-4b79-b445-b09db544d688', 'Ursula Campbell', '1992-02-18', '98765432138', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (81, 'd21ce850-ae07-439b-acb4-41659bbc7d47', 'Victor Simmons', '1994-03-03', '12345678938', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (82, 'cde5d18c-128b-4289-b38b-cbf5e0ca1f14', 'Wanda Greene', '1989-04-14', '98765432139', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (83, 'c4d64e72-8f6c-4f56-9862-323721ed680c', 'Xavier Allen', '1991-05-07', '12345678939', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (84, 'a4c9486e-405d-42f7-9bf9-be2c45879183', 'Yvette Powell', '1993-06-26', '98765432140', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (85, '024aa394-8e22-4ac8-bc00-94d95f90f2f4', 'Zane Mitchell', '1994-07-13', '12345678940', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (86, '2ca5f9d4-518e-4346-a227-d449152c00c2', 'Amber Perez', '1990-08-28', '98765432141', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (87, 'eb602985-a6b4-4041-8b12-9333efa1c0ec', 'Brandon Foster', '1991-09-23', '12345678941', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (88, 'd95586cd-204b-4175-891d-ef3e55d18677', 'Chloe White', '1992-10-17', '98765432142', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (89, '61eed273-6411-4d36-bbfb-b06f97e34468', 'Daniel Sanders', '1994-11-12', '12345678942', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (90, 'c81d3a0a-d2eb-46a1-b9e1-f993a6c02e9f', 'Erin Taylor', '1990-12-03', '98765432143', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (91, '5294db07-ec40-4b99-b33c-f8de3150722f', 'Francis Bailey', '1992-01-29', '12345678943', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (92, '977ceb1a-f064-4269-b318-6cb7f91bf2e5', 'Grace Barnes', '1991-02-19', '98765432144', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (93, '7277f869-d9b5-4938-8bd5-5b379b010a67', 'Harry Morris', '1995-03-21', '12345678944', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (94, '5900ff52-f404-45dd-9218-f86c0d6e303f', 'Isabella Cooper', '1993-04-15', '98765432145', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (95, '3c644340-dd53-4479-9fd4-0d825c7ce5f0', 'Jack Price', '1990-05-02', '12345678945', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (96, 'c6041d3e-5876-4fcc-aaf6-027e739fab48', 'Kimberly Evans', '1994-06-19', '98765432146', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (97, '27b25f65-d802-4e09-ba65-8ec1ae1dd959', 'Logan Thompson', '1991-07-30', '12345678946', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (98, '0fca6f67-65ad-44c8-b031-e9e50419c0ac', 'Maria Ramirez', '1995-08-21', '98765432147', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (99, '0ab84313-6e73-433a-984f-0b93e705d3da', 'Nathan Reed', '1989-09-16', '12345678947', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (100, 'f668a573-ca41-4569-8d90-5e2146e37255', 'Olivia Campbell', '1992-10-11', '98765432148', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (101, '14fb3b65-6346-4656-a1f6-053a52c5ceba', 'Paul Morris', '1993-11-19', '12345678948', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (102, '3054c5e6-988e-4caa-b08b-2fff2645a0d4', 'Quinn Carter', '1994-12-23', '12345678949', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (103, 'a129bd32-33bd-4118-bbdd-d41d4dcda94c', 'Riley Gray', '1991-01-31', '98765432150', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (104, '0f5f5ba7-6eac-47f0-8954-e450bd421d71', 'Sophia Howard', '1995-02-11', '12345678950', NULL, '2024-10-05 13:43:39.547613+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (105, 'f05a1260-3879-422f-a29f-9d2b78b85eac', 'Adrian Green', '1993-01-07', '22345678901', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (106, '22677a6a-80e2-4b9f-a6e1-a4449a22e3e6', 'Beatrice Hall', '1990-02-25', '98765432151', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (107, '09a26cef-498f-4c04-a538-0dc00db20fa9', 'Cameron Davis', '1995-03-14', '22345678902', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (108, 'df22cb73-1fd2-4633-98d3-8c9e30a6a101', 'Daphne Lewis', '1991-04-22', '98765432152', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (109, '40d14349-baaf-4dbe-9161-c0d0a7fc4413', 'Elijah Parker', '1994-05-30', '22345678903', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (110, '00cc2d01-60e8-4c9a-8242-b882bafa8194', 'Fiona Bell', '1989-06-18', '98765432153', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (111, '9880b3ec-8136-4c92-aea1-57abbd6e4141', 'Graham Edwards', '1990-07-04', '22345678904', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (112, 'e0f811f5-eb09-4423-9e76-3154e0e64b2d', 'Hannah Turner', '1992-08-27', '98765432154', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (113, 'a18168a4-3706-4923-828e-41edcc26390d', 'Ian Foster', '1993-09-09', '22345678905', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (114, '59d3d53e-055d-4eeb-a984-374f94765648', 'Jasmine White', '1995-10-12', '98765432155', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (115, 'c643e564-7c83-4323-984c-4def804b72e5', 'Kurt Walker', '1991-11-19', '22345678906', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (116, 'ea7b02f8-5464-4eb1-a82f-eaa132b68cf4', 'Lydia Brooks', '1994-12-25', '98765432156', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (117, '667b07c2-b137-4812-a8e1-aedb33293451', 'Mason Johnson', '1990-01-05', '22345678907', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (118, '7208e6ba-c68c-4f8f-8bdb-dc4701e1ff02', 'Natalie Morris', '1993-02-24', '98765432157', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (119, 'a8ffa26c-e4d9-46c3-97f7-31c5de8600da', 'Oscar Hughes', '1992-03-15', '22345678908', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (120, 'ae6a7f59-8d99-413b-a9df-49986be71e83', 'Peyton Clark', '1989-04-13', '98765432158', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (121, 'e6108eac-37bd-40ff-a077-0ecd7a98c6ae', 'Quinn Lee', '1991-05-23', '22345678909', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (122, '89720fb5-c3e8-4034-844b-4f54c51f8532', 'Ruby Adams', '1994-06-17', '98765432159', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (123, '7c7aa726-fd48-4c50-b328-5e454e54a24c', 'Sean Stewart', '1995-07-20', '22345678910', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (124, '7fe5e378-8045-407b-a9e9-cafcf7ef1cfa', 'Tina Sanders', '1993-08-29', '98765432160', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (125, '56fe14de-3cbc-4b8a-b51e-a5a07427c944', 'Umar Patel', '1990-09-11', '22345678911', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (126, 'd8f147a1-73db-4086-8a3a-1bfbc7f03f67', 'Vera Harris', '1992-10-08', '98765432161', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (127, '5fbff527-e8fa-4b6f-86c4-c7b7eef59718', 'Wesley Price', '1989-11-30', '22345678912', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (128, 'f7bd3c7b-cdc4-4eb9-a4e9-354dd575500a', 'Xena Griffin', '1994-12-27', '98765432162', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (129, 'e61cc67e-05c6-46d2-b880-f7af42cbf4ba', 'Yusuf Bennett', '1995-01-22', '22345678913', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (130, 'b3f5d502-03cd-44f9-83bd-5de1ffc937eb', 'Zara Mitchell', '1991-02-10', '98765432163', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (131, '25b88c2c-3f99-4f90-893b-cd16ac5b5d37', 'Alan Phillips', '1992-03-19', '22345678914', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (132, '1557f6b2-1b39-40d2-bc75-ea23e9dba1d6', 'Bella Reed', '1994-04-14', '98765432164', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (133, 'f1260e88-2632-4285-89c7-2341f6b0d13b', 'Charles Evans', '1989-05-24', '22345678915', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (134, '5080895a-468b-4745-aaf7-2361154642ff', 'Dana Fisher', '1990-06-12', '98765432165', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (135, '34dafbfc-4054-4ebd-bdb1-cc6e7f77c689', 'Edward Martinez', '1993-07-18', '22345678916', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (136, '405a0a69-ca49-4524-8daf-7b1efe96a7d6', 'Faye Allen', '1995-08-04', '98765432166', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (137, '153353a8-8438-412e-95a5-7e10097ec92c', 'George Perez', '1991-09-21', '22345678917', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (138, 'cf15b52c-f94a-4bd6-9304-30891ed0ed49', 'Hazel Carter', '1992-10-09', '98765432167', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (139, '6f67fbe6-12f2-4f44-834b-bed1c4cd9ba9', 'Ivan Murphy', '1990-11-03', '22345678918', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (140, '82cd8258-dc61-4118-a8e7-92397f9dc671', 'Jade Bailey', '1994-12-11', '98765432168', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (141, '23fdc746-dd7f-431a-9458-4ac2e67d6dc2', 'Kyle Rogers', '1995-01-30', '22345678919', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (142, '18259f13-0925-4330-9dfd-877374989688', 'Laura Coleman', '1993-02-16', '98765432169', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (143, 'd06a7f7f-0fe5-4cc2-bec1-cd6d58fbc4f9', 'Matthew Scott', '1991-03-08', '22345678920', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (144, 'b445e188-193c-44d3-a4d1-076a02eeb05f', 'Nina Moore', '1994-04-26', '98765432170', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (145, 'd09adba6-6732-4c11-bed0-f15e6a7f98bc', 'Oliver Hughes', '1992-05-14', '22345678921', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (146, '37d1c7ab-1ded-4f47-9d60-b232a7f2bef9', 'Paula Watson', '1995-06-20', '98765432171', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (147, '1d0558d4-e101-4e1a-82fc-c80f1e83ad2f', 'Quincy Brown', '1989-07-28', '22345678922', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (148, '739458e2-81c8-4f52-86b5-763d7e408294', 'Rosa Nelson', '1990-08-13', '98765432172', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (149, 'bb5ae62a-099b-472e-aaaf-0d076f99dc52', 'Simon Thompson', '1991-09-27', '22345678923', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (150, 'ac690c31-5540-4584-9436-0a5adfd96501', 'Tara King', '1994-10-18', '98765432173', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (151, '369ddc31-6044-4037-900c-375648515371', 'Ulysses Ward', '1992-11-08', '22345678924', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (152, '4e78ccdd-50d7-4d8e-ad4b-6956afc563e0', 'Victoria Bennett', '1995-12-23', '98765432174', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (153, '150797aa-22da-4331-a992-a03cff1e5b55', 'Warren Parker', '1989-01-16', '22345678925', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (154, '60e60da3-96b0-497b-8af5-21303dbe32ae', 'Xavier Green', '1990-02-12', '98765432175', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (155, '2ba09f31-9d60-4425-9066-89cbe57e0b7f', 'Yolanda James', '1991-03-25', '22345678926', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (156, '23603ef3-a64b-461d-b2c3-506f0ddc54a2', 'Zachary Lee', '1994-04-06', '98765432176', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (157, 'c6e99bb5-bfab-4f1e-8aec-605f3d952494', 'Alice Cooper', '1995-05-22', '22345678927', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (158, 'e5e8d1ea-4486-4298-b542-7f5ac562768c', 'Brandon White', '1992-06-29', '98765432177', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (159, '77b095dd-fc57-4226-8a12-be7b1a288f40', 'Catherine Johnson', '1989-07-07', '22345678928', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (160, '0fab7e84-477a-4ca6-abc4-5dd18c58591c', 'Derek Foster', '1990-08-23', '98765432178', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (161, '6e721bf5-705a-480e-9259-3835696b9e55', 'Elaine Miller', '1993-09-02', '22345678929', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (162, '4d40923e-82a6-47b4-a077-06a8dc395c18', 'Frank Bennett', '1995-10-25', '98765432179', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (163, '74c2a190-8fe7-43b8-af6b-5fda229fb968', 'Gina Collins', '1991-11-14', '22345678930', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (164, '07b6a49b-6a40-4995-91c4-de6aa1f39aa0', 'Henry Adams', '1992-12-30', '98765432180', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (165, 'c2796ccd-8a41-41ad-aee7-5c8c7977cc25', 'Isabelle Roberts', '1990-01-03', '22345678931', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (166, '43291dc2-b5d7-4430-9a46-f227955b50e2', 'Jason Harris', '1993-02-20', '98765432181', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (167, 'c8606822-7f8c-4f7f-a781-eb93e771b14a', 'Katie Evans', '1994-03-31', '22345678932', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (168, '0e72c18e-6d34-49ee-b35c-77ba6376af3a', 'Liam Martinez', '1995-04-11', '98765432182', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (169, '44210111-944a-46f7-bc41-80245fb65a3e', 'Molly Lee', '1991-05-05', '22345678933', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (170, '399fd2c8-e7c6-4197-b95c-b728cc22e8d1', 'Noah Baker', '1992-06-16', '98765432183', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (171, '718b8996-896f-4883-b068-8f6654323853', 'Olivia Carter', '1990-07-19', '22345678934', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (172, '346346dc-1de2-4042-8040-ba62fc347eb4', 'Peter Perez', '1993-08-22', '98765432184', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (173, '3d3e3648-573b-4f72-abb1-e591c36db6b7', 'Quinn Ward', '1994-09-09', '22345678935', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (174, '4835ee43-9e3d-4e65-b927-0f92a50af880', 'Rachel Stewart', '1991-10-16', '98765432185', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (175, '12e69098-25a1-441b-94b0-b394b62bf8d3', 'Sophie Collins', '1995-11-29', '22345678936', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (176, 'a312167b-3110-4e4e-b51e-81f422495766', 'Thomas Allen', '1992-12-05', '98765432186', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (177, 'bd0a2410-b08c-41e5-bbde-8c575ec547fc', 'Ursula Hughes', '1990-01-27', '22345678937', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (178, 'af8c7b18-6475-4b83-8399-172630c32b36', 'Vincent Cook', '1993-02-09', '98765432187', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (179, '79801b48-30c8-49ae-88b3-9f2c876a3e67', 'Willow Phillips', '1994-03-21', '22345678938', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (180, '3a594c94-2998-418e-80cd-72bc3f7474e0', 'Xander Watson', '1995-04-14', '98765432188', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (181, '75333586-96cc-4f0c-847c-841e1e60809f', 'Yasmin Reed', '1991-05-28', '22345678939', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (182, '01965181-2027-4b5f-bdca-766a326c37f9', 'Zane Edwards', '1992-06-13', '98765432189', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (183, '4a313fe2-fc0b-4497-ac26-1781086d7416', 'Amber Johnson', '1990-07-08', '22345678940', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (184, 'c54dfad4-180c-42a8-aea7-30c91afe7dc1', 'Bradley Hughes', '1993-08-24', '98765432190', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (185, '72836f6b-7da6-4a62-89eb-db8585aeb1b3', 'Clara Davis', '1995-09-05', '22345678941', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (186, '4203f4a0-948c-4984-ba53-4407aba2a5ff', 'David Martin', '1992-10-19', '98765432191', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (187, '27de478d-c516-4818-ae03-74be9dad9551', 'Emily Young', '1990-11-15', '22345678942', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (188, 'c883a4ea-9a90-466e-b783-de40c8e9af8e', 'Felix King', '1993-12-01', '98765432192', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (189, '9a646d23-ad67-4adc-b303-7c10d024d1c4', 'Gwen Nelson', '1995-01-07', '22345678943', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (190, '93e6c1b1-5595-40c1-9598-42885a081fb4', 'Harvey Roberts', '1992-02-18', '98765432193', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (191, 'dcd51985-be0b-4a17-9bd3-a210f32f113c', 'Ivy Morris', '1994-03-04', '22345678944', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (192, 'fb924ff9-1379-40e3-b0cd-4f9bf012a0cc', 'Jack Cooper', '1990-04-28', '98765432194', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (193, '1b1911ed-e585-44e9-92f6-82af8b0a679d', 'Karen Evans', '1993-05-16', '22345678945', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (194, '7643fb8a-e5fe-403b-abb6-f0878393c40a', 'Leo Martinez', '1995-06-21', '98765432195', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (195, 'ccc0723e-1c5f-47b9-b979-1a3516e5c0ed', 'Maya Carter', '1991-07-26', '22345678946', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (196, '15e24c78-06b1-4a6b-b300-7d77b9f38a5b', 'Nate Allen', '1992-08-11', '98765432196', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (197, '09a13200-4bd9-43de-b3c2-5e331056ea84', 'Oscar Watson', '1990-09-15', '22345678947', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (198, 'b079d1a5-4cbb-4066-aed6-85b85bd01c25', 'Penny Bennett', '1993-10-03', '98765432197', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (199, 'bc62e3aa-8619-447d-bd2c-e26a3bff86af', 'Quinn Rogers', '1995-11-18', '22345678948', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (200, '364a2ba8-83fa-4edc-bad6-74263b7afd2b', 'Rose Adams', '1992-12-29', '98765432198', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (201, 'bb4907ba-1808-4338-8ca9-c14b2a13218b', 'Sam Fisher', '1990-01-14', '22345678949', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (202, '5bb9a8ca-11e2-4712-9424-0b2b18283b35', 'Tina Lewis', '1993-02-22', '98765432199', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (203, '02a2e117-1979-4c24-a57f-b447c751d1e9', 'Umar Nelson', '1994-03-18', '22345678950', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (204, '5a0d5b8b-cc06-4239-a4c5-a0e657313a4b', 'Victoria Hill', '1995-04-26', '98765432200', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (205, '423691b9-ba6c-4f0c-ad3b-f9591fe1258b', 'William Baker', '1992-05-23', '22345678951', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (206, 'f6e74821-6774-4181-bfb8-dc57ca65c405', 'Xena Bailey', '1990-06-10', '98765432201', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (207, '996f106a-3613-40e6-b608-8ce896d4ba41', 'Yvonne Foster', '1993-07-12', '22345678952', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (208, '816217c6-ab6d-4c5c-a51d-028d547ece5c', 'Zack Turner', '1995-08-19', '98765432202', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (209, '36a82829-814d-4958-97c2-b291532f579f', 'Amelia Wright', '1991-09-20', '22345678953', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (210, '7350da8d-5b69-4f62-9ce2-10afa91aa514', 'Blake Howard', '1992-10-22', '98765432203', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (211, '3d5a2628-a3c7-44c2-92c7-24ca56beb779', 'Charlotte Brooks', '1990-11-27', '22345678954', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (212, 'a5311e82-0554-4f0a-a2d4-20c565373bb3', 'Daniel Murphy', '1993-12-17', '98765432204', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (213, 'ddc1a066-b7e2-4a22-a8ba-c82844c2b522', 'Emma Richardson', '1995-01-08', '22345678955', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (214, '07cc3c51-4844-4ff0-9c6f-ea0e2a5b8a74', 'Felix James', '1992-02-25', '98765432205', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (215, '03f520d3-aa8b-4bac-abe4-adfa1350a3bc', 'Grace Kelly', '1994-03-20', '22345678956', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (216, '758b10b3-6352-493b-9c9a-2a996ad56dd3', 'Hugo Ward', '1990-04-13', '98765432206', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (217, 'c31250be-9d54-4345-8c81-b4be81f11921', 'Isla Cox', '1993-05-27', '22345678957', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (218, 'f960733e-3e7f-4b59-ae3d-c098d5566e59', 'Jackie Sanders', '1995-06-22', '98765432207', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (219, 'cb41894d-f3ca-42dd-be83-840dc797cd6a', 'Kurt Parker', '1991-07-30', '22345678958', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (220, '6958666e-d6ad-4f2e-925c-ed81cb3915bc', 'Lana Johnson', '1992-08-24', '98765432208', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (221, 'f5c07eab-85e6-4311-b1ba-ab29782f6550', 'Mark White', '1990-09-06', '22345678959', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (222, '52a130bc-a3d0-4d41-81f1-5de788139993', 'Nina Hughes', '1993-10-27', '98765432209', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (223, 'd809d242-8e2a-4746-9b87-e1361a54cc8f', 'Oliver Brooks', '1995-11-15', '22345678960', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (224, 'a78062c8-de70-4b98-8b79-810dc562ca80', 'Paula Phillips', '1992-12-06', '98765432210', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (225, '7e94dc06-e23d-4cc8-8db2-8edb61e2cee0', 'Quinn Scott', '1990-01-16', '22345678961', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (226, '4c0c8564-6e52-4e59-a0c1-0610ddc2e485', 'Rachel Young', '1993-02-09', '98765432211', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (227, 'e771dd1e-7021-41c5-8a0a-688c7dfaba53', 'Steven Barnes', '1994-03-01', '22345678962', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (228, '45c8b256-44e9-4b7a-8b0f-50712c233e00', 'Tara Harris', '1995-04-30', '98765432212', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (229, '5e9ca87e-5970-4167-b6a9-fdff95ffeac8', 'Uma Thompson', '1991-05-17', '22345678963', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (230, '21386f86-8390-4bd2-81b7-430f68096e55', 'Vincent Carter', '1992-06-14', '98765432213', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (231, '52c94d65-8bb1-4c3f-87b4-647f151686ef', 'Wesley Davis', '1990-07-29', '22345678964', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (232, '9215df9f-d359-4836-8d0d-907b5f90f2bb', 'Xander Parker', '1993-08-05', '98765432214', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (233, '00c2ed57-485f-448f-b762-f177e90a9fb9', 'Yasmin Taylor', '1995-09-14', '22345678965', NULL, '2024-10-05 13:47:56.414981+00', NULL);
INSERT INTO general.people (person_id, entity_id, name, birth_date, document, details, created_at, updated_at) VALUES (234, '46823015-2f8f-4f82-80ed-c78c23187bc3', 'Zoe Martinez', '1992-10-20', '98765432215', NULL, '2024-10-05 13:47:56.414981+00', NULL);


--
-- Name: activities_activity_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.activities_activity_id_seq', 3, true);


--
-- Name: classes_class_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.classes_class_id_seq', 7, true);


--
-- Name: courses_course_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.courses_course_id_seq', 10, true);


--
-- Name: degree_programs_degree_program_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.degree_programs_degree_program_id_seq', 4, true);


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.departments_department_id_seq', 2, true);


--
-- Name: exams_exam_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.exams_exam_id_seq', 3, true);


--
-- Name: grades_grade_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.grades_grade_id_seq', 14, true);


--
-- Name: instructors_instructor_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.instructors_instructor_id_seq', 2, true);


--
-- Name: lessons_lesson_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.lessons_lesson_id_seq', 5, true);


--
-- Name: materials_material_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.materials_material_id_seq', 8, true);


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: faculty; Owner: postgres
--

SELECT pg_catalog.setval('faculty.students_student_id_seq', 4, true);


--
-- Name: people_person_id_seq; Type: SEQUENCE SET; Schema: general; Owner: postgres
--

SELECT pg_catalog.setval('general.people_person_id_seq', 234, true);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (activity_id);


--
-- Name: class_code_counters class_code_counters_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.class_code_counters
    ADD CONSTRAINT class_code_counters_pkey PRIMARY KEY (course_id, year_semester, session);


--
-- Name: classes classes_code_key; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.classes
    ADD CONSTRAINT classes_code_key UNIQUE (code);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (class_id);


--
-- Name: course_code_counters course_code_counters_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.course_code_counters
    ADD CONSTRAINT course_code_counters_pkey PRIMARY KEY (department_id);


--
-- Name: courses courses_code_key; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.courses
    ADD CONSTRAINT courses_code_key UNIQUE (code);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: degree_programs degree_programs_code_key; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.degree_programs
    ADD CONSTRAINT degree_programs_code_key UNIQUE (code);


--
-- Name: degree_programs_courses degree_programs_courses_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.degree_programs_courses
    ADD CONSTRAINT degree_programs_courses_pkey PRIMARY KEY (degree_program_id, course_id);


--
-- Name: degree_programs degree_programs_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.degree_programs
    ADD CONSTRAINT degree_programs_pkey PRIMARY KEY (degree_program_id);


--
-- Name: departments departments_code_key; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.departments
    ADD CONSTRAINT departments_code_key UNIQUE (code);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (exam_id);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (grade_id);


--
-- Name: instructor_enrollment_code_counters instructor_enrollment_code_counters_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructor_enrollment_code_counters
    ADD CONSTRAINT instructor_enrollment_code_counters_pkey PRIMARY KEY (department_id);


--
-- Name: instructors_courses instructors_courses_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors_courses
    ADD CONSTRAINT instructors_courses_pkey PRIMARY KEY (instructor_id, course_id);


--
-- Name: instructors instructors_enrollment_code_key; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors
    ADD CONSTRAINT instructors_enrollment_code_key UNIQUE (enrollment_code);


--
-- Name: instructors instructors_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors
    ADD CONSTRAINT instructors_pkey PRIMARY KEY (instructor_id);


--
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (lesson_id);


--
-- Name: material_requests material_requests_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.material_requests
    ADD CONSTRAINT material_requests_pkey PRIMARY KEY (material_id, lesson_id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (material_id);


--
-- Name: prerequisites prerequisites_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.prerequisites
    ADD CONSTRAINT prerequisites_pkey PRIMARY KEY (course_id, prerequisite_id);


--
-- Name: student_enrollment_code_counters student_enrollment_code_counters_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.student_enrollment_code_counters
    ADD CONSTRAINT student_enrollment_code_counters_pkey PRIMARY KEY (degree_program_id, year_semester);


--
-- Name: students_classes students_classes_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students_classes
    ADD CONSTRAINT students_classes_pkey PRIMARY KEY (student_id, class_id);


--
-- Name: students students_enrollment_code_key; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students
    ADD CONSTRAINT students_enrollment_code_key UNIQUE (enrollment_code);


--
-- Name: students_lessons students_lessons_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students_lessons
    ADD CONSTRAINT students_lessons_pkey PRIMARY KEY (student_id, lesson_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: people people_document_key; Type: CONSTRAINT; Schema: general; Owner: postgres
--

ALTER TABLE ONLY general.people
    ADD CONSTRAINT people_document_key UNIQUE (document);


--
-- Name: people people_entity_id_key; Type: CONSTRAINT; Schema: general; Owner: postgres
--

ALTER TABLE ONLY general.people
    ADD CONSTRAINT people_entity_id_key UNIQUE (entity_id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: general; Owner: postgres
--

ALTER TABLE ONLY general.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (person_id);


--
-- Name: academic_transcripts_class_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX academic_transcripts_class_id ON faculty.academic_transcripts USING btree (class_id);


--
-- Name: academic_transcripts_student_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX academic_transcripts_student_id ON faculty.academic_transcripts USING btree (student_id);


--
-- Name: activities_class_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX activities_class_id ON faculty.activities USING btree (class_id);


--
-- Name: activities_date_initial_time; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX activities_date_initial_time ON faculty.activities USING btree (date, initial_time);


--
-- Name: classes_course_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX classes_course_id ON faculty.classes USING btree (course_id);


--
-- Name: classes_initial_date; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX classes_initial_date ON faculty.classes USING btree (initial_date);


--
-- Name: classes_instructor_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX classes_instructor_id ON faculty.classes USING btree (instructor_id);


--
-- Name: courses_department_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX courses_department_id ON faculty.courses USING btree (department_id);


--
-- Name: courses_name; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX courses_name ON faculty.courses USING btree (name);


--
-- Name: degree_programs_department_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX degree_programs_department_id ON faculty.degree_programs USING btree (department_id);


--
-- Name: degree_programs_name; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX degree_programs_name ON faculty.degree_programs USING btree (name);


--
-- Name: departments_name; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX departments_name ON faculty.departments USING btree (name);


--
-- Name: exams_class_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX exams_class_id ON faculty.exams USING btree (class_id);


--
-- Name: exams_date_initial_time; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX exams_date_initial_time ON faculty.exams USING btree (date, initial_time);


--
-- Name: grades_activity_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX grades_activity_id ON faculty.grades USING btree (activity_id);


--
-- Name: grades_class_id_student_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX grades_class_id_student_id ON faculty.grades USING btree (class_id, student_id);


--
-- Name: grades_exam_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX grades_exam_id ON faculty.grades USING btree (exam_id);


--
-- Name: instructors_department_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX instructors_department_id ON faculty.instructors USING btree (department_id);


--
-- Name: instructors_person_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX instructors_person_id ON faculty.instructors USING btree (person_id);


--
-- Name: lessons_class_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX lessons_class_id ON faculty.lessons USING btree (class_id);


--
-- Name: lessons_date_initial_time; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX lessons_date_initial_time ON faculty.lessons USING btree (date, initial_time);


--
-- Name: material_requests_instructor_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX material_requests_instructor_id ON faculty.material_requests USING btree (instructor_id);


--
-- Name: materials_department_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX materials_department_id ON faculty.materials USING btree (department_id);


--
-- Name: student_enrollment_code_counters_degree_program_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX student_enrollment_code_counters_degree_program_id ON faculty.student_enrollment_code_counters USING btree (degree_program_id);


--
-- Name: students_degree_program_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX students_degree_program_id ON faculty.students USING btree (degree_program_id);


--
-- Name: students_person_id; Type: INDEX; Schema: faculty; Owner: postgres
--

CREATE INDEX students_person_id ON faculty.students USING btree (person_id);


--
-- Name: people_name; Type: INDEX; Schema: general; Owner: postgres
--

CREATE INDEX people_name ON general.people USING gist (name public.gist_trgm_ops);


--
-- Name: courses create_class_code_counter; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER create_class_code_counter AFTER INSERT ON faculty.courses FOR EACH ROW EXECUTE FUNCTION faculty.create_class_code_counter();


--
-- Name: departments create_course_code_counter; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER create_course_code_counter AFTER INSERT ON faculty.departments FOR EACH ROW EXECUTE FUNCTION faculty.create_course_code_counter();


--
-- Name: departments create_instructor_enrollment_code_counter; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER create_instructor_enrollment_code_counter AFTER INSERT ON faculty.departments FOR EACH ROW EXECUTE FUNCTION faculty.create_instructor_enrollment_code_counter();


--
-- Name: degree_programs create_student_enrollment_code_counter; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER create_student_enrollment_code_counter AFTER INSERT ON faculty.degree_programs FOR EACH ROW EXECUTE FUNCTION faculty.create_student_enrollment_code_counter();


--
-- Name: activities created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.activities FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: class_code_counters created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.class_code_counters FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: classes created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.classes FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: course_code_counters created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.course_code_counters FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: courses created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.courses FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: degree_programs created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.degree_programs FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: degree_programs_courses created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.degree_programs_courses FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: departments created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.departments FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: exams created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.exams FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: grades created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.grades FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: instructor_enrollment_code_counters created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.instructor_enrollment_code_counters FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: instructors created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.instructors FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: instructors_courses created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.instructors_courses FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: lessons created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.lessons FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: material_requests created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.material_requests FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: materials created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.materials FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: prerequisites created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.prerequisites FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: student_enrollment_code_counters created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.student_enrollment_code_counters FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: students created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.students FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: students_classes created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.students_classes FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: students_lessons created_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON faculty.students_lessons FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: classes generate_class_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER generate_class_code BEFORE INSERT ON faculty.classes FOR EACH ROW EXECUTE FUNCTION faculty.generate_class_code();


--
-- Name: courses generate_course_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER generate_course_code BEFORE INSERT ON faculty.courses FOR EACH ROW EXECUTE FUNCTION faculty.generate_course_code();


--
-- Name: instructors generate_instructor_enrollment_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER generate_instructor_enrollment_code BEFORE INSERT ON faculty.instructors FOR EACH ROW EXECUTE FUNCTION faculty.generate_instructor_enrollment_code();


--
-- Name: students generate_student_enrollment_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER generate_student_enrollment_code BEFORE INSERT ON faculty.students FOR EACH ROW EXECUTE FUNCTION faculty.generate_student_enrollment_code();


--
-- Name: lessons increment_lessons_in_class; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER increment_lessons_in_class AFTER INSERT ON faculty.lessons FOR EACH ROW EXECUTE FUNCTION faculty.increment_lessons_in_class();


--
-- Name: activities increment_score_in_class; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER increment_score_in_class AFTER INSERT ON faculty.activities FOR EACH ROW EXECUTE FUNCTION faculty.increment_score_in_class();


--
-- Name: exams increment_score_in_class; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER increment_score_in_class AFTER INSERT ON faculty.exams FOR EACH ROW EXECUTE FUNCTION faculty.increment_score_in_class();


--
-- Name: materials set_available_quantity; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_available_quantity BEFORE INSERT ON faculty.materials FOR EACH ROW EXECUTE FUNCTION faculty.set_available_quantity();


--
-- Name: grades set_class_id; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_class_id BEFORE INSERT ON faculty.grades FOR EACH ROW EXECUTE FUNCTION faculty.set_class_id();


--
-- Name: class_code_counters set_course_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_course_code BEFORE INSERT ON faculty.class_code_counters FOR EACH ROW EXECUTE FUNCTION faculty.set_course_code();


--
-- Name: student_enrollment_code_counters set_degree_program_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_degree_program_code BEFORE INSERT ON faculty.student_enrollment_code_counters FOR EACH ROW EXECUTE FUNCTION faculty.set_degree_program_code();


--
-- Name: course_code_counters set_department_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_department_code BEFORE INSERT ON faculty.course_code_counters FOR EACH ROW EXECUTE FUNCTION faculty.set_department_code();


--
-- Name: instructor_enrollment_code_counters set_department_code; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_department_code BEFORE INSERT ON faculty.instructor_enrollment_code_counters FOR EACH ROW EXECUTE FUNCTION faculty.set_department_code();


--
-- Name: material_requests set_fields; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_fields BEFORE INSERT ON faculty.material_requests FOR EACH ROW EXECUTE FUNCTION faculty.set_material_request_fields();


--
-- Name: classes set_year_semester; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER set_year_semester BEFORE INSERT ON faculty.classes FOR EACH ROW EXECUTE FUNCTION faculty.set_year_semester();


--
-- Name: activities updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.activities FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: class_code_counters updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.class_code_counters FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: classes updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.classes FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: course_code_counters updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.course_code_counters FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: courses updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.courses FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: degree_programs updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.degree_programs FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: degree_programs_courses updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.degree_programs_courses FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: departments updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.departments FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: exams updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.exams FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: grades updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.grades FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: instructor_enrollment_code_counters updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.instructor_enrollment_code_counters FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: instructors updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.instructors FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: instructors_courses updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.instructors_courses FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: lessons updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.lessons FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: material_requests updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.material_requests FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: materials updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.materials FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: prerequisites updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.prerequisites FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: student_enrollment_code_counters updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.student_enrollment_code_counters FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: students updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.students FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: students_classes updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.students_classes FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: students_lessons updated_at; Type: TRIGGER; Schema: faculty; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON faculty.students_lessons FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: people created_at; Type: TRIGGER; Schema: general; Owner: postgres
--

CREATE TRIGGER created_at BEFORE INSERT ON general.people FOR EACH ROW EXECUTE FUNCTION general.created_at();


--
-- Name: people updated_at; Type: TRIGGER; Schema: general; Owner: postgres
--

CREATE TRIGGER updated_at BEFORE UPDATE ON general.people FOR EACH ROW EXECUTE FUNCTION general.updated_at();


--
-- Name: activities activities_class_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.activities
    ADD CONSTRAINT activities_class_id_fkey FOREIGN KEY (class_id) REFERENCES faculty.classes(class_id);


--
-- Name: class_code_counters class_code_counters_course_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.class_code_counters
    ADD CONSTRAINT class_code_counters_course_id_fkey FOREIGN KEY (course_id) REFERENCES faculty.courses(course_id);


--
-- Name: classes classes_course_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.classes
    ADD CONSTRAINT classes_course_id_fkey FOREIGN KEY (course_id) REFERENCES faculty.courses(course_id);


--
-- Name: classes classes_instructor_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.classes
    ADD CONSTRAINT classes_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES faculty.instructors(instructor_id);


--
-- Name: course_code_counters course_code_counters_department_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.course_code_counters
    ADD CONSTRAINT course_code_counters_department_id_fkey FOREIGN KEY (department_id) REFERENCES faculty.departments(department_id);


--
-- Name: courses courses_department_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.courses
    ADD CONSTRAINT courses_department_id_fkey FOREIGN KEY (department_id) REFERENCES faculty.departments(department_id);


--
-- Name: degree_programs_courses degree_programs_courses_course_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.degree_programs_courses
    ADD CONSTRAINT degree_programs_courses_course_id_fkey FOREIGN KEY (course_id) REFERENCES faculty.courses(course_id);


--
-- Name: degree_programs_courses degree_programs_courses_degree_program_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.degree_programs_courses
    ADD CONSTRAINT degree_programs_courses_degree_program_id_fkey FOREIGN KEY (degree_program_id) REFERENCES faculty.degree_programs(degree_program_id);


--
-- Name: degree_programs degree_programs_department_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.degree_programs
    ADD CONSTRAINT degree_programs_department_id_fkey FOREIGN KEY (department_id) REFERENCES faculty.departments(department_id);


--
-- Name: exams exams_class_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.exams
    ADD CONSTRAINT exams_class_id_fkey FOREIGN KEY (class_id) REFERENCES faculty.classes(class_id);


--
-- Name: grades grades_activity_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.grades
    ADD CONSTRAINT grades_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES faculty.activities(activity_id);


--
-- Name: grades grades_class_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.grades
    ADD CONSTRAINT grades_class_id_fkey FOREIGN KEY (class_id) REFERENCES faculty.classes(class_id);


--
-- Name: grades grades_exam_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.grades
    ADD CONSTRAINT grades_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES faculty.exams(exam_id);


--
-- Name: grades grades_student_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.grades
    ADD CONSTRAINT grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES faculty.students(student_id);


--
-- Name: instructor_enrollment_code_counters instructor_enrollment_code_counters_department_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructor_enrollment_code_counters
    ADD CONSTRAINT instructor_enrollment_code_counters_department_id_fkey FOREIGN KEY (department_id) REFERENCES faculty.departments(department_id);


--
-- Name: instructors_courses instructors_courses_course_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors_courses
    ADD CONSTRAINT instructors_courses_course_id_fkey FOREIGN KEY (course_id) REFERENCES faculty.courses(course_id);


--
-- Name: instructors_courses instructors_courses_instructor_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors_courses
    ADD CONSTRAINT instructors_courses_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES faculty.instructors(instructor_id);


--
-- Name: instructors instructors_department_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors
    ADD CONSTRAINT instructors_department_id_fkey FOREIGN KEY (department_id) REFERENCES faculty.departments(department_id);


--
-- Name: instructors instructors_person_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.instructors
    ADD CONSTRAINT instructors_person_id_fkey FOREIGN KEY (person_id) REFERENCES general.people(person_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: lessons lessons_class_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.lessons
    ADD CONSTRAINT lessons_class_id_fkey FOREIGN KEY (class_id) REFERENCES faculty.classes(class_id);


--
-- Name: material_requests material_requests_instructor_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.material_requests
    ADD CONSTRAINT material_requests_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES faculty.instructors(instructor_id);


--
-- Name: material_requests material_requests_lesson_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.material_requests
    ADD CONSTRAINT material_requests_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES faculty.lessons(lesson_id);


--
-- Name: material_requests material_requests_material_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.material_requests
    ADD CONSTRAINT material_requests_material_id_fkey FOREIGN KEY (material_id) REFERENCES faculty.materials(material_id);


--
-- Name: materials materials_department_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.materials
    ADD CONSTRAINT materials_department_id_fkey FOREIGN KEY (department_id) REFERENCES faculty.departments(department_id);


--
-- Name: prerequisites prerequisites_course_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.prerequisites
    ADD CONSTRAINT prerequisites_course_id_fkey FOREIGN KEY (course_id) REFERENCES faculty.courses(course_id);


--
-- Name: prerequisites prerequisites_prerequisite_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.prerequisites
    ADD CONSTRAINT prerequisites_prerequisite_id_fkey FOREIGN KEY (prerequisite_id) REFERENCES faculty.courses(course_id);


--
-- Name: student_enrollment_code_counters student_enrollment_code_counters_degree_program_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.student_enrollment_code_counters
    ADD CONSTRAINT student_enrollment_code_counters_degree_program_id_fkey FOREIGN KEY (degree_program_id) REFERENCES faculty.degree_programs(degree_program_id);


--
-- Name: students_classes students_classes_class_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students_classes
    ADD CONSTRAINT students_classes_class_id_fkey FOREIGN KEY (class_id) REFERENCES faculty.classes(class_id);


--
-- Name: students_classes students_classes_student_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students_classes
    ADD CONSTRAINT students_classes_student_id_fkey FOREIGN KEY (student_id) REFERENCES faculty.students(student_id);


--
-- Name: students students_degree_program_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students
    ADD CONSTRAINT students_degree_program_id_fkey FOREIGN KEY (degree_program_id) REFERENCES faculty.degree_programs(degree_program_id);


--
-- Name: students_lessons students_lessons_lesson_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students_lessons
    ADD CONSTRAINT students_lessons_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES faculty.lessons(lesson_id);


--
-- Name: students_lessons students_lessons_student_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students_lessons
    ADD CONSTRAINT students_lessons_student_id_fkey FOREIGN KEY (student_id) REFERENCES faculty.students(student_id);


--
-- Name: students students_person_id_fkey; Type: FK CONSTRAINT; Schema: faculty; Owner: postgres
--

ALTER TABLE ONLY faculty.students
    ADD CONSTRAINT students_person_id_fkey FOREIGN KEY (person_id) REFERENCES general.people(person_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA faculty; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA faculty TO courses_app;


--
-- Name: SCHEMA general; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA general TO g_register_people_app;


--
-- Name: TABLE courses; Type: ACL; Schema: faculty; Owner: postgres
--

GRANT SELECT ON TABLE faculty.courses TO courses_app;


--
-- Name: TABLE people; Type: ACL; Schema: general; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE general.people TO g_register_people_app;


--
-- Name: TABLE departments; Type: ACL; Schema: faculty; Owner: postgres
--

GRANT SELECT ON TABLE faculty.departments TO courses_app;


--
-- Name: SEQUENCE people_person_id_seq; Type: ACL; Schema: general; Owner: postgres
--

GRANT USAGE ON SEQUENCE general.people_person_id_seq TO g_register_people_app;


--
-- Name: academic_transcripts; Type: MATERIALIZED VIEW DATA; Schema: faculty; Owner: postgres
--

REFRESH MATERIALIZED VIEW faculty.academic_transcripts;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;


--
-- Data for Name: job; Type: TABLE DATA; Schema: cron; Owner: postgres
--

INSERT INTO cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) VALUES (1, '0 1 1 1 *', 'CALL faculty.create_new_counters();', 'localhost', 5432, 'postgres', 'postgres', true, 'create_new_counters_1st_semester');
INSERT INTO cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) VALUES (2, '0 1 1 7 *', 'CALL faculty.create_new_counters();', 'localhost', 5432, 'postgres', 'postgres', true, 'create_new_counters_2nd_semester');
INSERT INTO cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) VALUES (3, '0 1 29 6 *', 'REFRESH MATERIALIZED VIEW faculty.academic_transcripts;', 'localhost', 5432, 'postgres', 'postgres', true, 'calculate_academic_transcripts_1st_semester');
INSERT INTO cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) VALUES (4, '0 1 20 12 *', 'REFRESH MATERIALIZED VIEW faculty.academic_transcripts;', 'localhost', 5432, 'postgres', 'postgres', true, 'calculate_academic_transcripts_2nd_semester');


--
-- Data for Name: job_run_details; Type: TABLE DATA; Schema: cron; Owner: postgres
--



--
-- Name: jobid_seq; Type: SEQUENCE SET; Schema: cron; Owner: postgres
--

SELECT pg_catalog.setval('cron.jobid_seq', 4, true);


--
-- Name: runid_seq; Type: SEQUENCE SET; Schema: cron; Owner: postgres
--

SELECT pg_catalog.setval('cron.runid_seq', 1, false);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

