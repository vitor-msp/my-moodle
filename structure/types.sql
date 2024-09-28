CREATE TYPE faculty.session AS enum(
    'M',
    'T',
    'N'
);

-- DCC, DAF
CREATE DOMAIN faculty.department_code AS char(3) NOT NULL CHECK (value ~ '^[A-Z]{3}$');

-- EGSFT, FISIC
CREATE DOMAIN faculty.degree_program_code AS char(5) NOT NULL CHECK (value ~ '^[A-Z]{5}$');

-- DCC001, DAF023
CREATE DOMAIN faculty.course_code AS char(6) CHECK (value ~ '^[A-Z]{3}\d{3}$');

-- DCC00120182M06, DAF02320201T91
CREATE DOMAIN faculty.class_code AS char(14) CHECK (value ~ '^[A-Z]{3}\d{3}\d{4}[1|2][M|T|N]\d{2}$');

-- DCC000164, DAF162963
CREATE DOMAIN faculty.instructor_enrollment_code AS char(9) CHECK (value ~ '^[A-Z]{3}\d{6}$');

-- EGSFT20182062, FISIC20201006
CREATE DOMAIN faculty.student_enrollment_code AS char(13) CHECK (value ~ '^[A-Z]{5}\d{4}[1|2]\d{3}$');

CREATE TYPE faculty.create_class_input AS (
    class_session faculty.session,
    initial_date date,
    final_date date,
    course_id int,
    instructor_id int
);

CREATE TYPE faculty.enroll_student_in_class_input AS (
    student_id int,
    class_id int
);

