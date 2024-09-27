CREATE TYPE faculty.session AS enum(
    'M',
    'T',
    'N'
);

CREATE DOMAIN faculty.total_grade_value AS real NOT NULL CHECK (value > 0);

CREATE DOMAIN faculty.grade_value AS real NOT NULL CHECK (value >= 0);

-- DCC, ICX
CREATE DOMAIN faculty.department_code AS char(3) NOT NULL CHECK (value ~ '^[A-Z]{3}$');

-- EGSFT, FISIC
CREATE DOMAIN faculty.degree_program_code AS char(5) NOT NULL CHECK (value ~ '^[A-Z]{5}$');

-- DCC001, ICX023
CREATE DOMAIN faculty.course_code AS char(6) CHECK (value ~ '^[A-Z]{3}\d{3}$');

-- DCC00120182M06, ICX02320201T91
CREATE DOMAIN faculty.class_code AS char(14) CHECK (value ~ '^[A-Z]{3}\d{3}\d{4}[1|2][M|T|N]\d{2}$');

-- DCC000164, ICX162963
CREATE DOMAIN faculty.instructor_enrollment_code AS char(9) CHECK (value ~ '^[A-Z]{3}\d{6}$');

-- EGSFT20182062, FISIC20201006
CREATE DOMAIN faculty.student_enrollment_code AS char(13) CHECK (value ~ '^[A-Z]{5}\d{4}[1|2]\d{3}$');

