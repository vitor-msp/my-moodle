CREATE TABLE IF NOT EXISTS faculty.course_code_counters(
    course_code_counter_id serial PRIMARY KEY,
    department_id int NOT NULL REFERENCES faculty.departments(department_id),
    department_code char(3) NOT NULL,
    counter int NOT NULL DEFAULT 0 CHECK (counter BETWEEN 0 AND 999),
    created_at timestamp NOT NULL,
    updated_at timestamp
);

CREATE TABLE IF NOT EXISTS faculty.instructor_enrollment_code_counters(
    instructor_enrollment_code_counter_id serial PRIMARY KEY,
    department_id int NOT NULL REFERENCES faculty.departments(department_id),
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
    class_code_counter_id serial PRIMARY KEY,
    course_id int NOT NULL REFERENCES faculty.courses(course_id),
    course_code char(6) NOT NULL,
    session faculty.session NOT NULL,
    counter int NOT NULL DEFAULT 0 CHECK (counter BETWEEN 0 AND 99),
    created_at timestamp NOT NULL,
    updated_at timestamp
);

