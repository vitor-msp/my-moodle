-- super user
CREATE ROLE moodle_super WITH superuser noinherit LOGIN PASSWORD 'moodlesuper';

-- register_people_app
CREATE ROLE g_register_people_app WITH nologin;

CREATE ROLE register_people_app WITH noinherit LOGIN connection LIMIT 10 PASSWORD 'register_people_app';

ALTER USER register_people_app SET ROLE g_register_people_app;

GRANT g_register_people_app TO register_people_app;

-- courses_app
CREATE ROLE courses_app WITH noinherit LOGIN connection LIMIT 10 PASSWORD 'courses_app';

