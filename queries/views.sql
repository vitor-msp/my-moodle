-- academic transcripts
CREATE MATERIALIZED VIEW faculty.academic_transcripts AS
WITH base AS (
    SELECT
        st.student_id AS student_id,
        st.enrollment_code AS student_enrollment_code,
        pe.name AS student_name,
        cl.year_semester AS year_semester,
        co.course_id AS course_id,
        co.code AS course_code,
        co.name AS course_name,
        cl.class_id AS class_id,
        cl.code AS class_code,
        cl.total_score AS total_score,
        cl.minimum_grade AS minimum_grade,
        sum(coalesce(gr.grade_value, 0)) AS student_grade,
        cl.total_lessons AS total_lessons,
        cl.minimum_lessons AS minimum_lessons
    FROM
        faculty.students st
        INNER JOIN general.people pe USING (person_id)
        INNER JOIN faculty.students_classes sc USING (student_id)
        INNER JOIN faculty.classes cl USING (class_id)
        INNER JOIN faculty.courses co USING (course_id)
        LEFT OUTER JOIN faculty.grades gr USING (student_id, class_id)
    GROUP BY
        st.student_id, st.enrollment_code, pe.name, cl.year_semester, co.course_id, co.code, co.name, cl.class_id, cl.code, cl.total_score, cl.minimum_grade, cl.total_lessons, cl.minimum_lessons
)
SELECT
    base.student_id AS student_id,
    base.student_enrollment_code AS student_enrollment_code,
    base.student_name AS student_name,
    base.year_semester AS year_semester,
    base.course_id AS course_id,
    base.course_code AS course_code,
    base.course_name AS course_name,
    base.class_id AS class_id,
    base.class_code AS class_code,
    base.total_score AS total_score,
    base.minimum_grade AS minimum_grade,
    base.student_grade AS student_grade,
    base.total_lessons AS total_lessons,
    base.minimum_lessons AS minimum_lessons,
    count(sl.*) AS student_lessons,
    CASE WHEN base.student_grade >= base.minimum_grade
        AND count(sl.*) >= base.minimum_lessons THEN
        'passed'
    ELSE
        'failed'
    END AS final_status
FROM
    base
    LEFT OUTER JOIN faculty.lessons le USING (class_id)
    LEFT OUTER JOIN faculty.students_lessons sl USING (student_id, lesson_id)
GROUP BY
    base.student_id,
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
    base.total_lessons,
    base.minimum_lessons
ORDER BY
    student_name,
    year_semester,
    course_name WITH NO data;

-- courses of degree programs
CREATE OR REPLACE VIEW faculty.courses_of_degree_programs AS
SELECT
    d.degree_program_id AS degree_program_id,
    d.code AS degree_program_code,
    d.name AS degree_program_name,
    c.course_id AS course_id,
    c.code AS course_code,
    c.name AS course_name
FROM
    faculty.degree_programs d
    INNER JOIN faculty.degree_programs_courses dc USING (degree_program_id)
    INNER JOIN faculty.courses c USING (course_id)
ORDER BY
    degree_program_name,
    course_name;

-- curriculums
CREATE OR REPLACE VIEW faculty.curriculums AS
WITH stage3 AS (
    WITH stage2 AS (
        WITH stage1 AS (
            SELECT
                degree_program_id AS degree_program_id,
                code AS degree_program_code,
                name AS degree_program_name,
                unnest(xpath('//curriculum/*', curriculum)) AS curriculum
            FROM
                faculty.degree_programs
)
            SELECT
                *,
                substring((xpath('name(//*[1])', curriculum))[1]::text FROM 8 FOR 2) AS period
            FROM
                stage1
)
            SELECT
                degree_program_id,
                degree_program_code,
                degree_program_name,
                period,
                unnest(xpath('//*/course', curriculum)) AS curriculum
            FROM
                stage2
)
        SELECT
            degree_program_id,
            degree_program_code,
            degree_program_name,
            period,
(xpath('/course/course_code/text()', curriculum))[1]::text AS course_code,
(xpath('/course/course_name/text()', curriculum))[1]::text AS course_name
        FROM
            stage3
        ORDER BY
            degree_program_name,
            period,
            course_name;

