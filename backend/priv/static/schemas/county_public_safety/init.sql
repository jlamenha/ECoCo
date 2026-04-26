-- Database: county_public_safety

CREATE TABLE county_public_safety.county_public_safety (
    County_ID INTEGER PRIMARY KEY,
    Name TEXT,
    Population INTEGER,
    Police_officers INTEGER,
    Residents_per_officer INTEGER,
    Case_burden INTEGER,
    Crime_rate INTEGER,
    Police_force TEXT,
    Location TEXT
);

CREATE TABLE county_public_safety.city (
    City_ID INTEGER PRIMARY KEY,
    County_ID INTEGER,
    Name TEXT,
    White INTEGER,
    Black INTEGER,
    Amerindian INTEGER,
    Asian INTEGER,
    Multiracial INTEGER,
    Hispanic INTEGER
);

ALTER TABLE county_public_safety.city ADD CONSTRAINT fk_city_County_ID_to_county_public_safety FOREIGN KEY (County_ID) REFERENCES county_public_safety.county_public_safety(County_ID);
