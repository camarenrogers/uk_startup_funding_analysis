SELECT 'company' AS tbl, COUNT(*) AS rows_loaded FROM uk_startup_funding.company
UNION ALL SELECT 'funding_by_sector', COUNT(*) FROM uk_startup_funding.funding_by_sector
UNION ALL SELECT 'funding_by_region', COUNT(*) FROM uk_startup_funding.funding_by_region
UNION ALL SELECT 'funding_by_size_band', COUNT(*) FROM uk_startup_funding.funding_by_size_band
UNION ALL SELECT 'advance_assurance', COUNT(*) FROM uk_startup_funding.advance_assurance
UNION ALL SELECT 'investment_size_band', COUNT(*) FROM uk_startup_funding.investment_size_band;

SELECT scheme_id, year_id, COUNT(*) AS n
FROM uk_startup_funding.funding_by_sector
GROUP BY scheme_id, year_id
ORDER BY scheme_id, year_id;

SELECT id, sector_id, companies_raising, amount_raised_millions
FROM uk_startup_funding.funding_by_sector
WHERE scheme_id = 1 AND year_id = 1
ORDER BY id;

DELETE FROM uk_startup_funding.funding_by_sector
WHERE scheme_id = 1 AND year_id = 1;

INSERT INTO uk_startup_funding.funding_by_sector
  (scheme_id, year_id, sector_id, companies_raising, amount_raised_millions)
VALUES
  (1, 1, 1, 25, 15), (1, 1, 2, 600, 285), (1, 1, 3, 25, 16), (1, 1, 4, 30, 15),
  (1, 1, 5, 415, 151), (1, 1, 6, 35, 9), (1, 1, 7, 125, 44), (1, 1, 8, 1510, 718),
  (1, 1, 9, 200, 108), (1, 1, 10, 10, 3), (1, 1, 11, 660, 369), (1, 1, 12, 240, 102),
  (1, 1, 13, 65, 19), (1, 1, 14, 110, 41), (1, 1, 15, 90, 30), (1, 1, 16, 120, 44),
  (1, 1, 17, NULL, 1);
  
  SELECT scheme_id, year_id, COUNT(*) AS n
FROM uk_startup_funding.funding_by_sector
GROUP BY scheme_id, year_id ORDER BY scheme_id, year_id;

SELECT 'sector' t, COUNT(*) n FROM uk_startup_funding.funding_by_sector
UNION ALL SELECT 'region', COUNT(*) FROM uk_startup_funding.funding_by_region
UNION ALL SELECT 'size_band', COUNT(*) FROM uk_startup_funding.funding_by_size_band
UNION ALL SELECT 'advance_assurance', COUNT(*) FROM uk_startup_funding.advance_assurance;

SELECT * FROM funding_by_sector;