-- Database: assets_maintenance
CREATE TABLE assets_maintenance.Third_Party_Companies (
    company_id INTEGER PRIMARY KEY,
    company_type TEXT,
    company_name TEXT,
    company_address TEXT,
    other_company_details TEXT
);

CREATE TABLE assets_maintenance.Maintenance_Contracts (
    maintenance_contract_id INTEGER PRIMARY KEY,
    maintenance_contract_company_id INTEGER,
    contract_start_date TEXT,
    contract_end_date TEXT,
    other_contract_details TEXT
);

CREATE TABLE assets_maintenance.Parts (
    part_id INTEGER PRIMARY KEY,
    part_name TEXT,
    chargeable_yn TEXT,
    chargeable_amount TEXT,
    other_part_details TEXT
);

CREATE TABLE assets_maintenance.Skills (
    skill_id INTEGER PRIMARY KEY,
    skill_code TEXT,
    skill_description TEXT
);

CREATE TABLE assets_maintenance.Staff (
    staff_id INTEGER PRIMARY KEY,
    staff_name TEXT,
    gender TEXT,
    other_staff_details TEXT
);

CREATE TABLE assets_maintenance.Assets (
    asset_id INTEGER PRIMARY KEY,
    maintenance_contract_id INTEGER,
    supplier_company_id INTEGER,
    asset_details TEXT,
    asset_make TEXT,
    asset_model TEXT,
    asset_acquired_date TEXT,
    asset_disposed_date TEXT,
    other_asset_details TEXT
);

CREATE TABLE assets_maintenance.Asset_Parts (
    asset_id INTEGER,
    part_id INTEGER
);

CREATE TABLE assets_maintenance.Maintenance_Engineers (
    engineer_id INTEGER PRIMARY KEY,
    company_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    other_details TEXT
);

CREATE TABLE assets_maintenance.Engineer_Skills (
    engineer_id INTEGER,
    skill_id INTEGER
);

CREATE TABLE assets_maintenance.Fault_Log (
    fault_log_entry_id INTEGER PRIMARY KEY,
    asset_id INTEGER,
    recorded_by_staff_id INTEGER,
    fault_log_entry_datetime TEXT,
    fault_description TEXT,
    other_fault_details TEXT
);

CREATE TABLE assets_maintenance.Engineer_Visits (
    engineer_visit_id INTEGER PRIMARY KEY,
    contact_staff_id INTEGER,
    engineer_id INTEGER,
    fault_log_entry_id INTEGER,
    fault_status TEXT,
    visit_start_datetime TEXT,
    visit_end_datetime TEXT,
    other_visit_details TEXT
);

CREATE TABLE assets_maintenance.Part_Faults (
    part_fault_id INTEGER PRIMARY KEY,
    part_id INTEGER,
    fault_short_name TEXT,
    fault_description TEXT,
    other_fault_details TEXT
);

CREATE TABLE assets_maintenance.Fault_Log_Parts (
    fault_log_entry_id INTEGER,
    part_fault_id INTEGER,
    fault_status TEXT
);

CREATE TABLE assets_maintenance.Skills_Required_To_Fix (
    part_fault_id INTEGER,
    skill_id INTEGER
);

-- =======================
-- Foreign Keys
-- =======================

ALTER TABLE assets_maintenance.Maintenance_Contracts 
ADD CONSTRAINT fk_Maintenance_Contracts_maintenance_contract_company_id_to_Third_Party_Companies 
FOREIGN KEY (maintenance_contract_company_id) 
REFERENCES assets_maintenance.Third_Party_Companies(company_id);

ALTER TABLE assets_maintenance.Assets 
ADD CONSTRAINT fk_Assets_supplier_company_id_to_Third_Party_Companies 
FOREIGN KEY (supplier_company_id) 
REFERENCES assets_maintenance.Third_Party_Companies(company_id);

ALTER TABLE assets_maintenance.Assets 
ADD CONSTRAINT fk_Assets_maintenance_contract_id_to_Maintenance_Contracts 
FOREIGN KEY (maintenance_contract_id) 
REFERENCES assets_maintenance.Maintenance_Contracts(maintenance_contract_id);

ALTER TABLE assets_maintenance.Asset_Parts 
ADD CONSTRAINT fk_Asset_Parts_asset_id_to_Assets 
FOREIGN KEY (asset_id) 
REFERENCES assets_maintenance.Assets(asset_id);

ALTER TABLE assets_maintenance.Asset_Parts 
ADD CONSTRAINT fk_Asset_Parts_part_id_to_Parts 
FOREIGN KEY (part_id) 
REFERENCES assets_maintenance.Parts(part_id);

ALTER TABLE assets_maintenance.Maintenance_Engineers 
ADD CONSTRAINT fk_Maintenance_Engineers_company_id_to_Third_Party_Companies 
FOREIGN KEY (company_id) 
REFERENCES assets_maintenance.Third_Party_Companies(company_id);

ALTER TABLE assets_maintenance.Engineer_Skills 
ADD CONSTRAINT fk_Engineer_Skills_skill_id_to_Skills 
FOREIGN KEY (skill_id) 
REFERENCES assets_maintenance.Skills(skill_id);

ALTER TABLE assets_maintenance.Engineer_Skills 
ADD CONSTRAINT fk_Engineer_Skills_engineer_id_to_Maintenance_Engineers 
FOREIGN KEY (engineer_id) 
REFERENCES assets_maintenance.Maintenance_Engineers(engineer_id);

ALTER TABLE assets_maintenance.Fault_Log 
ADD CONSTRAINT fk_Fault_Log_recorded_by_staff_id_to_Staff 
FOREIGN KEY (recorded_by_staff_id) 
REFERENCES assets_maintenance.Staff(staff_id);

ALTER TABLE assets_maintenance.Fault_Log 
ADD CONSTRAINT fk_Fault_Log_asset_id_to_Assets 
FOREIGN KEY (asset_id) 
REFERENCES assets_maintenance.Assets(asset_id);

ALTER TABLE assets_maintenance.Engineer_Visits 
ADD CONSTRAINT fk_Engineer_Visits_contact_staff_id_to_Staff 
FOREIGN KEY (contact_staff_id) 
REFERENCES assets_maintenance.Staff(staff_id);

ALTER TABLE assets_maintenance.Engineer_Visits 
ADD CONSTRAINT fk_Engineer_Visits_engineer_id_to_Maintenance_Engineers 
FOREIGN KEY (engineer_id) 
REFERENCES assets_maintenance.Maintenance_Engineers(engineer_id);

ALTER TABLE assets_maintenance.Engineer_Visits 
ADD CONSTRAINT fk_Engineer_Visits_fault_log_entry_id_to_Fault_Log 
FOREIGN KEY (fault_log_entry_id) 
REFERENCES assets_maintenance.Fault_Log(fault_log_entry_id);

ALTER TABLE assets_maintenance.Part_Faults 
ADD CONSTRAINT fk_Part_Faults_part_id_to_Parts 
FOREIGN KEY (part_id) 
REFERENCES assets_maintenance.Parts(part_id);

ALTER TABLE assets_maintenance.Fault_Log_Parts 
ADD CONSTRAINT fk_Fault_Log_Parts_fault_log_entry_id_to_Fault_Log 
FOREIGN KEY (fault_log_entry_id) 
REFERENCES assets_maintenance.Fault_Log(fault_log_entry_id);

ALTER TABLE assets_maintenance.Fault_Log_Parts 
ADD CONSTRAINT fk_Fault_Log_Parts_part_fault_id_to_Part_Faults 
FOREIGN KEY (part_fault_id) 
REFERENCES assets_maintenance.Part_Faults(part_fault_id);

ALTER TABLE assets_maintenance.Skills_Required_To_Fix 
ADD CONSTRAINT fk_Skills_Required_To_Fix_skill_id_to_Skills 
FOREIGN KEY (skill_id) 
REFERENCES assets_maintenance.Skills(skill_id);

ALTER TABLE assets_maintenance.Skills_Required_To_Fix 
ADD CONSTRAINT fk_Skills_Required_To_Fix_part_fault_id_to_Part_Faults 
FOREIGN KEY (part_fault_id) 
REFERENCES assets_maintenance.Part_Faults(part_fault_id);