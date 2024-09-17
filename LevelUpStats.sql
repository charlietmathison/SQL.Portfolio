USE HBTSCustPerf

DECLARE @Startdate date = '2024-08-01'
DECLARE @Enddate date = '2024-08-31'

USE HBTSCustPerf
SELECT MAX(cust.[Cust Name]) as 'Name'
	,MAX(DISTINCT svc.GROUPER_1) as 'Grouper 1'
	,MAX(DISTINCT svc.GROUPER_2) as 'Grouper 2'
	,MAX(DISTINCT svc.GROUPER_3) as 'Grouper 3'
	,MAX(DISTINCT svc.GROUPER_4) as 'Grouper 4'
	,SUM(DISTINCT svc.SVC_SUCCESSES_FOR_GROUPER) as 'SVC Successes'
	,SUM(DISTINCT svc.SVC_FAILURES_FOR_GROUPER) as 'SVC Failures'
	,SUM(DISTINCT svc.NOT_SVCD_FOR_GROUPER) as 'Not SVCd for Grouper'
	,(100*SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / (SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER) + SUM(svc.NOT_SVCD_FOR_GROUPER))) as 'SVC Success %'
FROM [rc].[SVC_ONEPAGER] as svc
	JOIN [rc].V_TS_TO_CUST as cust
	on svc.OID = cust.OID
WHERE 1=1
	AND svc.METRIC_START_DATE >= @Startdate
	AND svc.METRIC_END_DATE <= @Enddate
	AND cust.[Cust Name] = 'Healthcare System'
GROUP BY svc.GROUPER_1
		,svc.GROUPER_2
		,svc.GROUPER_3
		,svc.GROUPER_4
ORDER BY svc.GROUPER_1
		,svc.GROUPER_2
		,svc.GROUPER_3
		,svc.GROUPER_4