-- departments
CREATE OR REPLACE TRIGGER create_course_code_counter
    AFTER INSERT ON faculty.departments
    FOR EACH ROW
    EXECUTE FUNCTION faculty.create_course_code_counter();

CREATE OR REPLACE TRIGGER create_instructor_enrollment_code_counter
    AFTER INSERT ON faculty.departments
    FOR EACH ROW
    EXECUTE FUNCTION faculty.create_instructor_enrollment_code_counter();

-- degree_programs
CREATE OR REPLACE TRIGGER create_student_enrollment_code_counter
    AFTER INSERT ON faculty.degree_programs
    FOR EACH ROW
    EXECUTE FUNCTION faculty.create_student_enrollment_code_counter();

-- courses
CREATE OR REPLACE TRIGGER create_class_code_counter
    AFTER INSERT ON faculty.courses
    FOR EACH ROW
    EXECUTE FUNCTION faculty.create_class_code_counter();

CREATE OR REPLACE TRIGGER generate_course_code
    BEFORE INSERT ON faculty.courses
    FOR EACH ROW
    EXECUTE FUNCTION faculty.generate_course_code();

-- instructors
CREATE OR REPLACE TRIGGER generate_instructor_enrollment_code
    BEFORE INSERT ON faculty.instructors
    FOR EACH ROW
    EXECUTE FUNCTION faculty.generate_instructor_enrollment_code();

-- students
CREATE OR REPLACE TRIGGER generate_student_enrollment_code
    BEFORE INSERT ON faculty.students
    FOR EACH ROW
    EXECUTE FUNCTION faculty.generate_student_enrollment_code();

-- classes
CREATE OR REPLACE TRIGGER generate_class_code
    BEFORE INSERT ON faculty.classes
    FOR EACH ROW
    EXECUTE FUNCTION faculty.generate_class_code();

CREATE OR REPLACE TRIGGER set_year_semester
    BEFORE INSERT ON faculty.classes
    FOR EACH ROW
    EXECUTE FUNCTION faculty.set_year_semester();

-- activities
CREATE OR REPLACE TRIGGER increment_score_in_class
    AFTER INSERT ON faculty.activities
    FOR EACH ROW
    EXECUTE FUNCTION faculty.increment_score_in_class();

-- exams
CREATE OR REPLACE TRIGGER increment_score_in_class
    AFTER INSERT ON faculty.exams
    FOR EACH ROW
    EXECUTE FUNCTION faculty.increment_score_in_class();

-- lessons
CREATE OR REPLACE TRIGGER increment_lessons_in_class
    AFTER INSERT ON faculty.lessons
    FOR EACH ROW
    EXECUTE FUNCTION faculty.increment_lessons_in_class();

-- class_code_counters
CREATE OR REPLACE TRIGGER set_course_code
    BEFORE INSERT ON faculty.class_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION faculty.set_course_code();

-- course_code_counters
CREATE OR REPLACE TRIGGER set_department_code
    BEFORE INSERT ON faculty.course_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION faculty.set_department_code();

-- instructor_enrollment_code_counters
CREATE OR REPLACE TRIGGER set_department_code
    BEFORE INSERT ON faculty.instructor_enrollment_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION faculty.set_department_code();

-- student_enrollment_code_counters
CREATE OR REPLACE TRIGGER set_degree_program_code
    BEFORE INSERT ON faculty.student_enrollment_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION faculty.set_degree_program_code();