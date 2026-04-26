-- Database: music_1

CREATE TABLE music_1.genre (
    g_name TEXT PRIMARY KEY,
    rating TEXT,
    most_popular_in TEXT
);

CREATE TABLE music_1.artist (
    artist_name TEXT PRIMARY KEY,
    country TEXT,
    gender TEXT,
    preferred_genre TEXT
);

CREATE TABLE music_1.files (
    f_id INTEGER PRIMARY KEY,
    artist_name TEXT,
    file_size TEXT,
    duration TEXT,
    formats TEXT
);

CREATE TABLE music_1.song (
    song_name TEXT PRIMARY KEY,
    artist_name TEXT,
    country TEXT,
    f_id INTEGER,
    genre_is TEXT,
    rating INTEGER,
    languages TEXT,
    releasedate TEXT,
    resolution INTEGER
);

ALTER TABLE music_1.artist ADD CONSTRAINT fk_artist_preferred_genre_to_genre FOREIGN KEY (preferred_genre) REFERENCES music_1.genre(g_name);

ALTER TABLE music_1.files ADD CONSTRAINT fk_files_artist_name_to_artist FOREIGN KEY (artist_name) REFERENCES music_1.artist(artist_name);

ALTER TABLE music_1.song ADD CONSTRAINT fk_song_genre_is_to_genre FOREIGN KEY (genre_is) REFERENCES music_1.genre(g_name);

ALTER TABLE music_1.song ADD CONSTRAINT fk_song_f_id_to_files FOREIGN KEY (f_id) REFERENCES music_1.files(f_id);

ALTER TABLE music_1.song ADD CONSTRAINT fk_song_artist_name_to_artist FOREIGN KEY (artist_name) REFERENCES music_1.artist(artist_name);

