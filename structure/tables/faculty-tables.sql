CREATE TABLE IF NOT EXISTS faculty.departments(
    department_id serial PRIMARY KEY,
    code faculty.department_code NOT NULL UNIQUE,
    name varchar(50) NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.degree_programs(
    degree_program_id serial PRIMARY KEY,
    code faculty.degree_program_code NOT NULL UNIQUE,
    name varchar(50) NOT NULL,
    curriculum xml,
    department_id int NOT NULL REFERENCES faculty.departments(department_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.instructors(
    instructor_id serial PRIMARY KEY,
    person_id int NOT NULL REFERENCES general.people(person_id) ON UPDATE CASCADE ON DELETE SET NULL,
    enrollment_code faculty.instructor_enrollment_code NOT NULL UNIQUE,
    department_id int NOT NULL REFERENCES faculty.departments(department_id),
    max_course_load int NOT NULL DEFAULT 800,
    current_course_load int NOT NULL DEFAULT 0,
    active boolean DEFAULT TRUE,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.courses(
    course_id serial PRIMARY KEY,
    code faculty.course_code NOT NULL UNIQUE,
    name varchar(50) NOT NULL,
    syllabus hstore,
    department_id int NOT NULL REFERENCES faculty.departments(department_id),
    course_load int NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.prerequisites(
    course_id int NOT NULL REFERENCES faculty.courses(course_id),
    prerequisite_id int NOT NULL REFERENCES faculty.courses(course_id),
    PRIMARY KEY (course_id, prerequisite_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.classes(
    class_id serial PRIMARY KEY,
    code faculty.class_code NOT NULL UNIQUE,
    class_session faculty.session NOT NULL,
    initial_date date NOT NULL,
    final_date date NOT NULL CHECK (final_date > initial_date),
    year_semester char(5) NOT NULL,
    course_id int NOT NULL REFERENCES faculty.courses(course_id),
    instructor_id int NOT NULL REFERENCES faculty.instructors(instructor_id),
    total_score real NOT NULL DEFAULT 0,
    minimum_grade real NOT NULL DEFAULT 60,
    total_lessons int NOT NULL DEFAULT 0,
    minimum_lessons int NOT NULL DEFAULT 10,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.lessons(
    lesson_id serial PRIMARY KEY,
    date date NOT NULL,
    initial_time time NOT NULL,
    final_time time NOT NULL CHECK (final_time > initial_time),
    content_code char(5),
    description text,
    class_id int NOT NULL REFERENCES faculty.classes(class_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.students(
    student_id serial PRIMARY KEY,
    person_id int NOT NULL REFERENCES general.people(person_id) ON UPDATE CASCADE ON DELETE SET NULL,
    enrollment_code faculty.student_enrollment_code NOT NULL UNIQUE,
    degree_program_id int NOT NULL REFERENCES faculty.degree_programs(degree_program_id),
    max_course_load int NOT NULL DEFAULT 400,
    current_course_load int NOT NULL DEFAULT 0,
    active boolean DEFAULT TRUE,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.activities(
    activity_id serial PRIMARY KEY,
    date date NOT NULL,
    initial_time time NOT NULL,
    final_time time NOT NULL CHECK (final_time > initial_time),
    total_score real NOT NULL CHECK (total_score > 0),
    class_id int NOT NULL REFERENCES faculty.classes(class_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.exams(
    exam_id serial PRIMARY KEY,
    date date NOT NULL,
    initial_time time NOT NULL,
    final_time time NOT NULL CHECK (final_time > initial_time),
    total_score real NOT NULL CHECK (total_score > 0),
    class_id int NOT NULL REFERENCES faculty.classes(class_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.grades(
    grade_id serial PRIMARY KEY,
    grade_value real NOT NULL CHECK (grade_value >= 0),
    student_id int NOT NULL REFERENCES faculty.students(student_id),
    exam_id int REFERENCES faculty.exams(exam_id),
    activity_id int REFERENCES faculty.activities(activity_id),
    class_id int NOT NULL REFERENCES faculty.classes(class_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.instructors_courses(
    instructor_id int NOT NULL REFERENCES faculty.instructors(instructor_id),
    course_id int NOT NULL REFERENCES faculty.courses(course_id),
    PRIMARY KEY (instructor_id, course_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.degree_programs_courses(
    degree_program_id int NOT NULL REFERENCES faculty.degree_programs(degree_program_id),
    course_id int NOT NULL REFERENCES faculty.courses(course_id),
    PRIMARY KEY (degree_program_id, course_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.students_classes(
    student_id int NOT NULL REFERENCES faculty.students(student_id),
    class_id int NOT NULL REFERENCES faculty.classes(class_id),
    PRIMARY KEY (student_id, class_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.students_lessons(
    student_id int NOT NULL REFERENCES faculty.students(student_id),
    lesson_id int NOT NULL REFERENCES faculty.lessons(lesson_id),
    PRIMARY KEY (student_id, lesson_id),
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.materials(
    material_id serial PRIMARY KEY,
    name varchar(30) NOT NULL,
    department_id int REFERENCES faculty.departments(department_id),
    total_quantity int NOT NULL,
    available_quantity int NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

CREATE TABLE IF NOT EXISTS faculty.material_requests(
    material_id int NOT NULL REFERENCES faculty.materials(material_id),
    lesson_id int NOT NULL REFERENCES faculty.lessons(lesson_id),
    PRIMARY KEY (material_id, lesson_id),
    instructor_id int NOT NULL REFERENCES faculty.instructors(instructor_id),
    quantity int NOT NULL,
    date date NOT NULL,
    initial_time time NOT NULL,
    final_time time NOT NULL,
    return_timestamp timestamptz,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

