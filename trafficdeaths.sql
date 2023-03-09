-- Data citation: Centers for Disease Control and Prevention, 
-- National Center for Health Statistics. National Vital Statistics System, 
-- Mortality 2018-2021 on CDC WONDER Online Database, released in 2021.
-- Data are from the Multiple Cause of Death Files, 2018-2021, as compiled from 
-- data provided by the 57 vital statistics jurisdictions through the Vital Statistics 
-- Cooperative Program. Accessed at http://wonder.cdc.gov/ucd-icd10-expanded.html

CREATE DATABASE IF NOT EXISTS usatransport;
USE usatransport;

CREATE TABLE IF NOT EXISTS weekcauses(
	notes VARCHAR(10),
	cause VARCHAR(200),	cause_code VARCHAR(9),
	weekday VARCHAR(9),	weekday_code INT,
	deaths INT,
	population VARCHAR(14),
	crude_rate VARCHAR(14)
);

CREATE TABLE IF NOT EXISTS agecauses(
	notes VARCHAR(10),
	cause VARCHAR(200),	cause_code VARCHAR(9),
	agegroup VARCHAR(11),	agegroup_code VARCHAR(5),
	deaths INT,
	population VARCHAR(14),
	crude_rate VARCHAR(14)
);

CREATE TABLE IF NOT EXISTS causes(
	notes VARCHAR(10),
	cause VARCHAR(200),	cause_code VARCHAR(9),
	deaths INT,
	population VARCHAR(14),
	crude_rate VARCHAR(14)
);

-- load data into the tables
LOAD DATA LOCAL
INFILE "C:\\Users\\Dani\\Documents\\SQLpractice\\trafficdeathsweekday.txt"
INTO TABLE weekcauses
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 46 LINES;

LOAD DATA LOCAL
INFILE "C:\\Users\\Dani\\Documents\\SQLpractice\\trafficdeaths10yrs.txt"
INTO TABLE agecauses
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 56 LINES;

LOAD DATA LOCAL
INFILE "C:\\Users\\Dani\\Documents\\SQLpractice\\trafficdeaths.txt"
INTO TABLE causes
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 52 LINES;

-- sort categories by highest death count
SELECT SUM(deaths) AS deaths, LEFT(cause_code,2) AS causecode FROM causes
WHERE LEFT(cause_code,2) IN ('V0','V1','V2','V4','V5','V6','V7','V8','V9')
GROUP BY causecode
ORDER BY deaths DESC;

-- -- V87, V88 and V89 unspecified or other specified deaths in traffic, not categorized.
-- SELECT SUM(deaths), LEFT(cause_code,3) AS causecode FROM causes
-- WHERE LEFT(cause_code,3) IN ('V87','V88','V89')
-- GROUP BY causecode;

-- I chose pedestrian, motorcyclist and car occupants since those were the next biggest groups
-- pedestrian deaths by age
WITH p AS (SELECT SUM(deaths) AS pedestrian_deaths, agegroup FROM agecauses
WHERE LEFT(cause_code,2) = 'V0'
GROUP BY agegroup),
-- motorcylist deaths by age
m AS (SELECT SUM(deaths) AS motorcycle_rider_deaths, agegroup FROM agecauses
WHERE LEFT(cause_code,2) = 'V2'
GROUP BY agegroup),
-- car occupant deaths by age
car AS (SELECT SUM(deaths) AS car_occupant_deaths, agegroup FROM agecauses
WHERE LEFT(cause_code,2) = 'V4'
GROUP BY agegroup)
SELECT pedestrian_deaths, motorcycle_rider_deaths, car_occupant_deaths, p.agegroup FROM p
LEFT JOIN m ON m.agegroup = p.agegroup
LEFT JOIN car ON car.agegroup = p.agegroup
ORDER BY agegroup;

-- sorting by weekday
WITH p AS (SELECT SUM(deaths) as pedestrian_deaths, weekday FROM weekcauses
WHERE cause_code LIKE 'V0%'
GROUP BY weekday),
m AS (SELECT SUM(deaths) as motorcycle_rider_deaths, weekday FROM weekcauses
WHERE cause_code LIKE 'V2%'
GROUP BY weekday),
car AS (SELECT SUM(deaths) AS car_occupant_deaths, weekday FROM weekcauses
WHERE cause_code LIKE 'V4%'
GROUP BY weekday)
SELECT pedestrian_deaths, motorcycle_rider_deaths, car_occupant_deaths, p.weekday FROM p
JOIN m ON m.weekday=p.weekday
JOIN car ON car.weekday=p.weekday;
