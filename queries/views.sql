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

-- class schedules
CREATE OR REPLACE VIEW class_schedules AS
SELECT
    co.course_id AS course_id,
    co.code AS course_code,
    co.name AS course_name,
    cl.class_id AS class_id,
    cl.code AS class_code,
    cl.initial_date AS class_initial_date,
    cl.final_date AS class_final_date,
    le.lesson_id AS lesson_id,
    le.date AS lesson_date,
    le.initial_time AS lesson_initial_time,
    le.final_time AS lesson_final_time,
    coalesce(co.syllabus[le.content_code], '-') AS lesson_content,
    le.description AS lesson_description
FROM
    faculty.lessons le
    INNER JOIN faculty.classes cl USING (class_id)
    INNER JOIN faculty.courses co USING (course_id)
ORDER BY
    course_name,
    class_initial_date,
    lesson_date,
    lesson_initial_time;

