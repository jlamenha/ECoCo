-- architecture.architect
INSERT INTO architecture.architect (id, name, nationality, gender) VALUES
(1, 'Erma Lubowitz', 'American', 'female'),
(2, 'Wilfred Kshlerin', 'British', 'male'),
(3, 'Orville Beier', 'French', 'male'),
(4, 'Constance Lemke', 'German', 'female'),
(5, 'Sandra Moore', 'Italian', 'female'),
(6, 'Gabriel Greenholt', 'Spanish', 'male'),
(7, 'Hugo Kunde', 'Dutch', 'male'),
(8, 'Howard Welch', 'Japanese', 'male'),
(9, 'Miss Bridget Johns', 'Canadian', 'female'),
(10, 'William Moore', 'Swiss', 'male'),
(11, 'Lucia Heathcote', 'Swedish', 'female'),
(12, 'Merle Langosh', 'Danish', 'male'),
(13, 'Mable Spinka', 'Australian', 'female'),
(14, 'Doris Marquardt', 'Brazilian', 'female'),
(15, 'Madeline Armstrong', 'Chinese', 'female')
;

-- architecture.bridge
INSERT INTO architecture.bridge (id, architect_id, name, location, length_meters, length_feet) VALUES
(1, 3, 'Maurice Gateway Bridge', 'Istanbul', 1405, 4610),
(2, 6, 'Tower Road Bridge', 'Tokyo', 1399, 4590),
(3, 5, 'Purdy Wells Bridge', 'Tokyo', 137, 449),
(4, 9, 'Church Hill Bridge', 'Tokyo', 1914, 6280),
(5, 6, 'Orn Common Bridge', 'London', 625, 2051),
(6, 10, 'N Union Street Bridge', 'Budapest', 825, 2707),
(7, 5, 'D''Amore Station Bridge', 'Tokyo', 980, 3215),
(8, 9, 'Abernathy Ways Bridge', 'Venice', 1394, 4573),
(9, 5, 'Turcotte Way Bridge', 'San Francisco', 543, 1781),
(10, 13, 'Renner Crossing Bridge', 'Prague', 1424, 4672),
(11, 15, 'Hilda Estate Bridge', 'Berlin', 2169, 7116),
(12, 2, 'Timmy Mountain Bridge', 'Berlin', 1383, 4537),
(13, 12, 'Melody Stream Bridge', 'Paris', 1891, 6204),
(14, 5, 'Malvina Corner Bridge', 'Prague', 1959, 6427),
(15, 11, 'Kessler Run Bridge', 'Amsterdam', 2223, 7293),
(16, 9, 'Hall Lane Bridge', 'Venice', 239, 784),
(17, 9, 'Birch Avenue Bridge', 'Budapest', 1885, 6184),
(18, 14, 'Arnaldo Cove Bridge', 'Tokyo', 2059, 6755),
(19, 9, 'Colleen Spurs Bridge', 'Rome', 1078, 3537),
(20, 1, 'Waters Orchard Bridge', 'San Francisco', 2026, 6647),
(21, 6, '8th Avenue Bridge', 'Prague', 1803, 5915),
(22, 12, 'Cartwright Mill Bridge', 'London', 109, 358),
(23, 15, 'North Road Bridge', 'London', 1644, 5394),
(24, 10, 'Payton Manors Bridge', 'Berlin', 1759, 5771),
(25, 7, 'Davis Gateway Bridge', 'Budapest', 1977, 6486)
;

-- architecture.mill
INSERT INTO architecture.mill (id, architect_id, name, location, type, built_year, notes) VALUES
(1, 3, 'Yundt Ferry Mill', 'Tuscaloosa, Belize', 'Tidal Mill', 1801, 'Adiuvo carbo allatus capitulus timor.'),
(2, 14, 'Elissa Way Mill', 'Lisettetown, Kuwait', 'Tower Mill', 1762, 'Deinde vix congregatio.'),
(3, 12, 'Devonshire Road Mill', 'Michelview, Cocos (Keeling) Islands', 'Tower Mill', 1845, 'Acies cenaculum desipio aegre vulgo capillus corrumpo benigne amiculum.'),
(4, 4, 'Lorenzo Forge Mill', 'North Freddie, Madagascar', 'Windmill', 1829, 'Ratione acquiro valens acceptus antepono.'),
(5, 12, 'Merl Walks Mill', 'Port Orange, Uzbekistan', 'Tidal Mill', 1912, 'Vetus arcesso vilicus tristis tyrannus.'),
(6, 2, 'Armstrong Rest Mill', 'North Daneside, Guam', 'Post Mill', 1820, 'Mollitia solvo coadunatio curatio.'),
(7, 7, 'Old Military Road Mill', 'Midwest City, Lebanon', 'Windmill', 1794, 'Avarus admoveo cum corroboro umquam acquiro verumtamen stabilis ventito pectus.'),
(8, 13, 'Heller Hollow Mill', 'Hillsburgh, United Arab Emirates', 'Tower Mill', 1754, 'Certus basium conduco compello vaco traho sui vitiosus.'),
(9, 7, 'Bianka Fort Mill', 'North Ledabury, Mauritania', 'Watermill', 1853, 'Chirographum talis laborum conculco.'),
(10, 9, 'W Market Street Mill', 'Darlenefort, San Marino', 'Watermill', 1896, 'Tergum capio concedo viriliter solus terebro.'),
(11, 11, 'Janie Spur Mill', 'Abshireland, Greece', 'Tower Mill', 1797, 'Contra bene curiositas blandior tutis.'),
(12, 7, 'Torrance Gardens Mill', 'Athens-Clarke County, Pitcairn Islands', 'Tidal Mill', 1783, 'Adhaero concedo vinitor.'),
(13, 10, 'Moore Estates Mill', 'West Salmamouth, Falkland Islands (Malvinas)', 'Tower Mill', 1895, 'Voluptas votum cunabula sollicito cultura.'),
(14, 4, 'Diana Fords Mill', 'East Velma, Bhutan', 'Post Mill', 1782, 'Corrigo ustilo cicuta accusator versus urbs.'),
(15, 5, 'Brekke Cliffs Mill', 'Huntington Beach, North Macedonia', 'Tower Mill', 1723, 'Acidus sui vesper.'),
(16, 8, 'Littel Terrace Mill', 'Feestfort, Brunei Darussalam', 'Windmill', 1834, 'Sufficio consectetur chirographum vulticulus.'),
(17, 1, 'Batz Rue Mill', 'North Lyla, Romania', 'Smock Mill', 1665, 'Defendo cito tollo aperte perspiciatis.'),
(18, 15, 'E 4th Avenue Mill', 'Fort Shanyshire, India', 'Smock Mill', 1714, 'Ullus antiquus varietas derideo cursim cohaero.'),
(19, 14, 'Schneider Terrace Mill', 'Farmington Hills, Ghana', 'Post Mill', 1782, 'Cubicularis demulceo provident cultellus vulgivagus altus bos commodi arceo ciminatio.'),
(20, 12, 'Barton Way Mill', 'Beerchester, Guinea-Bissau', 'Windmill', 1819, 'Speciosus carmen esse fugiat sunt contigo thema quisquam.')
;
