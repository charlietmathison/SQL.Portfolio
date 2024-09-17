DECLARE @startDate char(10) = '2023-01-01'
DECLARE @endDate char(10) = '2024-08-01'

USE HBTSCustPerf

SELECT
   MAX(cust.[Cust Name]),
	MAX(svc.METRIC_START_DATE),
 --   SUM(svc.SVC_SUCCESSES_FOR_GROUPER) as 'SVC Successes',
 --   SUM(svc.SVC_FAILURES_FOR_GROUPER) as 'SVC Failures',
   -- SUM(svc.NOT_SVCD_FOR_GROUPER) as 'Not SVCd for Grouper'
	(100*SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / (SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER) + SUM(svc.NOT_SVCD_FOR_GROUPER))) as 'SVC Success %'
FROM
    [rc].[SVC_ONEPAGER] as svc
    JOIN [rc].V_TS_TO_CUST as cust ON svc.OID = cust.OID

WHERE svc.METRIC_START_DATE >= @Startdate
	AND svc.METRIC_END_DATE <= @Enddate
	AND [Cust Name]='Childrens Hospital of Philadelphia'
GROUP BY cust.[Cust Name],
svc.METRIC_START_DATE
ORDER BY cust.[cust name],
METRIC_START_DATE
