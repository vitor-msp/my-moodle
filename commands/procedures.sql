CREATE OR REPLACE PROCEDURE faculty.create_class(input faculty.create_class_input)
LANGUAGE plpgsql
SET default_transaction_isolation TO 'serializable'
AS $$
DECLARE
    course_load_used int;
    max_course_load int;
    new_course_load int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    SELECT
        coalesce(sum(co.course_load), 0) INTO course_load_used
    FROM
        faculty.classes cl
        INNER JOIN faculty.courses co USING (course_id)
    WHERE
        cl.in_progress
        AND cl.instructor_id = input.instructor_id;
    --
    SELECT
        i.max_course_load INTO max_course_load
    FROM
        faculty.instructors i
    WHERE
        i.instructor_id = input.instructor_id;
    --
    SELECT
        c.course_load INTO new_course_load
    FROM
        faculty.courses c
    WHERE
        c.course_id = input.course_id;
    --
    IF course_load_used + new_course_load > max_course_load THEN
        RAISE EXCEPTION 'course load exceeded for instructor_id %', input.instructor_id;
    END IF;
    --
    INSERT INTO faculty.classes(class_session, initial_date, final_date, course_id, instructor_id)
        VALUES (input.class_session, input.initial_date, input.final_date, input.course_id, input.instructor_id);
    --
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
    course_load_used int;
    max_course_load int;
    new_course_load int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    SELECT
        coalesce(sum(co.course_load), 0) INTO course_load_used
    FROM
        faculty.students_classes sc
        INNER JOIN faculty.classes cl USING (class_id)
        INNER JOIN faculty.courses co USING (course_id)
    WHERE
        sc.active
        AND cl.in_progress
        AND sc.student_id = input.student_id;
    --
    SELECT
        s.max_course_load INTO max_course_load
    FROM
        faculty.students s
    WHERE
        s.student_id = input.student_id;
    --
    SELECT
        co.course_load INTO new_course_load
    FROM
        faculty.classes cl
        INNER JOIN faculty.courses co USING (course_id)
    WHERE
        cl.class_id = input.class_id;
    --
    IF course_load_used + new_course_load > max_course_load THEN
        RAISE EXCEPTION 'course load exceeded for student_id %', input.student_id;
    END IF;
    --
    INSERT INTO faculty.students_classes(student_id, class_id)
        VALUES (input.student_id, input.class_id);
    --
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

