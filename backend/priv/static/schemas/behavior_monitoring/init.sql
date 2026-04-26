-- Database: behavior_monitoring

CREATE TABLE behavior_monitoring.Ref_Address_Types (
    address_type_code TEXT PRIMARY KEY,
    address_type_description TEXT
);

CREATE TABLE behavior_monitoring.Ref_Detention_Type (
    detention_type_code TEXT PRIMARY KEY,
    detention_type_description TEXT
);

CREATE TABLE behavior_monitoring.Ref_Incident_Type (
    incident_type_code TEXT PRIMARY KEY,
    incident_type_description TEXT
);

CREATE TABLE behavior_monitoring.Addresses (
    address_id INTEGER PRIMARY KEY,
    line_1 TEXT,
    line_2 TEXT,
    line_3 TEXT,
    city TEXT,
    zip_postcode TEXT,
    state_province_county TEXT,
    country TEXT,
    other_address_details TEXT
);

CREATE TABLE behavior_monitoring.Students (
    student_id INTEGER PRIMARY KEY,
    address_id INTEGER,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    cell_mobile_number TEXT,
    email_address TEXT,
    date_first_rental TEXT,
    date_left_university TEXT,
    other_student_details TEXT
);

CREATE TABLE behavior_monitoring.Teachers (
    teacher_id INTEGER PRIMARY KEY,
    address_id INTEGER,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    gender TEXT,
    cell_mobile_number TEXT,
    email_address TEXT,
    other_details TEXT
);

CREATE TABLE behavior_monitoring.Assessment_Notes (
    notes_id INTEGER,
    student_id INTEGER,
    teacher_id INTEGER,
    date_of_notes TEXT,
    text_of_notes TEXT,
    other_details TEXT
);

CREATE TABLE behavior_monitoring.Behavior_Incident (
    incident_id INTEGER PRIMARY KEY,
    incident_type_code TEXT,
    student_id INTEGER,
    date_incident_start TEXT,
    date_incident_end TEXT,
    incident_summary TEXT,
    recommendations TEXT,
    other_details TEXT
);

CREATE TABLE behavior_monitoring.Detention (
    detention_id INTEGER PRIMARY KEY,
    detention_type_code TEXT,
    teacher_id INTEGER,
    datetime_detention_start TEXT,
    datetime_detention_end TEXT,
    detention_summary TEXT,
    other_details TEXT
);

CREATE TABLE behavior_monitoring.Student_Addresses (
    student_id INTEGER,
    address_id INTEGER,
    date_address_from TEXT,
    date_address_to TEXT,
    monthly_rental INTEGER,
    other_details TEXT
);

CREATE TABLE behavior_monitoring.Students_in_Detention (
    student_id INTEGER,
    detention_id INTEGER,
    incident_id INTEGER
);

ALTER TABLE behavior_monitoring.Students ADD CONSTRAINT fk_Students_address_id_to_Addresses FOREIGN KEY (address_id) REFERENCES behavior_monitoring.Addresses(address_id);

ALTER TABLE behavior_monitoring.Teachers ADD CONSTRAINT fk_Teachers_address_id_to_Addresses FOREIGN KEY (address_id) REFERENCES behavior_monitoring.Addresses(address_id);

ALTER TABLE behavior_monitoring.Assessment_Notes ADD CONSTRAINT fk_Assessment_Notes_teacher_id_to_Teachers FOREIGN KEY (teacher_id) REFERENCES behavior_monitoring.Teachers(teacher_id);

ALTER TABLE behavior_monitoring.Assessment_Notes ADD CONSTRAINT fk_Assessment_Notes_student_id_to_Students FOREIGN KEY (student_id) REFERENCES behavior_monitoring.Students(student_id);

ALTER TABLE behavior_monitoring.Behavior_Incident ADD CONSTRAINT fk_Behavior_Incident_student_id_to_Students FOREIGN KEY (student_id) REFERENCES behavior_monitoring.Students(student_id);

ALTER TABLE behavior_monitoring.Behavior_Incident ADD CONSTRAINT fk_Behavior_Incident_incident_type_code_to_Ref_Incident_Type FOREIGN KEY (incident_type_code) REFERENCES behavior_monitoring.Ref_Incident_Type(incident_type_code);

ALTER TABLE behavior_monitoring.Detention ADD CONSTRAINT fk_Detention_teacher_id_to_Teachers FOREIGN KEY (teacher_id) REFERENCES behavior_monitoring.Teachers(teacher_id);

ALTER TABLE behavior_monitoring.Detention ADD CONSTRAINT fk_Detention_detention_type_code_to_Ref_Detention_Type FOREIGN KEY (detention_type_code) REFERENCES behavior_monitoring.Ref_Detention_Type(detention_type_code);

ALTER TABLE behavior_monitoring.Student_Addresses ADD CONSTRAINT fk_Student_Addresses_student_id_to_Students FOREIGN KEY (student_id) REFERENCES behavior_monitoring.Students(student_id);

ALTER TABLE behavior_monitoring.Student_Addresses ADD CONSTRAINT fk_Student_Addresses_address_id_to_Addresses FOREIGN KEY (address_id) REFERENCES behavior_monitoring.Addresses(address_id);

ALTER TABLE behavior_monitoring.Students_in_Detention ADD CONSTRAINT fk_Students_in_Detention_student_id_to_Students FOREIGN KEY (student_id) REFERENCES behavior_monitoring.Students(student_id);

ALTER TABLE behavior_monitoring.Students_in_Detention ADD CONSTRAINT fk_Students_in_Detention_detention_id_to_Detention FOREIGN KEY (detention_id) REFERENCES behavior_monitoring.Detention(detention_id);

ALTER TABLE behavior_monitoring.Students_in_Detention ADD CONSTRAINT fk_Students_in_Detention_incident_id_to_Behavior_Incident FOREIGN KEY (incident_id) REFERENCES behavior_monitoring.Behavior_Incident(incident_id);

