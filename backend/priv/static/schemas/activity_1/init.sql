-- Database: activity_1

CREATE TABLE activity_1.Activity (
    actid INTEGER PRIMARY KEY,
    activity_name TEXT
);

CREATE TABLE activity_1.Participates_in (
    stuid INTEGER,
    actid INTEGER
);

CREATE TABLE activity_1.Faculty_Participates_in (
    FacID INTEGER,
    actid INTEGER
);

CREATE TABLE activity_1.Student (
    StuID INTEGER PRIMARY KEY,
    LName TEXT,
    Fname TEXT,
    Age INTEGER,
    Sex TEXT,
    Major INTEGER,
    Advisor INTEGER,
    city_code TEXT
);

CREATE TABLE activity_1.Faculty (
    FacID INTEGER PRIMARY KEY,
    Lname TEXT,
    Fname TEXT,
    Rank TEXT,
    Sex TEXT,
    Phone INTEGER,
    Room TEXT,
    Building TEXT
);

ALTER TABLE activity_1.Participates_in ADD CONSTRAINT fk_Participates_in_actid_to_Activity FOREIGN KEY (actid) REFERENCES activity_1.Activity(actid);

ALTER TABLE activity_1.Participates_in ADD CONSTRAINT fk_Participates_in_stuid_to_Student FOREIGN KEY (stuid) REFERENCES activity_1.Student(StuID);

ALTER TABLE activity_1.Faculty_Participates_in ADD CONSTRAINT fk_Faculty_Participates_in_actid_to_Activity FOREIGN KEY (actid) REFERENCES activity_1.Activity(actid);

ALTER TABLE activity_1.Faculty_Participates_in ADD CONSTRAINT fk_Faculty_Participates_in_FacID_to_Faculty FOREIGN KEY (FacID) REFERENCES activity_1.Faculty(FacID);


