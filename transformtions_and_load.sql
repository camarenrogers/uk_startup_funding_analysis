SHOW CREATE TABLE uk_startup_funding.company;

ALTER TABLE uk_startup_funding.company
	MODIFY COLUMN company_id INT NOT NULL;

SELECT industry, COUNT(*) AS n
FROM uk_startup_funding.company
GROUP BY industry
ORDER BY n DESC;

-- 1. Add the foreign-key column
ALTER TABLE uk_startup_funding.company
  ADD COLUMN sector_id INT NULL AFTER industry;

-- 2. Populate it from the industry labels
UPDATE uk_startup_funding.company
SET sector_id = CASE industry
  WHEN 'FinTech'          THEN 9
  WHEN 'InsurTech'        THEN 9
  WHEN 'SaaS'             THEN 8
  WHEN 'AI'               THEN 8
  WHEN 'AI/SaaS'          THEN 8
  WHEN 'AI/Data'          THEN 8
  WHEN 'AI/VR'            THEN 8
  WHEN 'AI/DeepTech'      THEN 8
  WHEN 'CyberSecurity'    THEN 8
  WHEN 'Blockchain'       THEN 8
  WHEN 'Telecommunications' THEN 8
  WHEN 'Gaming'           THEN 8
  WHEN 'Social Network'   THEN 8
  WHEN 'Marketplace'      THEN 8
  WHEN 'Marketing'        THEN 8
  WHEN 'HealthTech'       THEN 14
  WHEN 'BioTech'          THEN 14
  WHEN 'CleanTech'        THEN 3
  WHEN 'Utilities'        THEN 3
  WHEN 'Consumer'         THEN 5
  WHEN 'E-commerce'       THEN 5
  WHEN 'Retail'           THEN 5
  WHEN 'Food'             THEN 5
  WHEN 'Materials'        THEN 2
  WHEN 'Manufacturing'    THEN 2
  WHEN 'Construction'     THEN 4
  WHEN 'PropTech'         THEN 4
  WHEN 'Marine'           THEN 6
  WHEN 'Logistics'        THEN 6
  WHEN 'Aerospace'        THEN 6
  WHEN 'HR'               THEN 11
  WHEN 'EdTech'           THEN 13
END;

-- 3. Add the foreign key constraint
ALTER TABLE uk_startup_funding.company
  ADD CONSTRAINT fk_company_sector
  FOREIGN KEY (sector_id) REFERENCES sector (sector_id);

-- 4. Verify nothing was missed
SELECT industry, sector_id FROM uk_startup_funding.company
WHERE sector_id IS NULL;

UPDATE uk_startup_funding.company
SET sector_id = CASE industry
  WHEN 'FinTech'          THEN 9
  WHEN 'InsurTech'        THEN 9
  WHEN 'SaaS'             THEN 8
  WHEN 'AI'               THEN 8
  WHEN 'AI/SaaS'          THEN 8
  WHEN 'AI/Data'          THEN 8
  WHEN 'AI/VR'            THEN 8
  WHEN 'AI/DeepTech'      THEN 8
  WHEN 'CyberSecurity'    THEN 8
  WHEN 'Blockchain'       THEN 8
  WHEN 'Telecommunications' THEN 8
  WHEN 'Gaming'           THEN 8
  WHEN 'Social Network'   THEN 8
  WHEN 'Marketplace'      THEN 8
  WHEN 'Marketing'        THEN 8
  WHEN 'HealthTech'       THEN 14
  WHEN 'BioTech'          THEN 14
  WHEN 'CleanTech'        THEN 3
  WHEN 'Utilities'        THEN 3
  WHEN 'Consumer'         THEN 5
  WHEN 'E-commerce'       THEN 5
  WHEN 'Retail'           THEN 5
  WHEN 'Food'             THEN 5
  WHEN 'Materials'        THEN 2
  WHEN 'Manufacturing'    THEN 2
  WHEN 'Construction'     THEN 4
  WHEN 'PropTech'         THEN 4
  WHEN 'Marine'           THEN 6
  WHEN 'Logistics'        THEN 6
  WHEN 'Aerospace'        THEN 6
  WHEN 'HR'               THEN 11
  WHEN 'EdTech'           THEN 13
END;
SET SQL_SAFE_UPDATES = 0;
SELECT COUNT(*) FROM uk_startup_funding.company WHERE sector_id IS NULL;

ALTER TABLE uk_startup_funding.company
	ADD CONSTRAINT fk_company_sector
    FOREIGN KEY (sector_id) REFERENCES sector (sector_id);

SELECT constraint_name, referenced_table_name
FROM information_schema.key_column_usage
WHERE table_name = 'company'
	AND referenced_table_name IS NOT NULL;
    
INSERT INTO uk_startup_funding.funding_by_size_band
  (id, scheme_id, year_id, size_band_id, companies_raising, amount_raised_millions)
VALUES
  -- 2022-23 (year_id 1), SEIS (scheme_id 2)
  (1,  2, 1, 1, 115,  NULL),
  (2,  2, 1, 2, 200,  NULL),
  (3,  2, 1, 3, 310,  NULL),
  (4,  2, 1, 4, 475,  NULL),
  (5,  2, 1, 5, 745,  NULL),
  (6,  2, 1, 6, NULL, NULL),   -- 150 to 200: suppressed
  (7,  2, 1, 7, NULL, NULL),   -- 200 to 250: suppressed
  -- 2023-24 (year_id 2)
  (8,  2, 2, 1, 130,  NULL),
  (9,  2, 2, 2, 190,  NULL),
  (10, 2, 2, 3, 370,  NULL),
  (11, 2, 2, 4, 600,  NULL),
  (12, 2, 2, 5, 580,  NULL),
  (13, 2, 2, 6, 175,  NULL),
  (14, 2, 2, 7, 260,  NULL),
  -- 2024-25 (year_id 3)
  (15, 2, 3, 1, 170,  NULL),
  (16, 2, 3, 2, 250,  NULL),
  (17, 2, 3, 3, 410,  NULL),
  (18, 2, 3, 4, 505,  NULL),
  (19, 2, 3, 5, 315,  NULL),
  (20, 2, 3, 6, 215,  NULL),
  (21, 2, 3, 7, 565,  NULL);
  
  ALTER TABLE uk_startup_funding.funding_by_size_band
	MODIFY COLUMN companies_raising INT NULL;
    
SELECT year_id, COUNT(*) AS bands,
	SUM(companies_raising) AS total_companies,
    SUM(companies_raising IS NULL) AS suppressed
FROM uk_startup_funding.funding_by_size_band
GROUP BY year_id;

SELECT  COUNT(*) FROM uk_startup_funding.company;

SELECT company_id, name, industry, stage, amount_gbp, date
FROM uk_startup_funding.company
ORDER BY company_id
LIMIT 3;

SELECT MIN(amount_gbp), MAX(amount_gbp), AVG(amount_gbp)
FROM uk_startup_funding.company;

SELECT * FROM uk_startup_funding.scheme;
USE uk_startup_funding;
SELECT * FROM region ORDER BY region_id;

SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'uk_startup_funding'
  AND table_name IN ('funding_by_sector','funding_by_region','investor_claims','advance_assurance','funding_totals')
ORDER BY table_name, ordinal_position;

-- ===== funding_by_sector (HMRC Tables 3,4,14,15) =====
INSERT INTO uk_startup_funding.funding_by_sector
  (scheme_id, year_id, sector_id, companies_raising, amount_raised_millions)
VALUES
  (1, 1, 1, 25, 15),
  (1, 2, 1, 20, 6),
  (1, 3, 1, 20, 7),
  (1, 1, 2, 600, 285),
  (1, 2, 2, 510, 212),
  (1, 3, 2, 550, 247),
  (1, 1, 3, 25, 16),
  (1, 2, 3, 25, 12),
  (1, 3, 3, 25, 12),
  (1, 1, 4, 30, 15),
  (1, 2, 4, 20, 7),
  (1, 3, 4, 25, 7),
  (1, 1, 5, 415, 151),
  (1, 2, 5, 365, 134),
  (1, 3, 5, 345, 125),
  (1, 1, 6, 35, 9),
  (1, 2, 6, 30, 13),
  (1, 3, 6, 25, 8),
  (1, 1, 7, 125, 44),
  (1, 2, 7, 90, 33),
  (1, 3, 7, 95, 31),
  (1, 1, 8, 1510, 718),
  (1, 2, 8, 1375, 548),
  (1, 3, 8, 1365, 550),
  (1, 1, 9, 200, 108),
  (1, 2, 9, 200, 114),
  (1, 3, 9, 175, 83),
  (1, 1, 10, 10, 3),
  (1, 2, 10, 10, 2),
  (1, 3, 10, 10, 3),
  (1, 1, 11, 660, 369),
  (1, 2, 11, 630, 299),
  (1, 3, 11, 620, 329),
  (1, 1, 12, 240, 102),
  (1, 2, 12, 190, 79),
  (1, 3, 12, 170, 61),
  (1, 1, 13, 65, 19),
  (1, 2, 13, 50, 14),
  (1, 3, 13, 45, 10),
  (1, 1, 14, 110, 41),
  (1, 2, 14, 85, 35),
  (1, 3, 14, 95, 34),
  (1, 1, 15, 90, 30),
  (1, 2, 15, 70, 29),
  (1, 3, 15, 80, 32),
  (1, 1, 16, 120, 44),
  (1, 2, 16, 110, 40),
  (1, 3, 16, 95, 37),
  (1, 1, 17, NULL, 1),
  (1, 2, 17, 0, 0),
  (1, 3, 17, 0, 0),
  (2, 1, 1, 15, 2),
  (2, 2, 1, 10, 1),
  (2, 3, 1, 15, 2),
  (2, 1, 2, 200, 18),
  (2, 2, 2, 250, 26),
  (2, 3, 2, 260, 29),
  (2, 1, 3, 10, 1),
  (2, 2, 3, 10, 1),
  (2, 3, 3, 10, 1),
  (2, 1, 4, 25, 2),
  (2, 2, 4, 15, 1),
  (2, 3, 4, 20, 3),
  (2, 1, 5, 225, 17),
  (2, 2, 5, 285, 27),
  (2, 3, 5, 270, 23),
  (2, 1, 6, 10, 1),
  (2, 2, 6, 5, 1),
  (2, 3, 6, 15, 2),
  (2, 1, 7, 70, 6),
  (2, 2, 7, 85, 9),
  (2, 3, 7, 100, 13),
  (2, 1, 8, 735, 64),
  (2, 2, 8, 925, 98),
  (2, 3, 8, 980, 115),
  (2, 1, 9, 50, 5),
  (2, 2, 9, 50, 6),
  (2, 3, 9, 65, 9),
  (2, 1, 10, 10, 1),
  (2, 2, 10, 10, 1),
  (2, 3, 10, 15, 1),
  (2, 1, 11, 230, 22),
  (2, 2, 11, 295, 33),
  (2, 3, 11, 325, 40),
  (2, 1, 12, 80, 7),
  (2, 2, 12, 115, 11),
  (2, 3, 12, 125, 14),
  (2, 1, 13, 35, 3),
  (2, 2, 13, 50, 6),
  (2, 3, 13, 45, 5),
  (2, 1, 14, 45, 5),
  (2, 2, 14, 60, 7),
  (2, 3, 14, 75, 9),
  (2, 1, 15, 50, 4),
  (2, 2, 15, 65, 6),
  (2, 3, 15, 75, 7),
  (2, 1, 16, 50, 5),
  (2, 2, 16, 75, 8),
  (2, 3, 16, 45, 4),
  (2, 1, 17, 0, 0),
  (2, 2, 17, 5, NULL),
  (2, 3, 17, 5, NULL);

-- ===== funding_by_region (HMRC Tables 7,8,18,19) =====
INSERT INTO uk_startup_funding.funding_by_region
  (scheme_id, year_id, region_id, companies_raising, amount_raised_millions)
VALUES
  (1, 1, 1, 45, 19),
  (1, 2, 1, 40, 11),
  (1, 3, 1, 55, 22),
  (1, 1, 2, 210, 94),
  (1, 2, 2, 205, 76),
  (1, 3, 2, 190, 83),
  (1, 1, 3, 105, 38),
  (1, 2, 3, 110, 57),
  (1, 3, 3, 120, 57),
  (1, 1, 4, 115, 44),
  (1, 2, 4, 105, 42),
  (1, 3, 4, 100, 37),
  (1, 1, 5, 135, 57),
  (1, 2, 5, 130, 41),
  (1, 3, 5, 105, 53),
  (1, 1, 6, 325, 189),
  (1, 2, 6, 315, 131),
  (1, 3, 6, 335, 158),
  (1, 1, 7, 2130, 1008),
  (1, 2, 7, 1790, 763),
  (1, 3, 7, 1770, 711),
  (1, 1, 8, 615, 281),
  (1, 2, 8, 545, 233),
  (1, 3, 8, 540, 237),
  (1, 1, 9, 245, 102),
  (1, 2, 9, 230, 87),
  (1, 3, 9, 220, 97),
  (1, 1, 10, 75, 28),
  (1, 2, 10, 65, 36),
  (1, 3, 10, 80, 27),
  (1, 1, 11, 205, 87),
  (1, 2, 11, 200, 78),
  (1, 3, 11, 175, 83),
  (1, 1, 12, 50, 22),
  (1, 2, 12, 40, 20),
  (1, 3, 12, 35, 11),
  (1, 1, 13, NULL, 1),
  (1, 2, 13, NULL, NULL),
  (1, 3, 13, NULL, 1),
  (2, 1, 1, 25, 2),
  (2, 2, 1, 50, 6),
  (2, 3, 1, 35, 3),
  (2, 1, 2, 120, 11),
  (2, 2, 2, 145, 15),
  (2, 3, 2, 140, 16),
  (2, 1, 3, 65, 6),
  (2, 2, 3, 65, 8),
  (2, 3, 3, 75, 8),
  (2, 1, 4, 45, 4),
  (2, 2, 4, 50, 4),
  (2, 3, 4, 80, 9),
  (2, 1, 5, 65, 6),
  (2, 2, 5, 85, 8),
  (2, 3, 5, 75, 7),
  (2, 1, 6, 120, 11),
  (2, 2, 6, 165, 19),
  (2, 3, 6, 160, 22),
  (2, 1, 7, 935, 81),
  (2, 2, 7, 1175, 125),
  (2, 3, 7, 1245, 143),
  (2, 1, 8, 270, 23),
  (2, 2, 8, 295, 31),
  (2, 3, 8, 325, 38),
  (2, 1, 9, 100, 9),
  (2, 2, 9, 140, 14),
  (2, 3, 9, 135, 15),
  (2, 1, 10, 35, 3),
  (2, 2, 10, 50, 4),
  (2, 3, 10, 55, 5),
  (2, 1, 11, 50, 4),
  (2, 2, 11, 70, 7),
  (2, 3, 11, 80, 8),
  (2, 1, 12, 20, 2),
  (2, 2, 12, 15, 2),
  (2, 3, 12, 25, 3);

-- ===== funding_by_size_band: EIS (HMRC Tables 5,6) =====
-- NOTE: SEIS band counts already loaded earlier. This adds EIS.
INSERT INTO uk_startup_funding.funding_by_size_band
  (scheme_id, year_id, size_band_id, companies_raising, amount_raised_millions)
VALUES
  (1, 1, 1, 125, 1),
  (1, 2, 1, 135, 1),
  (1, 3, 1, 135, 1),
  (1, 1, 2, 225, 4),
  (1, 2, 2, 195, 4),
  (1, 3, 2, 200, 4),
  (1, 1, 3, 385, 16),
  (1, 2, 3, 345, 14),
  (1, 3, 3, 330, 13),
  (1, 1, 4, 555, 43),
  (1, 2, 4, 565, 43),
  (1, 3, 4, 505, 37),
  (1, 1, 5, 430, 55),
  (1, 2, 5, 410, 51),
  (1, 3, 5, 410, 51),
  (1, 1, 6, 345, 61),
  (1, 2, 6, 310, 55),
  (1, 3, 6, 295, 52),
  (1, 1, 7, 265, 60),
  (1, 2, 7, 210, 48),
  (1, 3, 7, 260, 59),
  (1, 1, 8, 245, 68),
  (1, 2, 8, 200, 55),
  (1, 3, 8, 210, 58),
  (1, 1, 9, 170, 55),
  (1, 2, 9, 145, 47),
  (1, 3, 9, 175, 56),
  (1, 1, 10, 135, 51),
  (1, 2, 10, 150, 57),
  (1, 3, 10, 115, 43),
  (1, 1, 11, 125, 52),
  (1, 2, 11, 100, 43),
  (1, 3, 11, 110, 47),
  (1, 1, 12, 130, 64),
  (1, 2, 12, 90, 43),
  (1, 3, 12, 95, 46),
  (1, 1, 13, 375, 232),
  (1, 2, 13, 325, 197),
  (1, 3, 13, 315, 191),
  (1, 1, 14, 235, 206),
  (1, 2, 14, 190, 166),
  (1, 3, 14, 180, 157),
  (1, 1, 15, 125, 138),
  (1, 2, 15, 125, 137),
  (1, 3, 15, 100, 110),
  (1, 1, 16, 110, 151),
  (1, 2, 16, 80, 107),
  (1, 3, 16, 70, 96),
  (1, 1, 17, 60, 98),
  (1, 2, 17, 50, 82),
  (1, 3, 17, 55, 87),
  (1, 1, 18, 45, 87),
  (1, 2, 18, 40, 70),
  (1, 3, 18, 20, 41),
  (1, 1, 19, 95, 223),
  (1, 2, 19, 75, 186),
  (1, 3, 19, 95, 223),
  (1, 1, 20, 40, 128),
  (1, 2, 20, 20, 61),
  (1, 3, 20, 40, 127),
  (1, 1, 21, 15, 69),
  (1, 2, 21, 10, 39),
  (1, 3, 21, 15, 59),
  (1, 1, 22, 15, 109),
  (1, 2, 22, 10, 68),
  (1, 3, 22, 5, 19);

-- ===== advance_assurance (HMRC Tables 11,22; approved/rejected = same+subsequent yrs) =====
INSERT INTO uk_startup_funding.advance_assurance
  (scheme_id, year_id, applications_received, approved, rejected, pending)
VALUES
  (1, 1, 3665, 2960, 395, 310),
  (1, 2, 3150, 2305, 190, 660),
  (1, 3, 3185, 2435, 220, 535),
  (2, 1, 2835, 2320, 355, 160),
  (2, 2, 2745, 2200, 105, 440),
  (2, 3, 3285, 2785, 155, 345);