CREATE SCHEMA uk_startup_funding;
 
 RENAME TABLE mydb.company TO uk_startup_funding.company;
 RENAME TABLE mydb.funding_events TO uk_startup_funding.funding_events;
 RENAME TABLE mydb.funding_totals TO uk_startup_funding.funding_totals;
 RENAME TABLE mydb.investment_size_band TO uk_startup_funding.investment_size_band;
 RENAME TABLE mydb.region TO uk_startup_funding.region;
 RENAME TABLE mydb.scheme TO uk_startup_funding.scheme;
 RENAME TABLE mydb.sector TO uk_startup_funding.sector;
 RENAME TABLE mydb.year TO uk_startup_funding.year;
 
 USE uk_startup_funding;
 
 CREATE TABLE funding_by_sector (
	id INT PRIMARY KEY,
    scheme_id INT NOT NULL,
    year_id INT NOT NULL,
    sector_id INT NOT NULL,
    companies_raising INT NOT NULL,
    amount_raised_millions DECIMAL(10,2),
    
    FOREIGN KEY (scheme_id) REFERENCES scheme(scheme_id),
    FOREIGN KEY (year_id) REFERENCES year(year_id),
    FOREIGN KEY (sector_id) REFERENCES sector(sector_id)
);

CREATE TABLE funding_by_region (
	id INT PRIMARY KEY,
    scheme_id INT NOT NULL,
    year_id INT NOT NULL,
    region_id INT NOT NULL,
    companies_raising INT NOT NULL,
    amount_raised_millions DECIMAL(10,2),
    
    FOREIGN KEY (scheme_id) REFERENCES scheme(scheme_id),
    FOREIGN KEY (year_id) REFERENCES year(year_id),
    FOREIGN KEY (region_id) REFERENCES region(region_id)
);

CREATE TABLE funding_by_size_band (
	id INT PRIMARY KEY,
    scheme_id INT NOT NULL,
    year_id INT NOT NULL,
    size_band_id INT NOT NULL,
    companies_raising INT NOT NULL,
    amount_raised_millions DECIMAL(10,2),
    
    FOREIGN KEY (scheme_id) REFERENCES scheme(scheme_id),
    FOREIGN KEY (year_id) REFERENCES year(year_id),
    FOREIGN KEY (size_band_id) REFERENCES investment_size_band(size_band_id)
);

CREATE TABLE investor_claims (
	id INT PRIMARY KEY,
    scheme_id INT NOT NULL,
    year_id INT NOT NULL,
    size_band_id INT NOT NULL,
    investors_count INT NOT NULL,
    amount_raised_millions DECIMAL(10,2),
    
    FOREIGN KEY (scheme_id) REFERENCES scheme(scheme_id),
    FOREIGN KEY (year_id) REFERENCES year(year_id),
    FOREIGN KEY (size_band_id) REFERENCES investment_size_band(size_band_id)
);

CREATE TABLE advance_assurance (
	id INT PRIMARY KEY,
    scheme_id INT NOT NULL,
    year_id INT NOT NULL,
    applications_received INT NOT NULL,
    approved INT NOT NULL,
    rejected INT NOT NULL,
    pending INT NOT NULL,
    
    FOREIGN KEY (scheme_id) REFERENCES scheme(scheme_id),
    FOREIGN KEY (year_id) REFERENCES year(year_id)
);

ALTER TABLE company
ADD stage VARCHAR(50) NOT NULL;

ALTER TABLE company
ADD amount_gbp DECIMAL(10,2) NOT NULL;

ALTER TABLE company
ADD lead_investor VARCHAR(50) NOT NULL;


SELECT * FROM company;

ALTER TABLE company
ADD date DATE NOT NULL;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/Users/camarenrogers/Documents/uk_startup_funding_analysis/uk-startup-funding-tracker - uk-startup-funding-tracker.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(name, location, industry, website, stage, @raw_amount, lead_investor, date)
SET amount_gbp = REPLACE(@raw_amount, ',', '');

ALTER TABLE funding_events
DROP FOREIGN KEY company_id;

ALTER TABLE company
MODIFY company_id INT NOT NULL AUTO_INCREMENT;

ALTER TABLE company
MODIFY amount_gbp DECIMAL(15,2);

SELECT * FROM company;

ALTER TABLE company
MODIFY company_id INT NOT NULL AUTO_INCREMENT;

ALTER TABLE company AUTO_INCREMENT = 1;

SET SQL_SAFE_UPDATES = 0;

UPDATE company
SET date = CONCAT(date, '-01-01')
WHERE company_id > 0;

UPDATE company
SET date = YEAR(date)
WHERE company_id > 0;

ALTER TABLE company
MODIFY date YEAR;

-- Add the new column
ALTER TABLE company ADD COLUMN year_only YEAR;

-- Extract the year from the existing date column and move it to the new column
UPDATE company SET year_only = YEAR(date);

SELECT date, year_only FROM company LIMIT 10;

-- Remove the original date column
ALTER TABLE company DROP COLUMN date;

-- Rename the new column back to 'date'
ALTER TABLE company CHANGE COLUMN year_only date YEAR;

-- Create a temporary table with the re-sequenced IDs
CREATE TABLE company_new AS 
SELECT 
    (@row_number := @row_number + 1) AS company_id, 
    name, location, industry, website, stage, amount_gbp, lead_investor, date
FROM company, (SELECT @row_number := 0) AS t
ORDER BY company_id; -- Or change ORDER BY if you want a specific sort order

-- Drop the old table and rename the new one
DROP TABLE company;
ALTER TABLE company_new RENAME TO company;

-- Ensure the ID column is the Primary Key and set to Auto-Increment
ALTER TABLE company 
MODIFY company_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE company AUTO_INCREMENT = 1;

SELECT company_id, name FROM company LIMIT 10;

SELECT * FROM company_new;

DROP TABLE company;

SELECT * FROM company;

SELECT * FROM region;

ALTER TABLE funding_by_region
DROP FOREIGN KEY funding_by_region_ibfk_3;


ALTER TABLE region 
MODIFY region_id INT NOT NULL AUTO_INCREMENT;


INSERT INTO region (region_name) VALUES
('North East'),
('North West'),
('Yorkshire and the Humber'),
('East Midlands'),
('West Midlands'),
('East of England'),
('London'),
('South East'),
('South West'),
('Wales'),
('Scotland'),
('Northern Ireland'),
('Channel Islands / Isle of Man');

ALTER TABLE funding_by_sector
DROP FOREIGN KEY funding_by_sector_ibfk_3;

ALTER TABLE funding_events
DROP FOREIGN KEY sector_id;

ALTER TABLE sector
MODIFY sector_id INT NOT NULL AUTO_INCREMENT;


INSERT INTO sector (sector_name) VALUES
('Agriculture, Forestry and Fishing, Mining and Quarrying'),
('Manufacturing'),
('Electricity, Gas, Steam and Air Conditioning, Water, Sewerage and Waste'),
('Construction'),
('Wholesale and Retail Trade, Repairs'),
('Transport and Storage'),
('Accommodation and Food'),
('Information and Communication'),
('Financial and Insurance'),
('Real Estate'),
('Professional, Scientific and Technical'),
('Admin and Support Services, Public Admin, Defence and Social Services'),
('Education'),
('Health and Social Work'),
('Arts, Entertainment and Recreation'),
('Other services activities, Households, Overseas'),
('Unknown Sic2007');

SELECT * FROM sector;

ALTER TABLE funding_totals
DROP FOREIGN KEY scheme_id;

ALTER TABLE funding_totals
MODIFY scheme_id INT NOT NULL AUTO_INCREMENT;

ALTER TABLE funding_by_size_band
DROP FOREIGN KEY funding_by_size_band_ibfk_1;

ALTER TABLE investor_claims
DROP FOREIGN KEY investor_claims_ibfk_1;

ALTER TABLE advance_assurance
DROP FOREIGN KEY advance_assurance_ibfk_1;

ALTER TABLE funding_by_region
DROP FOREIGN KEY funding_by_region_ibfk_1;

ALTER TABLE funding_by_sector
DROP FOREIGN KEY funding_by_sector_ibfk_1;

ALTER TABLE scheme
MODIFY scheme_id INT NOT NULL AUTO_INCREMENT;


INSERT INTO scheme (scheme_name) VALUES
('EIS'),
('SEIS');

SELECT * FROM scheme;

SELECT * FROM year;

INSERT INTO year (year_id, tax_year) VALUES
(1, '2022-23'),
(2, '2023-24'),
(3, '2024-25');

INSERT INTO investment_size_band (size_band_id, size_band_label) VALUES
(1, 'Up to 10'),
(2, '10 to 25'),
(3, '25 to 50'),
(4, '50 to 100'),
(5, '100 to 150'),
(6, '150 to 200'),
(7, '200 to 250'),
(8, '250 to 300'),
(9, '300 to 350'),
(10, '350 to 400'),
(11, '400 to 450'),
(12, '450 to 500'),
(13, '500 to 750'),
(14, '750 to 1,000'),
(15, '1,250 to 1,500'),
(16, '1,500 to 1,750,'),
(17, '1,750 to 2,000'),
(18, '2,000 to 3,000'),
(19, '3,000 to 4,000'),
(20, '4,000 to 5,000'),
(21, '5,000 to 10,000');

SELECT * FROM investment_size_band;

SELECT * FROM funding_by_sector;

SELECT * FROM sector;

ALTER TABLE funding_by_sector
MODIFY sector_id INT NOT NULL;

ALTER TABLE funding_by_sector
MODIFY id INT NOT NULL AUTO_INCREMENT;


INSERT INTO funding_by_sector (scheme_id, year_id, sector_id, companies_raising)
VALUES 
(1, 1, 1, 25),
(1, 1, 2, 600),
(1, 1, 3, 25),
(1, 1, 4, 30),
(1, 1, 5, 415),
(1, 1, 6, 35),
(1, 1, 7, 125),
(1, 1, 8, 1510),
(1, 1, 9, 200),
(1, 1, 10, 10),
(1, 1, 11, 660),
(1, 1, 12, 240),
(1, 1, 13, 65),
(1, 1, 14, 110),
(1, 1, 15, 90),
(1, 1, 16, 120),
(1, 1, 17, 5);

SELECT * FROM scheme;

SET SQL_SAFE_UPDATES = 0;

-- Now run your update again
UPDATE `uk_startup_funding`.`funding_by_sector` 
SET `amount_raised_millions` = ROUND(`amount_raised_millions`);

-- Turn it back on afterward for safety
SET SQL_SAFE_UPDATES = 1;

UPDATE funding_by_sector
SET amount_raised_millions = CASE id
    WHEN 1 THEN 15
    WHEN 2 THEN 285
    WHEN 3 THEN 16
    WHEN 4 THEN 15
    WHEN 5 THEN 151
    WHEN 6 THEN 9
    WHEN 7 THEN 44
    WHEN 8 THEN 718
    WHEN 9 THEN 108
    WHEN 10 THEN 3
    WHEN 11 THEN 369
    WHEN 12 THEN 102
    WHEN 13 THEN 19
    WHEN 14 THEN 41
    WHEN 15 THEN 30
    WHEN 16 THEN 44
    WHEN 17 THEN 1
    ELSE amount_raised_millions
END
WHERE id BETWEEN 1 AND 17;

SELECT * FROM year;

-- Next insert 2023-24 and 2024-25 for EIS from sheet 3 and 4