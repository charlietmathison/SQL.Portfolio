DECLARE @Startdate date = '2021-10-05'
DECLARE @Enddate date = '2022-10-05'

USE IC_QA_S1

SELECT 
	MAX(ZC_BTG_ACTION.NAME) as 'BTG Action',
	MAX(ZC_BTG_REASON.NAME) as 'BTG Reason',
	MAX(ZC_LICENSE_USRTYPE.NAME) as 'User Type',
	COUNT(*) as 'BTG Checks Fired'
	
FROM F_BTG_LOG
	LEFT JOIN ZC_BTG_ACTION 
		ON F_BTG_LOG.BTG_ACTION_C = ZC_BTG_ACTION.BTG_ACTION_C
	LEFT JOIN ZC_BTG_REASON 
		ON F_BTG_LOG.BTG_REASON_C = ZC_BTG_REASON.BTG_REASON_C
	LEFT JOIN CLARITY_EMP 
		ON F_BTG_LOG.USER_ID = CLARITY_EMP.USER_ID
	LEFT JOIN ZC_LICENSE_USRTYPE 
		ON CLARITY_EMP.LICENSE_USRTYPE_C = ZC_LICENSE_USRTYPE.LICENSE_USRTYPE_C

WHERE 1=1
	AND F_BTG_LOG.BTG_ACTION_C=1
	AND F_BTG_LOG.BTG_INSTANT >= @Startdate
	AND F_BTG_LOG.BTG_INSTANT <= @Enddate
	
GROUP BY 
	ZC_BTG_ACTION.NAME, 
	ZC_BTG_REASON.NAME, 
	ZC_LICENSE_USRTYPE.NAME
	
ORDER BY [BTG Action],
	[BTG Reason],
	[User Type];

SELECT 
	MAX(ZC_BTG_ACTION.NAME) as 'BTG Action',
	MAX(ZC_LICENSE_USRTYPE.NAME) as 'User Type',
	COUNT(*) as 'BTG Checks Fired'
	
FROM F_BTG_LOG
	LEFT JOIN ZC_BTG_ACTION 
		ON F_BTG_LOG.BTG_ACTION_C = ZC_BTG_ACTION.BTG_ACTION_C
	LEFT JOIN ZC_BTG_REASON 
		ON F_BTG_LOG.BTG_REASON_C = ZC_BTG_REASON.BTG_REASON_C
	LEFT JOIN CLARITY_EMP 
		ON F_BTG_LOG.USER_ID = CLARITY_EMP.USER_ID
	LEFT JOIN ZC_LICENSE_USRTYPE 
		ON CLARITY_EMP.LICENSE_USRTYPE_C = ZC_LICENSE_USRTYPE.LICENSE_USRTYPE_C

WHERE 1=1
	AND (F_BTG_LOG.BTG_ACTION_C=2 OR F_BTG_LOG.BTG_ACTION_C=3)
	AND F_BTG_LOG.BTG_INSTANT >= @Startdate
	AND F_BTG_LOG.BTG_INSTANT <= @Enddate
	
GROUP BY 
	ZC_BTG_ACTION.NAME, 
	ZC_LICENSE_USRTYPE.NAME
	
ORDER BY [BTG Action],
	[User Type];

;