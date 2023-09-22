-- QUESTIONS
use projects;
-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count
FROM hrs
WHERE age>=18 AND termdate is NULL
GROUP BY gender;
SELECT* FROM hrs;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, count(*) AS count
 FROM hrs
 WHERE age>=18 AND termdate is NULL
GROUP BY race
ORDER BY count(*) DESC;

-- 3. What is the age distribution of employees in the company?
SELECT
MIN(age) AS youngest,
MAX(age) AS oldest
FROM hrs
 WHERE age>=18 AND termdate is NULL;
 
 SELECT
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
  END AS age_group,
  COUNT(*) AS count
FROM hrs
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;


 SELECT
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+'
  END AS age_group, gender, 
  COUNT(*) AS count
FROM hrs
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;


-- 4. How many employees work at headquarters versus remote locations?
SELECT location, count(*) AS count
FROM hrs
WHERE age>=18 and termdate IS NULL
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
 round(avg(datediff(termdate, hire_date))/360,0) AS avg_length_employment
FROM hrs
WHERE termdate IS NOT NULL AND termdate<=curdate() and age>=18;


SELECT
    location,
  round( AVG(DATEDIFF(termdate, hire_date))) AS avg_employment_length
FROM hrs
WHERE termdate IS NOT NULL
GROUP BY location;


-- 6. How does the gender distribution vary across departments and job titles?
   SELECT
    department,
    gender,
    COUNT(*) AS count_in_group,
    COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY department) AS gender_percentage
FROM hrs
GROUP BY department, gender
ORDER BY department, gender;

-- 7. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS title_count
FROM hrs
WHERE age>=18 AND termdate IS NULL
GROUP BY jobtitle
ORDER BY title_count DESC;

-- 8. Which department has the highest turnover rate?

SELECT
    department,
    COUNT(CASE WHEN termdate IS NOT NULL THEN 1 ELSE NULL END) AS termination_count,
    COUNT(*) AS total_count,
    (COUNT(CASE WHEN termdate IS NOT NULL THEN 1 ELSE NULL END) * 1.0 / COUNT(*)) * 100 AS turnover_rate
FROM hrs
WHERE age>=18 
GROUP BY department
ORDER BY turnover_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, count(*) AS count
FROM hrs
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
SELECT 
year,
hires,
terminations,
hires-terminations AS net_change,
round((hires-terminations)/hires *100,2) AS net_change_percent
FROM (
SELECT
year(hire_date)AS year,
count(*) AS hires,
sum(CASE WHEN termdate IS NOT NULL AND termdate<=curdate()THEN 1 ELSE 0 END) AS terminations
FROM hrs
WHERE age>=18
GROUP BY year(hire_date)
)AS subquery
ORDER BY year ASC;

-- 11. What is the tenure distribution for each department?
SELECT department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
FROM hrs
WHERE termdate<=curdate() AND termdate IS NOT NULL AND age>=18
GROUP BY department;