ALTER TABLE courses CHANGE course_number number decimal(4,0) NOT NULL;
ALTER TABLE courses DROP COLUMN title_changed;

ALTER TABLE courses_users CHANGE course_id course_id int(11) NOT NULL;
ALTER TABLE courses_users CHANGE user_id user_id int(11) NOT NULL;
ALTER TABLE courses_users ADD INDEX index_courses_users_on_course_id USING BTREE;
ALTER TABLE courses_users ADD INDEX index_courses_users_on_user_id USING BTREE;

ALTER TABLE day_times CHANGE day day varchar(255) NOT NULL;
ALTER TABLE day_times CHANGE start_time start_time varchar(255) NOT NULL;
ALTER TABLE day_times CHANGE end_time end_time varchar(255) NOT NULL;
