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

