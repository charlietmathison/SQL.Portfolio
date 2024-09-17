SELECT
	MAX(cust.[Cust Name]) 'Customer Name',
	MAX(cust.[Cust Type]) as 'Customer Type',
	--MAX(svc.[GROUPER_2]) as 'Grouper',
	--MAX(svc.[COLLECTION_DATE]) as 'Collection Date',
	SUM(svc.[SVC_SUCCESSES_FOR_GROUPER]) 'Total Radiology Successes'
	,(SUM(svc.SVC_SUCCESSES_FOR_GROUPER))/((SUM(svc.SVC_FAILURES_FOR_GROUPER))+(SUM(svc.NOT_SVCD_FOR_GROUPER))+(SUM(svc.SVC_SUCCESSES_FOR_GROUPER))) 'Success Rate'
FROM [HBTSCustPerf].[dbo].[V_TS_TO_CUST] as cust
INNER JOIN [HBTSCustPerf].[rc].[SVC_ONEPAGER] as svc
	ON svc.OID = cust.OID
WHERE svc.GROUPER_2 = 'Radiology'
	AND svc.SVC_SUCCESSES_FOR_GROUPER > 0
GROUP BY cust.[Cust Name]
ORDER BY SUM(svc.[SVC_SUCCESSES_FOR_GROUPER]) DESC