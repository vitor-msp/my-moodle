insert into faculty.departments (code,name) values ('DCC','depto ciencia computacao');
insert into faculty.departments (code,name) values ('DAF','depto de fisica');
select * from faculty.departments;

insert into faculty.degree_programs (code,name,department_id) values ('EGSFT','eng software',1);
insert into faculty.degree_programs (code,name,department_id) values ('CCOMP','ciencia da computacao',1);
insert into faculty.degree_programs (code,name,department_id) values ('FISBA','fisica bacharelado',2);
insert into faculty.degree_programs (code,name,department_id) values ('FISLI','fisica licenciatura',2);
select * from faculty.degree_programs;

insert into general.people (name,birth_date,document) values ('gaspar otacilio','1970-01-01','MKALKL3131');
insert into general.people (name,birth_date,document) values ('gilberto braga','1965-02-02','MKALK69A31');
insert into general.people (name,birth_date,document) values ('vitor mateus','1999-01-07','HHDKL65164');
insert into general.people (name,birth_date,document) values ('bruno costa','2001-03-25','ALOKL65112');
insert into general.people (name,birth_date,document) values ('alice guimaraes','2000-04-07','PRIAL61592');
select * from general.people;

insert into faculty.instructors (person_id,department_id) values (1,1);
insert into faculty.instructors (person_id,department_id) values (2,2);
select * from faculty.instructors;

insert into faculty.courses (name,department_id) values ('algoritmos 1',1);
insert into faculty.courses (name,department_id) values ('redes de computadores 1',1);
insert into faculty.courses (name,department_id) values ('arquitetura de computadores 1',1);
insert into faculty.courses (name,department_id) values ('arquitetura de computadores 2',1);
insert into faculty.courses (name,department_id) values ('gerencia de projetos de software',1);
insert into faculty.courses (name,department_id) values ('fundamentos de mecanica',2);
insert into faculty.courses (name,department_id) values ('fundamentos de eletromagnetismo',2);
insert into faculty.courses (name,department_id) values ('fisica quantica 1',2);
insert into faculty.courses (name,department_id) values ('fisica quantica 2',2);
select * from faculty.courses;

insert into faculty.classes (class_session,initial_date,final_date,course_id,instructor_id) 
    values ('M','2024-07-01','2024-12-15',2,1);
insert into faculty.classes (class_session,initial_date,final_date,course_id,instructor_id) 
    values ('M','2024-07-01','2024-12-15',2,1);
insert into faculty.classes (class_session,initial_date,final_date,course_id,instructor_id) 
    values ('T','2024-07-01','2024-12-15',6,2);
insert into faculty.classes (class_session,initial_date,final_date,course_id,instructor_id) 
    values ('N','2024-07-01','2024-12-15',6,2);
select * from faculty.classes;

insert into faculty.students (person_id,degree_program_id) values (3,2);
insert into faculty.students (person_id,degree_program_id) values (4,3);
insert into faculty.students (person_id,degree_program_id) values (5,2);
select * from faculty.students;

select * from faculty.course_code_counters;
select * from faculty.instructor_enrollment_code_counters;
select * from faculty.student_enrollment_code_counters;
select * from faculty.class_code_counters;

CALL faculty.create_class(('M', '2024-07-01', '2024-12-15', 2, 1)::faculty.create_class_input);
CALL faculty.create_class(('M', '2024-07-01', '2024-12-15', 1, 1)::faculty.create_class_input);
CALL faculty.create_class(('M', '2024-07-01', '2024-12-15', 3, 1)::faculty.create_class_input);
CALL faculty.create_class(('M', '2024-07-01', '2024-12-15', 5, 1)::faculty.create_class_input);
CALL faculty.create_class(('M', '2024-07-01', '2024-12-15', 7, 1)::faculty.create_class_input);
CALL faculty.create_class(('T', '2024-07-01', '2024-12-15', 5, 1)::faculty.create_class_input);
CALL faculty.create_class(('M', '2025-02-01', '2025-06-01', 4, 1)::faculty.create_class_input);
CALL faculty.create_class(('M', '2023-02-01', '2023-06-01', 8, 2)::faculty.create_class_input);

CALL faculty.enroll_student_in_class((1, 1)::faculty.enroll_student_in_class_input);
CALL faculty.enroll_student_in_class((1, 12)::faculty.enroll_student_in_class_input);
CALL faculty.enroll_student_in_class((1, 13)::faculty.enroll_student_in_class_input);
CALL faculty.enroll_student_in_class((1, 14)::faculty.enroll_student_in_class_input);
CALL faculty.enroll_student_in_class((1, 26)::faculty.enroll_student_in_class_input);

REFRESH MATERIALIZED VIEW faculty.academic_transcripts;
select * from faculty.academic_transcripts;

update faculty.courses set syllabus='
    "OSI" => "modelo osi",
    "FIS" => "camada física",
    "ENL" => "camada de enlace",
    "RED" => "camada de rede",
    "TRA" => "camada de transporte",
    "APL" => "camada de aplicação",
    "TIP" => "modelo tcp/ip"
'::hstore where course_id=2;