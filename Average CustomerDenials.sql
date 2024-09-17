
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
svc.METRIC_START_DATE,
svc.METRIC_NAME,
AVG(METRIC_VALUE)
FROM [HBTSCustPerf].[dbo].[V_TS_TO_CUST] as cust
INNER JOIN [HBTSCustPerf].[rc].[SVC_ONEPAGER_STATS] as svc
    ON svc.OID = cust.OID
WHERE svc.METRIC_START_DATE >= @startDate
    AND svc.METRIC_END_DATE <= @endDate
GROUP BY svc.METRIC_START_DATE,
svc.METRIC_NAME
ORDER BY METRIC_START_DATE
