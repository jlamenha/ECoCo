-- Database: club_1

CREATE TABLE club_1.Student (
    StuID INTEGER PRIMARY KEY,
    LName TEXT,
    Fname TEXT,
    Age INTEGER,
    Sex TEXT,
    Major INTEGER,
    Advisor INTEGER,
    city_code TEXT
);

CREATE TABLE club_1.Club (
    ClubID INTEGER PRIMARY KEY,
    ClubName TEXT,
    ClubDesc TEXT,
    ClubLocation TEXT
);

CREATE TABLE club_1.Member_of_club (
    StuID INTEGER,
    ClubID INTEGER,
    Position TEXT
);

ALTER TABLE club_1.Member_of_club ADD CONSTRAINT fk_Member_of_club_ClubID_to_Club FOREIGN KEY (ClubID) REFERENCES club_1.Club(ClubID);

ALTER TABLE club_1.Member_of_club ADD CONSTRAINT fk_Member_of_club_StuID_to_Student FOREIGN KEY (StuID) REFERENCES club_1.Student(StuID);

