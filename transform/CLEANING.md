# Data Cleaning

The easy targets:

- **Missing Values**: Cells or entire records that are blank or contain placeholders for missing information. 
- **Inconsistent Formatting**: Differences in capitalization (e.g., "USA" vs. "usa"), units of measurement, or spelling variations for the same entity (e.g., "Street" vs. "St."). 
- **Duplicates**: Entire rows or records that appear more than once in the dataset. 

The more difficult:

- **Outliers**: Data points that are significantly different from other observations in the dataset, which may be errors or genuine anomalies. 
- **Inaccurate Data**: Values that are factually incorrect, such as a person's age being 200 years old or an invalid postcode. 
- **Incorrect Data Types**: Numerical data stored as text, dates in inconsistent formats, or categorical data mixed into a single field. 
- **Structural Errors**: (Complex to sort out) Issues with the structure of the data, such as incorrect column headers or data spread across multiple columns when it should be in one. 

## Missing Values

```
-- Check for NULL or empty values
SELECT COUNT(*) as missing_count
FROM your_table_name 
WHERE column_name IS NULL 
   OR column_name = '' 
   OR TRIM(column_name) = '';

-- View the rows
SELECT * 
FROM your_table_name 
WHERE column_name IS NULL 
   OR column_name = '' 
   OR TRIM(column_name) = '';
```

```
-- Delete rows with NULL or empty values
DELETE FROM your_table_name 
WHERE column_name IS NULL 
   OR column_name = '' 
   OR TRIM(column_name) = '';
```

## Inconsistent Formatting

State Abbreviations:

```
-- Check current inconsistent values first
SELECT state_abbreviation, COUNT(*) as count
FROM your_table_name 
GROUP BY state_abbreviation 
ORDER BY state_abbreviation;

-- Update to uppercase
UPDATE your_table_name 
SET state_abbreviation = UPPER(state_abbreviation)
WHERE state_abbreviation != UPPER(state_abbreviation);
```

Email:

```
-- Convert emails to lowercase
UPDATE your_table_name 
SET email = LOWER(TRIM(email))
WHERE email != LOWER(TRIM(email));
```

## Duplicates

```
-- Create a new table with unique rows
CREATE TABLE your_table_clean AS 
SELECT DISTINCT * FROM your_table;

-- Drop original and rename
DROP TABLE your_table;
ALTER TABLE your_table_clean RENAME TO your_table;
```

## Inaccurate Data

Zip codes too short or long:

```
-- Find zip codes that are not exactly 5 characters
SELECT *
FROM your_table_name 
WHERE LENGTH(zip_code) != 5
   OR zip_code IS NULL;
```

## Outliers

There are many methods for this, including Percentiles, Z-score,
Thresholds, etc.

Standard Deviation / Z-Score

```
-- Find outliers using Z-score (values beyond 2 standard deviations)
WITH stats AS (
    SELECT 
        AVG(column_name) as mean_val,
        STDDEV(column_name) as std_dev
    FROM your_table_name
    WHERE column_name IS NOT NULL
)
SELECT 
    *,
    column_name,
    (column_name - stats.mean_val) / stats.std_dev as z_score,
    CASE 
        WHEN ABS((column_name - stats.mean_val) / stats.std_dev) > 3 THEN 'Extreme Outlier (>3σ)'
        WHEN ABS((column_name - stats.mean_val) / stats.std_dev) > 2 THEN 'Moderate Outlier (>2σ)'
    END as outlier_type
FROM your_table_name, stats
WHERE ABS((column_name - stats.mean_val) / stats.std_dev) > 2  -- Change threshold as needed
ORDER BY ABS((column_name - stats.mean_val) / stats.std_dev) DESC;
```
