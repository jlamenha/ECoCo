-- Database: movie_1

CREATE TABLE movie_1.Movie (
    mID INTEGER PRIMARY KEY,
    title TEXT,
    year INTEGER,
    director TEXT
);

CREATE TABLE movie_1.Reviewer (
    rID INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE movie_1.Rating (
    rID INTEGER,
    mID INTEGER,
    stars INTEGER,
    ratingDate TEXT
);

ALTER TABLE movie_1.Rating ADD CONSTRAINT fk_Rating_rID_to_Reviewer FOREIGN KEY (rID) REFERENCES movie_1.Reviewer(rID);

ALTER TABLE movie_1.Rating ADD CONSTRAINT fk_Rating_mID_to_Movie FOREIGN KEY (mID) REFERENCES movie_1.Movie(mID);

