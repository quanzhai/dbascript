DECLARE @cmd VARCHAR(5000)
DECLARE @varDate varchar(10)

SET @varDate = cast(CONVERT(char(10), GetDate(),126) as varchar(10))

--__Marval1177RequestAttributeValue
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestAttributeValueId],v.[requestAttributeTypeId],r.[requestId],QUOTENAME([textValue],''""'') as textValue,[booleanValue],[numberValue],[dateValue],v.[isLogicallyDeleted],v.[isRecycled] FROM [Marval].[dbo].[requestAttributeValue] v JOIN [Marval].[dbo].[request] r on v.[requestId]=r.[requestId] JOIN [Marval].[dbo].[requestAttributeType] t ON t.[requestAttributeTypeId]=v.[requestAttributeTypeId] where t.[containsPersonalInformation]=0 AND ([textValue] IS NOT NULL OR [booleanValue] IS NOT NULL OR [numberValue] IS NOT NULL OR [dateValue] IS NOT NULL) AND r.createdon >= dateadd(YEAR, -2, getdate())" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177RequestAttributeValue.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177RequestAttributeType
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestAttributeTypeId],[requestTypeId],QUOTENAME([name],''""'') as name,[dataEntryType],[groupName],[isLogicallyDeleted],[isRecycled],[createdOn],[createdBy],[updatedOn],[updatedBy],[dataType],[accessLevelId],[isRequired],QUOTENAME([description],''""'') as description,[containsPersonalInformation] FROM [Marval].[dbo].[requestAttributeType] WHERE [containsPersonalInformation]=0" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177RequestAttributeType.txt -s ";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177CI
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [CIId],[CITypeId],[isLogicallyDeleted],[isRecycled],[isBaseLine],[assetNo],[ownerCIId],[useOwnersAddress],[contactCIId],[name] ,[importantForBusCont],[CIStatusId],[stockAuditPeriodDays],[stockAuditNextDate],[locationCIId],[discoveryId],[locationId],[createdBy],[createdOn],[updatedBy],[updatedOn],[isLocked],[CIClass],[usedByCIId],[accessLevelId],[usersInSLA],[usersOutSLA],[autoDictionaryId],[autoClassificationId] FROM [Marval].[dbo].[CI]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177CI.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177CIType
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [CITypeId],REPLACE([name], CHAR(59), '''') as [name],[isBaseType],[baseCITypeId],[isAsset],[isRecycled],[isLogicallyDeleted],[createdOn],[createdBy],[updatedOn],[updatedBy] FROM [Marval].[dbo].[CIType]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177CIType.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Classification
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [classificationId],[dictionaryId],[description],[forceSatisfactionCollection],[isRecycled],[isLogicallyDeleted],[createdBy],[createdOn],[updatedBy],[updatedOn],[outageType],[backFillServiceIds],[overwriteExistingService] FROM [Marval].[dbo].[classification]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Classification.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Dictionary
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [dictionaryId],[name],[reqClassFiltersRuleSetId],[isRecycled],[isLogicallyDeleted],[createdOn],[createdBy],[updatedOn],[updatedBy] FROM [Marval].[dbo].[dictionary]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Dictionary.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Dt_list_requests_a
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestId],[requestNumber],[totalTimeSpentDuration],[isMajorIncident],[requestType_requestTypeId],[requestType_baseRequestTypeId],[requestType_acronym],[requestType_name],[assignment_startDate],[assignment_acceptedDate],[closedBy_id],[closedBy_name],[closedBy_primaryGroup_id],[closedBy_primaryGroup_name], sla_isFixed, sla_isRespondedTo FROM [Marval].[dbo].[dt_list_requests_a] where createdOn >= dateadd(YEAR, -2, getdate())" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Dt_list_requests_a.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Dt_list_requests_b
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestId],[requestNumber],[totalTimeSpentDuration],[isMajorIncident],[requestType_requestTypeId],[requestType_baseRequestTypeId],[requestType_acronym],[requestType_name],[assignment_startDate],[assignment_acceptedDate],[closedBy_id],[closedBy_name],[closedBy_primaryGroup_id],[closedBy_primaryGroup_name], sla_isFixed, sla_isRespondedTo FROM [Marval].[dbo].[dt_list_requests_b] where createdOn >= dateadd(YEAR, -2, getdate())" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Dt_list_requests_b.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Impact
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [impactId],[requestTypeId],[value],char(34) + [description] + char(34) as [description],[isRecycled],[isLogicallyDeleted],[updatedOn],[updatedBy] FROM [Marval].[dbo].[impact]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Impact.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Person
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [CIId],replace([givenName], CHAR(59), '''') as [givenName],Replace([middleName],CHAR(59), '''') as [middleName],REPLACE([familyName],CHAR(59), '''') as [familyName],[salutation],[title],REPLACE([jobTitle], CHAR(59), '''') as [jobTitle],REPLACE([nickname], CHAR(59), '''') as [nickname],[isUser],[isNamedUser],[selfServiceUserType],REPLACE([vehicleRegistration], CHAR(59), '''') as [vehicleRegistration] ,REPLACE([personalTelephone], CHAR(59), '''') as [personalTelephone],REPLACE([emergencyTelephone], CHAR(59), '''') as [emergencyTelephone],[isDisabled],[isXDirectory],[uniqueId],[secondaryId],REPLACE([securityAccess], CHAR(59), '''') as [securityAccess],[dateDisabled],[isSelfServiceApprover],[isXtractionNamedUser],[isXtractionConcurrentUser],[primaryGroupId] FROM [Marval].[dbo].[person]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Person.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Priority
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [priorityId],[requestTypeId],[value],REPLACE([description], CHAR(59), '''') as [description],[isRecycled],[isLogicallyDeleted],[updatedOn],[updatedBy] FROM [Marval].[dbo].[priority]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Priority.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Release
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestId],REPLACE([version], CHAR(59), '''') as [version], replace(Replace([results], CHAR(13) + CHAR(10), ''''), char(59), '''') as [results],[releaseDate], replace(Replace([backOutReason], CHAR(13) + CHAR(10), ''''), char(59), '''') as [backOutReason],[isCompleted],[isBackedOut],[monitoringPeriod],[serviceOutage] FROM [Marval].[dbo].[release]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Release.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Request
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestId],[requestNumber],[requestTypeId], REPLACE(REPLACE(REPLACE([description], CHAR(13), '' ''), CHAR(10), '' ''), CHAR(59), '''') as [description],[sectorCustomerId],[serviceId],[serviceFunctionId],[assignmentId],[trackingId],[contactCIId],[knownErrorId],[dateCreated],[dateOccurred],[urgencyId],[priorityId],[priorityOverridden],[slaResponseBreached],[slaFixBreached],[olaResponseBreached],[olaFixBreached],[isClosed],[isSolved],[isRespondedTo],[isFixed],[slaRespondedToInTime],[slaFixedInTime],[responsedToOn],[fixedOn],[solvedOn],[closedOn],[slaElapsedFixTimeSecs],[slaElapsedFixTimeSecsUpdatedAt],[slaElapsedFixTimeInSlaHours],[SLAElapsedFixTimeHourPeriodEnd],[slaElapsedClosedTimeSecs],[SLAElapsedClosedTimeSecUpdtdAt],[slaElapsedClosedTimeInSlaHours],[SLAElapsedClosedTimeHourPrdEnd],[workloadEstimate],REPLACE([thirdParty] , CHAR(59), '''') as [thirdParty],[preferredNotificationMethod],REPLACE([preferredNotificationAddress] , CHAR(59), '''') as [preferredNotificationAddress],[locationId],[slaExpectedResponseBreach],[slaExpectedFixBreach],[olaExpectedResponseBreach],[olaExpectedFixBreach],[startDate],[endDate],[createdOn],[createdBy],[updatedOn],[updatedBy],[callSource],[projectCode],[costCentre],[satisfactionId],REPLACE([contactName], CHAR(59), '''') as [contactName],REPLACE([contactTelephoneNumber], CHAR(59), '''') as [contactTelephoneNumber],REPLACE([contactTelephoneExtension], CHAR(59), '''') as [contactTelephoneExtension],[completeBy],[estimatedArrivalTime],REPLACE( [estimatedArrivalComment], CHAR(59), '''') as [estimatedArrivalComment],REPLACE(REPLACE(REPLACE([customerReportedSymptom] , CHAR(13), '' ''), CHAR(10), '' ''), CHAR(59), '''')  as [customerReportedSymptom],[solvedByUserId],[slaResponseEscalationPointId],[slaFixEscalationPointId],[olaResponseEscalationPointId],[olaFixEscalationPointId],[serviceLevelAgreementId],[personBuckCount],[groupBuckCount],[totalTimeSpentDuration],[solvedByKnownError],[spokeToCIId],[primaryNotifTarget],[templateRequestId],[slaElapsedResponseTime],[slaResponseTimeRemaining],[slaElapsedFixTime],[slaFixTimeRemaining],[slaElapsedFixTimeFromStart],[slaElapsedFixTimeFromResponse],[slaElapsedFixTimeFromBreach],[slaElapsedCloseTime],[slaElapsedCloseTime24],[slaElapsedTimeInHold],[slaElapsedTimeInHold24],[slaResponsePercentage],[slaFixPercentage],[olaElapsedResponseTime],[olaResponseTimeRemaining],[olaElapsedFixTime],[olaFixTimeRemaining],[olaElapsedFixTimeFromStart],[olaElapsedFixTimeFromResponse],[olaElapsedFixTimeFromBreach],[olaElapsedCloseTime],[olaElapsedCloseTime24],[olaElapsedTimeInHold],[olaElapsedTimeInHold24],[olaResponsePercentage],[olaFixPercentage],[isFirstTimeFix],[respondedToBy],[fixedBy],[solvedBy],[closedBy],[contractSLAId],[callTick],[approvalState],[approvalStateLastUpdatedOn],[requestArchiveId],[impactId],[SLIId],[serviceAgreementId],[thresholdPeriod],[alertingPeriod],[assigneeId],[previousAssigneeId],[trackerId],[statusId],[workflowId],[currentOlaId],[lastOlaId],[assignmentResponseDate],[lastPriorityChangeReasonId],[lastImpactChangeReasonId],[lastUrgencyChangeReasonId],[riskId],[selfServiceApproverId],[requestCost],[changeModelId],[requestCharge],[isClone],[consumed],[outOfHours] FROM [Marval].[dbo].[request]  where createdon >= dateadd(YEAR, -2, getdate())" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Request.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177RequestClassification
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT a.[requestClassificationId],a.[classificationId],a.[dictionaryId],a.[requestId]  FROM [Marval].[dbo].[requestClassification]  a left join [Marval].[dbo].[request] b on a.requestId = b.requestId where b.CreatedOn >= dateadd(year, -2, getdate())" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177RequestClassification.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177RequestSource
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestSourceId],[name],[isLogicallyDeleted],[isRecycled],[createdBy],[createdOn],[updatedBy],[updatedOn],[isSystem],[isForSelfService],[isForMailService],[isForWebService],[isForSNMPService],[isForDiscoveryService],[isForAutomated] FROM [Marval].[dbo].[requestSource]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177RequestSource.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177RequestStatus
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestStatusId],[startDate],[endDate],[workflowStatusId],[createdOn],[createdByUserId],[modifiedOn],[modifiedByUserId],[requestId] FROM [Marval].[dbo].[requestStatus] where [startDate] >= dateadd(year, -2, getdate())" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177RequestStatus.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177RequestType
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestTypeId],REPLACE([name], CHAR(59), '''') as [name],[isBaseType],REPLACE([acronym], CHAR(59), '''') as [acronym],[baseRequestTypeId],[defaultWorkflowId],[isRecycled],[isLogicallyDeleted],[createdOn],[createdBy],[updatedOn],[updatedBy],[isSolutionReqAtSol],[schStartOnCreate],[requireRiskRating],[requireRequestCost] FROM [Marval].[dbo].[requestType]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177RequestType.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177ServiceLevelAgreement
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [serviceLevelAgreementId],REPLACE([name], CHAR(59), '''') as [name],[startDate],[endDate],[responseTimeType],[responseTimeSecs],[responseTimeDays],[fixTimeType],[fixTimeSecs],[fixTimeDays],[clockType],[deductTimeInHoldState],[renewalDate], REPLACE([notes], CHAR(59), '''') as [notes],REPLACE([specialInstructions], CHAR(59), '''') as [specialInstructions],[callTickLimitIncidents],[callTickLimitTimeHours],[isRecycled],[isLogicallyDeleted],[isActive],[personBuckCountLimit],[personBuckCountScriptId],[groupBuckCountLimit],[groupBuckCountScriptId],[createdOn],[createdBy],[updatedOn],[updatedBy],[isSystem],[breachReasonEnabled],[renewalReminderInNdays],[sendEmailWithReminder],[contactId] FROM [Marval].[dbo].[serviceLevelAgreement]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177ServiceLevelAgreement.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Status
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [statusId],REPLACE([name], CHAR(59), '''') as [name],[isHoldState],[isClosedState],[isSolvedState],[isResponseState],[isFixedState],[isUnSolvedState],[isMoreState],[isBackedOutState],[isRecycled],[isLogicallyDeleted],[preScriptId],[postScriptId],[createdOn],[createdBy],[updatedOn],[updatedBy],[assigneeUpdateType],[updateAssigneeId],REPLACE([description], CHAR(59), '''') as [description],[isLockdownTriggerState],[isLockdownReleaseState],[consumeChargeableItems],[isOutageStart],[isOutageEnd],[collectHoldReason] FROM [Marval].[dbo].[status]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Status.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Urgency
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [urgencyId],[requestTypeId],[value],REPLACE([description], CHAR(59), '''') as [description],[isRecycled],[isLogicallyDeleted],[updatedOn],[updatedBy] FROM [Marval].[dbo].[urgency]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Urgency.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177User
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [userId],[personOrganisationalUnitId],REPLACE([username], CHAR(59), '''') as [username],[iterationCount],REPLACE([resetGuid] , CHAR(59), '''') as [resetGuid],[generatedOn] FROM [Marval].[dbo].[user_]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177User.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177WorkflowStatus
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [workflowStatusId],[workflowId],[statusId],[x],[y],[isRecycled],[isLogicallyDeleted] FROM [Marval].[dbo].[workflowStatus]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177WorkflowStatus.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177requestRelationship
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [requestId],[relatedRequestId],[relationshipCreatedOn] FROM [Marval].[dbo].[requestRelationship]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177requestRelationship.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Workflow
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [workflowId],[name],[isRecycled],[isLogicallyDeleted],[createdOn],[createdBy],[updatedOn],[updatedBy] FROM [Marval].[dbo].[workflow]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Workflow.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd

--__Marval1177Assignment
set @cmd = 'sqlcmd -S "localhost\MSSQL, 14301" -d "Marval" -E -Q "set nocount on;SELECT [assignmentId],[CIId],[supportGroup],[startDate],[endDate],[acceptedDate],[operationalLevelAgreementId],[underpinningContractId],[requestId],[OlaUcStartDate] ,[rejectedDate],[successfulDate],[unSuccessfulDate],[isPropogatedOLA],[isPropogatedUC],[OlaUcResponseBreach],[OlaUcFixBreach] FROM [Marval].[dbo].[assignment]" -o E:\Data\MarvalExport\'+@varDate+'__Marval1177Assignment.txt -s";" -W'

EXEC master.dbo.xp_cmdshell @cmd
