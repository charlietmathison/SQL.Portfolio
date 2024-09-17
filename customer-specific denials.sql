
DECLARE @startDate char(10) = '2023-01-01'
DECLARE @endDate char(10) = '2024-08-01'

/*
-- dates must be in 'YYYY-MM-DD' format


CREATE TABLE input_vars (
 startDate DATE,
 endDate DATE
 );

SELECT *
FROM input_vars
*/

SELECT
cust.[Cust Name],
svc.METRIC_START_DATE,
SUM(METRIC_VALUE) as 'Total Denials'
--svc.METRIC_VALUE
--AVG(METRIC_VALUE)
FROM [HBTSCustPerf].[dbo].[V_TS_TO_CUST] as cust
INNER JOIN [HBTSCustPerf].[rc].[SVC_ONEPAGER_STATS] as svc
    ON svc.OID = cust.OID
WHERE svc.METRIC_START_DATE >= @startDate
    AND svc.METRIC_END_DATE <= @endDate
	AND [Cust Name] = 'Erlanger Health'
	AND svc.METRIC_NAME LIKE '%Denial'
GROUP BY cust.[Cust Name],
svc.METRIC_START_DATE
ORDER BY cust.[cust name],
METRIC_START_DATE



SELECT
cust.[Cust Name],
svc.METRIC_START_DATE,
SUM(METRIC_VALUE) as 'SVCd Denials'
--svc.METRIC_VALUE
--AVG(METRIC_VALUE)
FROM [HBTSCustPerf].[dbo].[V_TS_TO_CUST] as cust
INNER JOIN [HBTSCustPerf].[rc].[SVC_ONEPAGER_STATS] as svc
    ON svc.OID = cust.OID
WHERE svc.METRIC_START_DATE >= @startDate
    AND svc.METRIC_END_DATE <= @endDate
	AND [Cust Name] = 'Erlanger Health'
	AND svc.METRIC_NAME LIKE 'SVCd%Denial'
GROUP BY cust.[Cust Name],
svc.METRIC_START_DATE
ORDER BY cust.[cust name],
METRIC_START_DATE

SELECT
cust.[Cust Name],
svc.METRIC_START_DATE,
SUM(METRIC_VALUE) as 'Manually Coded Denials'
--svc.METRIC_VALUE
--AVG(METRIC_VALUE)
FROM [HBTSCustPerf].[dbo].[V_TS_TO_CUST] as cust
INNER JOIN [HBTSCustPerf].[rc].[SVC_ONEPAGER_STATS] as svc
    ON svc.OID = cust.OID
WHERE svc.METRIC_START_DATE >= @startDate
    AND svc.METRIC_END_DATE <= @endDate
	AND [Cust Name] = 'Erlanger Health'
	AND svc.METRIC_NAME LIKE 'Manually%Denial'
GROUP BY cust.[Cust Name],
svc.METRIC_START_DATE
ORDER BY cust.[cust name],
METRIC_START_DATE
;