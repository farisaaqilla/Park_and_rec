SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT first_name, last_name, age, age + 10 AS ages
FROM parks_and_recreation.employee_demographics;

-- DISTINCT (Show unique value without repetition)
SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;

-- WHERE clause (show data with specific condition)
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

-- 'AND, OR, NOT' logical operators
SELECT * 
FROM employee_demographics
WHERE gender != 'female'
AND birth_date > '1985-01-01';

SELECT * 
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55;

-- LIKE statement,
-- '%' (anything) and '_' (specific value)
SELECT * 
FROM employee_demographics
WHERE first_name LIKE '%a%';

SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'a__';

SELECT * 
FROM employee_demographics
WHERE first_name LIKE 'a__%';

-- Group By (group together any rows with the same value stored in them, needed before using aggregate function like AVG, MAX etc)
-- COUNT (to count how many values in column)
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary, dept_id
FROM employee_salary
GROUP BY occupation, salary, dept_id;

-- ORDER BY (arrange ascending or descending)
SELECT *
FROM employee_demographics
ORDER BY gender, age DESC;

-- HAVING  (set condition after grouping them, to filter aggregated functions)
SELECT occupation, avg (salary)
FROM employee_salary
GROUP BY occupation
HAVING AVG(salary) > 75000;

SELECT occupation, salary, avg (salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation, salary
HAVING AVG(salary) > 5000;

-- Limit (limit number of rows to be executed) (can also be used with 'ORDER BY')
SELECT * 
FROM employee_demographics
ORDER BY age DESC
LIMIT 3;

-- Limit with position (2,1 --> take 3 rows data after the first 2)
SELECT * 
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 3;

-- Aliasing
SELECT gender, AVG (age) as avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age> 40;

-- INNER JOIN (join 2 or more tables together)
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- if choose specific columns for 'SELECT', need to specify the tables for similar columns ('employee_id')
SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- OUTER JOINS (LEFT or RIGHT). table after 'FROM' is default as 'left table' 
-- LEFT JOINS (take all from left table and only what matches from right table)
SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- RIGHT JOINS (take all from right table and only what matches from left table)
SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

-- SELF JOIN (tie the table to itself)
SELECT * 
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id;

-- MULTIPLE JOINS
SELECT *
FROM parks_departments;

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
	ON sal.dept_id = pd.department_id
;

-- UNION (show all unique values, no duplicate) // UNION ALL (show all values)
SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION 
SELECT first_name, last_name,  'Highly Paid' AS Label
FROM employee_salary
WHERE salary > 70000;

-- STRING functions
SELECT first_name, LENGTH (first_name)
FROM employee_demographics
ORDER BY 2;

-- UPPER and LOWER
SELECT first_name, UPPER (last_name)
FROM employee_demographics;

-- TRIM (remove white space)
SELECT TRIM('             sky              ');

-- RTRIM (right trim) //  LTRIM (left trim)
SELECT LTRIM('             sky              ');

-- SUBSTRING (taking out specific number/word from the value)
SELECT first_name,
LEFT (first_name, 4), 
RIGHT (first_name, 4),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_month 
FROM employee_demographics;

-- REPLACE
SELECT first_name, REPLACE (first_name, 'a' , 'z')
FROM employee_demographics;

-- LOCATE (find location of values)
SELECT first_name, LOCATE ('An', first_name)
FROM employee_demographics;

-- CONCAT (combine words into one)
SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) AS Full_name
FROM employee_demographics;

-- CASE
SELECT first_name, last_name, age,
CASE 
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'Middle'
    WHEN age >= 50 THEN 'Old'
END AS Age_bracket
FROM employee_demographics;

-- SUBQUERIES (subquery exceuted first, then outside of subquery)
SELECT *
FROM employee_demographics
WHERE employee_id IN 
				(SELECT employee_id
                FROM employee_salary
                WHERE dept_id = 1)
;

-- CTEs (Common Table Expression) (similar to subquery concept but more readable//can do >1 subquery)
WITH CTE_Example AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id =  sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example
;

-- Temporary Table (create temporary table, will gone after a while)
CREATE TEMPORARY TABLE temp_table
(first_name varchar (50),
last_name varchar (50),
favorite_movie varchar (100)
);

-- Insert data into temporary table
INSERT INTO temp_table
VALUES ('Alex', 'Freberg', 'Lord of the Rings');

SELECT *
FROM temp_table;

-- Create temporary table from existing table
CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;

-- Stored Procedures (keep complex code and call if needed)
CREATE PROCEDURE large_salaries ()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries ();

-- DELIMITER (keep few codes in stored procedures. more like advance)
DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000; 
    SELECT *
	FROM employee_salary
	WHERE salary >= 10000; 
END $$
DELIMITER ;

CALL large_salaries3();
