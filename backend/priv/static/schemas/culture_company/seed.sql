-- culture_company.book_club
INSERT INTO culture_company.book_club (book_club_id, Year, Author_or_Editor, Book_Title, Publisher, Category, Result) VALUES
(1, 2015, 'Diane Reichel', 'Stillicidium denique cruciamentum conicio suspendo decens', 'Penguin Random House', 'Science Fiction', 'Shortlisted'),
(2, 1996, 'Mrs. Kristie Nicolas', 'Suppono commodi conturbo calco claudeo', 'Wiley', 'Fiction', 'Nominee'),
(3, 2005, 'Jeannette Kautzer DVM', 'Quia ancilla comes cuppedia', 'Cambridge University Press', 'Mystery', 'Nominee'),
(4, 2025, 'Lionel Shanahan', 'Conicio cognomen cur stabilis', 'Cambridge University Press', 'Biography', 'Shortlisted'),
(5, 2011, 'Maurice Boehm', 'Autem mollitia allatus', 'Cambridge University Press', 'History', 'Shortlisted'),
(6, 1990, 'Kelly Cremin', 'Stultus iste creta', 'Bloomsbury', 'Romance', 'Nominee'),
(7, 1991, 'Jaime Ziemann', 'Optio stultus arcus cubitum caput', 'Hachette', 'Biography', 'Shortlisted'),
(8, 1993, 'Francis Stamm', 'Creo comes considero assumenda tricesimus confido', 'Scholastic', 'Biography', 'Shortlisted'),
(9, 1990, 'Ted Greenholt', 'Vorago causa magni timor cruentus suus', 'HarperCollins', 'Biography', 'Longlisted'),
(10, 2025, 'Jenna Klein', 'Clibanus vestigium', 'Scholastic', 'Science Fiction', 'Longlisted'),
(11, 2016, 'Miss Minnie Cummerata', 'Sono amoveo sono', 'Cambridge University Press', 'History', 'Nominee'),
(12, 2005, 'Dr. Kenny McCullough', 'Tandem natus tantillus ager unde trado', 'Bloomsbury', 'Non-Fiction', 'Winner'),
(13, 1994, 'Jeannette Cartwright', 'Delibero titulus absens ipsam vicissitudo non', 'Simon & Schuster', 'History', 'Nominee'),
(14, 2014, 'Mandy Rodriguez', 'Illo aeger', 'Wiley', 'Fantasy', 'Longlisted'),
(15, 2010, 'Mrs. Meredith Beatty', 'Tertius cupiditas denique attonbitus', 'Hachette', 'Romance', 'Winner'),
(16, 2005, 'Dennis VonRueden', 'Desipio combibo adiuvo carbo', 'Penguin Random House', 'Non-Fiction', 'Longlisted'),
(17, 2022, 'Eunice Lindgren-Murazik', 'Voveo corrupti alo deinde', 'Bloomsbury', 'Mystery', 'Longlisted'),
(18, 2018, 'Jo Jenkins', 'Soleo uredo acies cenaculum desipio aegre', 'Bloomsbury', 'Non-Fiction', 'Nominee'),
(19, 1997, 'Dixie Nicolas', 'Abscido copiose explicabo', 'HarperCollins', 'Biography', 'Nominee'),
(20, 2012, 'Dr. Sonja Champlin', 'Volup ut sulum vitae curtus', 'Cambridge University Press', 'Mystery', 'Longlisted')
;

-- culture_company.movie
INSERT INTO culture_company.movie (movie_id, Title, Year, Director, Budget_million, Gross_worldwide) VALUES
(1, 'Vilicus', 2019, 'Caleb Armstrong', 6, 178),
(2, 'Utique', 2003, 'Kerry Marquardt', 78, 843),
(3, 'Vicissitudo ocer', 2024, 'Jesus Kshlerin I', 17, 819),
(4, 'Umquam acquiro', 2023, 'Ted Schulist', 90, 786),
(5, 'Corporis carbo viduo ver', 2002, 'Dwayne Hauck', 222, 1647),
(6, 'Vitiosus curo caries', 1994, 'Catherine Mitchell', 143, 390),
(7, 'Bibo chirographum talis', 2010, 'Lana Veum', 62, 1496),
(8, 'Averto tracto delego tergum', 1998, 'Tricia Rutherford', 55, 947),
(9, 'Spero absconditus alias conor', 2023, 'Elsa Ebert', 58, 1693),
(10, 'Cibus vicissitudo', 2001, 'Andre Kub', 13, 91),
(11, 'Vinitor quae', 2003, 'Mr. Dana Hettinger', 78, 1901),
(12, 'Commodi voluptas votum cunabula', 2013, 'Eleanor Gislason', 103, 378),
(13, 'Ambulo quibusdam decimus curriculum', 2003, 'Dr. Ed VonRueden', 133, 227),
(14, 'Tui', 2004, 'Travis Ankunding', 179, 1850),
(15, 'Corrupti illo', 2020, 'Dean Collier', 155, 485),
(16, 'Consectetur chirographum vulticulus', 1991, 'Alvin Fay', 164, 1468),
(17, 'Admoneo claustrum defendo', 2000, 'Carlos Yundt I', 5, 1962),
(18, 'Verto cupressus tam benevolentia', 2004, 'Cameron Kunze', 80, 1835),
(19, 'Thymum umquam vesco', 2000, 'Loretta Watsica', 122, 1238),
(20, 'Vulgivagus altus', 1997, 'Cathy Satterfield', 13, 1966)
;

-- culture_company.culture_company
INSERT INTO culture_company.culture_company (Company_name, Type, Incorporated_in, Group_Equity_Shareholding, book_club_id, movie_id) VALUES
('Beer LLC', 'Publishing', 'UK', 57, 15, 14),
('Leffler - Lind', 'Broadcasting', 'France', 80, 13, 1),
('Stoltenberg LLC', 'Production', 'Japan', 76, 3, 17),
('Lesch - Howe', 'Publishing', 'Australia', 4, 16, 11),
('Lebsack, Barton and Conroy', 'Broadcasting', 'Germany', 45, 7, 6),
('Kemmer, Torp and O''Conner', 'Streaming', 'Spain', 96, 14, 17),
('Moen, Raynor and Rau', 'Production', 'Japan', 80, 5, 10),
('Jacobson Group', 'Distribution', 'Germany', 67, 11, 1),
('Prohaska - Quigley', 'Streaming', 'Spain', 47, 13, 10),
('Hodkiewicz - Braun', 'Broadcasting', 'UK', 48, 20, 1),
('Gusikowski - Weissnat', 'Streaming', 'UK', 99, 16, 11),
('Thompson, Huel and O''Reilly', 'Broadcasting', 'France', 18, 10, 6),
('Wilkinson Inc', 'Broadcasting', 'France', 100, 14, 4),
('Welch - Welch', 'Broadcasting', 'USA', 23, 17, 18),
('Hickle Inc', 'Production', 'UK', 96, 17, 4)
;
