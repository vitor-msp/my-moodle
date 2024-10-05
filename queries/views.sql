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
CREATE OR REPLACE VIEW faculty.class_schedules AS
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

-- people info
CREATE OR REPLACE VIEW general.people_info AS
SELECT
    person_id,
    name,
    birth_date,
    document,
    coalesce(details ->> 'gender', '-') AS gender,
    coalesce(details ->> 'race', '-') AS race,
    coalesce(details ->> 'email', '-') AS email,
    coalesce(general.format_telephone(trim(details -> 'telephone' ->> 'ddd'::text)::char(2), trim(details -> 'telephone' ->> 'number'::text)::char(9)), '-') AS telephone,
    coalesce(general.format_address((details -> 'address' ->> 'street', details -> 'address' ->> 'number', details -> 'address' ->> 'addressLine2', details -> 'address' ->> 'neighborhood', details -> 'address' ->> 'city', details -> 'address' ->> 'state', details -> 'address' ->> 'zipCode', details -> 'address' ->> 'country')::general.format_address_input), '-') AS address
FROM
    general.people
ORDER BY
    name WITH cascaded CHECK option;

-- grade interval
CREATE VIEW faculty.grade_intervals AS
WITH base AS (
    SELECT
        a.course_id,
        a.course_code,
        a.course_name,
        a.class_id,
        a.class_code,
        a.year_semester,
        faculty.classify_grades(a.student_grade) AS classified_grades
    FROM
        faculty.academic_transcripts a
    GROUP BY
        a.course_id,
        a.course_code,
        a.course_name,
        a.class_id,
        a.class_code,
        a.year_semester
)
SELECT
    course_id,
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
(classified_grades).status_a_percent * 100 || '%' AS status_a_percent,
(classified_grades).status_b_percent * 100 || '%' AS status_b_percent,
(classified_grades).status_c_percent * 100 || '%' AS status_c_percent,
(classified_grades).status_d_percent * 100 || '%' AS status_d_percent,
(classified_grades).status_e_percent * 100 || '%' AS status_e_percent
FROM
    base
ORDER BY
    base.course_name,
    base.class_id;

