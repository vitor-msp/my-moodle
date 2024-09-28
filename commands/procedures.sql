CREATE OR REPLACE PROCEDURE faculty.create_class(input faculty.create_class_input)
LANGUAGE plpgsql
SET default_transaction_isolation TO 'serializable'
AS $$
DECLARE
    instructor_is_active boolean;
    instructor_department int;
    course_department int;
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
    prerequisite record;
    final_status text;
    course_load_used int;
    max_course_load int;
    new_course_load int;
    _sqlstate text;
    _message text;
    _context text;
BEGIN
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
            IF final_status <> 'passed' THEN
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
    -- gets max course load for student
    SELECT
        s.max_course_load INTO max_course_load
    FROM
        faculty.students s
    WHERE
        s.student_id = input.student_id;
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
    course record;
    current_year_semester char(5);
    _sqlstate text;
    _message text;
    _context text;
BEGIN
    current_year_semester := general.get_current_year_semester();
    FOR course IN
    SELECT
        c.course_id
    FROM
        faculty.courses c LOOP
            INSERT INTO faculty.class_code_counters(course_id, session, year_semester)
                VALUES (course.course_id, 'M', current_year_semester);
            INSERT INTO faculty.class_code_counters(course_id, session, year_semester)
                VALUES (course.course_id, 'T', current_year_semester);
            INSERT INTO faculty.class_code_counters(course_id, session, year_semester)
                VALUES (course.course_id, 'N', current_year_semester);
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

