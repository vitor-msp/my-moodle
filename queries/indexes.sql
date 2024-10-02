-- people
CREATE INDEX IF NOT EXISTS people_name ON general.people USING btree(name);

-- student_enrollment_code_counters
CREATE INDEX IF NOT EXISTS student_enrollment_code_counters_degree_program_id ON faculty.student_enrollment_code_counters USING btree(degree_program_id);

-- departments
CREATE INDEX IF NOT EXISTS departments_name ON faculty.departments USING btree(name);

-- degree_programs
CREATE INDEX IF NOT EXISTS degree_programs_department_id ON faculty.degree_programs USING btree(department_id);

CREATE INDEX IF NOT EXISTS degree_programs_name ON faculty.degree_programs USING btree(name);

-- instructors
CREATE INDEX IF NOT EXISTS instructors_person_id ON faculty.instructors USING btree(person_id);

CREATE INDEX IF NOT EXISTS instructors_department_id ON faculty.instructors USING btree(department_id);

-- courses
CREATE INDEX IF NOT EXISTS courses_department_id ON faculty.courses USING btree(department_id);

CREATE INDEX IF NOT EXISTS courses_name ON faculty.courses USING btree(name);

-- classes
CREATE INDEX IF NOT EXISTS classes_course_id ON faculty.classes USING btree(course_id);

CREATE INDEX IF NOT EXISTS classes_instructor_id ON faculty.classes USING btree(instructor_id);

CREATE INDEX IF NOT EXISTS classes_initial_date ON faculty.classes USING btree(initial_date);

-- lessons
CREATE INDEX IF NOT EXISTS lessons_class_id ON faculty.lessons USING btree(class_id);

CREATE INDEX IF NOT EXISTS lessons_date_initial_time ON faculty.lessons USING btree(date, initial_time);

-- students
CREATE INDEX IF NOT EXISTS students_person_id ON faculty.students USING btree(person_id);

CREATE INDEX IF NOT EXISTS students_degree_program_id ON faculty.students USING btree(degree_program_id);

-- activities
CREATE INDEX IF NOT EXISTS activities_class_id ON faculty.activities USING btree(class_id);

CREATE INDEX IF NOT EXISTS activities_date_initial_time ON faculty.activities USING btree(date, initial_time);

-- exams
CREATE INDEX IF NOT EXISTS exams_class_id ON faculty.exams USING btree(class_id);

CREATE INDEX IF NOT EXISTS exams_date_initial_time ON faculty.exams USING btree(date, initial_time);

-- grades
CREATE INDEX IF NOT EXISTS grades_class_id_student_id ON faculty.grades USING btree(class_id, student_id);

CREATE INDEX IF NOT EXISTS grades_exam_id ON faculty.grades USING btree(exam_id);

CREATE INDEX IF NOT EXISTS grades_activity_id ON faculty.grades USING btree(activity_id);

-- academic_transcripts
CREATE INDEX IF NOT EXISTS academic_transcripts_student_id ON faculty.academic_transcripts USING btree(student_id);

CREATE INDEX IF NOT EXISTS academic_transcripts_class_id ON faculty.academic_transcripts USING btree(class_id);

-- materials
CREATE INDEX IF NOT EXISTS materials_name ON faculty.materials USING btree(name);

CREATE INDEX IF NOT EXISTS materials_department_id ON faculty.materials USING btree(department_id);

-- material_requests
CREATE INDEX IF NOT EXISTS material_requests_instructor_id ON faculty.material_requests USING btree(instructor_id);

