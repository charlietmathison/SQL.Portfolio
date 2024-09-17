/*****
Author: Charlie Mathison
Date: 6/7/2024
Description: How many BTG Checks have been fired over the course of 2023, broken down by Action, Reason, and User Type.
*****/

--USE IC_QA_S1

/*Setting timeframe of search*/
DECLARE @Startdate date = '2023-01-01'
DECLARE @Enddate date = '2023-12-31'


--Detailed Rows
SELECT 
	--ZC_BTG_ACTION.NAME AS 'BTG Action',
	CASE 
        WHEN ZC_BTG_ACTION.NAME = 'Denied access' THEN 'Covered by Inappropriate BTG – Access not allowed'
        ELSE ZC_BTG_ACTION.NAME
	END AS 'BTG Action',
/*Case statement sets BTG reason to N/A or not entered when null*/
    CASE 
        WHEN ZC_BTG_ACTION.NAME = 'Broke the Glass' AND ZC_BTG_REASON.NAME IS NULL THEN 'User Did Not Enter Reason'
        WHEN (ZC_BTG_ACTION.NAME = 'Bumped the Glass' OR ZC_BTG_ACTION.NAME = 'Denied Access') AND ZC_BTG_REASON.NAME IS NULL THEN 'N/A'
        ELSE ZC_BTG_REASON.NAME
    END AS 'BTG Reason',
/*Case statement seperates Providers from Non-Providers and looks to two different values for User Type if populated*/
	CASE 
		WHEN CLARITY_EMP.PROV_ID IS NULL AND ZC_USER_TYPES.NAME IS NULL THEN 'Non-Provider - No User Type Specified'
        WHEN CLARITY_EMP.PROV_ID IS NULL AND ZC_USER_TYPES.NAME IS NOT NULL THEN 'Non-Provider - ' + ZC_USER_TYPES.NAME
		WHEN CLARITY_EMP.PROV_ID IS NOT NULL AND CLARITY_SER.PROV_TYPE IS NULL AND ZC_USER_TYPES.NAME IS NOT NULL THEN 'Provider - ' + ZC_USER_TYPES.NAME
		WHEN CLARITY_EMP.PROV_ID IS NOT NULL AND CLARITY_SER.PROV_TYPE IS NULL AND ZC_USER_TYPES.NAME IS NULL THEN 'Provider - No User Type Specified'
        ELSE 'Provider - ' + CLARITY_SER.PROV_TYPE
	END AS 'User Type',
    COUNT(*) AS 'BTG Presented',
    COUNT(DISTINCT(F_BTG_LOG.PAT_ID)) AS 'Unique Patients'

FROM F_BTG_LOG
    LEFT JOIN ZC_BTG_ACTION 
        ON F_BTG_LOG.BTG_ACTION_C = ZC_BTG_ACTION.BTG_ACTION_C
    LEFT JOIN ZC_BTG_REASON 
        ON F_BTG_LOG.BTG_REASON_C = ZC_BTG_REASON.BTG_REASON_C
    LEFT JOIN CLARITY_EMP 
        ON F_BTG_LOG.USER_ID = CLARITY_EMP.USER_ID
	LEFT JOIN CLARITY_SER
		ON CLARITY_EMP.PROV_ID = CLARITY_SER.PROV_ID
	LEFT JOIN USER_TYPE
		ON CLARITY_EMP.USER_ID = USER_TYPE.USER_ID
	LEFT JOIN ZC_USER_TYPES
		ON USER_TYPE.USER_TYPE_C = ZC_USER_TYPES.USER_TYPES_C


WHERE 
    F_BTG_LOG.BTG_INSTANT >= @Startdate
    AND F_BTG_LOG.BTG_INSTANT <= @Enddate

GROUP BY 
    ZC_BTG_ACTION.NAME, 
    ZC_BTG_REASON.NAME,
	--Repeats Case statement from Select clause
	CASE 
		WHEN CLARITY_EMP.PROV_ID IS NULL AND ZC_USER_TYPES.NAME IS NULL THEN 'Non-Provider - No User Type Specified'
        WHEN CLARITY_EMP.PROV_ID IS NULL AND ZC_USER_TYPES.NAME IS NOT NULL THEN 'Non-Provider - ' + ZC_USER_TYPES.NAME
		WHEN CLARITY_EMP.PROV_ID IS NOT NULL AND CLARITY_SER.PROV_TYPE IS NULL AND ZC_USER_TYPES.NAME IS NOT NULL THEN 'Provider - ' + ZC_USER_TYPES.NAME
		WHEN CLARITY_EMP.PROV_ID IS NOT NULL AND CLARITY_SER.PROV_TYPE IS NULL AND ZC_USER_TYPES.NAME IS NULL THEN 'Provider - No User Type Specified'
        ELSE 'Provider - ' + CLARITY_SER.PROV_TYPE END

ORDER BY 
    ZC_BTG_ACTION.NAME,
    [BTG Presented],
	[Unique Patients]


-- Summary rows for each BTG Action
SELECT 
/*Summarizes the BTG Action on 'BTG Checks Fired' and 'Unique Patients'*/
    CASE 
        WHEN MAX(ZC_BTG_ACTION.NAME) = 'Denied access' THEN 'Covered by Inappropriate BTG – Access not allowed - Total'
        ELSE MAX(ZC_BTG_ACTION.NAME) + ' - Total' 
	END AS 'BTG Action',
    --'-' AS 'BTG Reason',
    --'-' AS 'User Type',
    COUNT(*) AS 'BTG Presented',
    COUNT(DISTINCT(F_BTG_LOG.PAT_ID)) AS 'Unique Patients'

FROM F_BTG_LOG
    LEFT JOIN ZC_BTG_ACTION 
        ON F_BTG_LOG.BTG_ACTION_C = ZC_BTG_ACTION.BTG_ACTION_C

WHERE 
    F_BTG_LOG.BTG_INSTANT >= @Startdate
    AND F_BTG_LOG.BTG_INSTANT <= @Enddate

GROUP BY 
    ZC_BTG_ACTION.NAME

ORDER BY 
    ZC_BTG_ACTION.NAME
   

-- Returns count of sensitive notes created in specified time
SELECT    
   COUNT(NOTE_ENC_INFO.NOTE_ID)  AS 'Total of Sensitive Notes Created'
FROM NOTE_ENC_INFO

WHERE 
    NOTE_ENC_INFO.SPEC_NOTE_TIME_DTTM >= @Startdate
    AND NOTE_ENC_INFO.SPEC_NOTE_TIME_DTTM <= @Enddate
	AND SENSITIVE_STAT_C = 1

--Returns count of Release Restriction FYI Flags created in specified time
SELECT 
	COUNT(DISTINCT(PATIENT_ID)) AS 'Total of Patients with Release Restrictions FYI Flags Added'

FROM PATIENT_FYI_FLAGS

WHERE
	ACCT_NOTE_INSTANT >= @Startdate
    AND ACCT_NOTE_INSTANT <= @Enddate
	AND PAT_FLAG_TYPE_C = '2'
   

;