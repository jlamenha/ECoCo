-- Database: battle_death

CREATE TABLE battle_death.battle (
    id INTEGER PRIMARY KEY,
    name TEXT,
    date TEXT,
    bulgarian_commander TEXT,
    latin_commander TEXT,
    result TEXT
);

CREATE TABLE battle_death.ship (
    lost_in_battle INTEGER,
    id INTEGER PRIMARY KEY,
    name TEXT,
    tonnage TEXT,
    ship_type TEXT,
    location TEXT,
    disposition_of_ship TEXT
);

CREATE TABLE battle_death.death (
    caused_by_ship_id INTEGER,
    id INTEGER PRIMARY KEY,
    note TEXT,
    killed INTEGER,
    injured INTEGER
);

ALTER TABLE battle_death.ship ADD CONSTRAINT fk_ship_lost_in_battle_to_battle FOREIGN KEY (lost_in_battle) REFERENCES battle_death.battle(id);

ALTER TABLE battle_death.death ADD CONSTRAINT fk_death_caused_by_ship_id_to_ship FOREIGN KEY (caused_by_ship_id) REFERENCES battle_death.ship(id);