-- Database: dog_kennels
-- Another average-to-long example, 8 tables and 6 FKs

CREATE TABLE dog_kennels.Breeds (
    breed_code TEXT PRIMARY KEY,
    breed_name TEXT
);

CREATE TABLE dog_kennels.Charges (
    charge_id INTEGER PRIMARY KEY,
    charge_type TEXT,
    charge_amount INTEGER
);

CREATE TABLE dog_kennels.Sizes (
    size_code TEXT PRIMARY KEY,
    size_description TEXT
);

CREATE TABLE dog_kennels.Treatment_Types (
    treatment_type_code TEXT PRIMARY KEY,
    treatment_type_description TEXT
);

CREATE TABLE dog_kennels.Owners (
    owner_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    email_address TEXT,
    home_phone TEXT,
    cell_number TEXT
);

CREATE TABLE dog_kennels.Dogs (
    dog_id INTEGER PRIMARY KEY,
    owner_id INTEGER,
    abandoned_yn TEXT,
    breed_code TEXT,
    size_code TEXT,
    name TEXT,
    age TEXT,
    date_of_birth TEXT,
    gender TEXT,
    weight TEXT,
    date_arrived TEXT,
    date_adopted TEXT,
    date_departed TEXT
);

CREATE TABLE dog_kennels.Professionals (
    professional_id INTEGER PRIMARY KEY,
    role_code TEXT,
    first_name TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip_code TEXT,
    last_name TEXT,
    email_address TEXT,
    home_phone TEXT,
    cell_number TEXT
);

CREATE TABLE dog_kennels.Treatments (
    treatment_id INTEGER PRIMARY KEY,
    dog_id INTEGER,
    professional_id INTEGER,
    treatment_type_code TEXT,
    date_of_treatment TEXT,
    cost_of_treatment INTEGER
);

ALTER TABLE dog_kennels.Dogs ADD CONSTRAINT fk_Dogs_owner_id_to_Owners FOREIGN KEY (owner_id) REFERENCES dog_kennels.Owners(owner_id);

ALTER TABLE dog_kennels.Dogs ADD CONSTRAINT fk_Dogs_size_code_to_Sizes FOREIGN KEY (size_code) REFERENCES dog_kennels.Sizes(size_code);

ALTER TABLE dog_kennels.Dogs ADD CONSTRAINT fk_Dogs_breed_code_to_Breeds FOREIGN KEY (breed_code) REFERENCES dog_kennels.Breeds(breed_code);

ALTER TABLE dog_kennels.Treatments ADD CONSTRAINT fk_Treatments_dog_id_to_Dogs FOREIGN KEY (dog_id) REFERENCES dog_kennels.Dogs(dog_id);

ALTER TABLE dog_kennels.Treatments ADD CONSTRAINT fk_Treatments_professional_id_to_Professionals FOREIGN KEY (professional_id) REFERENCES dog_kennels.Professionals(professional_id);

ALTER TABLE dog_kennels.Treatments ADD CONSTRAINT fk_Treatments_treatment_type_code_to_Treatment_Types FOREIGN KEY (treatment_type_code) REFERENCES dog_kennels.Treatment_Types(treatment_type_code);

