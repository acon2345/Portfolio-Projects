# Work Life Expectancy Project (Data Cleaning)

# Skills Used: Joins, Table Updates, Window Functions, Aggregate Functions, String Functions

SELECT * 
FROM world_life_expectancy
;

# Determine if there are any duplicate records using country and year as unique identifiers

SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY 1,2
HAVING COUNT(CONCAT(country, year)) > 1;

# Remove the duplicate records

SELECT *
FROM(
	SELECT Row_ID,
	CONCAT(country, year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) as Row_Num
	FROM world_life_expectancy) as life_expectancy
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
FROM(
	SELECT Row_ID,
	CONCAT(country, year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) as Row_Num
	FROM world_life_expectancy) as life_expectancy
WHERE Row_Num > 1
)
;

# Identify records that are blank and need to be filled with mssing data

SELECT * 
FROM world_life_expectancy
WHERE Status IS NULL
;

SELECT DISTINCT(Status) 
FROM world_life_expectancy
WHERE Status <> ''
;


# Use distinct list to update status of countries that should have a developing status

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

# Have to use update with a JOIN to correctly update the status for developing countries

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.STATUS = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

# Next do the same for and countries with missing status that should be developed

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.STATUS = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

# Now running a check if there are not any records with a blank Status field

SELECT * 
FROM world_life_expectancy
WHERE Status IS NULL
;

# Next work on records that are blank in the Life expectancy column

SELECT * 
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;

SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
	t2.Country, t2.Year, t2.`Life expectancy`,
    t3.Country, t3.Year, t3.`Life expectancy`,
    ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1) as average
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

# Update the table with the average clause used above as there seems to be an updward trend to account for

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = ''
;

# Run a check see if there are any more missing values in the Life expectancy column

SELECT * 
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

# Verify if there are any other elements to clean in the table

SELECT * 
FROM world_life_expectancy
;
