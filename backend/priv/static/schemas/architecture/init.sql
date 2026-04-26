-- Database: architecture

CREATE TABLE architecture.architect (
    id INTEGER PRIMARY KEY,
    name TEXT,
    nationality TEXT,
    gender TEXT
);

CREATE TABLE architecture.bridge (
    architect_id INTEGER,
    id INTEGER PRIMARY KEY,
    name TEXT,
    location TEXT,
    length_meters INTEGER,
    length_feet INTEGER
);

CREATE TABLE architecture.mill (
    architect_id INTEGER,
    id INTEGER PRIMARY KEY,
    location TEXT,
    name TEXT,
    type TEXT,
    built_year INTEGER,
    notes TEXT
);

ALTER TABLE architecture.bridge ADD CONSTRAINT fk_bridge_architect_id_to_architect FOREIGN KEY (architect_id) REFERENCES architecture.architect(id);

ALTER TABLE architecture.mill ADD CONSTRAINT fk_mill_architect_id_to_architect FOREIGN KEY (architect_id) REFERENCES architecture.architect(id);


