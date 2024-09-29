CREATE TABLE IF NOT EXISTS faculty.course_code_counters(
    department_id int PRIMARY KEY REFERENCES faculty.departments(department_id),
    department_code char(3) NOT NULL,
    counter int NOT NULL DEFAULT 0 CHECK (counter BETWEEN 0 AND 999),
    created_at timestamp NOT NULL,
    updated_at timestamp
);

CREATE TABLE IF NOT EXISTS faculty.instructor_enrollment_code_counters(
    department_id int PRIMARY KEY REFERENCES faculty.departments(department_id),
    department_code char(3) NOT NULL,
    counter int NOT NULL DEFAULT 0 CHECK (counter BETWEEN 0 AND 999999),
    created_at timestamp NOT NULL,
    updated_at timestamp
);

CREATE TABLE IF NOT EXISTS faculty.student_enrollment_code_counters(
    student_enrollment_code_counter_id serial PRIMARY KEY,
    degree_program_id int NOT NULL REFERENCES faculty.degree_programs(degree_program_id),
    degree_program_code char(5) NOT NULL,
    counter int NOT NULL DEFAULT 0 CHECK (counter BETWEEN 0 AND 999),
    created_at timestamp NOT NULL,
    updated_at timestamp
);

CREATE TABLE IF NOT EXISTS faculty.class_code_counters(
    course_id int NOT NULL REFERENCES faculty.courses(course_id),
    year_semester char(5) NOT NULL DEFAULT general.get_year_semester(CURRENT_DATE),
    session faculty.session NOT NULL,
    course_code char(6) NOT NULL,
    counter int NOT NULL DEFAULT 0 CHECK (counter BETWEEN 0 AND 99),
    created_at timestamp NOT NULL,
    updated_at timestamp,
    PRIMARY KEY (course_id, year_semester, session)
);

