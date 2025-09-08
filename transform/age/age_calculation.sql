SELECT 
    last_name, 
    birth_date,
    CASE 
        WHEN EXTRACT(MONTH FROM CURRENT_DATE) > EXTRACT(MONTH FROM birth_date) 
             OR (EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM birth_date) 
                 AND EXTRACT(DAY FROM CURRENT_DATE) >= EXTRACT(DAY FROM birth_date)) 
        THEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date)
        ELSE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date) - 1 
    END AS age_years
FROM people 
ORDER BY age_years DESC, last_name, first_name;


-- OR birthdays coming up in the next 30 days
SELECT 
    id, 
    first_name, 
    last_name, 
    birth_date,
    CASE 
        WHEN EXTRACT(MONTH FROM CURRENT_DATE) > EXTRACT(MONTH FROM birth_date) 
             OR (EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM birth_date) 
                 AND EXTRACT(DAY FROM CURRENT_DATE) >= EXTRACT(DAY FROM birth_date)) 
        THEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date)
        ELSE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date) - 1 
    END AS current_age,
    -- Calculate this year's birthday
    MAKE_DATE(
        EXTRACT(YEAR FROM CURRENT_DATE), 
        EXTRACT(MONTH FROM birth_date), 
        EXTRACT(DAY FROM birth_date)
    ) AS this_year_birthday,
    -- Calculate next birthday (this year or next year)
    CASE 
        WHEN MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE), 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        ) >= CURRENT_DATE
        THEN MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE), 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        )
        ELSE MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE) + 1, 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        )
    END AS next_birthday,
    -- Days until next birthday
    CASE 
        WHEN MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE), 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        ) >= CURRENT_DATE
        THEN MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE), 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        ) - CURRENT_DATE
        ELSE MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE) + 1, 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        ) - CURRENT_DATE
    END AS days_until_birthday,
    address, 
    city, 
    state, 
    zip_code 
FROM people 
WHERE 
    -- Filter for birthdays in the next 30 days
    CASE 
        WHEN MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE), 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        ) >= CURRENT_DATE
        THEN MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE), 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        ) - CURRENT_DATE
        ELSE MAKE_DATE(
            EXTRACT(YEAR FROM CURRENT_DATE) + 1, 
            EXTRACT(MONTH FROM birth_date), 
            EXTRACT(DAY FROM birth_date)
        ) - CURRENT_DATE
    END <= 30
ORDER BY days_until_birthday, last_name, first_name;