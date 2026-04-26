-- Database: allergy_1

CREATE TABLE allergy_1.Allergy_Type (
    Allergy TEXT PRIMARY KEY,
    AllergyType TEXT
);

CREATE TABLE allergy_1.Has_Allergy (
    StuID INTEGER,
    Allergy TEXT
);

CREATE TABLE allergy_1.Student (
    StuID INTEGER PRIMARY KEY,
    LName TEXT,
    Fname TEXT,
    Age INTEGER,
    Sex TEXT,
    Major INTEGER,
    Advisor INTEGER,
    city_code TEXT
);

ALTER TABLE allergy_1.Has_Allergy ADD CONSTRAINT fk_Has_Allergy_Allergy_to_Allergy_Type FOREIGN KEY (Allergy) REFERENCES allergy_1.Allergy_Type(Allergy);

ALTER TABLE allergy_1.Has_Allergy ADD CONSTRAINT fk_Has_Allergy_StuID_to_Student FOREIGN KEY (StuID) REFERENCES allergy_1.Student(StuID);

