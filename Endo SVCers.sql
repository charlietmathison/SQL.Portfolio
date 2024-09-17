DECLARE @Startdate date = '2024-01-01'
DECLARE @Enddate date = '2024-03-01'

USE HBTSCustPerf

SELECT
    MAX(cust.[Cust Name]) as 'Name',
    MAX(svc.GROUPER_1) as 'Grouper 1',
    SUM(svc.SVC_SUCCESSES_FOR_GROUPER) as 'SVC Successes',
    SUM(svc.SVC_FAILURES_FOR_GROUPER) as 'SVC Failures',
    SUM(svc.NOT_SVCD_FOR_GROUPER) as 'Not SVCd for Grouper',
    CASE
        WHEN COALESCE(SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER), 0) = 0 THEN NULL
        ELSE (100 * SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / NULLIF(SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER), 0))
    END as 'SVC Success %',
    CASE
        WHEN COALESCE(SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER) + SUM(svc.NOT_SVCD_FOR_GROUPER), 0) = 0 THEN NULL
        ELSE (100 * SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / NULLIF(SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER) + SUM(svc.NOT_SVCD_FOR_GROUPER), 0))
    END as 'Coverage Rate %'
FROM
    [rc].[SVC_ONEPAGER] as svc
    JOIN [rc].V_TS_TO_CUST as cust ON svc.OID = cust.OID

WHERE 1=1
	AND svc.GROUPER_1 = 'Endo'
	--AND cust.[Cust Name] = 'University Hospitals Cleveland'
	AND svc.METRIC_START_DATE >= @Startdate
	AND svc.METRIC_END_DATE <= @Enddate
GROUP BY cust.[Cust Name]
HAVING (100*SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / (SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER) + SUM(svc.NOT_SVCD_FOR_GROUPER))) > 90
ORDER BY 'SVC Successes' DESC;
