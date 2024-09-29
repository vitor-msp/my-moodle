-- general
CREATE OR REPLACE FUNCTION general.created_at()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.created_at := CURRENT_TIMESTAMP;
    NEW.updated_at := NULL;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION general.updated_at()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION general.get_year_semester(input_date date)
    RETURNS char (
        5)
    LANGUAGE plpgsql
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

CREATE OR REPLACE FUNCTION general.class_is_in_progress(class_year_semester char(5))
    RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_year_semester char(5);
BEGIN
    current_year_semester := general.get_year_semester(CURRENT_DATE);
    RETURN class_year_semester = current_year_semester;
END;
$$;

CREATE OR REPLACE FUNCTION general.format_telephone(ddd char(2), number char(9))
    RETURNS char (
        15)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN '(' || ddd || ') ' || substring(number FROM 1 FOR 5) || '-' || substring(number FROM 6 FOR 4);
END;
$$;

CREATE OR REPLACE FUNCTION general.format_address(address_input general.format_address_input)
    RETURNS text
    LANGUAGE plpgsql
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

-- departments
CREATE OR REPLACE FUNCTION faculty.create_course_code_counter()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.course_code_counters(department_id)
        VALUES(NEW.department_id);
    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION faculty.create_instructor_enrollment_code_counter()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.instructor_enrollment_code_counters(department_id)
        VALUES(NEW.department_id);
    RETURN NULL;
END;
$$;

-- degree_programs
CREATE OR REPLACE FUNCTION faculty.create_student_enrollment_code_counter()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.student_enrollment_code_counters(degree_program_id)
        VALUES(NEW.degree_program_id);
    RETURN NULL;
END;
$$;

-- courses
CREATE OR REPLACE FUNCTION faculty.create_class_code_counter()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO faculty.class_code_counters(course_id, course_code, session)
        VALUES(NEW.course_id, 'M'),
(NEW.course_id, 'T'),
(NEW.course_id, 'N');
    RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION faculty.generate_course_code()
    RETURNS TRIGGER
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

-- instructors
CREATE OR REPLACE FUNCTION faculty.generate_instructor_enrollment_code()
    RETURNS TRIGGER
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

-- students
CREATE OR REPLACE FUNCTION faculty.generate_student_enrollment_code()
    RETURNS TRIGGER
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

-- classes
CREATE OR REPLACE FUNCTION faculty.generate_class_code()
    RETURNS TRIGGER
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

CREATE OR REPLACE FUNCTION faculty.set_year_semester()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.year_semester := general.get_year_semester(NEW.initial_date);
    RETURN NEW;
END;
$$;

-- activities / exams
CREATE OR REPLACE FUNCTION faculty.increment_score_in_class()
    RETURNS TRIGGER
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

-- lessons
CREATE OR REPLACE FUNCTION faculty.increment_lessons_in_class()
    RETURNS TRIGGER
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

-- class_code_counters
CREATE OR REPLACE FUNCTION faculty.set_course_code()
    RETURNS TRIGGER
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

-- course_code_counters / instructor_enrollment_code_counters
CREATE OR REPLACE FUNCTION faculty.set_department_code()
    RETURNS TRIGGER
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

-- student_enrollment_code_counters
CREATE OR REPLACE FUNCTION faculty.set_degree_program_code()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    SELECT
        d.degree_program_code INTO NEW.degree_program_code
    FROM
        faculty.degree_programs d
    WHERE
        d.degree_program_id = NEW.degree_program_id;
    RETURN NEW;
END;
$$;

