CREATE DATABASE projects;


use projects;
SELECT * FROM `human resources`;
SHOW TABLES;
RENAME TABLE human_resources TO hrs;

ALTER TABLE hrs
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

SET sql_safe_updates=0;
UPDATE hrs
SET birthdate =CASE
WHEN birthdate like '%/%' THEN date_format (str_to_date(birthdate, '%d/%m/%Y'), '%Y/%m/%d')
WHEN birthdate like '%-%' then date_format (str_to_date(birthdate, '%d-%m-%Y'), '%Y/%m/%d')
ELSE NULL
END; # change the way the date is before to my preferred choice that is from m-d-y to d-m-y

ALTER TABLE hrs 
MODIFY COLUMN birthdate DATE; #change the text format of birthdate to date 

UPDATE hrs
SET hire_date =CASE
WHEN  hire_date like '%/%' THEN date_format (str_to_date( hire_date, '%m/%d/%Y'), '%Y/%m/%d')
WHEN  hire_date like '%-%' then date_format (str_to_date( hire_date, '%m-%d-%Y'), '%Y/%m/%d')
ELSE NULL
END; # change the way the date is before to my preferred choice that is from m-d-y to d-m-y

ALTER TABLE hrs 
MODIFY COLUMN hire_date DATE; #change the text format of hire_date to date 

UPDATE hrs
SET termdate=date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s'))
WHERE termdate IS NOT NULL AND termdate= '00' AND termdate='';


UPDATE hrs
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate NOT IN ('00', '');

ALTER TABLE hrs 
MODIFY COLUMN termdate DATE; 

SELECT  age from hrs;
SELECT * FROM hrs;
DESCRIBE hrs;


UPDATE hrs
SET termdate = '0000-00-00'  -- Replace with your desired default date
WHERE termdate IS NOT NULL AND (termdate = '00' OR termdate = '');

UPDATE hrs
SET termdate = NULL
WHERE termdate = '0000-00-00'; # successfully convert the text format to date

ALTER TABLE hrs ADD COLUMN age INT;

UPDATE hrs 
SET age=timestampdiff(year, birthdate, curdate()); #subtract the current date from the birthdate to give the age column
 
 SELECT 
 MIN(age) AS youngest,
 MAX(AGE) AS oldest
 from hrs; # showing the min and max age in the data
