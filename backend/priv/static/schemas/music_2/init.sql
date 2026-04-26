-- Database: music_2

CREATE TABLE music_2.Songs (
    SongId INTEGER PRIMARY KEY,
    Title TEXT
);

CREATE TABLE music_2.Albums (
    AId INTEGER PRIMARY KEY,
    Title TEXT,
    Year INTEGER,
    Label TEXT,
    Type TEXT
);

CREATE TABLE music_2.Band (
    Id INTEGER PRIMARY KEY,
    Firstname TEXT,
    Lastname TEXT
);

CREATE TABLE music_2.Instruments (
    SongId INTEGER PRIMARY KEY,
    BandmateId INTEGER,
    Instrument TEXT
);

CREATE TABLE music_2.Performance (
    SongId INTEGER PRIMARY KEY,
    Bandmate INTEGER,
    StagePosition TEXT
);

CREATE TABLE music_2.Tracklists (
    AlbumId INTEGER PRIMARY KEY,
    Position INTEGER,
    SongId INTEGER
);

CREATE TABLE music_2.Vocals (
    SongId INTEGER PRIMARY KEY,
    Bandmate INTEGER,
    Type TEXT
);

ALTER TABLE music_2.Instruments ADD CONSTRAINT fk_Instruments_BandmateId_to_Band FOREIGN KEY (BandmateId) REFERENCES music_2.Band(Id);

ALTER TABLE music_2.Instruments ADD CONSTRAINT fk_Instruments_SongId_to_Songs FOREIGN KEY (SongId) REFERENCES music_2.Songs(SongId);

ALTER TABLE music_2.Performance ADD CONSTRAINT fk_Performance_Bandmate_to_Band FOREIGN KEY (Bandmate) REFERENCES music_2.Band(Id);

ALTER TABLE music_2.Performance ADD CONSTRAINT fk_Performance_SongId_to_Songs FOREIGN KEY (SongId) REFERENCES music_2.Songs(SongId);

ALTER TABLE music_2.Tracklists ADD CONSTRAINT fk_Tracklists_AlbumId_to_Albums FOREIGN KEY (AlbumId) REFERENCES music_2.Albums(AId);

ALTER TABLE music_2.Tracklists ADD CONSTRAINT fk_Tracklists_SongId_to_Songs FOREIGN KEY (SongId) REFERENCES music_2.Songs(SongId);

ALTER TABLE music_2.Vocals ADD CONSTRAINT fk_Vocals_Bandmate_to_Band FOREIGN KEY (Bandmate) REFERENCES music_2.Band(Id);

ALTER TABLE music_2.Vocals ADD CONSTRAINT fk_Vocals_SongId_to_Songs FOREIGN KEY (SongId) REFERENCES music_2.Songs(SongId);

