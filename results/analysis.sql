USE uk_startup_funding;

SELECT MIN(date) AS earliest_startup_year
FROM company;

SELECT
	y.tax_year,
	s.sector_name,
    SUM(fs.amount_raised_millions) AS total_raised_millions
FROM funding_by_sector fs
JOIN sector s ON fs.sector_id = s.sector_id
JOIN year y ON fs.year_id = y.year_id
GROUP BY y.tax_year, s.sector_name
ORDER BY y.tax_year, total_raised_millions DESC;

SELECT
	name,
    industry,
    location,
    stage,
    amount_gbp,
    date
FROM company
JOIN sector ON company.sector_id = sector.sector_id
WHERE sector.sector_name = 'Manufacturing'
ORDER BY company.amount_gbp DESC;

SELECT
	sector.sector_name,
    company.location,
    COUNT(*) AS company_count
FROM company
JOIN sector ON company.sector_id = sector.sector_id
GROUP BY sector.sector_name, company.location
ORDER BY sector.sector_name, company_count DESC;

SELECT sector.sector_name, company.stage, COUNT(*) AS n
FROM company
JOIN sector ON company.sector_id = sector.sector_id
GROUP BY sector.sector_name, company.stage
ORDER BY sector.sector_name, n DESC;

SELECT
	sector.sector_name,
    COUNT(*)										AS num_companies,
    SUM(company.stage IN ('Pre-Seed', 'Seed'))		AS early_stage_count,
    ROUND(AVG(company.amount_gbp)/1000000, 2)		AS avg_raise_millions,
    ROUND(SUM(company.amount_gbp)/1000000, 2)		AS total_raise_millions
FROM company
JOIN sector ON company.sector_id = sector.sector_id
WHERE sector.sector_name IN (
	'Financial and Insurance',
    'Information and Communication',
    'Health and Social Work'
)
GROUP BY  sector.sector_name
ORDER BY num_companies DESC;

SELECT
	company.name,
    sector.sector_name,
    company.stage,
    company.location,
    company.amount_gbp
FROM company
JOIN sector ON company.sector_id = sector.sector_id
WHERE sector.sector_name IN (
	'Financial and Insurance',
    'Information and Communication',
    'Health and Social Work'
)
ORDER BY
	FIELD(company.stage, 'Pre-Seed', 'Seed', 'Series A', 'Series B') ASC,
    company.amount_gbp DESC;
    