-- Database: climbing

CREATE TABLE climbing.mountain (
    Mountain_ID INTEGER PRIMARY KEY,
    Name TEXT,
    Height INTEGER,
    Prominence INTEGER,
    Range TEXT,
    Country TEXT
);

CREATE TABLE climbing.climber (
    Climber_ID INTEGER PRIMARY KEY,
    Name TEXT,
    Country TEXT,
    Time TEXT,
    Points INTEGER,
    Mountain_ID INTEGER
);

ALTER TABLE climbing.climber ADD CONSTRAINT fk_climber_Mountain_ID_to_mountain FOREIGN KEY (Mountain_ID) REFERENCES climbing.mountain(Mountain_ID);

