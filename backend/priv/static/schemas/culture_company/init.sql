-- Database: culture_company

CREATE TABLE culture_company.book_club (
    book_club_id INTEGER PRIMARY KEY,
    Year INTEGER,
    Author_or_Editor TEXT,
    Book_Title TEXT,
    Publisher TEXT,
    Category TEXT,
    Result TEXT
);

CREATE TABLE culture_company.movie (
    movie_id INTEGER PRIMARY KEY,
    Title TEXT,
    Year INTEGER,
    Director TEXT,
    Budget_million INTEGER,
    Gross_worldwide INTEGER
);

CREATE TABLE culture_company.culture_company (
    Company_name TEXT PRIMARY KEY,
    Type TEXT,
    Incorporated_in TEXT,
    Group_Equity_Shareholding INTEGER,
    book_club_id INTEGER,
    movie_id INTEGER
);

ALTER TABLE culture_company.culture_company ADD CONSTRAINT fk_culture_company_movie_id_to_movie FOREIGN KEY (movie_id) REFERENCES culture_company.movie(movie_id);

ALTER TABLE culture_company.culture_company ADD CONSTRAINT fk_culture_company_book_club_id_to_book_club FOREIGN KEY (book_club_id) REFERENCES culture_company.book_club(book_club_id);

