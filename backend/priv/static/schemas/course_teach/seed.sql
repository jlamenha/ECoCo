-- course_teach.course
INSERT INTO course_teach.course (Course_ID, Staring_Date, Course) VALUES
(1, '09/09/2021', 'English'),
(2, '07/21/2022', 'Mathematics'),
(3, '12/20/2022', 'History'),
(4, '05/10/2024', 'Biology'),
(5, '06/02/2022', 'Chemistry'),
(6, '09/06/2021', 'Physics'),
(7, '07/15/2023', 'Geography'),
(8, '11/21/2023', 'Art'),
(9, '09/10/2022', 'Music'),
(10, '03/09/2023', 'Physical Education'),
(11, '02/13/2022', 'Computer Science'),
(12, '06/12/2021', 'Economics'),
(13, '06/26/2025', 'Philosophy'),
(14, '07/18/2020', 'Psychology'),
(15, '04/12/2025', 'Literature'),
(16, '04/14/2025', 'Statistics'),
(17, '07/18/2020', 'Sociology'),
(18, '10/17/2023', 'Political Science'),
(19, '05/09/2022', 'Foreign Language'),
(20, '09/25/2023', 'Drama')
;

-- course_teach.teacher
INSERT INTO course_teach.teacher (Teacher_ID, Name, Age, Hometown) VALUES
(1, 'Dr. Lance Padberg', '56', 'Little Rock'),
(2, 'Daisy Boyer V', '54', 'Phoenix'),
(3, 'Loretta Cronin', '53', 'Denver'),
(4, 'Melinda Howell PhD', '39', 'Hartford'),
(5, 'Miss Evelyn Purdy DDS', '49', 'Dover'),
(6, 'Charlie Fisher', '46', 'Atlanta'),
(7, 'Brandon Hand', '59', 'Honolulu'),
(8, 'Samuel Halvorson', '32', 'Boise'),
(9, 'Floyd Mayert', '25', 'Springfield'),
(10, 'Ted Greenholt', '61', 'Indianapolis'),
(11, 'Donald Schoen', '54', 'Des Moines'),
(12, 'Louise Wyman', '42', 'Topeka'),
(13, 'Joanne Botsford', '63', 'Frankfort'),
(14, 'Jacob Robel', '54', 'Baton Rouge'),
(15, 'Claude Grant', '52', 'Augusta')
;

-- course_teach.course_arrange
INSERT INTO course_teach.course_arrange (Course_ID, Teacher_ID, Grade) VALUES
(1, 2, 4),
(2, 14, 5),
(3, 7, 3),
(4, 12, 4),
(5, 2, 4),
(6, 13, 3),
(7, 14, 5),
(8, 9, 5),
(9, 2, 6),
(10, 13, 6),
(11, 2, 1),
(12, 3, 3),
(13, 7, 4),
(14, 2, 2),
(15, 13, 3),
(16, 13, 1),
(17, 9, 6),
(18, 9, 2),
(19, 11, 3),
(20, 11, 1)
;
