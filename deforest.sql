/* 1. Create "forestation" view: */

CREATE VIEW Forestation AS
SELECT r.country_name,
    f.year,
    r.income_group,
    r.region
    l.total_area_sq_mi,
    f.forest_area_sqkm,
    ((SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100) percentage_forest
FROM forest_area f
JOIN land_area l ON r.country_code = l.country_code
AND f.year = l.year
Join regions r ON r.country_code = f.country_code
GROUP BY r.country_name,
    f.year,
    r.income_group,
    r.region,
    l.total_area_sq_mi,
    f.forest_area_sqkm

/* GLOBAL SITUATION
    a. What was the total forest area (in sq km) of the world in 1990? 
    Please keep in mind that you can use the country recorrd denoted as "World" in the region table*/

SELECT SUM(forest_area_sqkm) total_forest_area
FROM Forestation
WHERE YEAR = 1990
    AND country_name = 'World'

/*  b. What was the total forest area (in sq km) of the world in 2016?
    Please keep in mind that you can use the country record in the table is denoted as "World" */

SELECT SUM(forest_area_sqkm) total_forest_area
FROM Forestation
WHERE YUEAR = 2016
    AND country_name = 'World'

/*  c. What was tye change (in sq km) in the forest area of the world from 1990 to 2016?  */

SELECT (
    (SELECT SUM(forest_area_sqkm) total_forest_area
    FROM Forestation
    WHERE YEAR = 1990
    AND country_name = 'World') -
    (SELECT SUM(forest_area_sqkm) total_forest_area
    FROM Forestation
    WHERE YEAR = 2016
    AND country_name = 'World' )) AS Difference 
FROM Forestation
LIMIT 1

/*  d. What was the percent change in forest area of the world between 1990 and 2016? */

SELECT (((
    (SELECT SUM(forest_area_sqk-m) total_forest_area
    FROM Forestation
    WHERE YEAR = 1990
    AND country_name = 'World') -
    (SELECT SUM(forest_area_sqkm) total_forest_area
    FROM Forestation
    WHERE YEAR = 2016
    AND country_name = 'World')) / (
    (SELECT SUM(forest_area_sqkm) total_forest_area
    FROM Forestation
    WHERE YEAR = 1990
    AND country_name = 'World'))) *100) AS Percent_decrease
FROM Forestation
LIMIT 1 


/*  e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to? */

WITH tb1 AS
    (SELECT MAX(forest_area_sqkm) - MIN(forest_area_sqkm) AS deforest
    FROM Forestation),

tb2 AS
    (SELECT *,
            total_area_sq_mi * 2.59 AS total_area_sq_km
    FROM land_area FULL 
    JOIN tb1
    ON land_area.total_area_sq_mi = tb1.deforest),

tb3 AS
    (SELECT *
    CASE
    WHEN deforest IS NULL THEN
    1324449
    ELSE NULL
    AND AS new_deforest
    FROM tb2)

SELECT country_name, total_area_sq_km
FROM tb3
WHERE total_area_sq_km < new_deforest AND YEAR = 2016
ORDER BY total_area_sq_km DESC
LIMIT 1;

/* REGIONAL OUTLOOK:

Table 2.1: 

 A.	What was the percent forest of the entire world in 2016? 
    Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places? */
    
SELECT  region,
        ROUND(((SUM(forest_area_sqkm) / 
        SUM(total_area_sq_mi*2.59))*100)::Numeric, 2) AS
        Percent_forest
FROM Forestation
WHERE YEAR = 2016
GROUP BY region
ORDER BY Percent_forest DESC;

/* B.   What was the percent forest of the entire world in 1990? Which region had the HIGHEST 
        percent forest in 1990, and which had the LOWEST, to 2 decimal places? */

SELECT  region,
        ROUND(((SUM(forest_area_sqkm) / 
        SUM(total_area_sq_mi*2.59))*100)::Numeric, 2) AS
        Percent_forest
FROM Forestation
WHERE YEAR = 1990
GROUP BY region
ORDER BY Percent_forest DESC;

/* C.    Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?*/

WITH tb1 AS
    (SELECT region,
            SUM(forest_area_sqkm) AS forest_sum_1990
    FROM Forestation
    WHERE YEAR = 1990
    AND region NOT LIKE 'World'
    GROUP BY 1), 

tb2 AS  
    (SELECT region, SUM(forest_area_sqkm) AS forest_sum_2016
    FROM Forestation
    WHERE YEAR = 2016
    AND region NOT LIKE 'WORLD'
    GROUP BY 1) 

SELECT tb1.region, tb1forest_sum_1990, tb2.forest_sum_2016
FROM tb1
JOIN tb2
ON tb1.region = tb2.region
WHERE tb2.forest_sum_2016 < tb1.forest_sum_1990;

/* Country-Level Detail

A.	Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?
 */

 WITH T1 AS 
    (SELECT country_name,
            SUM(forest_area_sqkm) forest_area_1
            FROM Forestation
            WHERE YEAR = 1990
            GROUP BY country_name,
                    forest_area_sqkm),

T2 AS   
    (SELECT country_name,
            SUM(forest_area_sqkm) forest_area_2
            FROM Forestation
            WHERE YEAR = 2016
            GROUP BY country_name,
                    forest_area_sqkm)

SELECT  f.country_name
        (f.forest_area_1 - t.forest_area_2) forest_change
FROM T1 f
JOIN T2 t ON f.country_name = t.country_name
WHERE f.forest_area_1 IS NOT NULL
AND t.forest_area_2 IS NOT NULL
AND f.country_name != 'World'
ORDER BY forest_change DESC
LIMIT 5;

/* B.	Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each? */

WITH T1 AS 
    (SELECT country_name,
            (SUM(forest_area_sqkm) / 
             SUM(total_area_sq_mi*2.59))*100 percent_forestation_1
    FROM Forestation
    WHERE YEAR = 1990
    GROUP BY country_name,
            forest_area_sqkm),        

T2 AS   
    (SELECT country_name,
            (SUM(forest_area_sqkm) /
             SUM(total_area_sq_mi*2.59))*100 percent_forestation_2
    FROM Forestation
    WHERE YEAR = 2016
    GROUP BY country_name,
            forest_area_sqk)

SELECT f.country_name,
        ROUND((((F.percent_forestation_1 - T.percent_forestation_2)/ (f.percent_forestation_1))*100)::Numeric, 2) percent_change
FROM T1 f
JOIN t2 t ON f.country_name = t.country_name
WHERE f.percent_forestation_1 IN NOT NULL
AND t.percent_forestation_2 IS NOT NULL
AND f.country_name != 'World'
ORDER BY percent_change DESC
LIMIT 5;

/* C.	If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016? */

WITH T1 AS 
    (SELECT country_name, YEAR,
            (SUM(forest_area_sqkm) / 
             SUM(total_area_sq_mi*2.59))*100 percent_forestation
    FROM Forestation
    WHERE YEAR = 2016
    GROUP BY country_name,
            YEAR,
            forest_area_sqkm)

SELECT DISTINCT(quartiles),
                COUNT(country_name)OVER(PARTITION BY quartiles)
FROM 
    (SELECT country_name,
            CASE
            WHEN percent_forestation<25 THEN '0-25'
            WHEN percent_forestation>=25
            AND percent_forestation<50 THEN '25-50'
            WHEN percent_forestation>=50
            AND percent_forestation<75 THEN '50-75'
            ELSE '75-100'
            END AS quartiles
            FROM T1
            WHERE percent_forestation IS NOT NULL
            AND YEAR = 2016) sub

/* D.	List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016. */ 

WITH T2 AS
    (WITH T1 AS
        (SELECT country_name, YEAR,
        (SUM(forest_area_sqkm)/
        SUM(total_area_sq_mi*2.59))*100 percent_forestation
        FROM Forestation
        WHERE YEAR = 2016
        GROUP BY country_name,
                YEAR,
                forest_area_sqkm) 

SELECT DISTINCT(quartiles),
                COUNT(country_name)OVER(PARTITION BY quartiles),
                country_name,
                percent_forestation
FROM 
    (SELECT country_name
            percent_forestation,
            CASE
            WHEN percent_forestation<=25 THEN '0-25'
            WHEN percent_forestation>25
            AND percent_forestation<=50 THEN '25-50'
            WHEN percent_forestation>50
            AND percent_forestation<=75 THEN '50-75'
            ELSE '75-100')
            END AS quartiles
            
FROM T1 
    WHERE percent_forestation IS NOT NULL
    AND YEAR = 2016) sub

SELECT country_name, 
        quartiles, 
        ROUND(percent_forestation::Numeric, 2),
        percent_forestation
        FROM T2
        WHERE quartiles = '75 - 100'
        ORDER BY percent_forestation DESC;

/* E.	How many countries had a percent forestation higher than the United States in 2016? */

SELECT COUNT(country_name)
FROM Forestation
WHERE YEAR = 2016
AND percent_forestation >
    (SELECT percent_forestation
    FROM Forestation
    WHERE country_name = 'United States'
    AND YEAR = 2016)
