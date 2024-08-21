# Work Life Expectancy Project (Exploratory Data Analysis)

SELECT * 
FROM world_life_expectancy
;

# Find the Min and Max of Life expectancy for each Country excluding any 0 records

SELECT Country,
	MIN(`Life expectancy`) as min_life_exp,
    MAX(`Life expectancy`) as max_life_exp
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
;

# Find the increases in life expectacy for each country over the 15 years

SELECT Country,
	MIN(`Life expectancy`) as min_life_exp,
    MAX(`Life expectancy`)as max_life_exp,
    ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase DESC
;

# Explore the average life expectacy of a human for each year, making sure to factor out any zeros

SELECT Year, 
	ROUND(AVG(`Life expectancy`),1) as Avg_Life_Exp
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

# Investigate a possible correlation between Life Expectancy and GDP

SELECT Country,
	ROUND(AVG(`Life expectancy`),1) as Avg_Life_Exp,
    ROUND(AVG(GDP),1) as Avg_GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_GDP > 0
ORDER BY Avg_GDP
;

# Create a case statement to categorize the life expectancy and GDP as high, low, etc. and find any correlation

SELECT 
	SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
	AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_Exp,
    SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
	AVG(CASE WHEN GDP < 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Exp
FROM world_life_expectancy
;

# Investigate possible correlation between status and life expectancy

SELECT Status, 
COUNT(DISTINCT Country), 
ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;


SELECT Status, COUNT(DISTINCT Country)
FROM world_life_expectancy
GROUP BY Status
;


# Investigate any correlation between the BMI and life expectancy

SELECT Country,
	ROUND(AVG(`Life expectancy`),1) as Avg_Life_Exp,
	ROUND(AVG(BMI),1) as Avg_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_BMI > 0
ORDER BY Avg_BMI
;


# Gather a running total of adult mortality over the 15 years for each country

SELECT Country,
	Year,
    `Life expectancy`,
    `Adult Mortality`,
    SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) as Adult_Mort_Roll_Total
FROM world_life_expectancy
;
