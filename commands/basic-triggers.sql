-- people
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON general.people
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON general.people
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- departments
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.departments
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.departments
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- degree_programs
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.degree_programs
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.degree_programs
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- degree_programs_courses
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.degree_programs_courses
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.degree_programs_courses
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- degree_programs_students
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.degree_programs_students
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.degree_programs_students
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- instructors
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.instructors
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.instructors
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- instructors_courses
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.instructors_courses
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.instructors_courses
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- courses
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.courses
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.courses
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- classes
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.classes
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.classes
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- students_classes
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.students_classes
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.students_classes
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- lessons
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.lessons
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.lessons
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- students_lessons
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.students_lessons
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.students_lessons
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- students
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.students
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.students
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- grades
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.grades
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.grades
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- activities
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.activities
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.activities
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- exams
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.exams
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.exams
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- course_code_counters
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.course_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.course_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- instructor_enrollment_code_counters
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.instructor_enrollment_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.instructor_enrollment_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- student_enrollment_code_counters
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.student_enrollment_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.student_enrollment_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- class_code_counters
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.class_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.class_code_counters
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

-- prerequisites
CREATE OR REPLACE TRIGGER created_at
    BEFORE INSERT ON faculty.prerequisites
    FOR EACH ROW
    EXECUTE FUNCTION general.created_at();

CREATE OR REPLACE TRIGGER updated_at
    BEFORE UPDATE ON faculty.prerequisites
    FOR EACH ROW
    EXECUTE FUNCTION general.updated_at();

