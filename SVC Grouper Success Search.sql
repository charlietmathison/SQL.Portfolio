SELECT
    MAX(cust.[Cust Name]) 'Customer Name',
    SUM(svc.SVC_SUCCESSES_FOR_GROUPER) 'svc successes',
    SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER) 'total svcd',
    SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / NULLIF((SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER)), 0) * 100 'svc succ rate %',
	SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / NULLIF((SUM(svc.SVC_FAILURES_FOR_GROUPER) + SUM(svc.SVC_SUCCESSES_FOR_GROUPER) + SUM(svc.NOT_SVCD_FOR_GROUPER)), 0) * 100 'svc cvg rate %',
	SUM(svc.SVC_SUCCESSES_FOR_GROUPER) / 20 'time saved (hrs)', -- based on estimated 3 min per hospital account
	SUM(svc.SVC_SUCCESSES_FOR_GROUPER) * 26 / 20000000 'money saved (M$ [26 $ / 1 hr])' -- based on 2022 average OP coder income of 55K from AAPC
FROM [HBTSCustPerf].[dbo].[V_TS_TO_CUST] as cust
INNER JOIN [HBTSCustPerf].[rc].[SVC_ONEPAGER] as svc
    ON svc.OID = cust.OID
WHERE svc.METRIC_START_DATE >= CAST('2022-05-01' AS DATE)
    AND svc.METRIC_END_DATE <= CAST('2023-05-01' AS DATE)
--GROUP BY cust.[Cust Name];
