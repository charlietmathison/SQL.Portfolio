USE HBTSCustPerf
SELECT
	MAX(cust.[Cust Name]) as 'Customer Name'
	,MIN(svc.METRIC_START_DATE) as 'Start Date'
	,MAX(svc.METRIC_END_DATE) as 'End Date'
	,MAX(svc.GROUPER_1) as 'Rev Group 1'
	,MAX(svc.GROUPER_2) as 'Rev Group 2'
	,SUM(svc.SVCd) as 'SVCd?'
	,SUM(svc.SVC_SUCCESSES_FOR_GROUPER) as 'Success'
	,SUM(svc.SVC_FAILURES_FOR_GROUPER) as 'Fail'
	,SUM(svc.NOT_SVCD_FOR_GROUPER) as 'Not SVCd'
FROM rc.V_SVC_ONE_PAGER as svc
JOIN rc.V_TS_TO_CUST as cust ON
svc.OID = cust.OID
WHERE CAST(svc.METRIC_START_DATE as date)>CAST('2021-12-31' as date)
and CAST(svc.METRIC_END_DATE as date)<CAST('2022-10-1' as date)
GROUP BY svc.SVC_SUCCESSES_FOR_GROUPER