-- Database: course_teach

CREATE TABLE course_teach.course (
    Course_ID INTEGER PRIMARY KEY,
    Staring_Date TEXT,
    Course TEXT
);

CREATE TABLE course_teach.teacher (
    Teacher_ID INTEGER PRIMARY KEY,
    Name TEXT,
    Age TEXT,
    Hometown TEXT
);

CREATE TABLE course_teach.course_arrange (
    Course_ID INTEGER PRIMARY KEY,
    Teacher_ID INTEGER,
    Grade INTEGER
);

ALTER TABLE course_teach.course_arrange ADD CONSTRAINT fk_course_arrange_Teacher_ID_to_teacher FOREIGN KEY (Teacher_ID) REFERENCES course_teach.teacher(Teacher_ID);

ALTER TABLE course_teach.course_arrange ADD CONSTRAINT fk_course_arrange_Course_ID_to_course FOREIGN KEY (Course_ID) REFERENCES course_teach.course(Course_ID);

