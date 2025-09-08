-- SQL Script to Calculate Age from Birth Date
-- This script assumes the CSV data has been loaded into a table called 'people'

-- Method 1: Using DATEDIFF and accounting for whether birthday has occurred this year
SELECT 
    id,
    first_name,
    last_name,
    birth_date,
    CASE 
        WHEN MONTH(CURDATE()) > MONTH(birth_date) 
             OR (MONTH(CURDATE()) = MONTH(birth_date) AND DAY(CURDATE()) >= DAY(birth_date))
        THEN YEAR(CURDATE()) - YEAR(birth_date)
        ELSE YEAR(CURDATE()) - YEAR(birth_date) - 1
    END AS age_years,
    address,
    city,
    state,
    zip_code
FROM people
ORDER BY age_years DESC, last_name, first_name;

-- Method 2: Alternative calculation using TIMESTAMPDIFF (MySQL/MariaDB)
SELECT 
    id,
    first_name,
    last_name,
    birth_date,
    TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) AS age_years,
    address,
    city,
    state,
    zip_code
FROM people
ORDER BY age_years DESC, last_name, first_name;

-- Method 3: PostgreSQL version using AGE function
SELECT 
    id,
    first_name,
    last_name,
    birth_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, birth_date)) AS age_years,
    address,
    city,
    state,
    zip_code
FROM people
ORDER BY age_years DESC, last_name, first_name;

-- Method 4: SQL Server version using DATEDIFF
SELECT 
    id,
    first_name,
    last_name,
    birth_date,
    CASE 
        WHEN MONTH(GETDATE()) > MONTH(birth_date) 
             OR (MONTH(GETDATE()) = MONTH(birth_date) AND DAY(GETDATE()) >= DAY(birth_date))
        THEN YEAR(GETDATE()) - YEAR(birth_date)
        ELSE YEAR(GETDATE()) - YEAR(birth_date) - 1
    END AS age_years,
    address,
    city,
    state,
    zip_code
FROM people
ORDER BY age_years DESC, last_name, first_name;

-- Additional query: Show age statistics
SELECT 
    COUNT(*) as total_people,
    MIN(CASE 
        WHEN MONTH(CURDATE()) > MONTH(birth_date) 
             OR (MONTH(CURDATE()) = MONTH(birth_date) AND DAY(CURDATE()) >= DAY(birth_date))
        THEN YEAR(CURDATE()) - YEAR(birth_date)
        ELSE YEAR(CURDATE()) - YEAR(birth_date) - 1
    END) AS youngest_age,
    MAX(CASE 
        WHEN MONTH(CURDATE()) > MONTH(birth_date) 
             OR (MONTH(CURDATE()) = MONTH(birth_date) AND DAY(CURDATE()) >= DAY(birth_date))
        THEN YEAR(CURDATE()) - YEAR(birth_date)
        ELSE YEAR(CURDATE()) - YEAR(birth_date) - 1
    END) AS oldest_age,
    ROUND(AVG(CASE 
        WHEN MONTH(CURDATE()) > MONTH(birth_date) 
             OR (MONTH(CURDATE()) = MONTH(birth_date) AND DAY(CURDATE()) >= DAY(birth_date))
        THEN YEAR(CURDATE()) - YEAR(birth_date)
        ELSE YEAR(CURDATE()) - YEAR(birth_date) - 1
    END), 1) AS average_age
FROM people;

-- Query to find people with birthdays in the next 30 days
SELECT 
    first_name,
    last_name,
    birth_date,
    CASE 
        WHEN MONTH(CURDATE()) > MONTH(birth_date) 
             OR (MONTH(CURDATE()) = MONTH(birth_date) AND DAY(CURDATE()) >= DAY(birth_date))
        THEN YEAR(CURDATE()) - YEAR(birth_date)
        ELSE YEAR(CURDATE()) - YEAR(birth_date) - 1
    END AS current_age,
    CASE 
        WHEN DATE_FORMAT(birth_date, '%m-%d') >= DATE_FORMAT(CURDATE(), '%m-%d')
        THEN DATE_ADD(DATE_FORMAT(birth_date, CONCAT(YEAR(CURDATE()), '-%m-%d')), INTERVAL 0 DAY)
        ELSE DATE_ADD(DATE_FORMAT(birth_date, CONCAT(YEAR(CURDATE()) + 1, '-%m-%d')), INTERVAL 0 DAY)
    END AS next_birthday
FROM people
WHERE 
    CASE 
        WHEN DATE_FORMAT(birth_date, '%m-%d') >= DATE_FORMAT(CURDATE(), '%m-%d')
        THEN DATEDIFF(DATE_FORMAT(birth_date, CONCAT(YEAR(CURDATE()), '-%m-%d')), CURDATE())
        ELSE DATEDIFF(DATE_FORMAT(birth_date, CONCAT(YEAR(CURDATE()) + 1, '-%m-%d')), CURDATE())
    END <= 30
ORDER BY next_birthday;