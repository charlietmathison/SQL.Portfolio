SELECT
	MAX(cust.[Cust Name]) 'Cust Name'
	,MAX(cust.[Cust Type]) 'Cust Type'
	,MAX(svc.COLLECTION_DATE) 'Collection Date'
	,MAX(svc.SVCd) 'SVCd Accounts'
	,MAX(svc.Total) 'Total Accounts'
	,MAX(svc.SVCd / svc.Total) 'SVC Rate'
FROM HBTSCustPerf.[rc].[V_SVC_ONE_PAGER] as svc
INNER JOIN [HBTSCustPerf].[dbo].[V_TS_TO_CUST] as cust
	ON svc.OID = cust.OID
WHERE MAX(svc.SVCd / svc.Total) < 20