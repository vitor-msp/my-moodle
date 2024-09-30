CREATE TABLE IF NOT EXISTS general.people(
    person_id serial PRIMARY KEY,
    entity_id uuid NOT NULL UNIQUE DEFAULT uuid_generate_v4(),
    name varchar(50) NOT NULL,
    birth_date date NOT NULL,
    document varchar(30) NOT NULL UNIQUE,
    details jsonb,
    created_at timestamptz NOT NULL,
    updated_at timestamptz
);

