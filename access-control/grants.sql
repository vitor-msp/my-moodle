-- register_people_app
GRANT USAGE ON SCHEMA general TO g_register_people_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON general.people TO g_register_people_app;
GRANT USAGE ON SEQUENCE general.people_person_id_seq TO g_register_people_app;

-- courses_app
GRANT USAGE ON SCHEMA faculty TO courses_app;
GRANT SELECT ON faculty.courses TO courses_app;
GRANT SELECT ON faculty.departments TO courses_app;

