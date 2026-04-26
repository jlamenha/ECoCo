-- Database: music_4

CREATE TABLE music_4.artist (
    Artist_ID INTEGER PRIMARY KEY,
    Artist TEXT,
    Age INTEGER,
    Famous_Title TEXT,
    Famous_Release_date TEXT
);

CREATE TABLE music_4.volume (
    Volume_ID INTEGER PRIMARY KEY,
    Volume_Issue TEXT,
    Issue_Date TEXT,
    Weeks_on_Top INTEGER,
    Song TEXT,
    Artist_ID INTEGER
);

CREATE TABLE music_4.music_festival (
    ID INTEGER PRIMARY KEY,
    Music_Festival TEXT,
    Date_of_ceremony TEXT,
    Category TEXT,
    Volume INTEGER,
    Result TEXT
);

ALTER TABLE music_4.volume ADD CONSTRAINT fk_volume_Artist_ID_to_artist FOREIGN KEY (Artist_ID) REFERENCES music_4.artist(Artist_ID);

ALTER TABLE music_4.music_festival ADD CONSTRAINT fk_music_festival_Volume_to_volume FOREIGN KEY (Volume) REFERENCES music_4.volume(Volume_ID);

