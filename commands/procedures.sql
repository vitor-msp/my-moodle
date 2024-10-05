CREATE OR REPLACE PROCEDURE faculty.create_class(input faculty.create_class_input)
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

CREATE OR REPLACE PROCEDURE faculty.enroll_student_in_class(input faculty.enroll_student_in_class_input)
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

CREATE OR REPLACE PROCEDURE faculty.create_new_counters()
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

CREATE OR REPLACE PROCEDURE faculty.request_material_from_department(input faculty.request_material_input)
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

CREATE OR REPLACE PROCEDURE faculty.request_global_material(input faculty.request_material_input)
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

CREATE OR REPLACE PROCEDURE faculty.return_material(input faculty.return_material_input)
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

