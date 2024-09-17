DECLARE @Startdate date = '2024-01-01'
DECLARE @Enddate date = '2024-04-10'

USE HBTSCustPerf

SELECT
    MAX(cust.[Cust Name]) as 'Name',
    --MAX(svc.GROUPER_1) as 'Grouper 1',
	--MAX(svc.GROUPER_2) as 'Grouper 2',
	--MAX(svc.GROUPER_3) as 'Grouper 3',
	--MAX(svc.GROUPER_4) as 'Grouper 4',
    SUM(svc.SVC_SUCCESSES_FOR_GROUPER) as 'SVC Successes',
    SUM(svc.SVC_FAILURES_FOR_GROUPER) as 'SVC Failures',
    SUM(svc.NOT_SVCD_FOR_GROUPER) as 'Not SVCd for Grouper'
FROM
    [rc].[SVC_ONEPAGER] as svc
    JOIN [rc].V_TS_TO_CUST as cust ON svc.OID = cust.OID

WHERE svc.GROUPER_1 In('Radiology','Lab')
	AND (svc.GROUPER_2 In('Radiology','Lab') OR svc.GROUPER_3 In('Radiology','Lab') OR svc.GROUPER_4 In('Radiology','Lab'))

	--AND cust.[Cust Name] = 'University Hospitals Cleveland'
	AND svc.METRIC_START_DATE >= @Startdate
	AND svc.METRIC_END_DATE <= @Enddate
GROUP BY cust.[Cust Name]
	    --,svc.GROUPER_1
		--,svc.GROUPER_2
		--,svc.GROUPER_3
		--,svc.GROUPER_4
ORDER BY cust.[Cust Name]
		--,svc.GROUPER_1
		--,svc.GROUPER_2
		--,svc.GROUPER_3
		--,svc.GROUPER_4
