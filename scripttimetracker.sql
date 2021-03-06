USE [TimeTracker]
GO
/****** Object:  StoredProcedure [dbo].[Allot_For_Keying]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[Allot_For_Keying]
(@opType varchar(100)=null,@Facility varchar(250)=null,@BatchName varchar(300)=null,
@from_Date datetime=null,@to_Date datetime=null,@from int=null,
@to int=null,@coder varchar(max)=null,@status varchar(350)=null,@projid int=null)
as
begin
--with cte1
--as
--(
--select ROW_NUMBER() over (order by [ALLOT_ID]) as rownumber from KEYING_ALLOTMENT
--)

if @opType='PageLoad'
begin
select distinct [ALLOT_ID], 
	[BATCH_ID] ,
	[PROJECT_ID],
	[ALLOTED_TO] as [Keyer],
	[BATCH_NAME] as [Batch Name],
	[ACCOUNT_NO] as [Account No],
	Convert(varchar(12),[RECEIVED_DATE],101) as [Received Date],
	[SPECIALITY] as [Speciality],
	[FACILITY] as [Facilty],
	[LOCATION] as [Location],
	[BATCH_STATUS] as [Batch Status],
	[CODER_NTLG] as [Coder],
		Convert(varchar(12),[CODED_DATE],101) as [Coded Date]
	--[ALLOTED_TO],
	--[ALLOTED_BY]
	--[ALLOTED_DATE],
	--[UPADATED_BY],
	--[UPDATED_DATE] 
	from  KEYING_ALLOTMENT where BATCH_STATUS='CODED' and [PROJECT_ID]=@projid
end
else if @opType='Reload'
begin
select distinct [ALLOT_ID], 
	[BATCH_ID] ,
	[PROJECT_ID],
	[ALLOTED_TO] as [Keyer],
	[BATCH_NAME] as [Batch Name],
	[ACCOUNT_NO] as [Account No],
	Convert(varchar(12),[RECEIVED_DATE],101) as [Received Date],
	[SPECIALITY] as [Speciality],
	[FACILITY] as [Facilty],
	[LOCATION] as [Location],
	[BATCH_STATUS]  as [Batch Status],
	[CODER_NTLG] as [Coder],
	Convert(varchar(12),[CODED_DATE],101)as [Coded Date]
	--[ALLOTED_TO],
	--[ALLOTED_BY]
	--[ALLOTED_DATE],
	--[UPADATED_BY],
	--[UPDATED_DATE] 
	
	from  KEYING_ALLOTMENT 
	where ((nullif(@Facility,null)is null or [FACILITY]=@Facility))and ((nullif(@BatchName,null)is null or BATCH_NAME=@BatchName))and
	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))AND --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	(nullif(@coder,null) is null or [CODER_NTLG]=@coder)and --((nullif(@from,null)is null and nullif(@to,null)is null)or cte1.rownumber between @from and @to)
	(nullif(@status,null)is null or [BATCH_STATUS]=@status)and [PROJECT_ID]=@projid
	
	
	end
	
	else if @opType='Pend' and (@status='Pending'or @status='Hold' or @status='Incomplete' or @status='Re-open' or @status='ALLOTTED')
	begin
	select distinct [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	[ALLOTED_TO] as [Keyer],
	[BATCH_NAME] as [Batch Name],
	[ACCOUNT_NO] as [Account No],
	Convert(varchar(12),[RECEIVED_DATE],101) as [Received Date],
	[SPECIALITY] as [Speciality],
	[FACILITY] as [Facilty],
	[LOCATION] as [Location],
	[BATCH_STATUS]  as [Batch Status],
	[CODER_NTLG] as [Coder Ntlg],
	Convert(varchar(12),[CODED_DATE],101)as [Coded Date]
	
	from  KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID and KT.KEYING_STATUS=@status and KA.BATCH_STATUS='KEYING'--KA.BATCH_STATUS='ALLOTTED'
	where ((nullif(@Facility,null)is null or [FACILITY]=@Facility))and ((nullif(@BatchName,null)is null or BATCH_NAME=@BatchName))and
	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))AND --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	(nullif(@coder,null) is null or [CODER_NTLG]=@coder)--and --((nullif(@from,null)is null and nullif(@to,null)is null)or cte1.rownumber between @from and @to)
	--(nullif(@status,null)is null or [BATCH_STATUS]=@status)
	and KA.PROJECT_ID=@projid
	
	end
	end
--exec dbo.Allot_For_Keying @opType='Pend',@Facility=null,@BatchName=null,@from_Date=null,@to_Date=null,@from= null,@to= null,@coder= null,@status='Incomplete'
GO
/****** Object:  StoredProcedure [dbo].[Allot_For_Keying_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[Allot_For_Keying_QC]
(@opType varchar(100)=null,@Facility varchar(250)=null,@BatchName varchar(300)=null,
@from_Date datetime=null,@to_Date datetime=null,@from int=null,
@to int=null,@coder varchar(max)=null,@status varchar(350)=null,@project int =null)
as
begin
--with cte1
--as
--(
--select ROW_NUMBER() over (order by [ALLOT_ID]) as rownumber from KEYING_ALLOTMENT
--)

if @opType='PageLoad'
begin
select distinct [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	KT.QC_BY as [QC],
	[BATCH_NAME] as [Batch Name],
	[ACCOUNT_NO] as [Account No],
	Convert(varchar(12),[RECEIVED_DATE],101) as [Received Date],
	[SPECIALITY] as [Speciality],
	[FACILITY] as [Facilty],
	[LOCATION] as [Location],
	[BATCH_STATUS] as [Batch Status],
	[CODER_NTLG] as [Coder],
    Convert(varchar(12),[CODED_DATE],101) as [Coded Date],
    KT.KEYED_BY as [Keyer],
    
    KT.KEYER_DATE as [Keyed Date]
	--[ALLOTED_TO],
	--[ALLOTED_BY]
	--[ALLOTED_DATE],
	--[UPADATED_BY],
	--[UPDATED_DATE] 
	from  KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID where KT.KEYING_STATUS='Completed' and KA.BATCH_STATUS='KEYING' and KA.PROJECT_ID=@project--KT.KEYING_STATUS='KEYED'  KT.QC_STATUS='Completed'
end
else if @opType='Reload'
begin
select distinct [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
    KT.QC_BY as [QC],
	[BATCH_NAME] as [Batch Name],
	[ACCOUNT_NO] as [Account No],
	Convert(varchar(12),[RECEIVED_DATE],101) as [Received Date],
	[SPECIALITY] as [Speciality],
	[FACILITY] as [Facilty],
	[LOCATION] as [Location],
	[BATCH_STATUS]  as [Batch Status],
	[CODER_NTLG] as [Coder],
	Convert(varchar(12),[CODED_DATE],101)as [Coded Date],
	    KT.KEYED_BY as [Keyer],
	    KT.KEYER_DATE as [Keyed Date]
	

	
	from  KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID --where
	where ((nullif(@Facility,null)is null or [FACILITY]=@Facility))and ((nullif(@BatchName,null)is null or BATCH_NAME=@BatchName))and
	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))AND --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	(nullif(@coder,null) is null or [CODER_NTLG]=@coder)and --((nullif(@from,null)is null and nullif(@to,null)is null)or cte1.rownumber between @from and @to)
	--(nullif(@status,null)is null or [BATCH_STATUS]=@status)--
	KT.KEYING_STATUS='Completed'  and KA.BATCH_STATUS='KEYING'--KT.KEYING_STATUS='KEYED'
	and  KA.PROJECT_ID=@project
	
	
	end
	
	else if @opType='Pend' and (@status='Pending'or @status='Hold' or @status='Incomplete'or @status='ALLOTTED')
	begin
	select distinct [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	KT.QC_BY as [QC],
	[BATCH_NAME] as [Batch Name],
	[ACCOUNT_NO] as [Account No],
	Convert(varchar(12),[RECEIVED_DATE],101) as [Received Date],
	[SPECIALITY] as [Speciality],
	[FACILITY] as [Facilty],
	[LOCATION] as [Location],
	[BATCH_STATUS]  as [Batch Status],
	[CODER_NTLG] as [Coder],
	Convert(varchar(12),[CODED_DATE],101)as [Coded Date],
	 KT.KEYED_BY as [Keyer],
	    KT.KEYER_DATE as [Keyed Date]
	
	from  KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID and KT.QC_STATUS=@status
	where ((nullif(@Facility,null)is null or [FACILITY]=@Facility))and ((nullif(@BatchName,null)is null or BATCH_NAME=@BatchName))and
	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))AND --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	(nullif(@coder,null) is null or [CODER_NTLG]=@coder)--and --((nullif(@from,null)is null and nullif(@to,null)is null)or cte1.rownumber between @from and @to)
	--(nullif(@status,null)is null or [BATCH_STATUS]=@status)
	and KA.PROJECT_ID=@project
	
	end
	end
--exec [Allot_For_Keying_QC] @opType='PageLoad',@Facility=null,@BatchName=null,@from_Date=null,@to_Date=null,@from= null,@to= null,@coder= null,@status='KEYED'
GO
/****** Object:  StoredProcedure [dbo].[Allot_For_Keying_QC11]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Allot_For_Keying_QC11]
(@opType varchar(100)=null,@Facility varchar(250)=null,@Account varchar(300)=null,
@from_Date datetime=null,@to_Date datetime=null,@from int=null,
@to int=null,@coder varchar(max)=null,@status varchar(350)=null,@projid int=null,@query varchar(max)=null,
@Keyers varchar(450)=null,@Allotedto varchar(600)=null)
as
declare @sql nvarchar(max)
declare @paramList nvarchar(max)--[Keyer]
--set @query='ACCOUNT_NO As [ACCOUNT NO],AGE As [AGE], CODER_NTLG As [CODED_BY],PATIENT_NAME As [Patient Name],BATCH_NAME As [Batch Name /File Name],FACILITY As [FACILITY],LOCATION As [LOCATION],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY]'

--set @query='ADMITTING_PHY As [ADMITTING PHY],ATTENDING_PHY As [ATTENDING PHY],Charge_Status As [Charge Status],INSURANCE As [INSURANCE],KEYER_COMMENTS As [Keyer Comments],Responsibility As [Responsibility],CODING_COMMENTS As [CODING COMMENTS],CPT As [CPT],ICD As [ICD],MODIFIER As [MODIFIER]'
--set @query='ACCOUNT_NO As [ACCOUNT NO],AGE As [AGE], CODER_NTLG As [CODED_BY],PATIENT_NAME As [Patient Name],BATCH_NAME As [Batch Name /File Name],FACILITY As [FACILITY],LOCATION As [LOCATION],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY]'
if @query like '%RECEIVED_DATE As%'
	begin
	set @query=REPLACE(@query,'RECEIVED_DATE As','convert(varchar(12),RECEIVED_DATE,101) as')
	end

if @opType='PageLoad'
begin

set @sql='select [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	KT.QC_BY as [QC],KA.BATCH_NAME,KA.ACCOUNT_NO as [Patient ID],convert(varchar(12),KA.RECEIVED_DATE,101) as [Dos],
	KA.FACILITY as [Facility],'+@query+',
	KT.KEYED_BY as [Biller],KT.KEYER_DATE as [Keyed Date],KT.RESPONSIBILITY
from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 

where KT.KEYING_STATUS=''Completed'' and KA.BATCH_STATUS=''KEYING'' and KA.PROJECT_ID=@projid'
	end
	
else if @opType='Reload'
	
begin
set @sql='select [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	KT.QC_BY as [QC],KA.BATCH_NAME,KA.ACCOUNT_NO as [Patient ID],convert(varchar(12),KA.RECEIVED_DATE,101) as [Dos],
	KA.FACILITY as [Facility],'+@query+',
	KT.KEYED_BY as [Biller],KT.KEYER_DATE as [Keyed Date],KT.RESPONSIBILITY
from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where KT.KEYING_STATUS=''Completed'' and KA.BATCH_STATUS=''KEYING'' and KA.PROJECT_ID=@projid'

	
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	
	if @Keyers is not null
	begin
	set @sql=@sql+' And KT.KEYED_BY=@Keyers'
	end
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	
	if @Allotedto is not null
	begin--QC_BY
	set @sql=@sql+' And KT.QC_BY=@Allotedto'
	end
	
	
	
	

end


else if @opType='Pend' and (@status='Pending'or @status='Hold' or @status='Incomplete'  or @status='ALLOTTED')--or @status='Re-open'
	begin
	set @sql='select [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	KT.QC_BY as [QC],KA.BATCH_NAME,KA.ACCOUNT_NO as [Patient ID],convert(varchar(12),KA.RECEIVED_DATE,101) as [Dos],
	KA.FACILITY as [Facility],'+@query+',
	KT.KEYED_BY as [Biller],KT.KEYER_DATE as [Keyed Date],KT.RESPONSIBILITY
from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where  KT.QC_STATUS=@status and KA.PROJECT_ID=@projid'
	
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	
	if @Keyers is not null
	begin
	set @sql=@sql+' And KT.KEYED_BY=@Keyers'
	end
	
	
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	
	if @Allotedto is not null
	begin--QC_BY
	set @sql=@sql+' And KT.QC_BY=@Allotedto'
	end
	

	end
	
	else if @opType='Pend' and (@status='Keying Pending'or @status='Keying Hold' or @status='Keying Incomplete')
	begin
	
	if(@status='Keying Pending')
	begin
	set @status='Pending'
	end
	
	else if(@status='Keying Hold')
	begin
	set @status='Hold'
	end
	
	else if(@status='Keying Incomplete')
	begin
	set @status='Incomplete'
	end
	
	
	set @sql='select [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	KT.QC_BY as [QC],KA.BATCH_NAME,KA.ACCOUNT_NO as [Patient ID],convert(varchar(12),KA.RECEIVED_DATE,101) as [Dos],
	KA.FACILITY as [Facility],'+@query+',
	KT.KEYED_BY as [Biller],KT.KEYER_DATE as [Keyed Date],KT.RESPONSIBILITY
from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where  KT.KEYING_STATUS=@status and KA.PROJECT_ID=@projid'
	
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	
	if @Keyers is not null
	begin
	set @sql=@sql+' And KT.KEYED_BY=@Keyers'
	end
	
	
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	
	if @Allotedto is not null
	begin--QC_BY
	set @sql=@sql+' And KT.QC_BY=@Allotedto'
	end
	

	end


--Reopen code
	 else if @opType='Pend' and (@status='Re_Open')
	
	
	begin
	
	
	
	
	set @sql='select [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	KT.QC_BY as [QC],KA.BATCH_NAME,KA.ACCOUNT_NO as [Patient ID],convert(varchar(12),KA.RECEIVED_DATE,101) as [Dos],
	KA.FACILITY as [Facility],'+@query+',
	KT.KEYED_BY as [Biller],KT.KEYER_DATE as [Keyed Date],KT.RESPONSIBILITY
from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where  IS_Reopen=''Yes'' and KT.QC_STATUS is null and KA.PROJECT_ID=@projid and KT.KEYING_STATUS=''Completed'''
	
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	
	if @Keyers is not null
	begin
	set @sql=@sql+' And KT.KEYED_BY=@Keyers'
	end
	
	
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	
	if @Allotedto is not null
	begin--QC_BY
	set @sql=@sql+' And KT.QC_BY=@Allotedto'
	end
	

	end
	
	

set @paramList='@opType varchar(100)=null,@Facility varchar(250)=null,@Account varchar(300)=null,
@from_Date datetime=null,@to_Date datetime=null,@from int=null,
@to int=null,@coder varchar(max)=null,@status varchar(350)=null,@projid int=null,@query varchar(max)=null,@Keyers varchar(450)=null,@Allotedto varchar(600)=null'
	
	
	
EXEC sp_executesql @sql,@paramList,@opType,@Facility,@Account,@from_Date,@to_Date,@from,@to,@coder,@status,@projid,@query,@Keyers,@Allotedto 
--exec Allot_For_Keying_QC11 @opType='Pend',@Facility=null,@Account=null,
--@from_Date=null,@to_Date=null,@from= null,
--@to= null,@coder= null,@status='Re_Open',
--@projid=8,@query='ACCOUNT_NO As [ACCOUNT NO],AGE As [AGE], CODER_NTLG As [CODED_BY],PATIENT_NAME As [Patient Name],BATCH_NAME As [Batch Name /File Name],FACILITY As [FACILITY],LOCATION As [LOCATION],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY]'
GO
/****** Object:  StoredProcedure [dbo].[Allot_For_Keying11]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[Allot_For_Keying11]
(@opType varchar(100)=null,@Facility varchar(250)=null,@Account varchar(300)=null,
@from_Date datetime=null,@to_Date datetime=null,@from int=null,
@to int=null,@coder varchar(max)=null,@status varchar(350)=null,@projid int=null,@query varchar(max)=null,@Allotedto varchar(600)=null)
as
declare @sql nvarchar(max)
declare @paramList nvarchar(max)
--set @query='ACCOUNT_NO As [ACCOUNT NO],AGE As [AGE], CODER_NTLG As [CODED_BY],PATIENT_NAME As [Patient Name],BATCH_NAME As [Batch Name /File Name],FACILITY As [FACILITY],LOCATION As [LOCATION],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY]'

--set @query='+'+@query+'+' --Keyer

if @opType='PageLoad'
begin

set @sql='select [ALLOT_ID], 
	[BATCH_ID] ,
	[PROJECT_ID],
	[ALLOTED_TO] as Biller,'+@query+',CODED_DATE as [Coded Date] from  dbo.KEYING_ALLOTMENT where PROJECT_ID=@projid and BATCH_STATUS=''CODED'''
	
	end
	
else if @opType='Reload'
	
begin
set @sql='select [ALLOT_ID], 
	[BATCH_ID] ,
	[PROJECT_ID],
	[ALLOTED_TO] as Biller,'+@query+',CODED_DATE as [Coded Date] from  dbo.KEYING_ALLOTMENT where PROJECT_ID=@projid '
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	if @status is not null
	begin
	set @sql=@sql+' And [BATCH_STATUS]=@status'
	end
	
	if @Allotedto is not null
	begin
	set @sql=@sql+' And [ALLOTED_TO]=@Allotedto'
	end

end


else if @opType='Pend' and (@status='Pending'or @status='Hold' or @status='Incomplete' or @status='ALLOTTED')
	begin
	set @sql='select [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	[ALLOTED_TO]  as Biller,'+@query+',CODED_DATE as [Coded Date],KT.Pending_Update_From as [Responsibility]from  dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID and KT.KEYING_STATUS=@status and KA.BATCH_STATUS=''KEYING'' where KA.PROJECT_ID=@projid'
	--,NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response], CLIENT_COMMENTS as [Client Comments]
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	end
	
	
	else if @opType='Pend' and @status='Re-open'
	begin
	set @sql='select [ALLOT_ID], 
	KA.[BATCH_ID] ,
	KA.[PROJECT_ID],
	[ALLOTED_TO]  as Biller,'+@query+',CODED_DATE as [Coded Date] from  dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID
	 and KA.PROJECT_ID=KT.PROJECT_ID and KT.KEYING_STATUS=''Allotted'' and KT.Charge_status=''Completed'' and KA.BATCH_STATUS=''KEYING'' 
	 where KA.PROJECT_ID=@projid and IS_REOPEN=''YES'''
	
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	end
	if @Allotedto is not null
	begin
	set @sql=@sql+' And [ALLOTED_TO]=@Allotedto'
	end
	
	
	else if @opType='Pend' and @status='Coding Pending'
	begin
	set @sql='select [ALLOT_ID], 
	[BATCH_ID] ,
	[PROJECT_ID],
	[ALLOTED_TO] as Biller,'+@query+',CODED_DATE as [Coded Date] from  dbo.KEYING_ALLOTMENT where PROJECT_ID=@projid and Is_Coding_Pending=1 and BATCH_STATUS=''CODED'''
	
	if @Facility is not null
	begin
	set @sql=@sql+' And [FACILITY]=@Facility'
	end
	if @Account is not null
	begin
	set @sql=@sql+' And ACCOUNT_NO=@Account'
	end
	if @from_Date is not null and @to_Date is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@from_Date'
	end
	if @from_Date is not null and @to_Date is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @from_Date and @to_Date'
	end
	if @coder is not null
	begin
	set @sql=@sql+' And [CODER_NTLG]=@coder'
	end
	end
	if @Allotedto is not null
	begin
	set @sql=@sql+' And [ALLOTED_TO]=@Allotedto'
	end
	

set @paramList='@opType varchar(100)=null,@Facility varchar(250)=null,@Account varchar(300)=null,
@from_Date datetime=null,@to_Date datetime=null,@from int=null,
@to int=null,@coder varchar(max)=null,@status varchar(350)=null,@projid int=null,@query varchar(max)=null,@Allotedto varchar(600)=null'
	
	
	
EXEC sp_executesql @sql,@paramList,@opType,@Facility,@Account,@from_Date,@to_Date,@from,@to,@coder,@status,@projid,@query,@Allotedto


--exec dbo.[Allot_For_Keying11] @opType='PageLoad',@Facility=null,@Account=null,
--@from_Date=null,@to_Date=null,@from= null,@to= null,@coder=null,@status='coded',
--@projid=8,@query='ACCOUNT_NO As [ACCOUNT NO],AGE As [AGE], CODER_NTLG As [CODED_BY],PATIENT_NAME As [Patient Name],
--BATCH_NAME As [Batch Name /File Name],FACILITY As [FACILITY],LOCATION As [LOCATION],RECEIVED_DATE As [RECEIVED_DATE],
--SPECIALITY As [SPECIALITY]',@Allotedto=null




GO
/****** Object:  StoredProcedure [dbo].[AR_Error_Log_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AR_Error_Log_Report]
(@proj int=null,
@Facility varchar(450)=null,
@FromDos datetime=null,
@ToDos Datetime=null,@opType varchar(300)=null,@Query nvarchar(max)=null,@ntlg varchar(max)=null,@QcedDate datetime=null)
as



Declare @sql nvarchar(max)
Declare @ParamList nvarchar(max)

Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))

if @opType='Select'
begin


if @AccessType='ar-qc-tl'--'KEYER-TL' or @AccessType='KEYER MANAGER' or @AccessType='KEYER-QC-TL' or @AccessType='KEYER-QC-MANAGER'

begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KT.AR_Assign_To as [AR By], KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],
KT.AR_Error_Category as [Error Category],KT.AR_Sub_Error_Category as [Sub Category],KT.AR_Error_Count as [Error Count],KT.AR_Error_Comments as [Error Comments],AR_Error_Correction as [Error Correction],
KT.AR_Error_List,KT.AR_Acknoledge_BY as [Acknowledge By],KT.AR_Acknoledge_Date as [Acknowledge Date],
KT.AR_IS_Acknowledge as [Acknowledge Status],KT.AR_Acknoledge_Comments as [Acknowledge Comments],
KT.AR_QC_Completed_Date as [Qced Date],KT.AR_QC_Assigned_To as [Qced By] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT 
on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.AR_Error_Count>0 and  KA.PROJECT_ID=@proj'

if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null

begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end

if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.AR_QC_Completed_Date,101) = @QcedDate '


end
  
end

--else if @AccessType='ar-qc'

--begin
--set @sql='
--select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.ERROR_LIST,KT.ACKNOWLEDGE_BY as [Acknowledge By],KT.ACK_DATE as [Acknowledge Date],KT.IS_ACKNOWLEDGE as [Acknowledge Status],KT.ACHNOWLEDGE_COMMENTS as [Acknowledge Comments],KT.QC_DATE as [Qced Date]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
--where KT.ERROR_COUNT>0 and  KA.PROJECT_ID=@proj'

--if @Facility is not null
--begin
--set @sql=@sql+' And KA.FACILITY =@Facility'
--end

--if @FromDos is not null and @ToDos is null
--begin
--set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
--end

--if @FromDos is not null and @ToDos is not null
--begin
--set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

--end


--if @QcedDate is not null
--begin
--set @sql=@sql+' And convert(varchar(12),KT.QC_DATE,101) = @QcedDate '


--end

--if @ntlg is not null

--begin
--set @sql=@sql+' And KEYED_BY=@ntlg'
--end
--end

else if @AccessType='ar-qc'
begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KT.AR_Assign_To as [AR By], KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],
KT.AR_Error_Category as [Error Category],KT.AR_Sub_Error_Category as [Sub Category],KT.AR_Error_Count as [Error Count],KT.AR_Error_Comments as [Error Comments],AR_Error_Correction as [Error Correction],
KT.AR_Error_List,KT.AR_Acknoledge_BY as [Acknowledge By],KT.AR_Acknoledge_Date as [Acknowledge Date],
KT.AR_IS_Acknowledge as [Acknowledge Status],KT.AR_Acknoledge_Comments as [Acknowledge Comments],
KT.AR_QC_Completed_Date as [Qced Date],KT.AR_QC_Assigned_To as [Qced By] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT 
on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.AR_Error_Count>0 and  KA.PROJECT_ID=@proj'
if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null
begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end


if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.AR_QC_Completed_Date,101)= @QcedDate '


end

if @ntlg is not null

begin
set @sql=@sql+' And AR_QC_Assigned_To=@ntlg'
end
end


set @ParamList='@proj int=null,
@Facility varchar(450)=null,
@FromDos datetime=null,
@ToDos Datetime=null,@opType varchar(300)=null,@Query nvarchar(max)=null,@ntlg varchar(max)=null,@QcedDate datetime=null'

exec sp_Executesql @sql,@ParamList,@proj ,
@Facility ,
@FromDos ,
@ToDos ,@opType,@Query,@ntlg,@QcedDate


end

--exec [AR_Error_Log_Report] 8,null,null,null,'Select',null,'GokulnatJ'


GO
/****** Object:  StoredProcedure [dbo].[AR_Production_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ALTER procedure [dbo].[AR_Production_Report](@facility varchar(200)=null, @accntNo varchar(200)=null, @ardate datetime=null,
-- @fromdos datetime=null, @todos datetime=null, @ar varchar(200)=null, @arstatus varchar(200)=null)
--as 

CREATE procedure [dbo].[AR_Production_Report] 
(
@Projid int=null,
@facility varchar(200)=null, 
@accntNo varchar(200)=null, 
@ardate datetime=null,
@fromdos datetime=null, 
@todos datetime=null, 
@ar varchar(200)=null, 
@ARStatus varchar(10)=null
)
as 

--IF (@fromdos != '' AND @todos != '' )
--begin



Declare @acctype varchar(200)

	set @acctype=(select distinct ACCESS_TYPE from  dbo.tbl_ACCESS_TYPE where ACCESS_TYPE=(select ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ar))


if  @ARStatus='Completed'

begin
SELECT dense_rank() over (order by t.batch_id) as S_No, t.PROJECT_ID as [Project ID],
 t.BATCH_ID as [Batch ID], FACILITY as Facility,RECEIVED_DATE as [Arrival Date],
ACCOUNT_NO as [Patient ID],NOTES as Notes,AR_STATUS as [AR Status],AR_Updated_By AS [AR Name], 
AR_Completed_Date as [AR Completed Date],AR_Assign_Date as [AR Assigned Date] ,
PATIENT_NAME as [Patient Name],AGE as Age,INSURANCE as Insurance,PROVIDER_MD as [Provider/MD Name],
ASSISTANT_PROVIDER as [Assistant Provider /PA/NP Name],
PATIENT_STATUS as [Patient Status],DOI as DOI,TOI as TOI,TYPE_OF_ACCIDENT as [Type of Account],
SHARD_VISIT as [Shared Visit],a.DISPOSITION as Disposition,CPT,MODIFIER as Modifier,UNITS as Units,
COMMENTS as Comments,DOWNLOADING_COMMENTS as [Down Coding Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator],
DOS_CHANGED as [Dos Change],t.ACCOUNT_STATUS as [Account Status],[W/O Attestation] as Attestation,
CHARGE_STATUS as [Charge Status],KEYER_COMMENTS as [Keyer Comments],k.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY a.ACCOUNT_NO,K.CPT_ORDER ,K.CPT ORDER BY K.CPT) AS VARCHAR(MAX)) AS ICDlIST,k.CPT_ORDER

into #temp1 FROM dbo.KEYING_ALLOTMENT A 
	inner join dbo.KEYING_TRANSACTION T on A.PROJECT_ID=T.PROJECT_ID and A.BATCH_ID=T.BATCH_ID 
	inner join Keying_Transaction_Detail K on T.BATCH_ID=K.BATCH_ID 




 where  K.PROJECT_ID=8 
 and (nullif(@accntNo,null)is null or A.ACCOUNT_NO=@accntNo) and (nullif(@Facility,null)is null or A.FACILITY=@Facility)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@FromDos,null)is null or [RECEIVED_DATE]=@FromDos)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@FromDos,null)is null and nullif(@ToDos,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@FromDos,101) and convert(varchar(12),@ToDos,101))) and   T.AR_Assign_Status ='Completed' and  
	--T.AR_Assign_Status =@ARStatus  and

	 
--	 --case when @ARStatus='Completed' then 'Completed' else @statusHoldAndAllotted end and
	(nullif(@ardate,null)is null or convert(varchar(12),AR_Completed_Date,101)=@ardate)
	and t.AR_Assign_To =case when @acctype= 'ar-tl' then  t.AR_Assign_To else @ar  end 



select S_No,[Project ID],[Batch ID], Facility,[Arrival Date],Notes,[AR Status],[AR Name],
[AR Completed Date],[AR Assigned Date],[Patient Name],[Patient ID],Age,Insurance,[Provider/MD Name],
[Assistant Provider /PA/NP Name],[Patient Status],DOI,TOI,[Type of Account],[Shared Visit],
Disposition,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,Modifier,Units,Comments,[Down Coding Comments],
[Deficiency Indicator],[Dos Change],[Account Status],Attestation,[Charge Status],[Keyer Comments] from #temp1
	Pivot 
	(
	max(ICD) for ICDlIST in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
	)as PIVOTEDTABLE order by [BATCH ID],CPT_ORDER
	drop table #temp1
	end


else

begin
SELECT dense_rank() over (order by t.batch_id) as S_No, t.PROJECT_ID as [Project ID],
 t.BATCH_ID as [Batch ID], FACILITY as Facility,RECEIVED_DATE as [Arrival Date],
ACCOUNT_NO as [Patient ID],NOTES as Notes,AR_STATUS as [AR Status],AR_Updated_By AS [AR Name], 
AR_Completed_Date as [AR Completed Date],AR_Assign_Date as [AR Assigned Date] ,
PATIENT_NAME as [Patient Name],AGE as Age,INSURANCE as Insurance,PROVIDER_MD as [Provider/MD Name],
ASSISTANT_PROVIDER as [Assistant Provider /PA/NP Name],
PATIENT_STATUS as [Patient Status],DOI as DOI,TOI as TOI,TYPE_OF_ACCIDENT as [Type of Account],
SHARD_VISIT as [Shared Visit],a.DISPOSITION as Disposition,CPT,MODIFIER as Modifier,UNITS as Units,
COMMENTS as Comments,DOWNLOADING_COMMENTS as [Down Coding Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator],
DOS_CHANGED as [Dos Change],t.ACCOUNT_STATUS as [Account Status],[W/O Attestation] as Attestation,
CHARGE_STATUS as [Charge Status],KEYER_COMMENTS as [Keyer Comments],k.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY a.ACCOUNT_NO,K.CPT_ORDER ,K.CPT ORDER BY K.CPT) AS VARCHAR(MAX)) AS ICDlIST,k.CPT_ORDER

into #temp12 FROM dbo.KEYING_ALLOTMENT A 
	inner join dbo.KEYING_TRANSACTION T on A.PROJECT_ID=T.PROJECT_ID and A.BATCH_ID=T.BATCH_ID 
	inner join Keying_Transaction_Detail K on T.BATCH_ID=K.BATCH_ID 




 where  K.PROJECT_ID=8 
 and (nullif(@accntNo,null)is null or A.ACCOUNT_NO=@accntNo) and (nullif(@Facility,null)is null or A.FACILITY=@Facility)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@FromDos,null)is null or [RECEIVED_DATE]=@FromDos)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@FromDos,null)is null and nullif(@ToDos,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@FromDos,101) and convert(varchar(12),@ToDos,101))) and 
	--T.AR_Assign_Status =@ARStatus  and
	 T.AR_Assign_Status in ('Allotted','hold') and 
	 
	 --case when @ARStatus='Completed' then 'Completed' else @statusHoldAndAllotted end and
	(nullif(@ardate,null)is null or convert(varchar(12),AR_Completed_Date,101)=@ardate)
	and t.AR_Assign_To =case when @acctype= 'ar-tl' then  t.AR_Assign_To else @ar  end 



select S_No,[Project ID],[Batch ID], Facility,[Arrival Date],Notes,[AR Status],[AR Name],
[AR Completed Date],[AR Assigned Date],[Patient Name],[Patient ID],Age,Insurance,[Provider/MD Name],
[Assistant Provider /PA/NP Name],[Patient Status],DOI,TOI,[Type of Account],[Shared Visit],
Disposition,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,Modifier,Units,Comments,[Down Coding Comments],
[Deficiency Indicator],[Dos Change],[Account Status],Attestation,[Charge Status],[Keyer Comments] from #temp12
	Pivot 
	(
	max(ICD) for ICDlIST in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
	)as PIVOTEDTABLE order by [BATCH ID],CPT_ORDER
	drop table #temp12
	end
	
	
	
--exec [AR_Production_Report]null,null,null,null,null,null,'manoharr','Completed'

GO
/****** Object:  StoredProcedure [dbo].[Bind_AR_QC_Facility]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Venkat>
-- Create date: <Create Date,03/11/2015>
-- Description:	<Description,Bind AR QC Facilities>
-- =============================================
CREATE PROCEDURE [dbo].[Bind_AR_QC_Facility](@ntlg varchar(200)=null) --Bind_AR_QC_Facility 'venkatacs'
AS
Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))


SELECT CODE,[DESCRIPTION] FROM DBO.TBL_FACILITY

--if(@AccessType='AR-QC-TL' or @AccessType='AR-QC')
--begin
--select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR-QC-TL','AR-QC')  and IS_DELETED='N' --or USER_NTLG=@tlntlg
--end
--else
--begin

--select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR-QC-TL','AR-QC') and IS_DELETED='N' --and TL_NTLG=@tlntlg or USER_NTLG=@tlntlg
--end

GO
/****** Object:  StoredProcedure [dbo].[Bind_Keyer_Facility]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--ALTER PROCEDURE [dbo].[Bind_Keyer_Facility]
--AS
--SELECT CODE,[DESCRIPTION] FROM DBO.TBL_FACILITY
--select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE='Keyer' and IS_DELETED='N'
--select BATCH_NAME from dbo.KEYING_ALLOTMENT where BATCH_STATUS='CODED'

CREATE PROCEDURE [dbo].[Bind_Keyer_Facility](@tlntlg varchar(200)=null)
AS
Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@tlntlg))


SELECT CODE,[DESCRIPTION] FROM DBO.TBL_FACILITY

if(@AccessType='KEYER-QC-TL' or @AccessType='KEYER-QC')
begin
select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('Keyer','KEYER-TL')  and IS_DELETED='N' --or USER_NTLG=@tlntlg
end
else
begin

select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('Keyer','KEYER-TL','SOFTWARE') and IS_DELETED='N' --and TL_NTLG=@tlntlg or USER_NTLG=@tlntlg
end

GO
/****** Object:  StoredProcedure [dbo].[Bind_Keyer_QC_Names]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[Bind_Keyer_QC_Names](@ntlg varchar(300)=null,
@proj int=null)
as

Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))

if @AccessType='KEYER-QC' 
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE='KEYER-QC' and IS_DELETED='N' and PROJECT_ID=@proj and [USER_NTLG]=@ntlg
end
else if @AccessType='KEYER-TL' or @AccessType='KEYER MANAGER' or @AccessType='CLIENT'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE = 'KEYER-QC' or ACCESS_TYPE='KEYER-QC-TL' and IS_DELETED='N' and PROJECT_ID=@proj and TL_NTLG=@ntlg 
--or [USER_NTLG]=@ntlg
end
else if @AccessType='KEYER-QC-TL'

begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in('KEYER-QC','KEYER-QC-TL') and IS_DELETED='N' and PROJECT_ID=@proj --or  TL_NTLG=@ntlg 
or [USER_NTLG]=@ntlg

end

else if @AccessType='KEYER-QC-MANAGER' --or @AccessType='SOFTWARE'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('KEYER-QC','KEYER-QC-TL') and IS_DELETED='N' and PROJECT_ID=@proj and TL_NTLG=@ntlg  
--or [USER_NTLG]=@ntlg
end

else if @AccessType='SOFTWARE'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('KEYER-QC','KEYER-QC-TL') and IS_DELETED='N' and PROJECT_ID=@proj or [USER_NTLG]=@ntlg  
--or [USER_NTLG]=@ntlg
end

--exec Bind_Keyer_QC_Names 'Venkataj ',8



GO
/****** Object:  StoredProcedure [dbo].[Bind_Keyer_QC_Users]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Bind_Keyer_QC_Users]
as
select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE='QC' and IS_DELETED='N'

GO
/****** Object:  StoredProcedure [dbo].[BIND_KEYER_TRAN_WITH_DETAILS]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[BIND_KEYER_TRAN_WITH_DETAILS]
as
begin
select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='KEYING_TRANSACTION'
select column_name from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='Keying_Transaction_Detail'
end
GO
/****** Object:  StoredProcedure [dbo].[BindMandatoryAndAdditionalConfig]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BindMandatoryAndAdditionalConfig]
(
    @ListBoxValue varchar(200)=null,
    @taskid int=null,
    @proJID int=null
    )
as

begin




 if(@ListBoxValue='Mandatory')--Mandatory
begin
select distinct FIELD_NAME,DISPLAY_FIELDS from dbo.tbl_MANDATORY_FIELD where TASK_ID=@taskid and IS_DELETED='N' 
end

else if (@ListBoxValue='FieldList')
begin
select  FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=@taskid and IS_DELETED='N' and PROJECT_ID=@proJID
order by FIELD_INDEX
select  FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=@taskid and IS_DELETED='N' and PROJECT_ID=@proJID
order by REPORT_INDEX


end


else if(@ListBoxValue='Additional')--Additional
begin
  if(@taskid=7)
 
   begin
  select  distinct FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=1  and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=7 and IS_DELETED='N' and PROJECT_ID=8)
  union All
  select  distinct FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=7 and FIELD_NAME in ('ALLOTTED_TO','CODED_DATE','IS_AUDITED')  and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=7 and IS_DELETED='N' and PROJECT_ID=8)--in second part PROJECT_ID=8 need to pass as PROJECT_ID=@project nothing but new project
  end
  
else if(@taskid=8)
begin
select distinct FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=@taskid and PROJECT_ID=7 and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=8 and IS_DELETED='N' and PROJECT_ID=8)--project_id=7 taken as base project with all additional fields configured
union all
select distinct FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=2  and PROJECT_ID=7 and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID in (8,2) and IS_DELETED='N' and PROJECT_ID=8)
end


else if(@taskid=9)
begin
select distinct FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=@taskid  and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=9 and IS_DELETED='N' and PROJECT_ID=8)

end
else if(@taskid=10)
begin
select distinct FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=@taskid  and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=10 and IS_DELETED='N' and PROJECT_ID=8)

end
else
begin
select distinct FIELD_NAME,DISPLAY_FIELD_NAME as DISPLAY_FIELDS from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=@taskid  and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where TASK_ID=@taskid and IS_DELETED='N' and PROJECT_ID=8)

end

end
end







--exec  BindMandatoryAndAdditionalConfig 'Additional',7,7
GO
/****** Object:  StoredProcedure [dbo].[BindTaskType_Keyer]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[BindTaskType_Keyer](@tasktype varchar(500)=null)
as

select TASK_NAME,DISPLAY_NAME,TASK_ID from dbo.tbl_TASK_TABLE where TASK_TYPE=@tasktype and IS_DELETED='N'
GO
/****** Object:  StoredProcedure [dbo].[CODING_RECON_REPORT]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CODING_RECON_REPORT] 


--@DiffDate int
@FDATE DATETIME	

AS
BEGIN



with cte1 as

(
SELECT        

A.FACILITY, A.RECEIVED_DATE AS DOS, ISNULL(A.RECEIVED, 0) AS RECEIVED, ISNULL(B.PENDING, 0) AS PENDING, ISNULL(C.CODED, 0) AS CODED, 
ISNULL(B.PENDING, 0) AS TOTAL_PENDING,(RECEIVED)AS TOTAL_RECIEVED, TOTAL_RECEIVED.TOT_RECEIVED AS TOTAL


FROM

(SELECT FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  RECEIVED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND '2015-02-20'
GROUP BY FACILITY,RECEIVED_DATE) AS A

LEFT JOIN

(SELECT  CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,FACILITY,COUNT(I.BATCH_ID) AS PENDING
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND t.CODING_STATUS = 'Pending'
 AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND '2015-02-20'
 GROUP BY FACILITY,RECEIVED_DATE) AS B 

ON A.FACILITY = B.FACILITY AND A.RECEIVED_DATE = B.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, FACILITY,COUNT(I.BATCH_ID) AS CODED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND '2015-02-20'
 GROUP BY FACILITY,RECEIVED_DATE) AS C
 
 ON A.FACILITY = C.FACILITY AND A.RECEIVED_DATE = C.RECEIVED_DATE 

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  TOT_RECEIVED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND '2015-02-20'
GROUP BY RECEIVED_DATE ) AS TOTAL_RECEIVED


ON A.RECEIVED_DATE = TOTAL_RECEIVED.RECEIVED_DATE
 
 GROUP BY A.FACILITY,A.RECEIVED_DATE,A.Received,B.PENDING,C.Coded,TOT_RECEIVED
 --ORDER BY A.RECEIVED_DATE

	)
	select I.RECEIVED_DATE ,T.DOS As DOSOld ,T.DOS_CHANGED,DATEDIFF(DAY,I.RECEIVED_DATE,T.DOS)As DiffDate ,cte1.DOS, cte1.CODED,cte1.FACILITY,cte1.PENDING,cte1.RECEIVED,cte1.TOTAL,cte1.TOTAL_PENDING,cte1.TOTAL_RECIEVED from cte1 Inner Join tbl_IMPORT_TABLE I on cte1.DOS=I.RECEIVED_DATE   inner JOIN  tbl_TRANSACTION T ON I.BATCH_ID = T.BATCH_ID
	WHERE        (T.DOS_CHANGED <> '')
	ORDER BY I.RECEIVED_DATE
	
	 --fOR NextDay
	
	SELECT i.FACILITY,i.RECEIVED_DATE,Count(i.ACCOUNT_NO) As NextDay 
	FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
	WHERE I.BATCH_ID = T.BATCH_ID
	AND T.DOS_CHANGED != ''
	AND RECEIVED_DATE BETWEEN @FDATE AND @FDATE
  Group by i.FACILITY,i.RECEIVED_DATE,ACCOUNT_NO, T.DOS,i.PATIENT_NAME
  
  
  --fOR PreviousDay
  
   SET @FDATE = DATEADD(DAY, -1,@FDATE)	
	SELECT i.FACILITY,i.RECEIVED_DATE,Count(i.ACCOUNT_NO) As PreviousDay 
	FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
	WHERE I.BATCH_ID = T.BATCH_ID
	AND T.DOS_CHANGED != ''
	AND RECEIVED_DATE BETWEEN @FDATE AND @FDATE
	 Group by i.FACILITY,i.RECEIVED_DATE,ACCOUNT_NO, T.DOS,i.PATIENT_NAME
  
 
    
	
--	SELECT * FROM (SELECT ACCOUNT_STATUS,BATCH_ID FROM tbl_TRANSACTION) up 
--PIVOT (SUM(BATCH_ID)  FOR ACCOUNT_STATUS  IN (  [No Charge],[Completed])
--) AS pvt
	
END



--Begin

--SELECT        tbl_IMPORT_TABLE.RECEIVED_DATE, tbl_TRANSACTION.DOS, tbl_TRANSACTION.DOS_CHANGED
--FROM            tbl_IMPORT_TABLE RIGHT OUTER JOIN
--                         tbl_TRANSACTION ON tbl_IMPORT_TABLE.BATCH_ID = tbl_TRANSACTION.BATCH_ID
--WHERE        (tbl_TRANSACTION.DOS_CHANGED <> '')

--End

GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorsXml]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ELMAH_GetErrorsXml]
(    @Application NVARCHAR(60),    @PageIndex INT = 0,    @PageSize INT = 15,    @TotalCount INT OUTPUT)
AS     SET NOCOUNT ON
    DECLARE @FirstTimeUTC DATETIME
    DECLARE @FirstSequence INT
    DECLARE @StartRow INT
    DECLARE @StartRowIndex INT
    SELECT @TotalCount = COUNT(1) FROM [ELMAH_Error]    WHERE [Application] = @Application

    -- Get the ID of the first error for the requested page

    SET @StartRowIndex = @PageIndex * @PageSize + 1

    IF @StartRowIndex <= @TotalCount
    BEGIN
        SET ROWCOUNT @StartRowIndex
        SELECT @FirstTimeUTC = [TimeUtc], @FirstSequence = [Sequence] FROM[ELMAH_Error] WHERE [Application] = @Application ORDER BY [TimeUtc] DESC, [Sequence] DESC
    END
    ELSE
    BEGIN
        SET @PageSize = 0
    END

    -- Now set the row count to the requested page size and get
    -- all records below it for the pertaining application.

    SET ROWCOUNT @PageSize

    SELECT errorId = [ErrorId],application = [Application],host= [Host],type= [Type],source= [Source],message= [Message],[user]= [User],statusCode  = [StatusCode],time = CONVERT(VARCHAR(50), [TimeUtc], 126) + 'Z'
    FROM [ELMAH_Error] error    WHERE [Application] = @Application    AND [TimeUtc] <= @FirstTimeUTC    AND [Sequence] <= @FirstSequence    ORDER BY [TimeUtc] DESC, [Sequence] DESC
    FOR XML AUTO
	
GO
/****** Object:  StoredProcedure [dbo].[ELMAH_GetErrorXml]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ELMAH_GetErrorXml]
(    @Application NVARCHAR(60),    @ErrorId UNIQUEIDENTIFIER)
AS
    SET NOCOUNT ON
    SELECT [AllXml] FROM [ELMAH_Error] WHERE [ErrorId] = @ErrorId    AND [Application] = @Application
GO
/****** Object:  StoredProcedure [dbo].[ELMAH_LogError]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[ELMAH_LogError]
(
    @ErrorId UNIQUEIDENTIFIER,    @Application NVARCHAR(60),    @Host NVARCHAR(30),    @Type NVARCHAR(100),
    @Source NVARCHAR(60),    @Message NVARCHAR(500),    @User NVARCHAR(50),    @AllXml NTEXT,
    @StatusCode INT,    @TimeUtc DATETIME)
AS
    SET NOCOUNT ON
    INSERT    INTO [ELMAH_Error] ([ErrorId], [Application], [Host], [Type], [Source],[Message],[User],[AllXml],[StatusCode],[TimeUtc] )
    VALUES (@ErrorId,@Application,@Host,@Type,@Source,@Message,@User,@AllXml,@StatusCode,@TimeUtc )

GO
/****** Object:  StoredProcedure [dbo].[fetchTaskID]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[fetchTaskID](@fieldname varchar(300)=null,@projectid int=null)
as
select TASK_ID from dbo.tbl_ADDITIONAL_FIELDS where FIELD_NAME=@fieldname and PROJECT_ID=@projectid
select TASK_ID from tbl_MANDATORY_FIELD where FIELD_NAME=@fieldname

GO
/****** Object:  StoredProcedure [dbo].[insert_Alloted_Keyers]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[insert_Alloted_Keyers] @KeyerDetailedList KeyerUpdate readonly,@STAT VARCHAR(200)=NULL,@proj int=null,@TL_NTLG varchar(250)=null
as begin
set nocount on

IF @STAT='ALLOT'
BEGIN
update dbo.KEYING_ALLOTMENT set ALLOTED_TO=Keyer_name from @KeyerDetailedList
where KEYING_ALLOTMENT.BATCH_ID=batchid and PROJECT_ID=proId and ACCOUNT_NO=accID and PROJECT_ID=@proj
end
ELSE IF @STAT='SUBMIT'
BEGIN
update dbo.KEYING_ALLOTMENT set ALLOTED_TO=Keyer_name,BATCH_STATUS='KEYING', ALLOTED_BY=@TL_NTLG,ALLOTED_DATE=GETDATE() from @KeyerDetailedList
where KEYING_ALLOTMENT.BATCH_ID=batchid and PROJECT_ID=proId and ACCOUNT_NO=accID and PROJECT_ID=@proj

update dbo.KEYING_TRANSACTION set KEYING_STATUS='ALLOTTED',CHARGE_STATUS='ALLOTTED', KEYED_BY=Keyer_name from @KeyerDetailedList
where KEYING_TRANSACTION.BATCH_ID=batchid and PROJECT_ID=proId  and PROJECT_ID=@proj--and ACCOUNT_NO=accID
END


--select getdate()

END
GO
/****** Object:  StoredProcedure [dbo].[Insert_Keyer_TDetails]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Insert_Keyer_TDetails] 
@dataset KeyerTranDetail_Insert readonly
as
insert into dbo.Keying_Transaction_Detail select * from @dataset
--select GETDATE()
GO
/****** Object:  StoredProcedure [dbo].[Insert_Keyer_Trans_With_Details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[Insert_Keyer_Trans_With_Details] 

@dataset Keyer_Tran_Insert READONLY--,@tablename varchar(500)=null
as
begin


insert into KEYING_TRANSACTION select distinct * from @dataset
--select GETDATE()
end


GO
/****** Object:  StoredProcedure [dbo].[Keyer_Error_Log_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Keyer_Error_Log_Report]
(@proj int=null,
@Facility varchar(450)=null,
@FromDos datetime=null,
@ToDos Datetime=null,@opType varchar(300)=null,@Query nvarchar(max)=null,@ntlg varchar(max)=null,@QcedDate datetime=null,@AccountType varchar(300)=null)
as

--set @Query='ERROR_COUNT,
--Keying_Error_Category,
--Keying_Error_Comments,
--Keying_Error_SubCategory'


Declare @sql nvarchar(max)
Declare @ParamList nvarchar(max)

Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))
if @opType='ReportFields'
begin
SELECT distinct DISPLAY_FIELD_NAME as DISPLAY_FIELDS, FIELD_NAME , 'ID'=1,REPORT_INDEX FROM DBO.TBL_ADDITIONAL_FIELDS P 

WHERE PROJECT_ID=@proj AND TASK_ID=10 and IS_DELETED='N'
order by REPORT_INDEX
end
if @opType='Select'
begin


if @AccessType='KEYER-TL' or @AccessType='KEYER MANAGER' or @AccessType='KEYER-QC-TL' or @AccessType='KEYER-QC-MANAGER'

begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],'+@Query+',KT.ERROR_LIST,KT.ACKNOWLEDGE_BY as [Acknowledge By],KT.ACK_DATE as [Acknowledge Date],KT.IS_ACKNOWLEDGE as [Acknowledge Status],KT.ACHNOWLEDGE_COMMENTS as [Acknowledge Comments],KT.QC_DATE as [Qced Date] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.ERROR_COUNT>0 and  KA.PROJECT_ID=@proj'


if(@AccountType='Regular')
begin 
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if(@AccountType='Pending')
begin 
set @sql=@sql+' And KA.FACILITY =@Facility'
end




if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null

begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end

if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.QC_DATE,101) = @QcedDate '


end
  
end

else if @AccessType='KEYER'

begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],'+@Query+',KT.ERROR_LIST,KT.ACKNOWLEDGE_BY as [Acknowledge By],KT.ACK_DATE as [Acknowledge Date],KT.IS_ACKNOWLEDGE as [Acknowledge Status],KT.ACHNOWLEDGE_COMMENTS as [Acknowledge Comments],KT.QC_DATE as [Qced Date]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.ERROR_COUNT>0 and  KA.PROJECT_ID=@proj'

if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null
begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end


if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.QC_DATE,101) = @QcedDate '


end

if @ntlg is not null

begin
set @sql=@sql+' And KEYED_BY=@ntlg'
end
end

else if @AccessType='KEYER-QC'
begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.QC_BY as QC,KT.QC_DATE as [Qced Date],'+@Query+',KT.ERROR_LIST,KT.ACKNOWLEDGE_BY as [Acknowledge By],KT.ACK_DATE as [Acknowledge Date],KT.IS_ACKNOWLEDGE as [Acknowledge Status],KT.ACHNOWLEDGE_COMMENTS as [Acknowledge Comments],KT.QC_DATE as [Qced Date]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.ERROR_COUNT>0 and  KA.PROJECT_ID=@proj'

if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null
begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end


if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.QC_DATE,101)= @QcedDate '


end

if @ntlg is not null

begin
set @sql=@sql+' And QC_BY=@ntlg'
end
end


set @ParamList='@proj int=null,
@Facility varchar(450)=null,
@FromDos datetime=null,
@ToDos Datetime=null,@opType varchar(300)=null,@Query nvarchar(max)=null,@ntlg varchar(max)=null,@QcedDate datetime=null'

exec sp_Executesql @sql,@ParamList,@proj ,
@Facility ,
@FromDos ,
@ToDos ,@opType,@Query,@ntlg,@QcedDate


end

--exec Keyer_Error_Log_Report 8,null,null,null,'Select',null,'GokulnatJ'


GO
/****** Object:  StoredProcedure [dbo].[Keyer_InsertORupdateAdditionalFeildsKeyer]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Keyer_InsertORupdateAdditionalFeildsKeyer](@projId int=null,@fieldName varchar(200)=null,@taskId int=null,@fieldIndex int=null,@repIndex int=null,@deleteStatus varchar(10)=null,@dmlOperation varchar(100)=null)
as

--if(@dmlOperation='INSERT')
--begin
--insert into dbo.tbl_ADDITIONAL_FIELDS(PROJECT_ID,FIELD_NAME,TASK_ID,FIELD_INDEX,REPORT_INDEX,IS_DELETED)values(@projId,@fieldName,@taskId,@fieldIndex,@repIndex,@deleteStatus)
--end
--else if(@dmlOperation='UPDATE')
--begin
--update dbo.tbl_ADDITIONAL_FIELDS set IS_DELETED=@deleteStatus where PROJECT_ID=@projId and TASK_ID=@taskId and FIELD_NAME=@fieldName--FIELD_INDEX=@fieldIndex
--end

--else if (@dmlOperation='UpdateFieldIndex')
--begin
--update dbo.tbl_ADDITIONAL_FIELDS set FIELD_INDEX=@fieldindex where TASK_ID=@taskId and PROJECT_ID=@projId and FIELD_NAME=@fieldName
--end
--else if (@dmlOperation='UpdateREPORTIndex')
--begin
--update dbo.tbl_ADDITIONAL_FIELDS set REPORT_INDEX=@repIndex where TASK_ID=@taskId and PROJECT_ID=@projId and FIELD_NAME=@fieldName
--end
declare @Displayname varchar(200)
if(@dmlOperation='INSERT')
begin
if not exists(select PROJECT_ID,FIELD_NAME,TASK_ID,IS_DELETED from dbo.tbl_ADDITIONAL_FIELDS where PROJECT_ID=@projId and FIELD_NAME=@fieldName and TASK_ID=@taskId)
begin

set @Displayname=(select distinct DISPLAY_FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where FIELD_NAME=@fieldName and PROJECT_ID=7)--PROJECT_ID=8
insert into dbo.tbl_ADDITIONAL_FIELDS(PROJECT_ID,FIELD_NAME,DISPLAY_FIELD_NAME,TASK_ID,FIELD_INDEX,REPORT_INDEX,IS_DELETED)values(@projId,@fieldName,@Displayname,@taskId,@fieldIndex,@repIndex,@deleteStatus)
end
else
begin
update dbo.tbl_ADDITIONAL_FIELDS set IS_DELETED='N' where PROJECT_ID=@projId and TASK_ID=@taskId and FIELD_NAME=@fieldName--FIELD_INDEX=@fieldIndex

End
End
else if(@dmlOperation='UPDATE')
begin
update dbo.tbl_ADDITIONAL_FIELDS set IS_DELETED=@deleteStatus where PROJECT_ID=@projId and TASK_ID=@taskId and FIELD_NAME=@fieldName--FIELD_INDEX=@fieldIndex
end

else if (@dmlOperation='UpdateFieldIndex')
begin
update dbo.tbl_ADDITIONAL_FIELDS set FIELD_INDEX=@fieldindex where TASK_ID=@taskId and PROJECT_ID=@projId and FIELD_NAME=@fieldName
end
else if (@dmlOperation='UpdateREPORTIndex')
begin
update dbo.tbl_ADDITIONAL_FIELDS set REPORT_INDEX=@repIndex where TASK_ID=@taskId and PROJECT_ID=@projId and FIELD_NAME=@fieldName
end



GO
/****** Object:  StoredProcedure [dbo].[KeyerTransaction_WithMultipleRecords]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[KeyerTransaction_WithMultipleRecords] @datatable  KeyerTrans_MultipleSelection readonly


as

Declare @rowCount int
DEclare @batchRef int 
Declare @tempVariable varchar(max)
set @rowCount=0
update K set K.RESPONSIBILITY =D.Responsibility,K.CHARGE_STATUS=D.Charge_Status,K.KEYING_STATUS=D.Charge_Status, K.KEYER_COMMENTS=D.KeyerComments,K.AR_Assign_Status=D.AR_Assign_Status,K.PC_Assign_Status=D.PC_Assign_Status,K.KEYER_DATE=getdate() from KEYING_TRANSACTION K inner join @datatable D on K.PROJECT_ID=D.Proj_Id and K.BATCH_ID=D.Batch_Id --and D.Responsibility not in ('Coding')


--update  CT set CT.CODING_STATUS='Completed',CT.QC_STATUS=NULL,CT.SEND_TO_CODER=NULL, CT.QC_BY=null,CT.IS_AUDITED=0,CT.Pending_Updated_By='KEYING',CT.CODING_COMMENTS=D.KeyerComments from tbl_TRANSACTION CT inner join @datatable D on CT.PROJECT_ID=D.Proj_Id and CT.BATCH_ID=D.Batch_Id and D.Responsibility in ('Coding')

update  CT set CT.CODING_STATUS='Completed',CT.QC_STATUS=NULL,CT.SEND_TO_CODER=NULL, CT.QC_BY=null,CT.IS_AUDITED=0,CT.Pending_Updated_By='KEYING',CT.KEYING_COMMENTS=D.KeyerComments from tbl_TRANSACTION CT inner join @datatable D on CT.PROJECT_ID=D.Proj_Id and CT.BATCH_ID=D.Batch_Id and D.Responsibility in ('Coding')

update  CT set CT.QC_STATUS=NULL,CT.QC_BY=null,BATCH_STATUS='CODED' from dbo.tbl_IMPORT_TABLE CT inner join @datatable D on CT.PROJECT_ID=D.Proj_Id and CT.BATCH_ID=D.Batch_Id and D.Responsibility in ('Coding')

--select GETDATE()

GO
/****** Object:  StoredProcedure [dbo].[M_Allot_For_AR_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manohar GK>
-- Create date: <06-03-2015>
-- Description:	<Allot for AR_QC>
-- =============================================
CREATE PROCEDURE [dbo].[M_Allot_For_AR_QC] 
	-- Add the parameters for the stored procedure here
	(
     @Facility varchar(200)=null,
     @from_Date datetime=null,
     @to_Date datetime=null,
     @status varchar(50)=null,
     @ar varchar(250)=null
     )
	
AS
BEGIN
	
	
	if @status='Completed'
	
	begin
	select  distinct KA.PROJECT_ID,ka.BATCH_ID, KA.FACILITY as Facility,KA.RECEIVED_DATE as [Received Date],ka.ACCOUNT_NO as [Patient ID],KA.PATIENT_NAME as [Patient Name],
     kt.KEYED_BY as [Keyed By],kt.KEYER_DATE as [Keyed Date],KA.AGE as Age,KA.DISPOSITION as Disposition,AR_QC_Assigned_To as ALLOTED_TO,Kt.AR_Updated_By as [AR Updated By],KT.AR_Updated_Date as [AR Updated Date],kt.AR_QC_Assigned_Status from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on ka.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID
      where KT.PROJECT_ID=8 and KT.Pending_Update_From='AR' and --(KT.AR_STATUS=''or KT.AR_STATUS is NULL) and --[RECEIVED_DATE] between @FromDos and @ToDos and kt.CHARGE_STATUS!='Completed'
     ((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
     --((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
     ((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
     [RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
     and (nullif(@Facility,null)is null or FACILITY=@Facility) and AR_Assign_Status ='Completed'  and (AR_QC_Assigned_Status is null or AR_QC_Assigned_Status='')--and AR_QC_Assigned_Status=case when @status ='Completed' then '' else AR_QC_Assigned_Status end
     and (nullif(@ar,null)is null or AR_Assign_To=@ar)--AR_Assign_Status=@status 
	end
	
	else
	
	begin
		select  distinct KA.PROJECT_ID,ka.BATCH_ID, KA.FACILITY as Facility,KA.RECEIVED_DATE as [Received Date],ka.ACCOUNT_NO as [Patient ID],KA.PATIENT_NAME as [Patient Name],
     kt.KEYED_BY as [Keyed By],kt.KEYER_DATE as [Keyed Date],KA.AGE as Age,KA.DISPOSITION as Disposition,AR_QC_Assigned_To as ALLOTED_TO,Kt.AR_Updated_By as [AR Updated By],KT.AR_Updated_Date as [AR Updated Date],kt.AR_QC_Assigned_Status from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on ka.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID
      where KT.PROJECT_ID=8 and KT.Pending_Update_From='AR' and --(KT.AR_STATUS=''or KT.AR_STATUS is NULL) and --[RECEIVED_DATE] between @FromDos and @ToDos and kt.CHARGE_STATUS!='Completed'
     ((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
     --((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
     ((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
     [RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
     and (nullif(@Facility,null)is null or FACILITY=@Facility) and AR_Assign_Status ='Completed'  and (AR_QC_Assigned_Status=@status)--and AR_QC_Assigned_Status=case when @status ='Completed' then '' else AR_QC_Assigned_Status end
     and (nullif(@ar,null)is null or AR_Assign_To=@ar)--AR_Assign_Status=@status 
	end
END
--exec [M_Allot_For_AR_QC] null,null,null,'Completed'
GO
/****** Object:  StoredProcedure [dbo].[M_AR_Bind_Pending_Log_Fields]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[M_AR_Bind_Pending_Log_Fields]
(@Facility varchar(200)=null,@from_Date datetime=null,@to_Date datetime=null,
 @projectID int=null,  @Notes varchar(max)=null, @Ntlg  varchar(50)=null,
 @ARStat varchar(200)=null, @Batch int=null,@dmlOperation varchar(20)=null,
 @arstatus varchar(50)=null,@Update varchar(20) out,@startIndex		int=null,
	@pageSize		int=null
)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	
	if(@dmlOperation is null)
	
	begin
	select dense_rank() over (order by KA.batch_id) as S_No,
	KT.AR_STATUS,kt.NOTES,KA.PROJECT_ID,KA.BATCH_ID, KA.FACILITY as Facility,
	convert(varchar(12),KA.RECEIVED_DATE,101) as [Arrival Date],KA.ACCOUNT_NO as [Patient Id],
	KA.PATIENT_NAME as [Patient Name],KA.AGE as Age,KT.INSURANCE as Insurance,
	KTD.PROVIDER_MD as [Provider/MD Name],KTD.ASSISTANT_PROVIDER as [Assistant Provider /PA/NP Name],
	kt.PATIENT_STATUS as [Patient Status],case when (convert(varchar(12),KT.DOI,101))='01/01/1900' then '' else convert(varchar(12),KT.DOI,101) end as DOI ,
	convert(varchar(12),KT.TOI,101) as TOI,KT.TYPE_OF_ACCIDENT as [Type of Accident],
	KT.SHARD_VISIT as [Shared Visit],KT.DISPOSITION as Disposition,KTD.CPT,
	KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
    ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER as Modifier,
	KTD.UNITS as Units,KTD.COMMENTS as Comments,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],
	KTD.DEFICIENCY_INDICATOR as [Deficiency Indicator],KT.DOS_CHANGED as [DOS Change],
	KTD.ACCOUNT_STATUS as [Account Status],kt.[W/O Attestation] as [Attestation], kt.CHARGE_STATUS as [Charge Status],
	KT.KEYER_COMMENTS as [Keyer Comments],KT.AR_Assign_To as [Allocated to],AR_Assign_Status ,ktd.CPT_ORDER  into #temp1 from 
	dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join
	Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
	
	 where KT.PROJECT_ID=8 and --KT.RESPONSIBILITY='AR' and --(KT.AR_STATUS=''or KT.AR_STATUS is NULL) and --[RECEIVED_DATE] between @FromDos and @ToDos and kt.CHARGE_STATUS!='Completed'
	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	and (nullif(@Facility,null)is null or FACILITY=@Facility)
	 and (AR_Assign_Status='Allotted' or AR_Assign_Status='Hold') and AR_Assign_To=@Ntlg --and kt.CHARGE_STATUS='Pending' 
	
	select S_No,AR_STATUS,NOTES,PROJECT_ID,BATCH_ID, Facility,[Arrival Date],[Patient Id],[Patient Name],AGE as Age,INSURANCE as Insurance, [Provider/MD Name],
	[Assistant Provider /PA/NP Name],[Patient Status],DOI,TOI,[Type of Accident],[Shared Visit],Disposition,CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,Modifier,Units,Comments,[Down Coding Comments],
	[Deficiency Indicator],[DOS Change],[Account Status],[Attestation], [Charge Status],[Keyer Comments],[Allocated to],AR_Assign_Status from #temp1
	Pivot 
	(
	max(ICD) for ICDlIST in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
	)as PIVOTEDTABLE order by BATCH_ID,CPT_ORDER
	drop table #temp1
	end
	
	
	
	
	if(@dmlOperation='Update')
	begin 
			if(@arstatus='Hold')
			begin
			update KEYING_TRANSACTION set KEYING_STATUS='Pending',RESPONSIBILITY='AR', AR_Assign_Status='Hold',NOTES=@Notes,AR_STATUS=@ARStat,AR_Updated_Date=GETDATE() where PROJECT_ID=@projectID and BATCH_ID=@Batch 
			select @Update='update'
			end
					
		    if(@arstatus='Completed')
					begin
					update KEYING_TRANSACTION set NOTES=@Notes,AR_Assign_Status=@arstatus,AR_Completed_Date=GETDATE(),
					 AR_Updated_By=@Ntlg,AR_Updated_Date=GETDATE(),AR_STATUS=@ARStat,Pending_Update_From='AR' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
					-- KEYING_STATUS='ALLOTTED',QC_STATUS='',RESPONSIBILITY='' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
					--update dbo.KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
					select @Update='update'
					end
	end
END

--declare  @refvalue varchar(50) 
--exec [M_AR_Bind_Pending_Log_Fields] @Facility=null,@from_Date=null,@to_Date=null
--,@projectID=8,@Notes=null, @Ntlg='SandeepB',@ARStat=null,@Batch=null,@dmlOperation=null

--
--Declare @newOut Varchar(30)
--exec [M_AR_Bind_Pending_Log_Fields] null,null,null,8,null,'ugeshA',null,null,null,null,@newOut out
GO
/****** Object:  StoredProcedure [dbo].[M_AR_QC_Bind_Inbox_Log]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manohar GK>
-- Create date: <27-12-2014>
-- Description:	<AR pending log Details>
-- =============================================
--ALTER PROCEDURE [dbo].[M_AR_Bind_Pending_Log_Fields]
--(@Facility varchar(200)=null,@from_Date datetime=null,@to_Date datetime=null,
--@projectID int=null,  @Notes varchar(max)=null, @Ntlg  varchar(50)=null
--,@ARStat varchar(200)=null, @Batch int=null,@dmlOperation varchar(20)=null,@arstatus varchar(50)=null,
--@Update varchar(20) out)
--	-- Add the parameters for the stored procedure here
	
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
	
--	select KT.AR_STATUS,kt.NOTES,KA.PROJECT_ID,KA.BATCH_ID, KA.FACILITY as Facility,convert(varchar(12),KA.RECEIVED_DATE,101) as [Arrival Date],KA.ACCOUNT_NO as [Patient Id],KA.PATIENT_NAME as [Patient Name],KA.AGE as Age,KT.INSURANCE as Insurance,KTD.PROVIDER_MD as [Provider/MD Name],
--	KTD.ASSISTANT_PROVIDER as [Assistant Provider /PA/NP Name],kt.PATIENT_STATUS as [Patient Status],convert(varchar(12),KT.DOI,101) as DOI,convert(varchar(12),KT.TOI,101) as TOI,KT.TYPE_OF_ACCIDENT as [Type of Accident],KT.SHARD_VISIT as [Shared Visit],KT.DISPOSITION as Disposition,KTD.CPT,KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (partition	BY KTD.CPT ORDER BY KTD.CPT) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER as Modifier,KTD.UNITS as Units,KTD.COMMENTS as Comments,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],
--	KTD.DEFICIENCY_INDICATOR as [Deficiency Indicator],KT.DOS_CHANGED as [DOS Change],KTD.ACCOUNT_STATUS as [Account Status],kt.[W/O Attestation] as [Attestation], kt.CHARGE_STATUS as [Charge Status],KT.KEYER_COMMENTS as [Keyer Comments],KT.AR_Assign_To as [Allocated to],AR_Assign_Status into #temp1 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join
--	Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
	
--	 where KT.PROJECT_ID=8 and --KT.RESPONSIBILITY='AR' and --(KT.AR_STATUS=''or KT.AR_STATUS is NULL) and --[RECEIVED_DATE] between @FromDos and @ToDos and kt.CHARGE_STATUS!='Completed'
--	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
--	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
--	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
--	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
--	and (nullif(@Facility,null)is null or FACILITY=@Facility)
--	 and (AR_Assign_Status='Allotted' or AR_Assign_Status='Hold') and AR_Assign_To=@Ntlg --and kt.CHARGE_STATUS='Pending' 
	
--	select AR_STATUS,NOTES,PROJECT_ID,BATCH_ID, Facility,[Arrival Date],[Patient Id],[Patient Name],AGE as Age,INSURANCE as Insurance, [Provider/MD Name],
--	[Assistant Provider /PA/NP Name],[Patient Status],DOI,TOI,[Type of Accident],[Shared Visit],Disposition,CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,Modifier,Units,Comments,[Down Coding Comments],
--	[Deficiency Indicator],[DOS Change],[Account Status],[Attestation], [Charge Status],[Keyer Comments],[Allocated to],AR_Assign_Status from #temp1
--	Pivot 
--	(
--	max(ICD) for ICDlIST in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
--	)as PIVOTEDTABLE
--	drop table #temp1
	
--	if(@dmlOperation='Update')
--	begin 
--			if(@arstatus='Hold')
--			begin
--			update KEYING_TRANSACTION set KEYING_STATUS='Pending',RESPONSIBILITY='AR', AR_Assign_Status='Hold' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
--			select @Update='update'
--			end
--					if(@arstatus='Completed')
--					begin
--					update KEYING_TRANSACTION set NOTES=@Notes,AR_Assign_Status=@arstatus,AR_Completed_Date=GETDATE(), AR_Updated_By=@Ntlg,AR_Updated_Date=GETDATE(),AR_STATUS=@ARStat,Pending_Update_From='AR',KEYING_STATUS='ALLOTTED',QC_STATUS='',RESPONSIBILITY='' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
--					update dbo.KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
--					select @Update='update'
--					end
--	end
--END

----declare  @refvalue varchar(50) 
----exec [M_AR_Bind_Pending_Log_Fields] @Facility=null,@from_Date=null,@to_Date=null
----,@projectID=8,@Notes=null, @Ntlg='SandeepB',@ARStat=null,@Batch=null,@dmlOperation=null
CREATE PROCEDURE [dbo].[M_AR_QC_Bind_Inbox_Log]
(@Facility varchar(200)=null,@from_Date datetime=null,@to_Date datetime=null,
 @projectID int=null,  @Notes varchar(max)=null, @Ntlg  varchar(50)=null,
 @ARStat varchar(200)=null, @Batch int=null,@dmlOperation varchar(20)=null,@accntNo varchar(100)=null,
 @arstatus varchar(50)=null,@Update varchar(20) out)
	
AS
BEGIN
	
	select dense_rank() over (order by KA.batch_id) as S_No,
	KT.AR_STATUS,kt.NOTES,kt.AR_QC_Comments,kt.AR_Updated_By,kt.AR_Updated_Date,KA.PROJECT_ID,KA.BATCH_ID, KA.FACILITY as Facility,
	convert(varchar(12),KA.RECEIVED_DATE,101) as [Arrival Date],KA.ACCOUNT_NO as [Patient Id],
	KA.PATIENT_NAME as [Patient Name],KA.AGE as Age,KT.INSURANCE as Insurance,
	KTD.PROVIDER_MD as [Provider/MD Name],KTD.ASSISTANT_PROVIDER as [Assistant Provider /PA/NP Name],
	kt.PATIENT_STATUS as [Patient Status],convert(varchar(12),KT.DOI,101) as DOI,
	convert(varchar(12),KT.TOI,101) as TOI,KT.TYPE_OF_ACCIDENT as [Type of Accident],
	KT.SHARD_VISIT as [Shared Visit],KT.DISPOSITION as Disposition,KTD.CPT,
	KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (partition	BY KA.ACCOUNT_NO,KTD.CPT_ORDER,KTD.CPT ORDER BY KTD.CPT) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER as Modifier,
	KTD.UNITS as Units,KTD.COMMENTS as Comments,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],
	KTD.DEFICIENCY_INDICATOR as [Deficiency Indicator],KT.DOS_CHANGED as [DOS Change],
	KTD.ACCOUNT_STATUS as [Account Status],kt.[W/O Attestation] as [Attestation], kt.CHARGE_STATUS as [Charge Status],
	KT.KEYER_COMMENTS as [Keyer Comments],KT.AR_QC_Assigned_To as [Allocated to],AR_Assign_Status,KT.AR_QC_Assigned_Status, ktd.CPT_ORDER  into #temp1 from 
	dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join
	Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
	
	 where KT.PROJECT_ID=8 and (nullif(@accntNo,null)is null or KA.ACCOUNT_NO=@accntNo) and--KT.RESPONSIBILITY='AR' and --(KT.AR_STATUS=''or KT.AR_STATUS is NULL) and --[RECEIVED_DATE] between @FromDos and @ToDos and kt.CHARGE_STATUS!='Completed'
	((nullif(@from_Date,null)is null or convert(varchar(12),[RECEIVED_DATE],101)=convert(varchar(12),@from_Date,101))or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	and (nullif(@Facility,null)is null or FACILITY=@Facility)-- and ACCOUNT_NO=@accntNo
	 and (AR_QC_Assigned_Status='Allotted' or AR_QC_Assigned_Status='Hold') and AR_QC_Assigned_To=@Ntlg--AR_Updated_By=@Ntlg--AR_QC_Assigned_To=@Ntlg --and kt.CHARGE_STATUS='Pending' 
	
	select S_No,AR_STATUS,NOTES,AR_QC_Comments, AR_Updated_By as [AR BY],AR_Updated_Date as [AR Date],PROJECT_ID,BATCH_ID, Facility,[Arrival Date],[Patient Id],[Patient Name],AGE as Age,INSURANCE as Insurance, [Provider/MD Name],
	[Assistant Provider /PA/NP Name],[Patient Status],DOI,TOI,[Type of Accident],[Shared Visit],Disposition,CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,Modifier,Units,Comments,[Down Coding Comments],
	[Deficiency Indicator],[DOS Change],[Account Status],[Attestation], [Charge Status],[Keyer Comments],[Allocated to],AR_Assign_Status,AR_QC_Assigned_Status from #temp1
	Pivot 
	(
	max(ICD) for ICDlIST in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
	)as PIVOTEDTABLE order by BATCH_ID,CPT_ORDER
	drop table #temp1
	
	--if(@dmlOperation='Update')
	--begin 
	--		if(@arstatus='Hold')
	--		begin
	--		update KEYING_TRANSACTION set KEYING_STATUS='Pending',RESPONSIBILITY='AR', AR_Assign_Status='Hold' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
	--		select @Update='update'
	--		end
	--				if(@arstatus='Completed')
	--				begin
	--				update KEYING_TRANSACTION set NOTES=@Notes,AR_Assign_Status=@arstatus,AR_Completed_Date=GETDATE(),
	--				 AR_Updated_By=@Ntlg,AR_Updated_Date=GETDATE(),AR_STATUS=@ARStat,Pending_Update_From='AR',
	--				 KEYING_STATUS='ALLOTTED',QC_STATUS='',RESPONSIBILITY='' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
	--				update dbo.KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
	--				select @Update='update'
	--				end
	--end
ENd

--declare  @refvalue varchar(50) 
--exec [M_AR_Bind_Pending_Log_Fields] @Facility=null,@from_Date=null,@to_Date=null
--,@projectID=8,@Notes=null, @Ntlg='SandeepB',@ARStat=null,@Batch=null,@dmlOperation=null

--
--Declare @newOut Varchar(30)
--exec [M_AR_QC_Bind_Inbox_Log] null,'03/09/2015',null,8,null,'Viswajitr',null,null,null,null,@newOut out




GO
/****** Object:  StoredProcedure [dbo].[M_AR_QC_Update_Inbox_Log]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Manohar GK>
-- Create date: <10-03-2015>
-- Description:	<Update AR QC Inbox log>
-- =============================================
CREATE proc [dbo].[M_AR_QC_Update_Inbox_Log](@acc varchar(300)=null,
@batch int=null,@projectid int=null,@ARComments varchar(max)=null,
@ARStatus varchar(max)=null,@ARQCComments varchar(max)=null,
@QC_Status varchar(200)=null,@errCat varchar(200)=null,
@errSubCat varchar(200)=null,@errorComments varchar(max)=null,@errCount int=null,
@ImpactErrCorrection varchar(20)=null,@ErrCountText varchar(450)=null)--,@update varchar(20) out)--@update varchar(20) out
as
begin
if @QC_Status='Skip'

begin

update dbo.KEYING_TRANSACTION set AR_Is_Skipped=1,AR_QC_Assigned_Status=@QC_Status                                                                                                                                                                                                 
where BATCH_ID=@batch and PROJECT_ID=@projectid

end

else

if(@QC_Status='Completed')

begin

update dbo.KEYING_TRANSACTION set NOTES=@ARComments,AR_STATUS=@ARStatus,
AR_QC_Completed_Date=GETDATE(),AR_Error_Category=@errCat,AR_Sub_Error_Category=@errSubCat,
AR_Error_Comments=@errorComments,AR_Error_Count=@errCount,AR_Error_Correction=@ImpactErrCorrection,
AR_Error_List=@ErrCountText,AR_QC_Assigned_Status=@QC_Status,AR_QC_Comments= @ARQCComments
                                                                                                                                                                                                       
where BATCH_ID=@batch and PROJECT_ID=@projectid

end

if @QC_Status='Hold'
begin
update dbo.KEYING_TRANSACTION set AR_QC_Assigned_Status=@QC_Status, 
AR_QC_Comments= @ARQCComments                                                                                                                                                                                            
where BATCH_ID=@batch and PROJECT_ID=@projectid

end


--else


--select @update='updated'
end
--Declare @update Varchar(30)
--exec M_AR_QC_Update_Inbox_Log null,null,8,null,null,null,'Completed',null,null,null,null,null,null,@update out
GO
/****** Object:  StoredProcedure [dbo].[M_Bind_AR_Allottment_Log_Details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<GK Manohar>
-- Create date: <02-02-2015>
-- Description:	<Bind AR allottment details,,>
-- =============================================
--ALTER PROCEDURE [dbo].[M_Bind_AR_Allottment_Log_Details]
--     -- Add the parameters for the stored procedure here
--     (
--     @Facility varchar(200)=null,
--     @from_Date datetime=null,
--     @to_Date datetime=null,
--     @status varchar(50)=null
--     )
--AS
--BEGIN
--     select  distinct KA.PROJECT_ID,ka.BATCH_ID, KA.FACILITY as Facility,KA.RECEIVED_DATE as [Received Date],ka.ACCOUNT_NO as [Patient ID],KA.PATIENT_NAME as [Patient Name],
--     kt.KEYED_BY as [Keyed By],kt.KEYER_DATE as [Keyed Date],KA.AGE as Age,KA.DISPOSITION as Disposition,AR_Assign_To as ALLOTED_TO from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on ka.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID
--      where KT.PROJECT_ID=8 and KT.RESPONSIBILITY='AR' and --(KT.AR_STATUS=''or KT.AR_STATUS is NULL) and --[RECEIVED_DATE] between @FromDos and @ToDos and kt.CHARGE_STATUS!='Completed'
--     ((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
--     --((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
--     ((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
--     [RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
--     and kt.CHARGE_STATUS='Pending' and AR_Assign_Status=@status and (nullif(@Facility,null)is null or FACILITY=@Facility)
     
     
--END


----exec [M_Bind_AR_Allottment_Log_Details] null,null,null,'Fresh'

CREATE PROCEDURE [dbo].[M_Bind_AR_Allottment_Log_Details]
     (
     @Facility varchar(200)=null,
     @from_Date datetime=null,
     @to_Date datetime=null,
     @status varchar(50)=null
     )
AS
BEGIN
     select  distinct KA.PROJECT_ID,ka.BATCH_ID, KA.FACILITY as Facility,KA.RECEIVED_DATE as [Received Date],ka.ACCOUNT_NO as [Patient ID],KA.PATIENT_NAME as [Patient Name],
     kt.KEYED_BY as [Keyed By],kt.KEYER_DATE as [Keyed Date],KA.AGE as Age,KA.DISPOSITION as Disposition,AR_Assign_To as ALLOTED_TO from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on ka.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID
      where KT.PROJECT_ID=8 and KT.RESPONSIBILITY='AR' and --(KT.AR_STATUS=''or KT.AR_STATUS is NULL) and --[RECEIVED_DATE] between @FromDos and @ToDos and kt.CHARGE_STATUS!='Completed'
     ((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
     --((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
     ((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
     [RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
     and AR_Assign_Status=@status and (nullif(@Facility,null)is null or FACILITY=@Facility)--and kt.CHARGE_STATUS='Pending' 
     
     
END


--exec [M_Bind_AR_Allottment_Log_Details] null,null,null,'Fresh'


GO
/****** Object:  StoredProcedure [dbo].[M_Bind_AR_Facility]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[M_Bind_AR_Facility](@tlntlg varchar(200)=null)
AS
Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@tlntlg))


SELECT CODE,[DESCRIPTION] FROM DBO.TBL_FACILITY

if(@AccessType='AR-QC-TL' or @AccessType='AR-QC')
begin
select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR','AR-TL')  and IS_DELETED='N' --or USER_NTLG=@tlntlg
end
else
begin

select [USER_NAME],USER_NTLG from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR','AR-TL') and IS_DELETED='N' --and TL_NTLG=@tlntlg or USER_NTLG=@tlntlg
end
GO
/****** Object:  StoredProcedure [dbo].[M_Bind_AR_Names]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[M_Bind_AR_Names](@ntlg varchar(300)=null,
@proj int=null)
as

Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))

if @AccessType='AR' 
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE='AR' and IS_DELETED='N' and PROJECT_ID=@proj and [USER_NTLG]=@ntlg
end
else if @AccessType='AR-TL' or @AccessType='AR MANAGER' or @AccessType='CLIENT'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE = 'AR' or TL_NTLG=@ntlg  and IS_DELETED='N' and PROJECT_ID=@proj --and TL_NTLG=@ntlg 
--or [USER_NTLG]=@ntlg
end
--else if @AccessType='AR-TL'

--begin
--Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in('AR-QC','AR-QC-TL') and IS_DELETED='N' and PROJECT_ID=@proj --or  TL_NTLG=@ntlg 
--or [USER_NTLG]=@ntlg

--end

else if @AccessType='AR-MANAGER' --or @AccessType='SOFTWARE'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR','AR-TL') and IS_DELETED='N' and PROJECT_ID=@proj and TL_NTLG=@ntlg  
--or [USER_NTLG]=@ntlg
end

else if @AccessType='SOFTWARE'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR','AR-TL') and IS_DELETED='N' and PROJECT_ID=@proj or [USER_NTLG]=@ntlg  
--or [USER_NTLG]=@ntlg
end

--exec [M_Bind_AR_Names] 'Manoharr',8

--Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE = 'AR' or ACCESS_TYPE='AR-TL' and IS_DELETED='N' and PROJECT_ID=8 and TL_NTLG='ManoharR' 
--select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG='ManoharR')
GO
/****** Object:  StoredProcedure [dbo].[M_Bind_AR_QC_Names]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[M_Bind_AR_QC_Names](@ntlg varchar(300)=null,
@proj int=null)
as

Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))

if @AccessType='AR-QC' 
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE='AR-QC' and IS_DELETED='N' and PROJECT_ID=@proj and [USER_NTLG]=@ntlg
end
else if @AccessType='AR-TL' or @AccessType='AR MANAGER' or @AccessType='CLIENT'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE = 'AR-QC' or ACCESS_TYPE='AR-QC-TL' and IS_DELETED='N' and PROJECT_ID=@proj and TL_NTLG=@ntlg 
--or [USER_NTLG]=@ntlg
end
else if @AccessType='AR-QC-TL'

begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in('AR-QC','AR-QC-TL') and IS_DELETED='N' and PROJECT_ID=@proj-- or  TL_NTLG=@ntlg 
or [USER_NTLG]=@ntlg

select  [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('ar','ar-tl')

end

else if @AccessType='AR-QC-MANAGER' --or @AccessType='SOFTWARE'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR-QC','AR-QC-TL') and IS_DELETED='N' and PROJECT_ID=@proj and TL_NTLG=@ntlg  
--or [USER_NTLG]=@ntlg
end

else if @AccessType='SOFTWARE'
begin
Select [USER_NAME],[USER_NTLG] from dbo.tbl_USER_ACCESS where ACCESS_TYPE in ('AR-QC','AR-QC-TL') and IS_DELETED='N' and PROJECT_ID=@proj or [USER_NTLG]=@ntlg  
--or [USER_NTLG]=@ntlg
end

--exec [M_Bind_AR_QC_Names] 'Viswajitr',8



GO
/****** Object:  StoredProcedure [dbo].[M_Bind_Patient_Pending_Log_Fields]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[M_Bind_Patient_Pending_Log_Fields] (@Facility varchar(200)=null,@from_Date datetime=null,@to_Date datetime=null,@projectID int=null,@pcstatus varchar(50)=null,@EPASTAT varchar(10)=null,
													@Pt_Calling_Comments varchar(max)=null,@Ntlg  varchar(50)=null,@Batch int=null,@dmlOperation varchar(20)=null,@Update varchar(20) out)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	
	select KT.PATIENT_CALLING_COMMENTS,KA.PROJECT_ID,KA.BATCH_ID,KA.FACILITY as Facility,CONVERT(varchar(12), KA.RECEIVED_DATE,101) as [Arrival Date],KA.ACCOUNT_NO as [Patient Id]
	 ,KA.PATIENT_NAME as [Patient Name],KT.CHARGE_STATUS as [Charge Status],KT.KEYER_COMMENTS as [Keyer Comments],KT.EDMD as [EDMD],PC_Assign_Status
	 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID --inner join Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
	where KT.PROJECT_ID=8 and-- kt.RESPONSIBILITY='Patient Calling' and --(KT.PATIENT_CALLING_COMMENTS is null or KT.PATIENT_CALLING_COMMENTS='') and
	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101))) --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	 and (nullif(@Facility,null)is null or FACILITY=@Facility)  and (PC_Assign_Status='Allotted' or PC_Assign_Status='Hold') and PC_Assign_To=@Ntlg  --and kt.KEYING_STATUS='Pending'
	
	if(@dmlOperation='Update')
	begin
	--
	if @pcstatus='Hold'
	begin 
	update KEYING_TRANSACTION  set KEYING_STATUS='Pending',RESPONSIBILITY='patient calling', PC_Assign_Status='Hold',PATIENT_CALLING_COMMENTS=@Pt_Calling_Comments,PC_Completed_Date=GETDATE() where PROJECT_ID=@projectID and BATCH_ID=@Batch 
	select @Update='update'
	end
	else if @pcstatus='Completed'
	begin
	begin tran
	update KEYING_TRANSACTION set PATIENT_CALLING_COMMENTS=@Pt_Calling_Comments,PC_Assign_Status=@pcstatus,PC_Updated_By=@Ntlg,PC_Updated_Date=GETDATE(),PC_Completed_Date=GETDATE(),Pending_Update_From='PatientCalling',KEYING_STATUS='ALLOTTED',QC_STATUS='',RESPONSIBILITY='' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
	update dbo.KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
	select @Update='update'
	commit
	end
	
	else if @pcstatus='Forward'
	begin
	update KEYING_TRANSACTION set PATIENT_CALLING_COMMENTS=@Pt_Calling_Comments,PC_Assign_Status=@pcstatus,PC_Updated_By=@Ntlg,PC_Updated_Date=GETDATE(),PC_Completed_Date=GETDATE(),Pending_Update_From='PatientCalling',KEYING_STATUS='Pending',QC_STATUS='',RESPONSIBILITY='EPA' where PROJECT_ID=@projectID and BATCH_ID=@Batch 
	update dbo.KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID=@projectID and BATCH_ID=@Batch
	select @Update='update'
	end
	end
	
END

GO
/****** Object:  StoredProcedure [dbo].[M_SP_ARForwardClick]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[M_SP_ARForwardClick] 
	@project int,
	@batch int,
	@ntlg varchar(50),
	@Restatus varchar(100),
	@comments varchar(max),
	@Status varchar(max)
	
AS
BEGIN
	if(@Restatus='PC')
	
	begin
	update  dbo.KEYING_TRANSACTION set AR_Assign_Status=null,PC_Assign_Status='Fresh',
	RESPONSIBILITY='Patient Calling',NOTES=@comments, AR_STATUS=@Status 
	where PROJECT_ID=@project and BATCH_ID=@batch
	
	end
	else begin
	begin tran
	
	update  dbo.KEYING_TRANSACTION set AR_Assign_Status=null,NOTES=@comments, AR_STATUS=@Status where PROJECT_ID=@project and BATCH_ID=@batch
	
	update CT set CT.CODING_STATUS='Completed',CT.KEYING_COMMENTS=@comments,CT.AR_STATUS=@Status,CT.SEND_TO_CODER=null,CT.QC_STATUS=NULL,CT.IS_AUDITED=0,
	CT.Pending_Updated_By='AR',CT.QC_BY=null from tbl_TRANSACTION CT where CT.BATCH_ID=@batch and CT.PROJECT_ID=@project
    update  CT set CT.QC_STATUS=NULL,CT.QC_BY=null,BATCH_STATUS='CODED' from dbo.tbl_IMPORT_TABLE CT where CT.PROJECT_ID=@project and CT.BATCH_ID=@batch

	commit
	end
ENd
GO
/****** Object:  StoredProcedure [dbo].[M_SP_PCForwardClick]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[M_SP_PCForwardClick]
	
	@project int,
	@batch int,
	@ntlg varchar(50),
	@Restatus varchar(100),
	@comments varchar(max)
	
AS
BEGIN
	if(@Restatus='AR')
	
	begin
	update  dbo.KEYING_TRANSACTION set PC_Assign_Status=null, AR_Assign_Status='Fresh',
	RESPONSIBILITY='AR',PATIENT_CALLING_COMMENTS=@comments where PROJECT_ID=@project and BATCH_ID=@batch
	end
	else begin
	begin tran
	
	update  dbo.KEYING_TRANSACTION set AR_Assign_Status=null,PATIENT_CALLING_COMMENTS=@comments where PROJECT_ID=@project and BATCH_ID=@batch
	
	update CT set CT.CODING_STATUS='Completed',CT.KEYING_COMMENTS=@comments,CT.SEND_TO_CODER=null,CT.QC_STATUS=NULL,CT.IS_AUDITED=0,
	CT.Pending_Updated_By='PC',CT.QC_BY=null from tbl_TRANSACTION CT where CT.BATCH_ID=@batch and CT.PROJECT_ID=@project
    update  CT set CT.QC_STATUS=NULL,CT.QC_BY=null,BATCH_STATUS='CODED' from dbo.tbl_IMPORT_TABLE CT where CT.PROJECT_ID=@project and CT.BATCH_ID=@batch

	commit
	end
ENd
GO
/****** Object:  StoredProcedure [dbo].[PC_Summary_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[PC_Summary_Report] (@from_Date datetime=null,@to_Date datetime=null,@Pcdate datetime=null,@Status varchar(200)=null)
as
select  PC_Assign_To as [PC By],convert(varchar(12),PC_Completed_Date,101) as [PC Date],COUNT(T.BATCH_ID)as [Production Count],convert(varchar(12),A.RECEIVED_DATE,101) AS DOS
    from dbo.KEYING_TRANSACTION T inner join KEYING_ALLOTMENT A
on T.BATCH_ID=A.BATCH_ID
where PC_Assign_Status=@Status and (nullif(@Pcdate,null) is null or Convert(varchar(12),PC_Completed_Date,101)=@Pcdate)
and 	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))
group by PC_Assign_To,convert(varchar(12),PC_Completed_Date,101),convert(varchar(12),A.RECEIVED_DATE,101)

--exec PC_Summary_Report null,null,null,'Hold'




GO
/****** Object:  StoredProcedure [dbo].[SELECT_KEYER_TRANS_TEST_t22]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SELECT_KEYER_TRANS_TEST_t22] @KeyerDetailedList KeyerUpdate readonly
as begin

DECLARE @FIELD_NAME VARCHAR(MAX)
DECLARE @SQL VARCHAR(MAX)
declare @sql1 varchar(max)

DECLARE @TCOLUMN TABLE (COLUMN_NAME VARCHAR(MAX))
declare @tab1 table(batid int null)
insert into @tab1
select batchid from @KeyerDetailedList

select @sql1=(STUFF(
                (
                    SELECT  ','+' ' +  Convert(varchar(100),x1.batid)
                    FROM    @tab1 x1
                   
                    FOR XML PATH('')
                ),1,1,'')) 
FROM   @tab1 x1

INSERT INTO @TCOLUMN
SELECT COLUMN_NAME  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TBL_TRANSACTION' and COLUMN_NAME not in ('PROVIDER_MD','ASSISTANT_PROVIDER')
union all
SELECT COLUMN_NAME  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='tbl_TRANSACTION_DETAILS'



DECLARE @TFIELD_NAME TABLE (FIELD_NAME VARCHAR(MAX),ID INT)
INSERT INTO @TFIELD_NAME
SELECT FIELD_NAME, 'ID'=1 FROM DBO.TBL_ADDITIONAL_FIELDS P 
INNER JOIN @TCOLUMN T ON P.FIELD_NAME =T.COLUMN_NAME   WHERE PROJECT_ID=8 AND TASK_ID=8 --AND FIELD_NAME<>'CODED_DATE'

union all

SELECT FIELD_NAME, 'ID'=1 FROM DBO.tbl_MANDATORY_FIELD  P 
INNER JOIN @TCOLUMN T ON P.FIELD_NAME =T.COLUMN_NAME   WHERE TASK_ID=8 --AND FIELD_NAME<>'CODED_DATE'


SELECT  
        @FIELD_NAME=(STUFF(
                (
                    SELECT  ','+ T1.FIELD_NAME
                    FROM    @TFIELD_NAME T1
                    WHERE   T1.ID = T.ID
                    ORDER BY T1.FIELD_NAME
                    FOR XML PATH('')
                ),1,1,'')) 
FROM    @TFIELD_NAME T
GROUP BY T.ID


--SET @SQL ='SELECT '+@FIELD_NAME+', T.TRANS_ID,T.PROJECT_ID,T.BATCH_ID FROM DBO.TBL_TRANSACTION T inner join dbo.tbl_TRANSACTION_DETAILS TD on T.TRANS_ID=TD.TRANS_ID and T.BATCH_ID in ('+@sql1+') and T.PROJECT_ID=7'

--SET @SQL ='SELECT '+@FIELD_NAME+', T.TRANS_ID,T.PROJECT_ID,T.BATCH_ID,TD.PROVIDER_MD,TD.ASSISTANT_PROVIDER,TD.ICD_RESULT,TD.CPT_ORDER FROM DBO.TBL_TRANSACTION T inner join dbo.tbl_TRANSACTION_DETAILS TD on T.TRANS_ID=TD.TRANS_ID and T.BATCH_ID in ('+@sql1+') and T.PROJECT_ID=8'
--SET @SQL ='SELECT '+@FIELD_NAME+', T.TRANS_ID,T.PROJECT_ID,T.BATCH_ID,TD.PROVIDER_MD,TD.ASSISTANT_PROVIDER,T.SHARD_VISIT,T.DOS_CHANGED,TD.DOWNLOADING_COMMENTS,TD.DEFICIENCY_INDICATOR,TD.ICD_RESULT,TD.CPT_ORDER FROM DBO.TBL_TRANSACTION T inner join dbo.tbl_TRANSACTION_DETAILS TD on T.TRANS_ID=TD.TRANS_ID and T.BATCH_ID in ('+@sql1+') and T.PROJECT_ID=8'
SET @SQL ='SELECT '+@FIELD_NAME+', T.TRANS_ID,T.PROJECT_ID,T.BATCH_ID,TD.PROVIDER_MD,TD.ASSISTANT_PROVIDER,T.SHARD_VISIT,T.DOS_CHANGED,T.DOS,TD.DOWNLOADING_COMMENTS,T.PATIENT_STATUS,T.DOI,T.TOI,TD.DEFICIENCY_INDICATOR,T.TYPE_OF_ACCIDENT,TD.TRANS_DETAIL_ID,TD.UNITS,  TD.ICD_RESULT,TD.CPT_ORDER FROM DBO.TBL_TRANSACTION T inner join dbo.tbl_TRANSACTION_DETAILS TD on T.TRANS_ID=TD.TRANS_ID and T.BATCH_ID in ('+@sql1+') and T.PROJECT_ID=8'


EXEC (@SQL)
END

--select GETDATE()
--end

--DECLARE @MyMessageQueue KeyerUpdate
 
-- INSERT INTO @MyMessageQueue(batchid ,proId)
-- VALUES (14,8)
          
          
 
-- EXEC [SELECT_KEYER_TRANS_TEST_t22] @MyMessageQueue
GO
/****** Object:  StoredProcedure [dbo].[sp_Account_From_Next_day]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Account_From_Next_day]
	@FromDate datetime,
	@ToDate datetime
AS

BEGIN

    DECLARE @TDATE DATETIME
    
    SET @TDATE = CONVERT(DATE,@ToDate, 103)
	
	SELECT i.FACILITY,i.RECEIVED_DATE,i.ACCOUNT_NO,i.PATIENT_NAME, T.DOS, '' AS POS, '' AS PROC1,'' AS VISIT, '' AS PATIENT_CHART_NUMBER, '' AS PROVIDER, '' AS CHARGEVALUE 
	FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
	WHERE I.BATCH_ID = T.BATCH_ID
	AND T.DOS_CHANGED != ''
	AND RECEIVED_DATE BETWEEN @TDATE AND @TDATE

END


GO
/****** Object:  StoredProcedure [dbo].[sp_Account_From_Pre_day]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Account_From_Pre_day]
	@FromDate DATETIME,
	@ToDate DATETIME
AS

BEGIN
	
	
	DECLARE @FDATE DATETIME
	DECLARE @TDATE DATETIME
	
	
	SET @FDATE = CONVERT(DATE,@FromDate, 103)	
	
	SET @FDATE = DATEADD(DAY, -1,@FDATE)	
	
	
	SELECT i.FACILITY,i.RECEIVED_DATE,i.ACCOUNT_NO,i.PATIENT_NAME,T.DOS, '' AS POS, '' AS PROC1,'' AS VISIT, '' AS PATIENT_CHART_NUMBER, '' AS PROVIDER, '' AS CHARGEVALUE
	FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
	WHERE I.BATCH_ID = T.BATCH_ID
	AND T.DOS_CHANGED != ''
	AND RECEIVED_DATE BETWEEN @FDATE AND @FDATE
	

END


GO
/****** Object:  StoredProcedure [dbo].[sp_AMD_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_AMD_Report]
	
	@ALLOTMENT AMD_Report READONLY
	
AS
BEGIN
	
	IF NOT EXISTS (SELECT A.PATIENT_ID FROM TBL_AMD_DATA A inner join @ALLOTMENT AA on A.PATIENT_ID = AA.PATIENT_ID AND A.CPT = AA.CPT)
	
	BEGIN
	
	INSERT INTO TBL_AMD_DATA 
	
	(DOS,PATIENT_NAME,PATIENT_TYPE,CPT,VISIT_NUMBER,CHART_NO,PROVIDER_CODE,PATIENT_ID,CHARGE_VALUE,UPLOAD_BY,FILE_UPLOAD_DATE)
	
	SELECT * FROM @ALLOTMENT
	
	END
	
	
	ELSE 
	
	BEGIN
	
	UPDATE A SET A.CHARGE_VALUE = AA.CHARGE_VALUE, A.PATIENT_TYPE = AA.PATIENT_TYPE, A.CPT = AA.CPT, A.VISIT_NUMBER = AA.VISIT_NUMBER, A.CHART_NO = AA.CHART_NO,
	A.PROVIDER_CODE  = AA.PROVIDER_CODE,A.FILE_UPLOAD_DATE = AA.FILE_UPLOAD_DATE FROM TBL_AMD_DATA A, @ALLOTMENT AA 
	
	WHERE A.PATIENT_ID = AA.PATIENT_ID AND A.CPT = AA.CPT
	
	END
	
	

-- DECLARE @MyMessageQueue AMD_Report_Excel
 
--INSERT INTO @MyMessageQueue(DOS,PATIENT_NAME,PATIENT_TYPE,CPT,VISIT_NUMBER,CHART_NO,PROVIDER_CODE,PATIENT_ID,CHARGE_VALUE,UPLOAD_BY)
--VALUES ('18-02-2015 00:00:00','REHM, ROBERT','23','2010F/2010','2004777','0003503353','6347','1436501054','0.01','MariaS1','09-06-2015 00:00:00')
          
          
 
---- EXEC [sp_AMD_Report] @MyMessageQueue

	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AR_QC_Submit_Click]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_AR_QC_Submit_Click]
	@pcallot_List pcallot readonly, @assignedby varchar(50)=null, @date date=null
AS
BEGIN
update KEYING_TRANSACTION   set AR_QC_Assigned_Status='Allotted', AR_QC_Assigned_By  =@assignedby, AR_QC_Assigned_Date=@date, AR_QC_Assigned_To = ntlg from @pcallot_List
where BATCH_ID=batchid  and PROJECT_ID=projectid 

-- 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_AR_Submit_Click]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ravi G
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_AR_Submit_Click]
	@pcallot_List pcallot readonly, @assignedby varchar(50)=null, @date date=null
AS
BEGIN
--update KEYING_TRANSACTION   set AR_QC_Assigned_Status='Allotted', AR_QC_Assigned_By  =@assignedby, AR_QC_Assigned_Date=@date, AR_QC_Assigned_To = ntlg from @pcallot_List
--where BATCH_ID=batchid  and PROJECT_ID=projectid 
update KEYING_TRANSACTION   set AR_Assign_Status='Allotted', AR_Assign_By  =@assignedby, AR_Assign_Date=@date, AR_Assign_To = ntlg from @pcallot_List
where BATCH_ID=batchid  and PROJECT_ID=projectid 

-- 
END






--ALTER PROCEDURE [dbo].[sp_PC_Allotment_Click] @pcallot_List pcallot readonly
--AS
--BEGIN
--	update [WFI_TEST].[dbo].[KEYING_ALLOTMENT] set ALLOTED_TO=ntlg from @pcallot_List
--where [KEYING_ALLOTMENT].BATCH_ID=batchid and [KEYING_ALLOTMENT].PROJECT_ID=projectid 
--END
GO
/****** Object:  StoredProcedure [dbo].[sp_Auto_Reconsolidation_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Auto_Reconsolidation_Report]
	
	@FDate varchar (100),
	@TDate varchar (100),
	@PreDate varchar (100),
	@NextDate varchar (100),
	@Facility varchar (100)
AS
BEGIN
	
	
IF(@FDate = @TDate)

  BEGIN
  
  SELECT HOSPITAL_LOG.RECEIVED_DATE, ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IN_HOSPITAL_LOG, ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IP_RECEIVED,

ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS TOTAL_INVENTORY_RECORD, ISNULL(CODED_ENTERED.ENTERED,0) AS ACCOUNTS_CODED_ER,

ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS ACCOUNTS_CODED_IP,ISNULL(CODED_ENTERED.ENTERED,0) + ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS TOTAL_CODED,

(ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0))  - ISNULL(CODED_ENTERED.ENTERED,0) AS PENDING_ACCOUNT_FROM_EPA,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) AS ACCOUNTS_BILLED_IN_AMD, ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS ACCOUNTS_BILLED_IP_AMD,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) + ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS TOTAL_BILLED_IN_AMD,

ISNULL(BILLED_OFFICE.BILLED_OFFICE,0) AS BILLED_OFFICE,

ISNULL(OTHERS.BILLED_OFFICE,0) AS OTHERS,

ISNULL(PREVIOUS.PRE,0) AS ACCOUNTS_FROM_PRE, ISNULL(PREVIOUS.PRE1,0) AS ACCOUNTS_FROM_NEXT, 

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) AS PENDING_WITH_CODING,

ISNULL(PENDING_WITH_PC.PC_PENDING,0) AS PENDING_WITH_PC,

ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS PENDING_WITH_EPA,

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) + ISNULL(PENDING_WITH_PC.PC_PENDING,0) + ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS BILLING_PENDING



 FROM (
 
SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT
 FROM tbl_IMPORT_TABLE I
WHERE I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 0
GROUP BY RECEIVED_DATE) AS HOSPITAL_LOG 

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 1
GROUP BY RECEIVED_DATE) AS IP_HOSPITAL_LOG

ON HOSPITAL_LOG.RECEIVED_DATE = IP_HOSPITAL_LOG.RECEIVED_DATE

LEFT JOIN 

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 0
 GROUP BY RECEIVED_DATE) AS CODED_ENTERED
 
 
 ON HOSPITAL_LOG.RECEIVED_DATE = CODED_ENTERED.RECEIVED_DATE
 
 LEFT JOIN 
 
 (SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS IP_ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 1
 GROUP BY RECEIVED_DATE) AS IP_CODED_ENTERED
 
 ON HOSPITAL_LOG.RECEIVED_DATE = IP_CODED_ENTERED.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '23'
GROUP BY DOS) AS BILLED_AMD

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '21'
GROUP BY DOS) AS BILLED_AMD_IP

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD_IP.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '11'
GROUP BY DOS) AS BILLED_OFFICE

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_OFFICE.DOS


LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = 'N/A'
GROUP BY DOS) AS OTHERS

ON HOSPITAL_LOG.RECEIVED_DATE = OTHERS.DOS

LEFT JOIN

(SELECT PRE1.RECEIVED_DATE,PRE,PRE1 FROM 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum,RECEIVED_DATE AS RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @PreDate AND @PreDate
GROUP BY RECEIVED_DATE) AS PRE


LEFT JOIN 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum1,RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE1 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @FDate AND @NextDate
GROUP BY RECEIVED_DATE) AS PRE1


ON PRE.RowNum = PRE1.RowNum1) AS PREVIOUS

ON HOSPITAL_LOG.RECEIVED_DATE = PREVIOUS.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(A.BATCH_ID) AS CODING_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Coding' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_CODING


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_CODING.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS PC_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Patient Calling' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_PC


on HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_PC.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS EPA_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='EPA' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_EPA


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_EPA.RECEIVED_DATE

GROUP BY HOSPITAL_LOG.RECEIVED_DATE, HOSPITAL_LOG.NO_OF_PATIENT,IP_HOSPITAL_LOG.NO_OF_PATIENT, CODED_ENTERED.ENTERED, IP_CODED_ENTERED.IP_ENTERED, BILLED_AMD.AMD_ENTERED,
BILLED_AMD_IP.AMD_ENTERED, PREVIOUS.PRE, PREVIOUS.PRE1, PENDING_WITH_CODING.CODING_PENDING, PENDING_WITH_PC.PC_PENDING, PENDING_WITH_EPA.EPA_PENDING,BILLED_OFFICE.BILLED_OFFICE,OTHERS.BILLED_OFFICE
  
  END 
  
  
  ELSE IF (@FDate != @TDate)
  
  BEGIN		
	
  SELECT HOSPITAL_LOG.RECEIVED_DATE, ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IN_HOSPITAL_LOG, ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IP_RECEIVED,

ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS TOTAL_INVENTORY_RECORD, ISNULL(CODED_ENTERED.ENTERED,0) AS ACCOUNTS_CODED_ER,

ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS ACCOUNTS_CODED_IP,

ISNULL(CODED_ENTERED.ENTERED,0) + ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS TOTAL_CODED,

(ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0))  - ISNULL(CODED_ENTERED.ENTERED,0) AS PENDING_ACCOUNT_FROM_EPA,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) AS ACCOUNTS_BILLED_IN_AMD, ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS ACCOUNTS_BILLED_IP_AMD,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) + ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS TOTAL_BILLED_IN_AMD,

ISNULL(BILLED_OFFICE.BILLED_OFFICE,0) AS BILLED_OFFICE,

ISNULL(OTHERS.BILLED_OFFICE,0) AS OTHERS,

ISNULL(PREVIOUS.PRE,0) AS ACCOUNTS_FROM_PRE, ISNULL(PREVIOUS.PRE1,0) AS ACCOUNTS_FROM_NEXT, 

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) AS PENDING_WITH_CODING,

ISNULL(PENDING_WITH_PC.PC_PENDING,0) AS PENDING_WITH_PC,

ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS PENDING_WITH_EPA,

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) + ISNULL(PENDING_WITH_PC.PC_PENDING,0) + ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS BILLING_PENDING



 FROM (
 
SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT
 FROM tbl_IMPORT_TABLE I
WHERE I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 0
GROUP BY RECEIVED_DATE) AS HOSPITAL_LOG 

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 1
GROUP BY RECEIVED_DATE) AS IP_HOSPITAL_LOG

ON HOSPITAL_LOG.RECEIVED_DATE = IP_HOSPITAL_LOG.RECEIVED_DATE

LEFT JOIN 

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 0
 GROUP BY RECEIVED_DATE) AS CODED_ENTERED
 
 
 ON HOSPITAL_LOG.RECEIVED_DATE = CODED_ENTERED.RECEIVED_DATE
 
 LEFT JOIN 
 
 (SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS IP_ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 1
 GROUP BY RECEIVED_DATE) AS IP_CODED_ENTERED
 
 ON HOSPITAL_LOG.RECEIVED_DATE = IP_CODED_ENTERED.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate 
AND PATIENT_TYPE = '23'
GROUP BY DOS) AS BILLED_AMD

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '21'
GROUP BY DOS) AS BILLED_AMD_IP

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD_IP.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '11'
GROUP BY DOS) AS BILLED_OFFICE

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_OFFICE.DOS


LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = 'N/A'
GROUP BY DOS) AS OTHERS

ON HOSPITAL_LOG.RECEIVED_DATE = OTHERS.DOS

LEFT JOIN


(SELECT PRE1.RECEIVED_DATE,PRE,PRE1 FROM 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum,RECEIVED_DATE AS RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @PreDate AND @TDate
GROUP BY RECEIVED_DATE) AS PRE


LEFT JOIN 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum1,RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE1 
FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @FDate AND @NextDate
GROUP BY RECEIVED_DATE) AS PRE1


ON PRE.RowNum = PRE1.RowNum1) AS PREVIOUS

ON HOSPITAL_LOG.RECEIVED_DATE = PREVIOUS.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(A.BATCH_ID) AS CODING_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Coding' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_CODING


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_CODING.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS PC_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Patient Calling' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_PC


on HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_PC.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS EPA_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='EPA' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_EPA


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_EPA.RECEIVED_DATE

GROUP BY HOSPITAL_LOG.RECEIVED_DATE, HOSPITAL_LOG.NO_OF_PATIENT,IP_HOSPITAL_LOG.NO_OF_PATIENT, CODED_ENTERED.ENTERED, IP_CODED_ENTERED.IP_ENTERED, BILLED_AMD.AMD_ENTERED,
BILLED_AMD_IP.AMD_ENTERED, PREVIOUS.PRE, PREVIOUS.PRE1, PENDING_WITH_CODING.CODING_PENDING, PENDING_WITH_PC.PC_PENDING, PENDING_WITH_EPA.EPA_PENDING,BILLED_OFFICE.BILLED_OFFICE, OTHERS.BILLED_OFFICE

    END
    


END


GO
/****** Object:  StoredProcedure [dbo].[sp_Billed_Accounts_AMD]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Billed_Accounts_AMD]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS

BEGIN
	
	SELECT DOS AS RECEIVED_DATE,PATIENT_ID AS ACCOUNT_NO,PATIENT_NAME AS PATIENT_NAME,PATIENT_TYPE AS POS,CPT AS PROC1,VISIT_NUMBER AS VISIT,
	CHART_NO AS PATIENT_CHART_NUMBER,PROVIDER_CODE AS PROVIDER,CHARGE_VALUE AS CHARGEVALUE FROM TBL_AMD_DATA
    WHERE DOS BETWEEN @FromDate AND @ToDate
    AND PATIENT_TYPE = 23

END


GO
/****** Object:  StoredProcedure [dbo].[sp_Billed_IP_Accounts_AMD]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Billed_IP_Accounts_AMD]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS

BEGIN
	
		
	SELECT DOS AS RECEIVED_DATE,PATIENT_ID AS ACCOUNT_NO,PATIENT_NAME AS PATIENT_NAME,PATIENT_TYPE AS POS,CPT AS PROC1,VISIT_NUMBER AS VISIT,
	CHART_NO AS PATIENT_CHART_NUMBER,PROVIDER_CODE AS PROVIDER,CHARGE_VALUE AS CHARGEVALUE FROM TBL_AMD_DATA
    WHERE DOS BETWEEN @FromDate AND @ToDate
    AND PATIENT_TYPE = 21

END


GO
/****** Object:  StoredProcedure [dbo].[sp_Binding_Project_Id]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Binding_Project_Id] 
	@UserNtlg varchar (100)
AS
BEGIN
	
	SELECT DISTINCT CLIENT_NAME,U.PROJECT_ID FROM tbl_CLIENT_MASTER C, tbl_PROJECT_MASTER P, tbl_USER_ACCESS U
	WHERE C.CLIENT_ID = P.CLIENT_ID
	AND P.PROJECT_ID = U.PROJECT_ID
	AND U.USER_NTLG = @UserNtlg

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Coding_Recon_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Coding_Recon_Report] 
	@FromDate varchar (100),
	@ToDate varchar (100),
	@PreviousDate varchar (100),
	@NextDate varchar (100)
AS
BEGIN
	
	SELECT HOSPITAL_LOG.RECEIVED_DATE, HOSPITAL_LOG.FACILITY, ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IN_HOSPITAL_LOG,

	ISNULL(CODED_ENTERED.ENTERED,0) AS ACCOUNTS_CODED_ER,

	ISNULL(PREVIOUS.PRE,0) AS ACCOUNTS_FROM_PRE, ISNULL(PREVIOUS.PRE1,0) AS ACCOUNTS_FROM_NEXT,

	ISNULL(PENDING.PENDING,0) AS CODING_PENDING
	
	 FROM (
 
		SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
		COUNT(I.BATCH_ID) AS  NO_OF_PATIENT,FACILITY
		 FROM tbl_IMPORT_TABLE I
		WHERE I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
		AND I.IS_INPATIENT = 0
		GROUP BY RECEIVED_DATE,FACILITY) AS HOSPITAL_LOG 

		LEFT JOIN

		(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
		COUNT(I.BATCH_ID) AS  NO_OF_PATIENT, FACILITY
		 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
		WHERE I.BATCH_ID = T.BATCH_ID
		AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
		AND I.IS_INPATIENT = 1
		GROUP BY RECEIVED_DATE,FACILITY) AS IP_HOSPITAL_LOG

		ON HOSPITAL_LOG.RECEIVED_DATE = IP_HOSPITAL_LOG.RECEIVED_DATE AND HOSPITAL_LOG.FACILITY = IP_HOSPITAL_LOG.FACILITY

		LEFT JOIN 

		(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS ENTERED, FACILITY
		 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
		 WHERE I.BATCH_ID = T.BATCH_ID
		 AND T.CODING_STATUS IN ('Completed','No Charge')
		 AND i.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
		 AND I.IS_INPATIENT = 0
		 GROUP BY RECEIVED_DATE,FACILITY) AS CODED_ENTERED
		 
		 
		 ON HOSPITAL_LOG.RECEIVED_DATE = CODED_ENTERED.RECEIVED_DATE AND HOSPITAL_LOG.FACILITY = CODED_ENTERED.FACILITY
		 
		 LEFT JOIN 
		 
		 (SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS IP_ENTERED,FACILITY
		 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
		 WHERE I.BATCH_ID = T.BATCH_ID
		 AND T.CODING_STATUS IN ('Completed','No Charge')
		 AND i.RECEIVED_DATE BETWEEN @FromDate AND @ToDate 
		 AND I.IS_INPATIENT = 1
		 GROUP BY RECEIVED_DATE,FACILITY) AS IP_CODED_ENTERED
		 
		 ON HOSPITAL_LOG.RECEIVED_DATE = IP_CODED_ENTERED.RECEIVED_DATE AND HOSPITAL_LOG.FACILITY = IP_CODED_ENTERED.FACILITY

		LEFT JOIN

		(SELECT PRE1.RECEIVED_DATE,PRE,PRE1,PRE1.FACILITY FROM 

		(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum,RECEIVED_DATE AS RECEIVED_DATE,
		COUNT(I.BATCH_ID) AS PRE,FACILITY
		 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.DOS_CHANGED != ''
		AND RECEIVED_DATE BETWEEN @PreviousDate AND @ToDate
		GROUP BY RECEIVED_DATE,FACILITY) AS PRE


		LEFT JOIN 

		(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum1,RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE1,
		FACILITY
		FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.DOS_CHANGED != ''
		AND RECEIVED_DATE BETWEEN @FromDate AND @NextDate
		GROUP BY RECEIVED_DATE,FACILITY) AS PRE1


		ON PRE.RowNum = PRE1.RowNum1) AS PREVIOUS

		ON HOSPITAL_LOG.RECEIVED_DATE = PREVIOUS.RECEIVED_DATE AND HOSPITAL_LOG.FACILITY = PREVIOUS.FACILITY

		LEFT JOIN 

		(SELECT CONVERT(DATE,RECEIVED_DATE,103) AS RECEIVED_DATE,COUNT(I.BATCH_ID) AS PENDING,FACILITY
		FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
		WHERE I.BATCH_ID = T.BATCH_ID
		AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
		AND T.CODING_STATUS = 'Pending'
		AND I.BATCH_STATUS ='ASSIGNED'
		GROUP BY RECEIVED_DATE,FACILITY) AS PENDING

		ON HOSPITAL_LOG.RECEIVED_DATE = PENDING.RECEIVED_DATE
		AND HOSPITAL_LOG.FACILITY = PENDING.FACILITY

		GROUP BY HOSPITAL_LOG.RECEIVED_DATE, HOSPITAL_LOG.NO_OF_PATIENT,IP_HOSPITAL_LOG.NO_OF_PATIENT, CODED_ENTERED.ENTERED, IP_CODED_ENTERED.IP_ENTERED,PREVIOUS.PRE, 
		PREVIOUS.PRE1 , PENDING.PENDING,HOSPITAL_LOG.FACILITY

		ORDER BY HOSPITAL_LOG.RECEIVED_DATE, HOSPITAL_LOG.FACILITY

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Comparision_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_Comparision_Report]
	@UserName varchar (100),
	@Facility varchar (100),
	@FromDate varchar (100),
	@ToDate Varchar (100),
	@AccountType Varchar (50),
	@ReleaseDate varchar (50)
AS
BEGIN

 DECLARE @dataset  OutputExcel
 Declare @data2 dbo.Coder_Limited_Records	
	
	INSERT INTO @dataset 	
			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
			T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
			CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
			CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID			
			AND I.QC_STATUS = 'SEND TO KEYER'			
			AND T.CODED_DATE BETWEEN @FromDate AND @ToDate		
			and IS_SKIPPED = 1 and IS_AUDITED = 0
			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
			ORDER BY D.TRANS_DETAIL_ID desc
	
		
		SELECT FACILITY AS FAC,RECEIVED_DATE AS Arvl_Dt,ACCOUNT_NO AS Pat_ID,PATIENT_NAME AS 'Patient Name', AGE AS Age,DISPOSITION AS Disp,EDMD AS EDMD, ATTENDING_PHY AS 'Admitting Phy', ADMITTING_PHY AS 'Attending Phy', INSURANCE AS Insurance,PROVIDER_MD AS 'Provider/MD Name',
		ASSISTANT_PROVIDER AS 'Assistant Provider /PA/NP Name',PATIENT_STATUS AS 'Patient status', DOI AS DOI,TOI AS TOI, TYPE_OF_ACCIDENT AS 'Type Of Accident', SHARD_VISIT AS 'Shared Visit', DISPOSITION AS 'Disposition',CPT AS CPT, ICD1 AS 'ICD-1', ICD2 AS 'ICD-2', ICD3 AS 'ICD-3', ICD4 AS 'ICD-4', ICD5 AS 'ICD-5', ICD6 AS 'ICD-6', ICD7 AS 'ICD-7', ICD8 AS 'ICD-8',
		MODIFIER AS Modifier, UNITS AS Units, COMMENTS AS 'Comments', DOWNLOADING_COMMENTS AS 'Down coding Comments', DEFICIENCY_INDICATOR AS 'Deficiency Indicator', DOS_CHANGED AS 'DOS Change', CODING_STATUS AS 'Account Status', HOSPITAL_EMPLOYEE AS 'Hospital Employee', [W/O_ATTESTATION] AS  'W/O Attestation', CODED_BY AS 'Coded By'
		
		FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order			
	
	END

GO
/****** Object:  StoredProcedure [dbo].[sp_CreateNewColumn]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateNewColumn]
	@ColumnName varchar(100),
	@TableName varchar(100),
	@datatype VARCHAR(100)
AS
    DECLARE @tsql varchar (200)

	set @tsql = 'ALTER TABLE [' + @tablename + '] ADD [' + @columnname + '] ' + @datatype 
	
	EXEC (@tsql)
	


GO
/****** Object:  StoredProcedure [dbo].[sp_Down_Coidng_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_Down_Coidng_Report]
                @UserName varchar (100)=null,
                @Facility varchar (100)=null,
                @FromDate varchar (100)=null,
                @ToDate Varchar (100)=null
                
AS
BEGIN

 DECLARE @dataset  OutputExcel
 Declare @data2 dbo.Coder_Limited_Records

                IF (@Facility != '' AND @FromDate != '' AND @ToDate != '' )
    
    BEGIN
                
                INSERT INTO @dataset 
                                                SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
                                                T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
                                                CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
                                                CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
                                                ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
                                                CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
                                                FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
                                                WHERE I.BATCH_ID = T.BATCH_ID
                                                AND T.TRANS_ID = D.TRANS_ID                                                                                                
                                                AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
                                                AND I.FACILITY = @Facility
                                                AND DOWNLOADING_COMMENTS != ''                                                                                
                                                GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
                                                T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
                                                ORDER BY D.TRANS_DETAIL_ID desc
                
                                
                                SELECT * FROM @dataset
                                PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
                                ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order                                               
                
                END       
              
      
                ELSE IF (@Facility = '' AND @FromDate != '' AND @ToDate != '')
                
                BEGIN
                
                INSERT INTO @dataset 
                                                SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
                                                T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
                                                CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
                                                CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
                                                ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
                                                CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
                                                FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
                                                WHERE I.BATCH_ID = T.BATCH_ID
                                                AND T.TRANS_ID = D.TRANS_ID                                                
                                                --AND I.QC_STATUS = 'SEND TO KEYER'
                                                --AND T.CODING_STATUS IN ('Completed','No Charge')
                                                AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate     
                                                         
                                                GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
                                                T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
                                                ORDER BY D.TRANS_DETAIL_ID desc
                
                                
                                SELECT * FROM @dataset
                                PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
                                ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order               
                                
                
                END       
                
                ELSE IF (@Facility = '' AND @FromDate = '' AND @ToDate = '')
                
                BEGIN
                
                INSERT INTO @dataset 
                                                SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
                                                T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
                                                CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
                                                CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
                                                ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
                                                CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
                                                FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
                                                WHERE I.BATCH_ID = T.BATCH_ID
                                                AND T.TRANS_ID = D.TRANS_ID                                                
                                                --AND I.QC_STATUS = 'SEND TO KEYER'     
                                                --AND T.CODING_STATUS IN ('Completed','No Charge')                   
                                                           
                                                GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
                                                T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
                                                ORDER BY D.TRANS_DETAIL_ID desc
                
                                
                                SELECT * FROM @dataset
                                PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
                                ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order               
                                
                
                END       
                
                
                
                
                --New Added
                
                    ELSE IF (@Facility != '' AND @FromDate = '' AND @ToDate = '')
                
                BEGIN
                
                INSERT INTO @dataset 
                                                SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
                                                T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
                                                CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
                                                CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
                                                ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
                                                CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
                                                FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
                                                 WHERE I.BATCH_ID = T.BATCH_ID
                                                AND T.TRANS_ID = D.TRANS_ID                                                                                                
                                                --AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
                                                AND I.FACILITY = @Facility
                                                AND DOWNLOADING_COMMENTS != ''               
                                                GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
                                                T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
                                                ORDER BY D.TRANS_DETAIL_ID desc
                
                                
                                SELECT * FROM @dataset
                                PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
                                ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order         
                                
                
                END   
 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Dynamic_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Dynamic_Report] 
	@TaskId int,
	@ProjectId int,
	@ReportName varchar (100),
	@ReportId int,
	@ReportIndex int,
	@TypeName varchar (500)
AS
BEGIN
   IF @TypeName = 0 
  
  BEGIN 
  
	INSERT INTO tbl_DYNAMIC_REPORT_LOG (PROJECT_ID,REPORT_NAME) VALUES (@ProjectId,@ReportName)
	
	END
	
	IF @TypeName = 1
	
	BEGIN	
	
	SELECT REPORT_ID,REPORT_NAME FROM tbl_DYNAMIC_REPORT_LOG WHERE PROJECT_ID = @ProjectId
	
	END
	
	IF @TypeName = 2 
	
	 BEGIN
	 
	  SELECT FIELD_NAME FROM tbl_DYNAMIC_REPORT_TABLE WHERE REPORT_ID = @ReportId AND PROJECT_ID = @ProjectId AND IS_DELETED = 'N'
	  
	 END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Facility]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Facility] 
	@TaskId int,
	@ProjectId int
AS
BEGIN
	SELECT CODE FROM tbl_FACILITY
	
	SELECT DISPOSITION FROM tbl_DISPOSITION_MASTER
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_Coder]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_Coder]	
	@UserNTLG varchar (100),
	@Type varchar (100)
AS
BEGIN
	
	DECLARE @dataset TransactionDetails 
    Declare @data2 dbo.Coder_Limited_Records
    
	IF (@Type = 'Regular' )
	
	BEGIN
	
	INSERT INTO @dataset 		     
	
			SELECT  DENSE_RANK() OVER(ORDER BY T.TRANS_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
			T.SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS  
			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID
			AND I.BATCH_STATUS ='CODED'
			AND T.QC_STATUS IS NULL
			AND IS_AUDITED = 0
		    AND T.CODED_BY =@UserNTLG	
		    AND T.KEYING_COMMENTS IS NULL
		    AND T.IS_REOPENED = 0	
			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS
			ORDER BY D.TRANS_DETAIL_ID desc
	
		
		SELECT *  FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order 			
		
		END
		
		ELSE IF (@Type = 'Pending')
		
		BEGIN		
	
	
	INSERT INTO @dataset 		     
	
			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS  FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID
			AND I.BATCH_STATUS ='CODED'
			AND T.QC_STATUS IS NULL
			AND IS_AUDITED = 0
			--AND IS_PENDING = 1 
		    AND T.CODED_BY =@UserNTLG		
			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS
			ORDER BY D.TRANS_DETAIL_ID desc
	
		
		SELECT *  FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order		
		
		END 
	
END







GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_Coder_Error]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_Coder_Error]
	@UserNTLG varchar (100)
AS
BEGIN
	
	DECLARE @dataset ErrorCorrectedByQC 
	
	
	INSERT INTO @dataset 	
		SELECT t.TRANS_ID, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,CPT_ORDER FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND ((T.QC_STATUS ='ERROR' AND SEND_TO_CODER = 'N'))		
		AND  (T.IS_ACKNOWLEDGE ='C' or	T.IS_ACKNOWLEDGE IS NULL )		
	    AND t.CODED_BY = @UserNTLG
		GROUP BY t.TRANS_ID,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CODED_DATE,CPT_ORDER
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_Coder_Error_Clarification]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_Coder_Error_Clarification]	
	@UserNTLG varchar (100),
		@Type varchar (100),
		@ddlValue varchar(50)
AS
BEGIN
		
	DECLARE @dataset ErrorCorrectedByQC 

IF(@ddlValue='1')
BEGIN
		  
		  
	IF (@Type = 'Regular' )
	
	BEGIN
	
	INSERT INTO @dataset 	
		SELECT t.TRANS_ID, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,CPT_ORDER FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND ((T.QC_STATUS ='ERROR' AND SEND_TO_CODER = 'N'))		
		AND  (T.IS_ACKNOWLEDGE ='C' or	T.IS_ACKNOWLEDGE IS NULL )
		AND (T.IS_PENDING=0)
	    AND t.CODED_BY = @UserNTLG
		GROUP BY t.TRANS_ID,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CODED_DATE,CPT_ORDER
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END
     ELSE IF (@Type = 'Pending')		
		BEGIN	
		
	INSERT INTO @dataset 	
		SELECT t.TRANS_ID, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,CPT_ORDER FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND ((T.QC_STATUS ='ERROR' AND SEND_TO_CODER = 'N'))		
		AND  (T.IS_ACKNOWLEDGE ='C' or	T.IS_ACKNOWLEDGE IS NULL )
		AND (T.IS_PENDING=1)
	    AND t.CODED_BY = @UserNTLG
		GROUP BY t.TRANS_ID,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CODED_DATE,CPT_ORDER
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
		
		END
	END
	
	--New Code for Keyer send Status
	
	
	ELSE IF(@ddlValue='Yes')
	BEGIN
	
		IF (@Type = 'Regular' )
	
	BEGIN
	
	INSERT INTO @dataset 	
		SELECT t.TRANS_ID, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,CPT_ORDER FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND ((T.QC_STATUS ='COMPLETED' AND SEND_TO_CODER = 'Y'))		
		AND  (T.IS_ACKNOWLEDGE ='C' or	T.IS_ACKNOWLEDGE IS NULL )
		AND (T.IS_PENDING=0)
	    AND t.CODED_BY = @UserNTLG	  
	   AND (T.QC_DATE BETWEEN CONVERT(DATETIME, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0), 102) AND CONVERT(DATETIME, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0), 102))
		GROUP BY t.TRANS_ID,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CODED_DATE,CPT_ORDER
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END
     ELSE IF (@Type = 'Pending')		
		BEGIN	
		
	INSERT INTO @dataset 	
		SELECT t.TRANS_ID, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,CPT_ORDER FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND ((T.QC_STATUS ='COMPLETED' AND SEND_TO_CODER = 'Y'))		
		AND  (T.IS_ACKNOWLEDGE ='C' or	T.IS_ACKNOWLEDGE IS NULL )
		AND (T.IS_PENDING=1)
	    AND t.CODED_BY = @UserNTLG
	    AND (T.QC_DATE BETWEEN CONVERT(DATETIME, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0), 102) AND CONVERT(DATETIME, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0), 102))
		GROUP BY t.TRANS_ID,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CODED_DATE,CPT_ORDER
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
		
		END
	
	END
	
	ELSE IF(@ddlValue='No')
	BEGIN
	
		IF (@Type = 'Regular' )
	
	BEGIN
	
	INSERT INTO @dataset 	
		SELECT t.TRANS_ID, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,CPT_ORDER FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND ((T.QC_STATUS ='ERROR' AND SEND_TO_CODER = 'N'))		
		AND  (T.IS_ACKNOWLEDGE ='C' or	T.IS_ACKNOWLEDGE IS NULL )
		AND (T.IS_PENDING=0)
	    AND t.CODED_BY = @UserNTLG
		GROUP BY t.TRANS_ID,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CODED_DATE,CPT_ORDER
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END
     ELSE IF (@Type = 'Pending')		
		BEGIN	
		
	INSERT INTO @dataset 	
		SELECT t.TRANS_ID, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,CPT_ORDER FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND ((T.QC_STATUS ='ERROR' AND SEND_TO_CODER = 'N'))		
		AND  (T.IS_ACKNOWLEDGE ='C' or	T.IS_ACKNOWLEDGE IS NULL )
		AND (T.IS_PENDING=1)
	    AND t.CODED_BY = @UserNTLG
		GROUP BY t.TRANS_ID,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,d.PROVIDER_MD,d.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],t.QC_COMMENTS,t.ACKNOWLEDGE_COMMENTS,SEND_TO_CODER,CODED_DATE,CPT_ORDER
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
		
		END
	
	END
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_Coder_status]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_Coder_status]	
	@UserNTLG varchar (100),
	@BatchId varchar (100)
AS
BEGIN
	
	DECLARE @dataset TransactionDetails 
	
	INSERT INTO @dataset 	
			SELECT  (RANK() OVER(ORDER BY account_no,cpt)) AS ROWNO,T.TRANS_ID,d.cpt_order,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,t.CODING_COMMENTS FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID
			AND I.BATCH_STATUS ='IT Clarification'
			AND T.QC_STATUS IS NULL
			AND IS_AUDITED = 0
			AND T.CODED_BY = @UserNTLG
			AND I.BATCH_ID = @BatchId			
			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,t.CODING_COMMENTS
			ORDER BY D.TRANS_DETAIL_ID desc
		
		
		SELECT * FROM @dataset 
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		 ORDER BY ACCOUNT_NO, cpt_order 
		 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_QC]	
	@UserNTLG varchar (100),
	@CoderName varchar (100)
AS
BEGIN
	
	DECLARE @dataset TransQCDetails 
	
	INSERT INTO @dataset 	
			SELECT T.TRANS_ID, DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO, REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,
			T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,
			I.ACCOUNT_NO,
			I.PATIENT_NAME,I.AGE,t.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO, CPT,cpt_order
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,[W/O_ATTESTATION],D.COMMENTS,T.CODING_STATUS   FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID
			AND I.BATCH_STATUS ='CODED'
			AND T.QC_STATUS = 'ASSIGNED TO QC'
		    AND T.QC_BY =@UserNTLG
		    AND T.CODED_BY = @CoderName 
			AND D.QC_STATUS  IS NULL 
			AND IS_AUDITED = 0
			AND SEND_TO_CODER IS NULL	
			AND CPT_ORDER IS NOT NULL			
			GROUP BY cpt_order,T.TRANS_ID,D.TRANS_DETAIL_ID, D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.CODED_DATE,[W/O_ATTESTATION],D.COMMENTS,T.CODING_STATUS
			ORDER BY D.TRANS_DETAIL_ID
		   
		
		SELECT *  FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable 
        ORDER BY ROWNO,ACCOUNT_NO, cpt_order 
       
        
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_QC_Error]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_QC_Error]	

	@UserNTLG varchar (100)
AS
BEGIN
	
	DECLARE @dataset TransDataWithCPTAndICDForError 
	
	INSERT INTO @dataset 	
		SELECT T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],T.ACKNOWLEDGE_COMMENTS FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.QC_STATUS = 'ERROR'
		AND T.IS_ACKNOWLEDGE = 'N' 		
	    AND t.QC_BY = @UserNTLG
		GROUP BY T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],T.ACKNOWLEDGE_COMMENTS
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_QC_Error_Clarification]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_QC_Error_Clarification]	
	@UserNTLG varchar (100),		
		@Type varchar (100)
AS
BEGIN
	
	DECLARE @dataset TransDataWithCPTAndICDForError 
	
			  
	IF (@Type = 'Regular' )
	
	BEGIN
	
	INSERT INTO @dataset 	
		SELECT T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],T.ACKNOWLEDGE_COMMENTS FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.QC_STATUS = 'ERROR'
		AND T.IS_ACKNOWLEDGE = 'N' 
		AND T.IS_PENDING=0
	    AND t.QC_BY = @UserNTLG
		GROUP BY T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],T.ACKNOWLEDGE_COMMENTS
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END
		
		
		
		   ELSE IF (@Type = 'Pending')		
		BEGIN	
			
	INSERT INTO @dataset 	
		SELECT T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],T.ACKNOWLEDGE_COMMENTS FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.QC_STATUS = 'ERROR'
		AND T.IS_ACKNOWLEDGE = 'N' 
		AND T.IS_PENDING=1
	    AND t.QC_BY = @UserNTLG
		GROUP BY T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],T.ACKNOWLEDGE_COMMENTS
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Data_For_QC_Log_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Data_For_QC_Log_Report]	
	@Userntlg varchar (100),
	@Qcstatus VARCHAR (100),
	@FromDate DATETIME,
	@ToDate DATETIME
AS
BEGIN
	
	DECLARE @dataset ErrorDataForQCLogReport 
	DECLARE @USERACCESS VARCHAR (100)
	
	
	SET @USERACCESS = (SELECT ACCESS_TYPE FROM tbl_USER_ACCESS WHERE USER_NTLG =@Userntlg)
	
	IF (@Qcstatus = 'ERROR')
	
	BEGIN
	
	IF(@USERACCESS = 'CODER-QC')
	
	BEGIN
	
	IF (@FromDate != '' AND @ToDate != '')
		
    BEGIN 
		  
	INSERT INTO @dataset
		
		
		SELECT  CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)
		--AND T.QC_BY =@Userntlg		
		AND T.QC_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END
        
        ELSE
        
         BEGIN
          INSERT INTO @dataset 	
         SELECT CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)
		--AND T.QC_BY =@Userntlg	
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
         END 
        
      END 
        
        ELSE IF(@USERACCESS = 'CODER')
        
        BEGIN
        
        IF (@FromDate != '' AND @ToDate != '')
        BEGIN
        
        INSERT INTO @dataset 		
		
		
		SELECT  CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)
		--AND T.CODED_BY =@Userntlg		
		AND T.CODED_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        ELSE 
        
        BEGIN
         INSERT INTO @dataset 	
        
		SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)
		--AND T.CODED_BY =@Userntlg
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        END 
        
        
        
        
        ELSE IF (@USERACCESS ='CODER-TL')
        
        BEGIN
        
        IF(@FromDate != '' AND  @ToDate != '' )
        
        BEGIN         
         INSERT INTO @dataset 	
		SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)			
		AND T.CODED_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        ELSE 
        
        BEGIN
         INSERT INTO @dataset 	
         
		SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)	
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        END 
        
        ELSE IF (@USERACCESS ='CODER-QC-TL')
        
        BEGIN
        
        IF(@FromDate != '' AND @ToDate != '' )
        
        BEGIN 
            INSERT INTO @dataset 	
		SELECT  CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
--		AND T.QC_STATUS IN(@Qcstatus)			
		AND T.QC_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        ELSE 
        
        BEGIN
         INSERT INTO @dataset 	
        SELECT  CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)	
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        
        END 
        
        END 
        
    END
		
		
   ELSE
   
   BEGIN
   
   IF(@USERACCESS = 'CODER-QC')
	
	BEGIN
	
	IF (@FromDate != '' AND @ToDate != '')
		
    BEGIN 
		  
	INSERT INTO @dataset
		
		
		SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)
		--AND T.QC_BY =@Userntlg		
		AND T.QC_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END
        
        ELSE
        
         BEGIN
          INSERT INTO @dataset 	
         SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND (T.SEND_TO_CODER = 'Y' or t.SEND_TO_CODER ='N')
		--AND T.QC_STATUS IN(@Qcstatus)
		--AND T.QC_BY =@Userntlg	
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
         END 
        
      END 
        
        ELSE IF(@USERACCESS = 'CODER')
        
        BEGIN
        
        IF (@FromDate != '' AND @ToDate != '')
        BEGIN
        
        INSERT INTO @dataset 		
		
		
		SELECT  CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.ACCOUNT_STATUS = 'Completed' 	
		AND T.IS_ACKNOWLEDGE = 'Y' 
		--AND T.CODED_BY =@Userntlg		
		AND T.CODED_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        ELSE 
        
        BEGIN
         INSERT INTO @dataset 	
        
		SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.ACCOUNT_STATUS = 'Completed'
		AND T.IS_ACKNOWLEDGE = 'Y'  	
		AND T.CODED_BY =@Userntlg
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        END 
        
        
        
        
        ELSE IF (@USERACCESS ='CODER-TL')
        
        BEGIN
        
        IF(@FromDate != '' AND  @ToDate != '' )
        
        BEGIN         
         INSERT INTO @dataset 	
		SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'		 
		AND T.ACCOUNT_STATUS = 'Completed'
		AND T.IS_ACKNOWLEDGE = 'Y'  			
		AND T.CODED_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        ELSE 
        
        BEGIN
         INSERT INTO @dataset 	
         
		SELECT  CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.ACCOUNT_STATUS = 'Completed'
		AND T.IS_ACKNOWLEDGE = 'Y'  
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        END 
        
        ELSE IF (@USERACCESS ='CODER-QC-TL')
        
        BEGIN
        
        IF(@FromDate != '' AND @ToDate != '' )
        
        BEGIN 
            INSERT INTO @dataset 	
		SELECT   CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO, CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.ACCOUNT_STATUS = 'Completed'
		AND T.IS_ACKNOWLEDGE = 'Y'  	
		AND T.QC_DATE BETWEEN @FromDate AND @ToDate	    
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        END 
        
        ELSE 
        
        BEGIN
         INSERT INTO @dataset 	
        SELECT  CONVERT(date, T.QC_DATE ,103) AS QC_DATE, D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT
		ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,T.QC_COMMENTS,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND T.SEND_TO_CODER = 'Y'
		AND T.ACCOUNT_STATUS = 'Completed'
		AND T.IS_ACKNOWLEDGE = 'Y'  	
		GROUP BY  D.TRANS_DETAIL_ID,T.QC_DATE, T.QC_COMMENTS,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,T.ERROR_CATEGORY,T.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR
		ORDER BY D.TRANS_DETAIL_ID ASC
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
        
        END 
        
        END 
   
   END 
   
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Dynamic_fields_Binding]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Dynamic_fields_Binding]
	@TaskId int,
	@ProjectId int
	
AS
BEGIN
	
SELECT * FROM (SELECT FIELD_NAME FROM tbl_ADDITIONAL_FIELDS WHERE TASK_ID =@TaskId AND PROJECT_ID = @ProjectId
UNION 
SELECT FIELD_NAME FROM tbl_MANDATORY_FIELD WHERE TASK_ID =@TaskId) AS A
ORDER BY FIELD_NAME

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Field]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Field] 
	
AS
BEGIN

	    SELECT D.DOWNLOADING_COMMENTS,I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_STATUS ='CODED'
		AND I.QC_STATUS = 'ASSIGNED TO QC'	   
		GROUP BY D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY
		
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Log_type]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Log_type]

AS
BEGIN
	SELECT TASK_NAME,TASK_ID FROM tbl_TASK_TABLE WHERE TASK_TYPE = 'Coding'


    SELECT TASK_NAME,TASK_ID FROM tbl_TASK_TABLE WHERE TASK_TYPE = 'Coding_QC'
END

GO
/****** Object:  StoredProcedure [dbo].[sp_get_master_list]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_get_master_list] 

AS
BEGIN
	
	SELECT SP_ID,SPECIALITY FROM tbl_SPECIALITY WHERE IS_DELETED ='N'
	
	SELECT LOCATION_ID,LOCATION FROM tbl_LOCATION WHERE IS_DELETED = 'N'
	
	SELECT SOFTWARE_ID,SOFTWARE FROM tbl_SOFTWARE_MASTER WHERE IS_DELETED = 'N'
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Menu_Details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Get_Menu_Details]
	@USERNTLG VARCHAR (100)
AS
BEGIN	

	SELECT MENU_NAME,SUB_MENU_NAME,URL FROM tbl_MAIN_MENU M, tbl_SUB_MENU S
	WHERE M.MENU_ID = S.MENU_ID
	AND ACCESS_TYPE IN (SELECT ACCESS_ID FROM tbl_ACCESS_TYPE WHERE ACCESS_TYPE IN (SELECT ACCESS_TYPE FROM tbl_USER_ACCESS WHERE USER_NTLG = @USERNTLG))
	ORDER BY ORDER_ID
	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Record_By_Status]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Record_By_Status] 
	@Status varchar (100),
	@ProjectId int ,	
	@TaskId int
AS
BEGIN
	
	declare @sql_Str varchar(8000)
	declare @sql varchar(8000)
	
    SELECT FIELD_NAME FROM tbl_COMMON_FIELD WHERE TASK_ID = @TaskId AND PROJECT_ID = @ProjectId    
	
	 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Record_For_Error_Log_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Record_For_Error_Log_Report] 
	@FromDate varchar (100),
	@ToDate Varchar (100),
	@UserName varchar (100)
AS
BEGIN
	SELECT T.CODED_BY AS 'CODER NAME', U.TL_NAME AS 'TL NAME', I.RECEIVED_DATE AS DOS, T.QC_DATE AS 'DATE AUDITED', COUNT(T.BATCH_ID) AS 'NO OF CHART'
	FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D, tbl_USER_ACCESS U
	WHERE I.BATCH_ID = T.BATCH_ID
	AND T.TRANS_ID = D.TRANS_ID
	AND T.CODED_BY = U.USER_NTLG
	AND T.QC_BY = @UserName
	AND T.QC_DATE BETWEEN @FromDate AND @ToDate
	AND T.QC_DATE IS NOT NULL
	GROUP BY T.CODED_BY, U.TL_NAME, I.RECEIVED_DATE, T.QC_DATE



	SELECT T.CODED_BY AS 'CODER NAME', COUNT(T.BATCH_ID) AS 'AUDITED CHART', I.RECEIVED_DATE AS DOS
	FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D, tbl_USER_ACCESS U
	WHERE I.BATCH_ID = T.BATCH_ID
	AND T.TRANS_ID = D.TRANS_ID
	AND T.CODED_BY = U.USER_NTLG
	AND T.IS_AUDITED = 1
	AND T.QC_BY = @UserName
	AND T.QC_DATE BETWEEN @FromDate AND @ToDate
	AND T.QC_DATE IS NOT NULL
	GROUP BY T.CODED_BY, U.TL_NAME, I.RECEIVED_DATE, T.QC_DATE


	SELECT E.CODER_NAME AS 'CODER NAME',E.RECEIVED_DATE,[E/M],ICD,CPT,[EKG&CM],[X-RAY],MODIFIER,AFTER_HRS,PQRI,OTHERS,TOTAL_ERRORS,CODERS,
	QA_FINDINGS,MAIN_ERROR_CATEGORY,SUB_ERROR_CATEGORY
	FROM tbl_ERROR_CATEGORY_REPORT E
	WHERE E.QC_BY = @UserName
	AND E.RECEIVED_DATE BETWEEN @FromDate AND @ToDate

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Record_For_Filter]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Record_For_Filter]
	@Facility varchar (100),
	@FromDos varchar (100),
	@ToDos varchar (100),
	@CoderName varchar (100),
	@Status varchar (100),
	@ProjectId int,
	@TaskId int
AS
BEGIN

    DECLARE @COMMONFIELD VARCHAR (100)

    SET @COMMONFIELD = (SELECT FIELD_NAME FROM tbl_COMMON_FIELD WHERE PROJECT_ID =@ProjectId AND TASK_ID =@TaskId)
	
	SELECT @COMMONFIELD, ALLOTTED_TO FROM tbl_IMPORT_TABLE WHERE (NULLIF(@Facility,NULL)IS NULL OR FACILITY =@Facility)
	And (NULLIF(@CoderName,NULL)IS NULL OR ALLOTTED_TO =@CoderName)

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Trans_Detail_Data]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Trans_Detail_Data]
	@TransId int,
	@CodedDate Datetime
AS
BEGIN
		SELECT  I.ACCOUNT_NO, T.TRANS_ID,T.BATCH_ID,INSURANCE,i.ADMITTING_PHY,i.ATTENDING_PHY,i.EDMD,DOI,TOI,PROVIDER_MD,ASSISTANT_PROVIDER,T.DISPOSITION,PATIENT_STATUS,TYPE_OF_ACCIDENT,SHARD_VISIT,T.ACCOUNT_STATUS, DOS_CHANGED 
		FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE T.TRANS_ID = D.TRANS_ID
		AND I.BATCH_ID = T.BATCH_ID
		AND T.CODED_DATE = @CodedDate
		AND T.CODING_STATUS <> 'ALLOTTED'
	    AND T.QC_BY IS NULL 
	    AND T.QC_STATUS IS NULL		
		GROUP BY I.ACCOUNT_NO,T.TRANS_ID,T.BATCH_ID,INSURANCE,i.ADMITTING_PHY,i.ATTENDING_PHY,i.EDMD,DOI,TOI,PROVIDER_MD,ASSISTANT_PROVIDER,T.DISPOSITION,PATIENT_STATUS,TYPE_OF_ACCIDENT,SHARD_VISIT,T.ACCOUNT_STATUS, DOS_CHANGED 

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_User_Detail_By_Access_Type]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_User_Detail_By_Access_Type]
	@AccessType varchar (100)
AS
BEGIN
	
	SELECT USER_NAME,USER_NTLG FROM tbl_USER_ACCESS WHERE ACCESS_TYPE =@AccessType	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetMandatoryAndAdditionalFields]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetMandatoryAndAdditionalFields] 
	-- Add the parameters for the stored procedure here
	@TaskId int	,
	@ProjectId int,
	@Type INT
AS
BEGIN
  IF @Type = 0
  
  BEGIN
	SELECT DISTINCT FIELD_NAME AS MANDATORY_FIELD FROM tbl_MANDATORY_FIELD WHERE TASK_ID IN(@TaskId) AND IS_DELETED = 'N'
	
	
	SELECT DISTINCT FIELD_NAME AS ADDITIONAL_FIELD FROM tbl_ADDITIONAL_FIELDS WHERE TASK_ID IN (@TaskId) AND PROJECT_ID <> @ProjectId AND IS_DELETED ='N'	
	
	
	SELECT DISTINCT FIELD_NAME AS SELECTED_FIELD FROM tbl_ADDITIONAL_FIELDS WHERE TASK_ID IN (@TaskId) AND PROJECT_ID = @ProjectId AND IS_DELETED ='N'	
	END
	
	IF @Type = 1
	
	BEGIN
	
	SELECT DISTINCT FIELD_NAME AS MANDATORY_FIELD FROM tbl_MANDATORY_FIELD WHERE TASK_ID IN(@TaskId) AND IS_DELETED = 'N'
	
	
	SELECT DISTINCT FIELD_NAME AS ADDITIONAL_FIELD FROM (SELECT FIELD_NAME FROM tbl_ADDITIONAL_FIELDS WHERE TASK_ID IN (1,2) AND PROJECT_ID = @ProjectId

    UNION

    SELECT FIELD_NAME  FROM tbl_MANDATORY_FIELD WHERE TASK_ID IN (1,2)) AS A ORDER BY FIELD_NAME
	
	
	SELECT DISTINCT FIELD_NAME AS SELECTED_FIELD FROM tbl_ADDITIONAL_FIELDS WHERE TASK_ID IN (@TaskId) AND PROJECT_ID = @ProjectId AND IS_DELETED ='N'	
	
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Hospital_Log]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Hospital_Log] 
	@FromDate varchar (100),
	@ToDate varchar (100)
AS
BEGIN
	
	SELECT  I.FACILITY,CONVERT(DATE,I.RECEIVED_DATE,103) AS Arvl_Dt, I.ACCOUNT_NO,I.PATIENT_NAME,i.ADMITTING_PHY,i.ATTENDING_PHY 
	FROM tbl_IMPORT_TABLE I
	WHERE I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	AND I.IS_INPATIENT = 0
	ORDER BY ACCOUNT_NO,FACILITY

END

GO
/****** Object:  StoredProcedure [dbo].[sp_hospital_Log_In_Patient]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_hospital_Log_In_Patient]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS
BEGIN

	 SELECT I.FACILITY,CONVERT(DATE,I.RECEIVED_DATE,103) AS Arvl_Dt, I.ACCOUNT_NO,I.PATIENT_NAME,T.INSURANCE, i.ADMITTING_PHY,i.ATTENDING_PHY
     FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
	 WHERE I.BATCH_ID = T.BATCH_ID
	 AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	 AND I.IS_INPATIENT = 1

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Additional_Field]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Additional_Field]
		@ProjectId int,
		@TaskId int,
		@FieldName varchar (100),
		@FieldIndex int,
		@ReportIndex int,
		@TypeId int
AS
BEGIN

IF @TypeId = 1

BEGIN

DECLARE @count int


 set  @count= (SELECT COUNT(*) AS ROW_COUNT FROM tbl_ADDITIONAL_FIELDS  WHERE TASK_ID = 1 AND PROJECT_ID = 8 AND FIELD_NAME =@FieldName)
 
 IF(@count = 0)

  BEGIN
	INSERT INTO tbl_ADDITIONAL_FIELDS (PROJECT_ID,FIELD_NAME,DISPLAY_FIELD_NAME,TASK_ID,CONTROL_TYPE,DATA_TYPE,MASTER_LIST_TABLE,FIELD_INDEX,REPORT_INDEX,IS_DELETED)
		SELECT @ProjectId,FIELD_NAME,DISPLAY_FIELD_NAME,@TaskId,CONTROL_TYPE,DATA_TYPE,MASTER_LIST_TABLE,@FieldIndex,@ReportIndex,'N' FROM tbl_ADDITIONAL_FIELDS 
		WHERE FIELD_NAME =@FieldName 

  END
  END
  
  IF @TypeId = 0
  
  BEGIN
  
  INSERT INTO tbl_ADDITIONAL_FIELDS (PROJECT_ID,FIELD_NAME,DISPLAY_FIELD_NAME,TASK_ID,CONTROL_TYPE,DATA_TYPE,MASTER_LIST_TABLE,FIELD_INDEX,REPORT_INDEX)
  
  SELECT @ProjectId,FIELD_NAME,DISPLAY_FIELD_NAME,@TaskId,CONTROL_TYPE,DATA_TYPE,MASTER_LIST_TABLE,@FieldIndex,@ReportIndex FROM tbl_ADDITIONAL_FIELDS 
  WHERE FIELD_NAME = @FieldName  AND TASK_ID IN (1,2)
  UNION 
  SELECT @ProjectId,FIELD_NAME,DISPLAY_FIELDS,@TaskId,'','','',FIELD_INDEX,REPORT_INDEX FROM tbl_MANDATORY_FIELD WHERE FIELD_NAME =@FieldName 
  AND TASK_ID IN (1,2) 
  
		
  END
  
  END
  

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Common_Fields]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Common_Fields]
	@FieldName varchar(100),
	@TaskId int,
	@ProjectId int
AS
BEGIN  
  
  DECLARE @count int
  
  
   SET @count = (SELECT COUNT(*) FROM tbl_COMMON_FIELD WHERE TASK_ID = 1 AND PROJECT_ID = 8)
   
   IF (@count > 0 )
   
   BEGIN 
   
       UPDATE tbl_COMMON_FIELD SET FIELD_NAME = @FieldName WHERE TASK_ID = @TaskId AND PROJECT_ID = @ProjectId
   
   END 
   
   IF (@count = 0)
   
   BEGIN   
  
	INSERT INTO tbl_COMMON_FIELD (FIELD_NAME,TASK_ID,PROJECT_ID) VALUES (@FieldName,@TaskId,@ProjectId)
	
   END
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Data_Import]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Data_Import] 
	 @FieldName varchar (1000),
	 @FieldValue varchar (1000),
	 @ProjectId int,	
	 @Upload_By varchar(100),
	 @Upload_date datetime
	  
AS
BEGIN
	SET NOCOUNT ON;

	declare @sql_Str varchar(8000)
	
    select @sql_Str='INSERT INTO tbl_IMPORT_TABLE ('+@FieldName+') VALUES ('+@FieldValue+ ')'
    
    exec(  @sql_Str);
    
    declare @Id int
    
    set @Id = SCOPE_IDENTITY()
    
    
    UPDATE tbl_IMPORT_TABLE SET PROJECT_ID = @ProjectId, UPLOAD_BY = @Upload_By, UPLOAD_DATE = @Upload_date 
    WHERE  BATCH_ID =  @Id
			
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Data_To_Transaction_Pending_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Data_To_Transaction_Pending_QC]
	
 @ProjectId int,
 @BatchId int,
 @Insurance varchar (100),
 @AdmittingPhy varchar (100),
 @AttendingPhy varchar (100),
 @EDMD varchar (100),
 @DOI varchar (100),
 @TOI varchar (100), 
 @CodingComment varchar (500),
 @CodedDate datetime,
 @CodedBy varchar (100),
 @CodingStatus varchar (100) ,
 @ID varchar(10) output,
 @ProviderMD varchar (100),
 @AssistantProvider varchar (100),
 @TransId int,
 @Disposition varchar (100),
 @PatientStaus varchar (100),
 @TypeOfAccident varchar (100),
 @SharedVisit varchar (50),
 @AccountStatus varchar (50),
 @DOSChanged varchar (100),
 @WOAttestation varchar (100),
 @ReceivedDate datetime 

	
AS

  DECLARE @BID VARCHAR (100)
  
  DECLARE @TRANSIDVALUE VARCHAR (100)
  
  DECLARE @DOSCHANGEDCOMMENTS VARCHAR (100)
  
  DECLARE @RECEVIEDDATE VARCHAR (100)
  
  SET @BID = (SELECT COUNT(*) FROM tbl_TRANSACTION WHERE BATCH_ID = @BatchId)

  IF  ( @TransId = 0 AND @BID = 0 )
  
BEGIN
	
	IF (@DOSChanged != '' )  
	
	      BEGIN
	      
	      SET @RECEVIEDDATE = (SELECT CONVERT(date, RECEIVED_DATE ,103) FROM tbl_IMPORT_TABLE WHERE BATCH_ID =@BatchId)
	      
	      SET @DOSCHANGEDCOMMENTS = 'DOS CHANGED FROM ' +  @RECEVIEDDATE + ' TO ' + @DOSChanged      
	       
	
	      END
	      
	      
	 ELSE
	 
	       SET @DOSCHANGEDCOMMENTS = ''      
	  
	
	INSERT INTO tbl_TRANSACTION (PROJECT_ID,BATCH_ID,INSURANCE,ADMITTING_PHY,ATTENDING_PHY,EDMD,DOI,TOI,CODING_COMMENTS,CODED_DATE,CODED_BY,CODING_STATUS,PROVIDER_MD,ASSISTANT_PROVIDER,DISPOSITION,PATIENT_STATUS,TYPE_OF_ACCIDENT,SHARD_VISIT,ACCOUNT_STATUS,DOS_CHANGED,[W/O_ATTESTATION], DOS,PENDING_WORKED_DATE) 
	VALUES 
	(@ProjectId,@BatchId,@Insurance,@AdmittingPhy,@AttendingPhy,@EDMD,@DOI,@TOI,@CodingComment,CURRENT_TIMESTAMP,@CodedBy,@CodingStatus,@ProviderMD,@AssistantProvider,@Disposition,@PatientStaus,@TypeOfAccident,@SharedVisit,@AccountStatus,@DOSCHANGEDCOMMENTS,@WOAttestation,@ReceivedDate, CURRENT_TIMESTAMP)
	
	
	IF (@DOSChanged != '' )
	
	  UPDATE tbl_TRANSACTION SET DOS =@DOSChanged WHERE BATCH_ID =@BatchId
	
	
	SET @ID = SCOPE_IDENTITY();
	
	IF ((@CodingStatus = 'Completed') or (@CodingStatus = 'Client Clarification(s)'))
	
	BEGIN
	  UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='CODED' WHERE BATCH_ID = @BatchId
	  UPDATE tbl_TRANSACTION SET CODING_STATUS = 'Completed', ACCOUNT_STATUS ='Completed' WHERE BATCH_ID = @BatchId
	END 
	
	ELSE IF (@CodingStatus = 'IT Clarification')
	
	BEGIN
	
	 UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='IT Clarification' WHERE BATCH_ID = @BatchId
	
	END 
	
	ELSE IF (@CodingStatus ='No Charge')
	
	BEGIN
	
	   UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='CODED' WHERE BATCH_ID = @BatchId
	   UPDATE tbl_TRANSACTION SET CODING_STATUS = 'No Charge', ACCOUNT_STATUS ='No Charge' WHERE BATCH_ID = @BatchId
	
	END  
	
	IF (@CodingStatus = 'PENDED')
	
	BEGIN	
	
	UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='CODED' WHERE BATCH_ID = @BatchId
	
	END   
	
END

ELSE IF ( @TransId = 0 AND @BID > 0 )

BEGIN

  SET @TRANSIDVALUE = (SELECT TRANS_ID FROM tbl_TRANSACTION WHERE BATCH_ID=@BatchId)

  UPDATE tbl_TRANSACTION SET INSURANCE= @Insurance , ADMITTING_PHY = @AdmittingPhy, ATTENDING_PHY = @AttendingPhy,EDMD = @EDMD, DOI = @DOI, TOI =@TOI, PROVIDER_MD=@ProviderMD, ASSISTANT_PROVIDER=@AssistantProvider, DISPOSITION=@Disposition,PATIENT_STATUS=@PatientStaus,TYPE_OF_ACCIDENT = @TypeOfAccident, SHARD_VISIT=@SharedVisit,ACCOUNT_STATUS = @AccountStatus, DOS_CHANGED = @DOSChanged, CODING_STATUS=@CodingStatus
  WHERE 
  TRANS_ID = @TRANSIDVALUE 
  
  SET @ID= @TRANSIDVALUE
  
END

ELSE IF (@TransId > 0)

BEGIN
 
  UPDATE tbl_TRANSACTION SET INSURANCE= @Insurance , ADMITTING_PHY = @AdmittingPhy, ATTENDING_PHY = @AttendingPhy,EDMD = @EDMD, DOI = @DOI, TOI =@TOI, PROVIDER_MD=@ProviderMD, ASSISTANT_PROVIDER=@AssistantProvider, DISPOSITION=@Disposition,PATIENT_STATUS=@PatientStaus,TYPE_OF_ACCIDENT = @TypeOfAccident, SHARD_VISIT=@SharedVisit,ACCOUNT_STATUS = @AccountStatus, DOS_CHANGED = @DOSChanged
  WHERE 
  TRANS_ID = @TransId 

END 



GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Data_Transaction_Table]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Data_Transaction_Table]


 @ProjectId int,
 @BatchId int,
 @Insurance varchar (100),
 @AdmittingPhy varchar (100),
 @AttendingPhy varchar (100),
 @EDMD varchar (100),
 @DOI varchar (100),
 @TOI varchar (100), 
 @CodingComment varchar (500),
 @CodedDate datetime,
 @CodedBy varchar (100),
 @CodingStatus varchar (100) ,
 @ID varchar(10) output,
 @ProviderMD varchar (100),
 @AssistantProvider varchar (100),
 @TransId int,
 @Disposition varchar (100),
 @PatientStaus varchar (100),
 @TypeOfAccident varchar (100),
 @SharedVisit varchar (50),
 @AccountStatus varchar (50),
 @DOSChanged varchar (100),
 @WOAttestation varchar (100),
 @ReceivedDate datetime 
	
AS

  DECLARE @BID VARCHAR (100)
  
  DECLARE @TRANSIDVALUE VARCHAR (100)
  
  DECLARE @DOSCHANGEDCOMMENTS VARCHAR (100)
  
  DECLARE @RECEVIEDDATE VARCHAR (100)
  
  SET @BID = (SELECT COUNT(*) FROM tbl_TRANSACTION WHERE BATCH_ID = @BatchId)

  IF  ( @TransId = 0 AND @BID = 0 )
  
BEGIN
	
	
	IF (@DOSChanged != '' )  
	
	      BEGIN
	      
	      SET @RECEVIEDDATE = (SELECT CONVERT(date, RECEIVED_DATE ,103) FROM tbl_IMPORT_TABLE WHERE BATCH_ID =@BatchId)
	      
	      SET @DOSCHANGEDCOMMENTS = 'DOS CHANGED FROM ' +  @RECEVIEDDATE + ' TO ' + @DOSChanged      
	       
	
	      END
	      
	      
	 ELSE
	 
	       SET @DOSCHANGEDCOMMENTS = ''      
	  
	
	INSERT INTO tbl_TRANSACTION (PROJECT_ID,BATCH_ID,INSURANCE,ADMITTING_PHY,ATTENDING_PHY,EDMD,DOI,TOI,CODING_COMMENTS,CODED_DATE,CODED_BY,CODING_STATUS,PROVIDER_MD,ASSISTANT_PROVIDER,DISPOSITION,PATIENT_STATUS,TYPE_OF_ACCIDENT,SHARD_VISIT,ACCOUNT_STATUS,DOS_CHANGED,[W/O_ATTESTATION], DOS) 
	VALUES 
	(@ProjectId,@BatchId,@Insurance,@AdmittingPhy,@AttendingPhy,@EDMD,@DOI,@TOI,@CodingComment,CURRENT_TIMESTAMP,@CodedBy,@CodingStatus,@ProviderMD,@AssistantProvider,@Disposition,@PatientStaus,@TypeOfAccident,@SharedVisit,@AccountStatus,@DOSCHANGEDCOMMENTS,@WOAttestation,@ReceivedDate)
		
	
	IF (@DOSChanged != '' )
	
	  UPDATE tbl_TRANSACTION SET DOS =@DOSChanged WHERE BATCH_ID =@BatchId
	
	
	SET @ID = SCOPE_IDENTITY();
	
	IF ((@CodingStatus = 'Completed') or (@CodingStatus = 'Client Clarification(s)'))
	
	BEGIN
	  UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='CODED' WHERE BATCH_ID = @BatchId
	  UPDATE tbl_TRANSACTION SET CODING_STATUS = 'Completed', ACCOUNT_STATUS ='Completed' WHERE BATCH_ID = @BatchId
	END 
	
	ELSE IF (@CodingStatus = 'IT Clarification')
	
	BEGIN
	
	 UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='IT Clarification' WHERE BATCH_ID = @BatchId
	
	END 
	
	ELSE IF (@CodingStatus ='No Charge')
	
	BEGIN
	
	   UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='CODED' WHERE BATCH_ID = @BatchId
	   UPDATE tbl_TRANSACTION SET CODING_STATUS = 'No Charge', ACCOUNT_STATUS ='No Charge' WHERE BATCH_ID = @BatchId
	
	END  
	
	ELSE IF (@CodingStatus = 'Pending')
	
	BEGIN
	UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='PENDED' WHERE BATCH_ID = @BatchId
	UPDATE tbl_TRANSACTION SET IS_PENDING = 1 WHERE BATCH_ID = @BatchId
	
	
	END   
	
END

ELSE IF ( @TransId = 0 AND @BID > 0 )

BEGIN

  SET @TRANSIDVALUE = (SELECT TRANS_ID FROM tbl_TRANSACTION WHERE BATCH_ID=@BatchId)

  UPDATE tbl_TRANSACTION SET INSURANCE= @Insurance , ADMITTING_PHY = @AdmittingPhy, ATTENDING_PHY = @AttendingPhy,EDMD = @EDMD, DOI = @DOI, TOI =@TOI, PROVIDER_MD=@ProviderMD, ASSISTANT_PROVIDER=@AssistantProvider, DISPOSITION=@Disposition,PATIENT_STATUS=@PatientStaus,TYPE_OF_ACCIDENT = @TypeOfAccident, SHARD_VISIT=@SharedVisit,ACCOUNT_STATUS = @AccountStatus, DOS_CHANGED = @DOSChanged, CODING_STATUS=@CodingStatus
  WHERE 
  TRANS_ID = @TRANSIDVALUE 
  
  SET @ID= @TRANSIDVALUE
  
END

ELSE IF (@TransId > 0)

BEGIN
 
  UPDATE tbl_TRANSACTION SET INSURANCE= @Insurance , ADMITTING_PHY = @AdmittingPhy, ATTENDING_PHY = @AttendingPhy,EDMD = @EDMD, DOI = @DOI, TOI =@TOI, PROVIDER_MD=@ProviderMD, ASSISTANT_PROVIDER=@AssistantProvider, DISPOSITION=@Disposition,PATIENT_STATUS=@PatientStaus,TYPE_OF_ACCIDENT = @TypeOfAccident, SHARD_VISIT=@SharedVisit,ACCOUNT_STATUS = @AccountStatus, DOS_CHANGED = @DOSChanged
  WHERE 
  TRANS_ID = @TransId 

END 

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Dynamic_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Dynamic_Report]
	@ReportId int,
	@ReportIndex int,
	@ProjectId int,
	@FieldName varchar (100)
AS
BEGIN
	INSERT INTO tbl_DYNAMIC_REPORT_TABLE (PROJECT_ID,FIELD_NAME,DISPLAY_FIELDS,TASK_ID,REPORT_ID,REPORT_INDEX)  

SELECT @ProjectId,FIELD_NAME,DISPLAY_FIELD_NAME, TASK_ID,@ReportId,@ReportIndex FROM tbl_ADDITIONAL_FIELDS WHERE TASK_ID IN (1,2) AND PROJECT_ID = @ProjectId
AND FIELD_NAME = @FieldName

    UNION ALL

SELECT @ProjectId,FIELD_NAME,DISPLAY_FIELDS,TASK_ID,@ReportId,@ReportIndex  FROM tbl_MANDATORY_FIELD WHERE TASK_ID IN (1,2) AND FIELD_NAME = @FieldName

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Import_Data]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Insert_Import_Data]
	@NTLG VARCHAR (100),
	@ALLOTED_DATE DATETIME,
	@BATCH_NAME VARCHAR (100),
	@ACCOUNT_NO VARCHAR (100),
	@FACILITY VARCHAR (100),
	@PROJECT_ID INT,
	@ALLOTTEDBY VARCHAR (100)
	
AS
BEGIN

		UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS = 'ASSIGNED' , ALLOTTED_TO = @NTLG, ALLOTTED_DATE = @ALLOTED_DATE, ALLOTTED_BY=@ALLOTTEDBY
		WHERE BATCH_NAME =@BATCH_NAME AND ACCOUNT_NO =@ACCOUNT_NO AND PROJECT_ID = @PROJECT_ID AND FACILITY =@FACILITY

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Keyer_Allotment_Record]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Keyer_Allotment_Record] 
 
	@KEYERALLOTMENT sp_Insert_Into_Keyer_Allotment READONLY	,
	@BATCHIDVALUE VARCHAR (1000)	
	
AS	

	INSERT INTO KEYING_ALLOTMENT ([BATCH_ID]
      ,[PROJECT_ID]
      ,[BATCH_NAME]
      ,[ACCOUNT_NO]
      ,[RECEIVED_DATE]
      ,[SPECIALITY]
      ,[FACILITY]
      ,[LOCATION]
      ,[BATCH_STATUS]
      ,[CODER_NTLG]
      ,[CODED_DATE]
      ,[ALLOTED_TO]
      ,[ALLOTED_BY]
      ,[ALLOTED_DATE]
      ,[UPDATED_BY]
      ,[UPDATED_DATE]
      ,[PATIENT_NAME]
      ,[AGE]
      ,[DISPOSITION]
      ,[IS_AUDITED],
      [QC_ALLOTED_BY],
      [Is_In_Patient],
      [Is_Coding_Pending] ) SELECT * FROM @KEYERALLOTMENT 
      
      
	UPDATE tbl_IMPORT_TABLE SET QC_STATUS ='SEND TO KEYER' , RELEASED_DATE= CURRENT_TIMESTAMP WHERE BATCH_ID IN (SELECT BATCH_ID FROM @KEYERALLOTMENT)	
	
	UPDATE tbl_TRANSACTION SET QC_STATUS ='SEND TO KEYER' WHERE BATCH_ID IN (SELECT BATCH_ID FROM @KEYERALLOTMENT)

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Project_Master]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Project_Master] 
	@ProjectId int,
	@ClientId int,
	@SpecialityId int,
	@LocationId int,
	@SoftwareId int,
	@ReleaseBy varchar (100)
AS
BEGIN
	INSERT INTO tbl_PROJECT_MASTER(CLIENT_ID,SPECIALITY_ID,LOCATION_ID,SOFTWARE_ID,QC_RELEASE_BY)
	VALUES
	(@ClientId,@SpecialityId,@LocationId,@SoftwareId,@ReleaseBy)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Insert_Transaction_details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Insert_Transaction_details]
	@TransId int,
	@CPT varchar (500),
	@icd varchar (500),
	@Modifier varchar (500),
	@Units varchar (100),
	@Comments varchar (500),
	@Result varchar(500),
	@DownloadingComments varchar (100),	
	@AccountStatus varchar (100),	
	@Deficiency_Indicator varchar (100),
	@RecordType varchar (100),
	@CptOrder varchar (100),
	@ProviderMD varchar (100),
	@AssistantMD varchar (100),
	@AccountType varchar (100)
	
	
AS
BEGIN

    
   DECLARE @TRANSDETAILSID VARCHAR (1000)   
   
    
    IF (@RecordType = 0  )
    
    BEGIN 
    
    
	INSERT INTO tbl_TRANSACTION_DETAILS (TRANS_ID,CPT,ICD,MODIFIER,UNITS,COMMENTS,ICD_RESULT,DOWNLOADING_COMMENTS,DEFICIENCY_INDICATOR,ACCOUNT_STATUS,CPT_ORDER,PROVIDER_MD,ASSISTANT_PROVIDER) 
	VALUES (@TransId,@CPT,@icd,@Modifier,@Units,@Comments,@Result,@DownloadingComments,@Deficiency_Indicator,@AccountStatus,@CptOrder,@ProviderMD,@AssistantMD)
	
	END
	
	
	ELSE IF (@RecordType =1 )
	
	BEGIN  
	
	  UPDATE tbl_TRANSACTION_DETAILS SET CPT=@CPT, ICD=@icd, MODIFIER=@Modifier, UNITS=@Units, COMMENTS=@Comments, ICD_RESULT=@Result,DOWNLOADING_COMMENTS=@DownloadingComments,
	  DEFICIENCY_INDICATOR=@Deficiency_Indicator, ACCOUNT_STATUS=@AccountStatus, PROVIDER_MD=@ProviderMD, ASSISTANT_PROVIDER=@AssistantMD
	  WHERE TRANS_ID = @TransId
	
	END 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Inset_Get_RowId]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Inset_Get_RowId]
	@ClientName varchar (100),
	@ID varchar(10) output

AS
BEGIN
	
	SET NOCOUNT ON;
	
	INSERT INTO tbl_CLIENT_MASTER (CLIENT_NAME) VALUES (@ClientName)
	
	SET @ID = SCOPE_IDENTITY();
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Master_list]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Master_list] 
	
AS
BEGIN
	
	SELECT * FROM tbl_INSURANCE_MASTER ORDER BY INSURANCE

	SELECT * FROM tbl_PATIENT_STATUS_MASTER ORDER BY PATIENT_STATUS

	SELECT * FROM tbl_ACCIDENT_MASTER ORDER BY TYPE_OF_ACCIDENT

	SELECT * FROM tbl_DISPOSITION_MASTER ORDER BY DISPOSITION

	SELECT * FROM tbl_MODIFIER_MASTER ORDER BY MODIFIERS

	SELECT * FROM tbl_DOWN_CODING_MASTER ORDER BY  DESCRIPTION
	
	SELECT  FIRST_NAME + ',' + LAST_NAME + '-' + CAST((PROVIDER_ID)  AS VARCHAR(200)) AS PROVIDER_NAME, A_ID FROM tbl_ASSISTANT_PROVIDER_MASTER ORDER BY PROVIDER_NAME
 

    SELECT CASE WHEN FIRST_NAME ='DO NOT USE' THEN 'DO NOT USE' ELSE FIRST_NAME + ',' + LAST_NAME + '-' + CAST((PHYSICIAN_ID)  AS VARCHAR(200)) END AS PHYSICIAN_NAME, PHYSICIAN_ID   FROM tbl_PROVIDER_MD_MASTER ORDER BY PHYSICIAN_NAME


END

GO
/****** Object:  StoredProcedure [dbo].[sp_Output_Excel_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_Output_Excel_Report]
	@UserName varchar (100),
	@Facility varchar (100),
	@FromDate varchar (100),
	@ToDate Varchar (100),
	@AccountType Varchar (50),
	@ReleaseDate varchar (50)
AS
BEGIN

 DECLARE @dataset  OutputExcel
 Declare @data2 dbo.Coder_Limited_Records

	--IF (@Facility != '' AND @FromDate != '' AND @ToDate != '' AND @ReleaseDate = '' )
    
    --BEGIN
	
	INSERT INTO @dataset 	
			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
			T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
			CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
			CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID			
			AND I.QC_STATUS = 'SEND TO KEYER'
			--AND T.CODING_STATUS IN ('Completed','No Charge')
			AND T.CODED_DATE BETWEEN '2015-04-01' AND '2015-04-16'
			--AND I.FACILITY = @Facility		
			and IS_SKIPPED = 1 and IS_AUDITED = 0
			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
			ORDER BY D.TRANS_DETAIL_ID desc
	
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order			
	
	END
	
--	ELSE IF (@Facility = '' AND @FromDate != '' AND @ToDate != '' AND @ReleaseDate = '')
	
--	BEGIN
	
--	INSERT INTO @dataset 	
--			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
--			T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
--			CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
--			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
--			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
--			CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
--			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
--			WHERE I.BATCH_ID = T.BATCH_ID
--			AND T.TRANS_ID = D.TRANS_ID			
--			AND I.QC_STATUS = 'SEND TO KEYER'
--			AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate			
--			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
--			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
--			ORDER BY D.TRANS_DETAIL_ID desc
	
		
--		SELECT * FROM @dataset
--		PIVOT(max(ICD) 
--        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
--		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order	
		
	
--	END 
        
--    ELSE IF (@Facility != '' AND @FromDate != '' AND @ToDate != '' AND @ReleaseDate != '' )
    
--    BEGIN
	
--	INSERT INTO @dataset 	
--			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
--			T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
--			CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
--			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
--			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
--			CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
--			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
--			WHERE I.BATCH_ID = T.BATCH_ID
--			AND T.TRANS_ID = D.TRANS_ID			
--			AND I.QC_STATUS = 'SEND TO KEYER'
--			AND T.CODING_STATUS IN ('Completed','No Charge')
--			AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate	
--			AND CONVERT(DATE,I.RELEASED_DATE,103) = @ReleaseDate
--			AND I.FACILITY = @Facility		
--			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
--			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
--			ORDER BY D.TRANS_DETAIL_ID desc
	
		
--		SELECT * FROM @dataset
--		PIVOT(max(ICD) 
--        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
--		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order			
	
--	END
	
--	ELSE IF (@Facility = '' AND @FromDate != '' AND @ToDate != '' AND @ReleaseDate != '')
	
--	BEGIN
	
--	INSERT INTO @dataset 	
--			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
--			T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
--			CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
--			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
--			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
--			CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
--			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
--			WHERE I.BATCH_ID = T.BATCH_ID
--			AND T.TRANS_ID = D.TRANS_ID			
--			AND I.QC_STATUS = 'SEND TO KEYER'
--			AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate	
--			AND CONVERT(DATE,I.RELEASED_DATE,103) = @ReleaseDate		
--			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
--			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
--			ORDER BY D.TRANS_DETAIL_ID desc
	
		
--		SELECT * FROM @dataset
--		PIVOT(max(ICD) 
--        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
--		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order	
		
	
--	END 	
        
--END



GO
/****** Object:  StoredProcedure [dbo].[sp_PC_Allotment_Click]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
CREATE PROCEDURE [dbo].[sp_PC_Allotment_Click] @pcallot_List pcallot readonly
AS
BEGIN
	update [dbo].[KEYING_ALLOTMENT] set ALLOTED_TO=ntlg from @pcallot_List
where [KEYING_ALLOTMENT].BATCH_ID=batchid and [KEYING_ALLOTMENT].PROJECT_ID=projectid 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PC_Submit_Click]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ravi G
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_PC_Submit_Click]
	@pcallot_List pcallot readonly, @assignedby varchar(50)=null, @date date=null
AS
BEGIN
update KEYING_TRANSACTION   set PC_Assign_Status='Allotted', PC_Assign_By =@assignedby, PC_Assign_Date=@date, PC_Assign_To = ntlg from @pcallot_List
where BATCH_ID=batchid  and PROJECT_ID=projectid 

-- 
END




--ALTER PROCEDURE [dbo].[sp_PC_Allotment_Click] @pcallot_List pcallot readonly
--AS
--BEGIN
--	update [WFI_TEST].[dbo].[KEYING_ALLOTMENT] set ALLOTED_TO=ntlg from @pcallot_List
--where [KEYING_ALLOTMENT].BATCH_ID=batchid and [KEYING_ALLOTMENT].PROJECT_ID=projectid 
--END
GO
/****** Object:  StoredProcedure [dbo].[sp_Pending_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Pending_Report] 
	@Facility varchar (100),
	@FromDOS varchar (100),
	@ToDOS Varchar (100)
AS
BEGIN

	 SELECT * FROM TBL_IMPORT_TABLE I, TBL_TRANSACTION T
	 WHERE I.BATCH_ID = T.BATCH_ID
	 AND T.CODING_STATUS = 'PENDING'
	 AND I.RECEIVED_DATE BETWEEN @FROMDOS AND @TODOS
	 AND I.FACILITY = @FACILITY
	 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Produ_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Produ_Report] 
	
	@UserName varchar (100),
	@FromCodedDate varchar (100),
	@ToCodedDate varchar (100)
AS
BEGIN  

    DECLARE @ACCESSTYPE VARCHAR (100)
    
    
    SET @ACCESSTYPE = (SELECT ACCESS_TYPE FROM tbl_USER_ACCESS WHERE USER_NTLG =@UserName)
    
    IF @ACCESSTYPE = 'Coder'
    
    BEGIN    
  
		SELECT T.CODED_BY,T.QC_BY,CONVERT(date, T.CODED_DATE ,103) AS CODED_DATE, CONVERT(date,T.QC_DATE,103) AS QC_DATE, UPPER(T.QC_STATUS) AS QC_STATUS,
		UPPER (T.CODING_STATUS) AS CODING_STATUS,COUNT(*) AS NO_OF_RECORD 
		FROM tbl_TRANSACTION T , tbl_USER_ACCESS A
		WHERE T.CODED_BY = A.USER_NTLG
		AND T.CODED_BY = @UserName
		AND T.CODED_DATE BETWEEN @FromCodedDate AND @ToCodedDate
		GROUP BY T.CODED_BY,T.QC_BY,T.CODED_DATE,T.QC_DATE, T.CODING_STATUS,T.QC_STATUS
		ORDER BY CONVERT(date, T.CODED_DATE ,103) 
	END
	
	ELSE IF @ACCESSTYPE ='CODER-QC'
	
	BEGIN 
	
	    SELECT T.CODED_BY,T.QC_BY,CONVERT(date, T.CODED_DATE ,103) AS CODED_DATE, CONVERT(date,T.QC_DATE,103) AS QC_DATE, UPPER(T.QC_STATUS) AS QC_STATUS,
		UPPER (T.CODING_STATUS) AS CODING_STATUS,COUNT(*) AS NO_OF_RECORD 
		FROM tbl_TRANSACTION T , tbl_USER_ACCESS A
		WHERE T.CODED_BY = A.USER_NTLG
		AND T.QC_BY = @UserName
		AND T.QC_STATUS IN ('ASSIGNED TO QC', 'ERROR','SEND TO KEYER','Completed')	
		AND T.CODED_DATE BETWEEN @FromCodedDate AND @ToCodedDate
		GROUP BY T.CODED_BY,T.QC_BY,T.CODED_DATE,T.QC_DATE, T.CODING_STATUS,T.QC_STATUS
		ORDER BY CONVERT(date, T.CODED_DATE ,103)
	
	END 	
	
	ELSE IF @ACCESSTYPE ='CODER-TL'
	
	BEGIN
	
	   SELECT T.CODED_BY,T.QC_BY,CONVERT(date, T.CODED_DATE ,103) AS CODED_DATE, CONVERT(date,T.QC_DATE,103) AS QC_DATE, UPPER(T.QC_STATUS) AS QC_STATUS,
		UPPER (T.CODING_STATUS) AS CODING_STATUS,COUNT(*) AS NO_OF_RECORD 
		FROM tbl_TRANSACTION T , tbl_USER_ACCESS A
		WHERE T.CODED_BY = A.USER_NTLG		
		AND T.CODED_DATE BETWEEN @FromCodedDate AND @ToCodedDate
		GROUP BY T.CODED_BY,T.QC_BY,T.CODED_DATE,T.QC_DATE, T.CODING_STATUS,T.QC_STATUS
		ORDER BY CONVERT(date, T.CODED_DATE ,103)
	
	END 
	
	ELSE IF @ACCESSTYPE ='CODER-QC-TL'
	
	BEGIN
	 
	    SELECT T.CODED_BY,T.QC_BY,CONVERT(date, T.CODED_DATE ,103) AS CODED_DATE, CONVERT(date,T.QC_DATE,103) AS QC_DATE, UPPER(T.QC_STATUS) AS QC_STATUS,
		UPPER (T.CODING_STATUS) AS CODING_STATUS,COUNT(*) AS NO_OF_RECORD 
		FROM tbl_TRANSACTION T , tbl_USER_ACCESS A
		WHERE T.CODED_BY = A.USER_NTLG	
		AND T.CODED_DATE BETWEEN @FromCodedDate AND @ToCodedDate
		GROUP BY T.CODED_BY,T.QC_BY,T.CODED_DATE,T.QC_DATE, T.CODING_STATUS,T.QC_STATUS
		ORDER BY CONVERT(date, T.CODED_DATE ,103)
	
	END 

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_Billed_Office]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_Billed_Office]
	@FDate varchar (100),
	@TDate varchar (100)
	
AS

BEGIN
	
	SELECT FACILITY,A.DOS,I.ACCOUNT_NO,A.PATIENT_NAME,A.CPT,A.VISIT_NUMBER,A.CHART_NO,A.PROVIDER_CODE,A.CHARGE_VALUE
	FROM TBL_AMD_DATA A, tbl_IMPORT_TABLE I
	WHERE A.PATIENT_ID = I.ACCOUNT_NO
	AND A.DOS BETWEEN @FDate AND @TDate
	AND PATIENT_TYPE = '11'
	GROUP BY  FACILITY,A.DOS,I.ACCOUNT_NO,A.PATIENT_NAME,A.CPT,A.VISIT_NUMBER,A.CHART_NO,A.PROVIDER_CODE,A.CHARGE_VALUE

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_Coded_IP_Report_Breakup]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_Coded_IP_Report_Breakup]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS
BEGIN
	 DECLARE @dataset  OutputExcel
 Declare @data2 dbo.Coder_Limited_Records	
    
    BEGIN
	
	INSERT INTO @dataset 	
			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
			T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
			CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
			CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID			
			--AND I.QC_STATUS = 'SEND TO KEYER'
			AND T.CODING_STATUS IN ('Completed','No Charge')
			AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate		
			AND I.IS_INPATIENT = 1		
			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
			ORDER BY D.TRANS_DETAIL_ID desc
	
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order			
	
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_Coded_Report_Breakup]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_Coded_Report_Breakup]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS
BEGIN
	 DECLARE @dataset  OutputExcel
 Declare @data2 dbo.Coder_Limited_Records	
    
    BEGIN
	
	INSERT INTO @dataset 	
			SELECT  DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,T.TRANS_ID,REPLACE(d.cpt_order,'CPT','') AS CPT_ORDER,t.CODING_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, T.DOS ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,
			T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,
			CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER, 
			CASE WHEN D.UNITS =0 THEN '' ELSE D.UNITS END AS UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS , CASE WHEN T.TYPE_OF_ACCIDENT = 'Employment/Work related (Hosp)' THEN 'YES' ELSE 'NO' END AS HOSPITAL_EMPLOYEE
			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID	
			AND T.CODING_STATUS IN ('Completed','No Charge')
			AND I.IS_INPATIENT = 0
			AND i.RECEIVED_DATE BETWEEN @FromDate AND @ToDate				
			GROUP BY T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,t.CODING_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION],IS_REOPENED,D.COMMENTS,T.CODING_STATUS,T.KEYING_COMMENTS 
			ORDER BY D.TRANS_DETAIL_ID desc
	
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID ,ACCOUNT_NO, cpt_order			
	
	END
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_Coding_Pending_Breakup]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_Coding_Pending_Breakup] 
	@FromDate varchar (100),
	@ToDate varchar (100)
AS
BEGIN
	SELECT A.FACILITY,A.RECEIVED_DATE,A.ACCOUNT_NO,A.PATIENT_NAME,I.EDMD,T.KEYER_COMMENTS, CONVERT(DATE,KEYER_DATE,103) AS KEYER_DATE,CODING_COMMENTS,
	DATEDIFF(HOUR,KEYER_DATE, CURRENT_TIMESTAMP) AS HRS 
	FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T , tbl_IMPORT_TABLE I 
	WHERE A.BATCH_ID = T.BATCH_ID
	AND I.BATCH_ID = A.BATCH_ID
	AND RESPONSIBILITY ='Coding' and CHARGE_STATUS ='Pending'
	AND A.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
 
 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_EPA_Pending_Breakup]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_EPA_Pending_Breakup] 
	@FromDate varchar (100),
	@ToDate varchar (100)
	
AS

BEGIN

SELECT A.FACILITY,A.RECEIVED_DATE,A.ACCOUNT_NO,A.PATIENT_NAME,I.EDMD,T.KEYER_COMMENTS, CONVERT(DATE,KEYER_DATE,103) AS KEYER_DATE, EPA_RESPONSE,
DATEDIFF(HOUR,KEYER_DATE, CURRENT_TIMESTAMP) AS HRS
 
FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T , tbl_IMPORT_TABLE I
WHERE A.BATCH_ID = T.BATCH_ID
AND I.BATCH_ID = A.BATCH_ID
AND RESPONSIBILITY ='EPA' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
 
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_Inventory_Total_Record]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_Inventory_Total_Record] 
	@FromDate varchar(100),
	@ToDate varchar (100)
AS
BEGIN

	SELECT I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,T.INSURANCE,I.ADMITTING_PHY,I.ATTENDING_PHY
	FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
	WHERE I.BATCH_ID = T.BATCH_ID
	AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	AND I.IS_INPATIENT IN (1,0)


END

GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_Others]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_Others]
	@FDate varchar (100),
	@TDate varchar (100)
	
AS

BEGIN
	
	
	SELECT A.DOS,A.PATIENT_ID,A.PATIENT_NAME,A.CPT,A.VISIT_NUMBER,A.CHART_NO,A.PROVIDER_CODE,A.CHARGE_VALUE
	FROM TBL_AMD_DATA A
	WHERE A.DOS BETWEEN @FDate AND @TDate
	AND PATIENT_TYPE = 'N/A'
	GROUP BY  A.DOS,A.PATIENT_ID, A.PATIENT_NAME,A.CPT,A.VISIT_NUMBER,A.CHART_NO,A.PROVIDER_CODE,A.CHARGE_VALUE
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_PC_Pending_Breakup]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_PC_Pending_Breakup] 
	@FromDate varchar (100),
	@ToDate varchar (100)
	
AS

BEGIN

 SELECT A.FACILITY,A.RECEIVED_DATE,A.ACCOUNT_NO,A.PATIENT_NAME,I.EDMD,T.KEYER_COMMENTS, CONVERT(DATE,KEYER_DATE,103) AS KEYER_DATE, PATIENT_CALLING_COMMENTS,
 DATEDIFF(HOUR,KEYER_DATE, CURRENT_TIMESTAMP) AS HRS 
 FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T , tbl_IMPORT_TABLE I
 WHERE A.BATCH_ID = T.BATCH_ID
 AND A.BATCH_ID = I.BATCH_ID
 AND RESPONSIBILITY ='Patient Calling' and CHARGE_STATUS ='Pending'
 AND A.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
 
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Recon_Pending_From_EPA]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Recon_Pending_From_EPA]
 
   @FromDate varchar (100),
   @ToDate varchar (100)

AS
BEGIN
	
	SELECT A.FACILITY,A.ACCOUNT_NO,A.PATIENT_NAME,CONVERT(DATE,A.RECEIVED_DATE,103) AS DOS,A.EDMD,B.CODED_DATE,A.BATCH_STATUS,B.CODING_COMMENTS
	
	FROM 

	(SELECT I.BATCH_ID,ACCOUNT_NO,RECEIVED_DATE,FACILITY,PATIENT_NAME,EDMD, I.BATCH_STATUS
	 FROM tbl_IMPORT_TABLE I
	 WHERE I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	 AND I.IS_INPATIENT = 0) AS A 
	
	join

	(SELECT I.BATCH_ID,ACCOUNT_NO,RECEIVED_DATE,FACILITY,T.CODING_STATUS, CONVERT(DATE,T.CODED_DATE,103) AS CODED_DATE,T.CODING_COMMENTS
	 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
	 WHERE I.BATCH_ID = T.BATCH_ID
	 AND T.CODING_STATUS IN ('Completed','No Change')
	 AND i.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	 AND I.IS_INPATIENT = 0) AS B 
	 	 
	 on a.BATCH_ID != b.BATCH_ID
	 and a.BATCH_STATUS != 'CODED' 
	 group by A.FACILITY,A.ACCOUNT_NO,A.PATIENT_NAME,A.RECEIVED_DATE,A.EDMD,CONVERT(DATE,B.CODED_DATE,103), A.BATCH_STATUS,B.CODING_COMMENTS
 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Reconsolidation_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reconsolidation_Report]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS
BEGIN
	SELECT A.FACILITY,A.RECEIVED_DATE,ISNULL(A.NO_OF_PATIENT,0) AS NO_OF_PATIENT,ISNULL (B.PENDING,0) AS CODING_PENDING, ISNULL(C.ENTERED,0) AS CHARGES_ENTERED,
ISNULL (B.PENDING,0)  AS TOTAL_PENDING


FROM

(SELECT FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND '2015-02-04'
GROUP BY FACILITY,RECEIVED_DATE) AS A

LEFT JOIN

(SELECT  CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,FACILITY,COUNT(I.BATCH_ID) AS PENDING
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND t.CODING_STATUS = 'Pending'
 AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND '2015-02-04'
 GROUP BY FACILITY,RECEIVED_DATE) AS B 

ON A.FACILITY = B.FACILITY AND A.RECEIVED_DATE = B.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, FACILITY,COUNT(I.BATCH_ID) AS ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND '2015-02-04'
 GROUP BY FACILITY,RECEIVED_DATE) AS C
 
 ON A.FACILITY = C.FACILITY AND A.RECEIVED_DATE = C.RECEIVED_DATE 

 
 GROUP BY A.FACILITY,A.RECEIVED_DATE,A.NO_OF_PATIENT,B.PENDING,C.ENTERED
 ORDER BY A.RECEIVED_DATE

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Reopen_Record]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reopen_Record]
	@ACCOUNTNO VARCHAR (100)
AS
BEGIN
	    UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='CODED' WHERE BATCH_ID IN (@ACCOUNTNO)
		
		UPDATE tbl_TRANSACTION SET CODING_STATUS=NULL, QC_STATUS=NULL, SEND_TO_CODER= NULL, IS_AUDITED =0, IS_SKIPPED=0, IS_REOPENED =1
		WHERE BATCH_ID IN (@ACCOUNTNO)
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Reopen_Record_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reopen_Record_QC]
	@UserName varchar (100),
	@Facility varchar (100),
	@FromDate varchar (100),
	@ToDate Varchar (100),
	@AccountType Varchar (50),
	@AccountNo varchar (100)
AS
BEGIN

   DECLARE @ReportSet TransDataReopen 

   IF (@Facility != '' AND @FromDate != '' AND @ToDate != '' AND @AccountNo != '' )
   
   BEGIN
	INSERT INTO @ReportSet 	
	SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND T.QC_STATUS = 'SEND TO KEYER'
	    --AND I.QC_BY = @UserName
	    AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	    AND I.FACILITY = @Facility	 
	    AND I.ACCOUNT_NO = @AccountNo   
	    AND I.IS_INPATIENT IN (@AccountType)
		GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
		SELECT * FROM @ReportSet
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
  END
  
  IF (@Facility != '' AND @FromDate != '' AND @ToDate != '' AND @AccountNo = '' )
   
   BEGIN
	INSERT INTO @ReportSet 	
	SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND T.QC_STATUS = 'SEND TO KEYER'
	   -- AND I.QC_BY = @UserName
	    AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	    AND I.FACILITY = @Facility
	    AND I.IS_INPATIENT IN (@AccountType)
		GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
		SELECT * FROM @ReportSet
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
  END
  
		IF (@Facility = '' AND @FromDate != '' AND @ToDate != '' AND @AccountNo = '' )
   
   BEGIN
	INSERT INTO @ReportSet 	
	SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND T.QC_STATUS = 'SEND TO KEYER'
	    --AND I.QC_BY = @UserName
	    AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate  
	    AND I.IS_INPATIENT IN (@AccountType)
		GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
		SELECT * FROM @ReportSet
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		
  END
		
		IF (@Facility = '' AND @FromDate != '' AND @ToDate != '' AND @AccountNo != '')
		
		BEGIN
		INSERT INTO @ReportSet 	
		
		SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND T.QC_STATUS = 'SEND TO KEYER'
	    --AND I.QC_BY = @UserName
	    AND I.IS_INPATIENT IN (@AccountType)
	    AND I.ACCOUNT_NO = @AccountNo
	    AND  I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate	  
		GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
		SELECT * FROM @ReportSet
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
		END 
		
		IF (@Facility != '' AND @FromDate = '' AND @ToDate = '' AND @AccountNo = '')
		
		BEGIN
		INSERT INTO @ReportSet
		 	
		SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND T.QC_STATUS = 'SEND TO KEYER'
	    --AND I.QC_BY = @UserName
	    AND I.IS_INPATIENT IN (@AccountType)
	    AND I.FACILITY =@Facility	  
		GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
		SELECT * FROM @ReportSet
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
		END 
		
		IF (@Facility != '' AND @FromDate = '' AND @ToDate = '' AND @AccountNo != '')
		
		BEGIN
		INSERT INTO @ReportSet
		 	
		SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS, DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND T.QC_STATUS = 'SEND TO KEYER'
	    --AND I.QC_BY = @UserName
	    AND I.IS_INPATIENT IN (@AccountType)
	    AND I.FACILITY =@Facility	
	    AND I.ACCOUNT_NO = @AccountNo  
		GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
		SELECT * FROM @ReportSet
		PIVOT(max(ICD) 
        FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
		END 
		
		
		IF (@Facility = '' AND @FromDate = '' AND @ToDate = '' AND @AccountNo = '' )
			BEGIN
				INSERT INTO @ReportSet 	
						
			SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS, DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
			ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID		
			AND T.QC_STATUS = 'SEND TO KEYER'
			--AND I.QC_BY = @UserName		
			AND I.IS_INPATIENT IN (@AccountType)
			GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		    T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
			
			SELECT * FROM @ReportSet
			PIVOT(max(ICD) 
			FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
		END 
		
		IF (@Facility = '' AND @FromDate = '' AND @ToDate = '' AND @AccountNo != '' )
			BEGIN
				INSERT INTO @ReportSet 	
						
			SELECT D.MODIFIER,D.UNITS,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED, T.QC_STATUS,T.CODED_BY, I.FACILITY,CONVERT(date, I.RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS, DOI  AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
			ORDER BY CPT) as varchar(10)) AS ICD_RESULT,I.BATCH_ID FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID		
			AND T.QC_STATUS = 'SEND TO KEYER'
			--AND I.QC_BY = @UserName		
			AND I.IS_INPATIENT IN (@AccountType)
			AND I.ACCOUNT_NO = @AccountNo
			GROUP BY  D.MODIFIER,D.UNITS,T.CODING_COMMENTS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,I.QC_ALLOTTED_BY,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		    T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,I.BATCH_ID
		
			
			SELECT * FROM @ReportSet
			PIVOT(max(ICD) 
			FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
		END 
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Select-PC-Allotment]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Select-PC-Allotment] 
(@Facility varchar(200)=null,@from_Date datetime=null,@to_Date datetime=null,@status varchar(30)=null)

AS
BEGIN

SELECT KT.PROJECT_ID,KA.BATCH_ID ,FACILITY,RECEIVED_DATE,ACCOUNT_NO,PATIENT_NAME,AGE,PC_Assign_To as [ALLOTED_TO]
  FROM [dbo].[KEYING_ALLOTMENT] KA inner join dbo.KEYING_TRANSACTION KT on KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID
	where KT.PROJECT_ID=8 and kt.RESPONSIBILITY='Patient Calling' and kt.PC_Assign_Status=@status and
	((nullif(@from_Date,null)is null or [RECEIVED_DATE]=convert(varchar(12),@from_Date,101))or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))
	and kt.CHARGE_STATUS='Pending' and (nullif(@Facility,null)is null or FACILITY=@Facility) 

end

--  exec [sp_Select-PC-Allotment] @status='fresh' ,@Facility='a' , @from_Date='01/01/2015'
GO
/****** Object:  StoredProcedure [dbo].[sp_Task_Mapping_Details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Task_Mapping_Details]
	 @projectId int
AS
BEGIN
	
	SELECT TASK_ID,DISPLAY_NAME FROM tbl_TASK_TABLE

	SELECT T.TASK_ID,T.DISPLAY_NAME FROM tbl_PROJECT_MAPPING M , tbl_TASK_TABLE T
	WHERE M.TASK_ID = T.TASK_ID
	AND M.PROJECT_ID = @projectId

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Total_Account_Billed_in_AMD]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Total_Account_Billed_in_AMD]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS

BEGIN
	
	
	SELECT DOS AS RECEIVED_DATE,PATIENT_ID AS ACCOUNT_NO,PATIENT_NAME AS PATIENT_NAME,PATIENT_TYPE AS POS,CPT AS PROC1,VISIT_NUMBER AS VISIT,
	CHART_NO AS PATIENT_CHART_NUMBER,PROVIDER_CODE AS PROVIDER,CHARGE_VALUE AS CHARGEVALUE FROM TBL_AMD_DATA
    WHERE DOS BETWEEN @FromDate AND @ToDate
    AND PATIENT_TYPE IN (23,21)

END


GO
/****** Object:  StoredProcedure [dbo].[sp_Total_Pending_Account_Details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Total_Pending_Account_Details]
	@FromDate varchar (100),
	@ToDate varchar (100)
AS

BEGIN
	
	SELECT A.FACILITY,A.RECEIVED_DATE,A.ACCOUNT_NO,A.PATIENT_NAME,T.KEYER_COMMENTS,T.KEYER_DATE,T.CODING_COMMENTS FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
	WHERE A.BATCH_ID = T.BATCH_ID
	AND RESPONSIBILITY IN ('Coding','Patient Calling','EPA') and CHARGE_STATUS ='Pending'
	AND A.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Update_CPT_details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_CPT_details]
	 @TransId int,
	 @NewCPT varchar(100),
	 @NewICD1 varchar (100),
	 @NewICD2 varchar (100),
	 @NewICD3 varchar (100),
	 @NewICD4 varchar (100),
	 @NewICD5 varchar (100),
	 @NewICD6 varchar (100),
	 @NewICD7 varchar (100),
	 @NewICD8 varchar (100),
	 @OldCPT varchar (100),	 
	 @OldICD1 varchar (100),
	 @OldICD2 varchar (100),
	 @OldICD3 varchar (100),
	 @OldICD4 varchar (100),
	 @OldICD5 varchar (100),
	 @OldICD6 varchar (100),
	 @OldICD7 varchar (100),
	 @OldICD8 varchar (100),	 
	 @Modifier varchar (100),
	 @units varchar(100),
	 @DowncodingComments varchar (100),
	 @Indicator varchar (100),
	 @ProviderMD varchar (100),
	 @AssistantMD varchar (100),
	 @CPTOrder varchar (100)
AS
BEGIN
	
	UPDATE tbl_TRANSACTION_DETAILS SET CPT=@NewCPT, MODIFIER=@Modifier, UNITS =@units, DOWNLOADING_COMMENTS=@DowncodingComments, DEFICIENCY_INDICATOR=@Indicator, PROVIDER_MD=@ProviderMD,ASSISTANT_PROVIDER =@AssistantMD, CPT_ORDER=@CPTOrder
	WHERE TRANS_ID = @TransId AND CPT = @OldCPT
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD1 WHERE CPT=@OldCPT AND ICD= @OldICD1 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD2 WHERE CPT=@OldCPT AND ICD= @OldICD2 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD3 WHERE CPT=@OldCPT AND ICD= @OldICD3 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD4 WHERE CPT=@OldCPT AND ICD= @OldICD4 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD5 WHERE CPT=@OldCPT AND ICD= @OldICD5 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD6 WHERE CPT=@OldCPT AND ICD= @OldICD6 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD7 WHERE CPT=@OldCPT AND ICD= @OldICD7 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD8 WHERE CPT=@OldCPT AND ICD= @OldICD8 AND TRANS_ID=@TransId
	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Update_CPT_details_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_CPT_details_QC]
	 @TransId int,
	 @NewCPT varchar(100),
	 @NewICD1 varchar (100),
	 @NewICD2 varchar (100),
	 @NewICD3 varchar (100),
	 @NewICD4 varchar (100),
	 @NewICD5 varchar (100),
	 @NewICD6 varchar (100),
	 @NewICD7 varchar (100),
	 @NewICD8 varchar (100),
	 @OldCPT varchar (100),	 
	 @OldICD1 varchar (100),
	 @OldICD2 varchar (100),
	 @OldICD3 varchar (100),
	 @OldICD4 varchar (100),
	 @OldICD5 varchar (100),
	 @OldICD6 varchar (100),
	 @OldICD7 varchar (100),
	 @OldICD8 varchar (100),	 
	 @Modifier varchar (100),
	 @units varchar(100),
	 @DowncodingComments varchar (100),
	 @Indicator varchar (100),
	 @ProviderMD varchar (100),
	 @AssistantMD varchar (100),
	 @CPTOrder varchar (100)
AS
BEGIN
	
	UPDATE tbl_TRANSACTION_DETAILS SET CPT=@NewCPT, MODIFIER=@Modifier, UNITS =@units, DOWNLOADING_COMMENTS=@DowncodingComments, DEFICIENCY_INDICATOR=@Indicator, PROVIDER_MD=@ProviderMD,ASSISTANT_PROVIDER =@AssistantMD, CPT_ORDER=@CPTOrder
	WHERE TRANS_ID = @TransId AND CPT = @OldCPT
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD1 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD1 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD2 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD2 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD3 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD3 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD4 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD4 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD5 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD5 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD6 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD6 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD7 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD7 AND TRANS_ID=@TransId
	
	UPDATE tbl_TRANSACTION_DETAILS SET ICD=@NewICD8 WHERE CPT=@OldCPT AND TRANS_DETAIL_ID= @OldICD8 AND TRANS_ID=@TransId
	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Update_Data_UserAccess_Table]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Update_Data_UserAccess_Table](

	@ID int,
	@UserName varchar(50)=null,
	@UserNtlg varchar(50)=null,
	@TlName varchar(50)=null,
	@OmName varchar(50)=null,
	@SmName varchar(50)=null,
	@AccessType varchar(50)=null,
	@Status varchar(50)=null)

AS

begin
update tbl_USER_ACCESS set USER_NAME=@UserName,USER_NTLG=@UserNtlg,TL_NAME=@TlName,OM_NAME=@OmName,SM_NAME=@SmName,
ACCESS_TYPE=@AccessType,IS_DELETED=@Status where USER_ID=@ID

end
--  IF (@TransId = 0)
  
--BEGIN
	
--	INSERT INTO tbl_TRANSACTION (PROJECT_ID,BATCH_ID,INSURANCE,ADMITTING_PHY,ATTENDING_PHY,EDMD,DOI,TOI,CODING_COMMENTS,CODED_DATE,CODED_BY,CODING_STATUS,PROVIDER_MD,ASSISTANT_PROVIDER) 
--	VALUES 
--	(@ProjectId,@BatchId,@Insurance,@AdmittingPhy,@AttendingPhy,@EDMD,@DOI,@TOI,@CodingComment,@CodedDate,@CodedBy,@CodingStatus,@ProviderMD,@AssistantProvider)
	
--	SET @ID = SCOPE_IDENTITY();
	
--	IF (@CodingStatus = 'Completed')
	
--	BEGIN
--	  UPDATE tbl_IMPORT_TABLE SET BATCH_STATUS ='CODED' WHERE BATCH_ID = @BatchId
--	END 
	
--END

--IF (@TransId > 0)

--BEGIN
 
--  UPDATE tbl_TRANSACTION SET INSURANCE= @Insurance , ADMITTING_PHY = @AdmittingPhy, ATTENDING_PHY = @AttendingPhy,EDMD = @EDMD, DOI = @DOI, TOI =@TOI, PROVIDER_MD=@ProviderMD, ASSISTANT_PROVIDER=@AssistantProvider
--  WHERE 
--  TRANS_ID = @TransId 

--END 

GO
/****** Object:  StoredProcedure [dbo].[sp_Update_Details_From_Coder]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Details_From_Coder]
	
	@BatchId int,
	@Facility varchar (100),
	@ReceivedDate varchar (100),
	@AcountNo varchar (100),
	@PatientName varchar (100),
	@Insurance varchar (100),
	@Admitting varchar (100),
	@Attending varchar (100),
	@EDMD varchar (100),
	@DOI varchar (100),
	@TOI varchar (100),
	@Provider varchar (100),
	@Assistant varchar (100),
	@Disposition varchar (100),
	@PatientStatus varchar (100),
	@TypeOfAccident varchar (100),
	@SharedVisit varchar (100),
	@DosChanged varchar (100),
	@Newcpt varchar (100),
	@Newicd1 varchar (100),
	@Newicd2 varchar (100),
	@Newicd3 varchar (100),
	@Newicd4 varchar (100),
	@Newicd5 varchar (100),
	@Newicd6 varchar (100),
	@Newicd7 varchar (100),
	@Newicd8 varchar (100),
	@oldcpt varchar (100),
	@oldicd1 varchar (100),
	@oldicd2 varchar (100),
	@oldicd3 varchar (100),
	@oldicd4 varchar (100),
	@oldicd5 varchar (100),
	@oldicd6 varchar (100),
	@oldicd7 varchar (100),
	@oldicd8 varchar (100),
	@OldModifier varchar (100),
	@OldUnits varchar (100),
	@OldDeficiencey varchar (100),
	@OldDownCoding varchar (100),
	@DowncodingComments varchar (100),
	@UpdatedBy varchar (100),
	@Modifier varchar (100),
	@Units varchar (100),
	@Deficiency varchar (100),
	@WO varchar(500), 
	@Comments varchar (500)
	
	
	
AS
BEGIN
	
	
	
	UPDATE tbl_IMPORT_TABLE SET FACILITY = @Facility , RECEIVED_DATE =@ReceivedDate, ACCOUNT_NO =@AcountNo, PATIENT_NAME =@PatientName, DISPOSITION =@Disposition
WHERE BATCH_ID =@BatchId


UPDATE tbl_TRANSACTION SET INSURANCE =@Insurance, ADMITTING_PHY =@Admitting, ATTENDING_PHY =@Attending, EDMD =@EDMD,DOI =@DOI, TOI = @TOI, PROVIDER_MD =@Provider, 
ASSISTANT_PROVIDER =@Assistant, DISPOSITION =@Disposition,PATIENT_STATUS =@PatientStatus, TYPE_OF_ACCIDENT =@TypeOfAccident, SHARD_VISIT =@SharedVisit, DOS_CHANGED =@DosChanged, UPDATED_BY =@UpdatedBy,
UPDATED_DATE = CONVERT (date, SYSDATETIME()), CODING_STATUS='Completed', [W/O_ATTESTATION] =@WO
WHERE BATCH_ID =@BatchId

UPDATE tbl_TRANSACTION_DETAILS SET PROVIDER_MD=@Provider WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND CPT = @oldcpt 

UPDATE tbl_TRANSACTION_DETAILS SET ASSISTANT_PROVIDER=@Assistant WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND CPT = @oldcpt 

UPDATE tbl_TRANSACTION_DETAILS SET COMMENTS=@Comments WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND CPT = @oldcpt 

UPDATE tbl_TRANSACTION_DETAILS SET CPT = @Newcpt WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND CPT = @oldcpt 

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd1 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd1 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd2 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd2 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd3 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd3 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd4 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd4 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd5 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd5 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd6 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd6 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd7 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd7 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd8 WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND ICD = @oldicd8 AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET MODIFIER = @Modifier WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND MODIFIER = @OldModifier AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET UNITS = @Units WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND UNITS = @OldUnits  AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET DEFICIENCY_INDICATOR = @Deficiency WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND DEFICIENCY_INDICATOR = @OldDeficiencey  AND CPT = @Newcpt

UPDATE tbl_TRANSACTION_DETAILS SET DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_ID IN (SELECT T.TRANS_ID FROM tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
WHERE T.TRANS_ID = D.TRANS_ID AND T.BATCH_ID = @BatchId) AND DOWNLOADING_COMMENTS = @OldDownCoding  AND CPT = @Newcpt

END

GO
/****** Object:  StoredProcedure [dbo].[sp_Update_Details_From_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Details_From_QC]
	
	@BatchId int,
	@Facility varchar (100),
	@ReceivedDate varchar (100),
	@AcountNo varchar (100),
	@PatientName varchar (100),
	@Insurance varchar (100),
	@Admitting varchar (100),
	@Attending varchar (100),
	@EDMD varchar (100),
	@DOI varchar (100),
	@TOI varchar (100),
	@Provider varchar (100),
	@Assistant varchar (100),
	@Disposition varchar (100),
	@PatientStatus varchar (100),
	@TypeOfAccident varchar (100),
	@SharedVisit varchar (100),
	@DosChanged varchar (100),
	@Newcpt varchar (100),
	@Newicd1 varchar (100),
	@Newicd2 varchar (100),
	@Newicd3 varchar (100),
	@Newicd4 varchar (100),
	@Newicd5 varchar (100),
	@Newicd6 varchar (100),
	@Newicd7 varchar (100),
	@Newicd8 varchar (100),
	@oldcpt varchar (100),
	@oldicd1 varchar (100),
	@oldicd2 varchar (100),
	@oldicd3 varchar (100),
	@oldicd4 varchar (100),
	@oldicd5 varchar (100),
	@oldicd6 varchar (100),
	@oldicd7 varchar (100),
	@oldicd8 varchar (100),
	@DowncodingComments varchar (100),
	@UpdatedBy varchar (100),
	@Modifier varchar (100),
	@Units varchar (100),
	@Deficiency varchar (100),
	@TransDetailId int,
	@WO varchar(500)	
	
AS
BEGIN
	
	UPDATE tbl_IMPORT_TABLE SET FACILITY = @Facility , RECEIVED_DATE =@ReceivedDate, ACCOUNT_NO =@AcountNo, PATIENT_NAME =@PatientName, DISPOSITION =@Disposition
WHERE BATCH_ID =@BatchId


UPDATE tbl_TRANSACTION SET INSURANCE =@Insurance, ADMITTING_PHY =@Admitting, ATTENDING_PHY =@Attending, EDMD =@EDMD,DOI =@DOI, TOI = @TOI, PROVIDER_MD =@Provider, 
ASSISTANT_PROVIDER =@Assistant, DISPOSITION =@Disposition,PATIENT_STATUS =@PatientStatus, TYPE_OF_ACCIDENT =@TypeOfAccident, SHARD_VISIT =@SharedVisit, DOS_CHANGED =@DosChanged, UPDATED_BY =@UpdatedBy,
UPDATED_DATE = CONVERT (date, SYSDATETIME()),[W/O_ATTESTATION] =@WO
WHERE BATCH_ID =@BatchId

UPDATE tbl_TRANSACTION_DETAILS SET QC_STATUS='Completed' WHERE CPT =(SELECT CPT FROM tbl_TRANSACTION_DETAILS WHERE TRANS_DETAIL_ID =@TransDetailId)

UPDATE tbl_TRANSACTION_DETAILS SET CPT = @Newcpt, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd1, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd2 , DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd3, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd4, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd5, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd6, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd7, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET ICD = @Newicd8, DOWNLOADING_COMMENTS = @DowncodingComments WHERE TRANS_DETAIL_ID = @TransDetailId

UPDATE tbl_TRANSACTION_DETAILS SET MODIFIER=@Modifier, UNITS =@Units, DEFICIENCY_INDICATOR=@Deficiency WHERE TRANS_DETAIL_ID = @TransDetailId


END

GO
/****** Object:  StoredProcedure [dbo].[sp_Update_DOS_For_Coder_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_DOS_For_Coder_QC]
	-- Add the parameters for the stored procedure here
	@DOSChanged varchar (100),
	@TransId int 
	
AS
BEGIN
	
	    DECLARE @BATCHID VARCHAR (100)
	
		DECLARE @RECEVIEDDATE VARCHAR (100)
		
		DECLARE @DOSCHANGEDCOMMENTS VARCHAR (100)
		
		SET @BATCHID = (SELECT BATCH_ID FROM tbl_IMPORT_TABLE WHERE BATCH_ID IN (SELECT BATCH_ID FROM tbl_TRANSACTION WHERE TRANS_ID=@TransId))
		  
		SET @RECEVIEDDATE = (SELECT CONVERT(date, RECEIVED_DATE ,103) FROM tbl_IMPORT_TABLE WHERE BATCH_ID =@BATCHID)
	      
	    SET @DOSCHANGEDCOMMENTS = 'DOS CHANGED FROM ' +  @RECEVIEDDATE + ' TO ' + @DOSChanged      
	    
	    
	    UPDATE tbl_TRANSACTION SET DOS_CHANGED=@DOSCHANGEDCOMMENTS, DOS=@DOSChanged  WHERE TRANS_ID = @TransId
	    
	    
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Update_Keyer_Details]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Keyer_Details] 
	
	@BATCHIDVALUE int,
	@Comments varchar (100)
AS
BEGIN  

   
	UPDATE KEYING_ALLOTMENT SET BATCH_STATUS= 'KEYING' WHERE BATCH_ID = @BATCHIDVALUE
	
	UPDATE KEYING_TRANSACTION SET QC_STATUS = NULL, KEYING_STATUS = 'ALLOTTED',RESPONSIBILITY = NULL, PENDING_UPDATE_FROM='CODING', CODING_COMMENTS=@Comments
	WHERE BATCH_ID =@BATCHIDVALUE	
	
	
	UPDATE tbl_IMPORT_TABLE SET QC_STATUS ='SEND TO KEYER' , RELEASED_DATE= CURRENT_TIMESTAMP WHERE BATCH_ID IN (@BATCHIDVALUE)	
	
	UPDATE tbl_TRANSACTION SET QC_STATUS ='SEND TO KEYER' WHERE BATCH_ID IN (@BATCHIDVALUE)
	
	
		UPDATE KEYING_TRANSACTION SET 
		KEYING_TRANSACTION.INSURANCE = T.INSURANCE,
		KEYING_TRANSACTION.ADMITTING_PHY = T.ADMITTING_PHY,
		KEYING_TRANSACTION.ATTENDING_PHY = T.ATTENDING_PHY,
		KEYING_TRANSACTION.EDMD = T.EDMD,
		KEYING_TRANSACTION.TOI = T.TOI,
		KEYING_TRANSACTION.DISPOSITION = T.DISPOSITION,
		KEYING_TRANSACTION.PATIENT_STATUS = T.PATIENT_STATUS,
		KEYING_TRANSACTION.TYPE_OF_ACCIDENT = T.TYPE_OF_ACCIDENT,
		KEYING_TRANSACTION.SHARD_VISIT = T.SHARD_VISIT,
		KEYING_TRANSACTION.[W/O Attestation] = T.[W/O_ATTESTATION],
		KEYING_TRANSACTION.IS_SKIPPED = T.IS_SKIPPED
		from 
		KEYING_TRANSACTION K inner join tbl_TRANSACTION T  
		on K.BATCH_ID = T.BATCH_ID
		WHERE T.BATCH_ID = @BATCHIDVALUE
		
		
		DECLARE @COUNT INT
		  
		CREATE TABLE #Temp
		(
		  TRANS_DETAIL_ID integer,
		  TRANS_ID integer,
		  CPT varchar (100),
		  ICD varchar (100),
		  MODIFIER varchar (100),
		  UNITS integer,
		  COMMENTS varchar (100),
		  ICD_RESULT varchar (100),
		  DOWNLOADING_COMMENTS varchar (500),
		  DEFICIENCY_INDICATOR varchar (500),
		  CPT_ORDER varchar(100),
		  PROVIDER_MD varchar (200),
		  ASSISTANT_PROVIDER varchar (200)
		)
		
		
		INSERT INTO #Temp		
		SELECT TRANS_DETAIL_ID,TRANS_ID,CPT,ICD,MODIFIER,UNITS,COMMENTS,ICD_RESULT,DOWNLOADING_COMMENTS,DEFICIENCY_INDICATOR,CPT_ORDER,PROVIDER_MD,ASSISTANT_PROVIDER
		FROM tbl_TRANSACTION_DETAILS WHERE TRANS_ID IN (SELECT TRANS_ID FROM tbl_TRANSACTION WHERE BATCH_ID= @BATCHIDVALUE)
		
		SET @COUNT  = (SELECT COUNT(*) FROM #Temp)
		
		while @COUNT > 0
  Begin 
    
     UPDATE Keying_Transaction_Detail SET 
          Keying_Transaction_Detail.CPT = T.CPT,
          Keying_Transaction_Detail.ICD = T.ICD,
          Keying_Transaction_Detail.MODIFIER = T.MODIFIER,
          Keying_Transaction_Detail.UNITS = T.UNITS,
          Keying_Transaction_Detail.COMMENTS = T.COMMENTS,
          Keying_Transaction_Detail.ICD_RESULT = T.ICD_RESULT,
          Keying_Transaction_Detail.DOWNLOADING_COMMENTS = T.DOWNLOADING_COMMENTS,
          Keying_Transaction_Detail.DEFICIENCY_INDICATOR = T.DEFICIENCY_INDICATOR,
          Keying_Transaction_Detail.CPT_ORDER = T.CPT_ORDER,
          Keying_Transaction_Detail.PROVIDER_MD = T.PROVIDER_MD,
          Keying_Transaction_Detail.ASSISTANT_PROVIDER = T.ASSISTANT_PROVIDER                 
        FROM 
        Keying_Transaction_Detail K , #Temp T  
        WHERE K.TRANS_ID = T.TRANS_ID

  SET @COUNT = @COUNT -1 

  End
	
	
 CREATE TABLE #TEMP1
 (
   TRANS_DETAIL_ID INTEGER
 )


INSERT INTO #TEMP1

SELECT TRANS_DETAIL_ID FROM Keying_Transaction_Detail K WHERE TRANS_ID = (SELECT TRANS_ID FROM tbl_TRANSACTION WHERE BATCH_ID=@BATCHIDVALUE) AND 
NOT EXISTS (SELECT * FROM tbl_TRANSACTION_DETAILS D WHERE K.TRANS_DETAIL_ID = D.TRANS_DETAIL_ID AND TRANS_ID = (SELECT TRANS_ID FROM tbl_TRANSACTION WHERE BATCH_ID=@BATCHIDVALUE))

DECLARE @TCOUNT INT

 SET @TCOUNT  = (SELECT COUNT(*) FROM #TEMP1)
		
		while @TCOUNT > 0
		
		BEGIN
		 
		 DELETE FROM Keying_Transaction_Detail WHERE TRANS_DETAIL_ID = (SELECT TRANS_DETAIL_ID FROM #TEMP1)
		 
		 SET @TCOUNT = @TCOUNT -1 
		
		END 		
	
END

	  
		CREATE TABLE #Temp2
		(		  
		  TRANS_DETAIL_ID integer,
		  CPT varchar (100),
		  ICD varchar (100),
		  MODIFIER varchar (100),
		  UNITS integer,
		  COMMENTS varchar (100),
		  ICD_RESULT varchar (100),
		  DOWNLOADING_COMMENTS varchar (500),
		  DEFICIENCY_INDICATOR varchar (500),
		  CPT_ORDER varchar(100),
		  PROVIDER_MD varchar (200),
		  ASSISTANT_PROVIDER varchar (200)
		)

INSERT INTO #Temp2

SELECT TRANS_DETAIL_ID,CPT,ICD,MODIFIER,UNITS,COMMENTS,ICD_RESULT,DOWNLOADING_COMMENTS,DEFICIENCY_INDICATOR,CPT_ORDER,PROVIDER_MD,ASSISTANT_PROVIDER FROM tbl_TRANSACTION_DETAILS K WHERE TRANS_ID = (SELECT TRANS_ID FROM tbl_TRANSACTION WHERE BATCH_ID=@BATCHIDVALUE) AND 
NOT EXISTS (SELECT * FROM Keying_Transaction_Detail D WHERE K.TRANS_DETAIL_ID = D.TRANS_DETAIL_ID and TRANS_ID = (SELECT TRANS_ID FROM tbl_TRANSACTION WHERE BATCH_ID=@BATCHIDVALUE))

DECLARE @TKOUNT INT


 SET @TKOUNT  = (SELECT COUNT(*) FROM #Temp2)
 
while @TKOUNT > 0
		
		BEGIN		 		  
		
		 INSERT INTO Keying_Transaction_Detail (TRANS_DETAIL_ID,CPT,ICD,MODIFIER,UNITS,COMMENTS,ICD_RESULT,DOWNLOADING_COMMENTS,DEFICIENCY_INDICATOR,CPT_ORDER,PROVIDER_MD,ASSISTANT_PROVIDER)
		 
		 select TRANS_DETAIL_ID,CPT,ICD,MODIFIER,UNITS,COMMENTS,ICD_RESULT,DOWNLOADING_COMMENTS,DEFICIENCY_INDICATOR,CPT_ORDER,PROVIDER_MD,ASSISTANT_PROVIDER from #Temp2
		 
		 SET @TKOUNT = @TKOUNT -1 
		
		END 	
GO
/****** Object:  StoredProcedure [dbo].[sp_Update_Pending_Commenst]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Pending_Commenst]
	@AccountNo varchar (100),
	@Comments varchar (100),
	@Resposibility varchar (100),
	@Edmd varchar (100)
	
AS
BEGIN
	
	
	
	DECLARE @BATCHID VARCHAR (100)
	
	
	SET @BATCHID = (SELECT BATCH_ID FROM tbl_IMPORT_TABLE WHERE ACCOUNT_NO = @AccountNo)
	
	IF (@Resposibility = 'CODER')
	
	BEGIN
	
	UPDATE tbl_TRANSACTION SET CODING_COMMENTS = @Comments WHERE BATCH_ID = @BATCHID
	
	UPDATE tbl_IMPORT_TABLE SET EDMD=@Edmd WHERE BATCH_ID =@BATCHID
	
	END 
	
	ELSE IF (@Resposibility = 'EPA')
	
	BEGIN
	
	UPDATE tbl_TRANSACTION SET CLIENT_RESPONSE = @Comments, CLIENT_RESPONSE_DATE = CURRENT_TIMESTAMP WHERE BATCH_ID = @BATCHID
	
	END 
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Update_Resposible_Details_For_Client]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Resposible_Details_For_Client] 
	@BatchId varchar (100)
AS
BEGIN
	
	
	
	
	UPDATE tbl_TRANSACTION SET RESPONSIBILITY='EPA' , SEND_TO_CLIENT_DATE = CURRENT_TIMESTAMP WHERE BATCH_ID IN (SELECT BATCH_ID FROM tbl_IMPORT_TABLE WHERE ACCOUNT_NO IN (@BatchId))
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATE_STATUS]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATE_STATUS]
	@TRANS_DETAILS_ID INT
AS
BEGIN
	
	DECLARE @ID INT
	DECLARE @COUNT INT
	
	SET @ID = (SELECT TRANS_ID FROM tbl_TRANSACTION_DETAILS WHERE TRANS_DETAIL_ID=@TRANS_DETAILS_ID)
	
	SET @COUNT = (SELECT COUNT(*) FROM tbl_TRANSACTION_DETAILS WHERE TRANS_ID = @ID AND QC_STATUS IS NULL)
	
	
	IF @COUNT = 0
	
	BEGIN
	 
	   UPDATE tbl_TRANSACTION SET QC_STATUS='Completed', SEND_TO_CODER ='R' WHERE TRANS_ID=@ID
	
	END 
	
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_User_Access]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_User_Access]
	@EmpId int,
	@ProjectId int,
	@UserName varchar (100),
	@UserNtlg varchar (100),
	@AccessType varchar (100),
	@TlNtlg varchar (100),
	@TlName varchar (100),
	@OmNtlg varchar (100),
	@OmName varchar (100),
	@SmNtlg varchar (100),
	@SmName varchar (100),
	@ntlg varchar (100)
AS
BEGIN
 
    DECLARE @USERACCESS VARCHAR (100)
    
    SET @USERACCESS = (SELECT COUNT(*) FROM tbl_USER_ACCESS WHERE USER_NTLG = @UserNtlg)
    
    IF(@USERACCESS = 0 )
    
    BEGIN   
	
	INSERT INTO tbl_USER_ACCESS (EMP_ID,PROJECT_ID,USER_NAME,USER_NTLG,ACCESS_TYPE,TL_NTLG,TL_NAME,OM_NTLG,OM_NAME,SM_NTLG,SM_NAME,Update_Date,Update_By) 
	VALUES 
	(@EmpId,@ProjectId,@UserName,@UserNtlg,@AccessType,@TlNtlg,@TlName,@OmNtlg,@OmName,@SmNtlg,@SmName,CURRENT_TIMESTAMP,@ntlg)
	
	SELECT USER_NAME,USER_NTLG,TL_NAME,OM_NAME,SM_NAME,ACCESS_TYPE,CASE WHEN IS_DELETED = 'N' THEN 'YES' ELSE 'NO' END AS 'ACCESS_STATUS',Update_Date,Update_By
	FROM tbl_USER_ACCESS
	ORDER BY Update_Date DESC
	
	END 	
			
END

GO
/****** Object:  StoredProcedure [dbo].[sp_WC_Insurance_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_WC_Insurance_Report]
	@UserName varchar (100),
	@Facility varchar (100),
	@FromDate varchar (100),
	@ToDate Varchar (100)
AS
BEGIN
    DECLARE @dataset WC_Report_Data 
    DECLARE @USERACCESS VARCHAR (100) 
    
    SET @USERACCESS = (SELECT ACCESS_TYPE FROM tbl_USER_ACCESS WHERE USER_NTLG =@UserName)
    
    IF(@USERACCESS = 'CODER-QC' )
    
    BEGIN 
    
     IF (@Facility != '' AND @FromDate != '' AND @ToDate != '' )
   
        BEGIN
           INSERT INTO @dataset 	
    
			SELECT  'Yes' AS HOSPITAL_EMPLOYEE, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,DOI AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
			ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D 
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID			
			AND I.BATCH_STATUS ='CODED'
			AND T.QC_STATUS = 'Completed'
			AND I.QC_BY = @UserName	
			AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
			AND I.FACILITY =@Facility			 	
			and t.TYPE_OF_ACCIDENT ='Employment/Work related (Hosp)'		
			GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]
			
			
		
			SELECT * FROM @dataset
			PIVOT(max(ICD) 
			FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		        
        END
        
        IF (@Facility = '' AND @FromDate != '' AND @ToDate != '')
        
		BEGIN
		
		INSERT INTO @dataset 	
		 
		SELECT 'Yes' AS HOSPITAL_EMPLOYEE, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
		FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND I.BATCH_STATUS ='CODED'
		AND T.QC_STATUS = 'Completed'	
		AND T.TYPE_OF_ACCIDENT ='EMPLOYMENT/WORK RELATED (HOSP)'
		AND I.QC_BY = @UserName
        AND  I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate	  
    	GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]	
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
		FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
			
		END 
		
		IF (@Facility != '' AND @FromDate = '' AND @ToDate = '')
		
		BEGIN
		
		INSERT INTO @dataset 	
		 
		SELECT  'Yes' AS HOSPITAL_EMPLOYEE,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI  AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
		FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND I.BATCH_STATUS ='CODED'
		AND T.QC_STATUS = 'Completed'
		AND T.TYPE_OF_ACCIDENT ='EMPLOYMENT/WORK RELATED (HOSP)'
		AND I.QC_BY = @UserName
        AND I.FACILITY =@Facility		  
    	GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]	
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
		FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
			
		END
		
		
		IF (@Facility = '' AND @FromDate = '' AND @ToDate = '' )
		
			BEGIN
			
			  INSERT INTO @dataset 	
			 
				SELECT 'Yes' AS HOSPITAL_EMPLOYEE, T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
				T.PATIENT_STATUS,DOI AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
				CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
				ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
				FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
				WHERE I.BATCH_ID = T.BATCH_ID
				AND T.TRANS_ID = D.TRANS_ID				
				AND I.BATCH_STATUS ='CODED'
				AND T.QC_STATUS = 'Completed'
				AND T.TYPE_OF_ACCIDENT ='EMPLOYMENT/WORK RELATED (HOSP)'
				AND I.QC_BY = @UserName	
				GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
				T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]
				
				SELECT * FROM @dataset
				PIVOT(max(ICD) 
				FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
			
			END
		
		END 
		
		
	IF(@USERACCESS = 'CODER-QC-TL' )
	
	BEGIN
	
	 IF (@Facility != '' AND @FromDate != '' AND @ToDate != '' )
   
        BEGIN
           INSERT INTO @dataset 	
    
			SELECT  'Yes' AS HOSPITAL_EMPLOYEE,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,DOI AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
			ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
			FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID			
			AND I.BATCH_STATUS ='CODED'
			AND T.QC_STATUS = 'Completed'
			AND T.TYPE_OF_ACCIDENT ='EMPLOYMENT/WORK RELATED (HOSP)'		
			AND I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate
	        AND I.FACILITY = @Facility	 			
			GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]
			
		
			SELECT * FROM @dataset
			PIVOT(max(ICD) 
			FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		        
        END
        
        IF (@Facility = '' AND @FromDate != '' AND @ToDate != '')
        
		BEGIN
		
		INSERT INTO @dataset 	
		 
		SELECT  'Yes' AS HOSPITAL_EMPLOYEE,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
		FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND I.BATCH_STATUS ='CODED'
		AND T.QC_STATUS = 'Completed'	
		AND T.TYPE_OF_ACCIDENT ='EMPLOYMENT/WORK RELATED (HOSP)'
        AND  I.RECEIVED_DATE BETWEEN @FromDate AND @ToDate	  
    	GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]	
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
		FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
			
		END 
		
		IF (@Facility != '' AND @FromDate = '' AND @ToDate = '')
		
		BEGIN
		
		INSERT INTO @dataset 	
		 
		SELECT  'Yes' AS HOSPITAL_EMPLOYEE,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,DOI  AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
		CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
		ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
		FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
		WHERE I.BATCH_ID = T.BATCH_ID
		AND T.TRANS_ID = D.TRANS_ID		
		AND I.BATCH_STATUS ='CODED'
		AND T.QC_STATUS = 'Completed'
		AND T.TYPE_OF_ACCIDENT ='EMPLOYMENT/WORK RELATED (HOSP)'	
        AND I.FACILITY =@Facility		  
    	GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
		T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]	
		
		SELECT * FROM @dataset
		PIVOT(max(ICD) 
		FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
			
		END
		
		
		IF (@Facility = '' AND @FromDate = '' AND @ToDate = '' )
		
			BEGIN
			
			  INSERT INTO @dataset 	
			 
				SELECT  'Yes' AS HOSPITAL_EMPLOYEE,T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,CONVERT(date, DOS_CHANGED ,103) AS DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
				T.PATIENT_STATUS,DOI AS DOI,T.TOI,'Employment/Work related' AS TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
				CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY CPT
				ORDER BY CPT) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.[W/O_ATTESTATION] 
				FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
				WHERE I.BATCH_ID = T.BATCH_ID
				AND T.TRANS_ID = D.TRANS_ID				
				AND I.BATCH_STATUS ='CODED'
				AND T.QC_STATUS = 'Completed'	
				AND T.TYPE_OF_ACCIDENT ='EMPLOYMENT/WORK RELATED (HOSP)'			
				GROUP BY D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
				T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.[W/O_ATTESTATION]
				
				SELECT * FROM @dataset
				PIVOT(max(ICD) 
				FOR ICD_RESULT IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
			
			END
			
	END 		
			
END

GO
/****** Object:  StoredProcedure [dbo].[test_Allot_For_Keying]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[test_Allot_For_Keying]
(@opType varchar(100)=null,@Facility varchar(250)=null,
@from_Date datetime=null,@to_Date datetime=null,@from int=null,
@to int=null,@coder varchar(max)=null,@status varchar(350)=null)
as
begin
--with cte1
--as
--(
--select ROW_NUMBER() over (order by [ALLOT_ID]) as rownumber from KEYING_ALLOTMENT
--)

if @opType='PageLoad'
begin
select distinct [ALLOT_ID], 
	[BATCH_ID] ,
	[PROJECT_ID],
	[BATCH_NAME],
	[ACCOUNT_NO],
	[RECEIVED_DATE],
	[SPECIALITY],
	[FACILITY],
	[LOCATION],
	[BATCH_STATUS],
	[CODER_NTLG],
	[CODED_DATE],
	[ALLOTED_TO],
	[ALLOTED_BY],
	[ALLOTED_DATE],
	[UPADATED_BY],
	[UPDATED_DATE] from  KEYING_ALLOTMENT where BATCH_STATUS='CODED'
end
else  if @opType='Reload'
begin
select distinct [ALLOT_ID], 
	[BATCH_ID] ,
	[PROJECT_ID],
	[BATCH_NAME],
	[ACCOUNT_NO],
	[RECEIVED_DATE],
	[SPECIALITY],
	[FACILITY],
	[LOCATION],
	[BATCH_STATUS],
	[CODER_NTLG],
	[CODED_DATE],
	[ALLOTED_TO],
	[ALLOTED_BY],
	[ALLOTED_DATE],
	[UPADATED_BY],
	[UPDATED_DATE] from  KEYING_ALLOTMENT where [BATCH_STATUS]=@status and((nullif(@Facility,null)is null or [FACILITY]=@Facility))AND
	((nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or [CODED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))AND --(nullif(@from_Date,null)is null or [CODED_DATE]=@from_Date)and
	(nullif(@coder,null) is null or [CODER_NTLG]=@coder)--and --((nullif(@from,null)is null and nullif(@to,null)is null)or cte1.rownumber between @from and @to)
	--(nullif(@status,null)is null or [BATCH_STATUS]=@status)
	
	end
	end
	
	
-- exec [dbo].test_Allot_For_Keying @opType='Reload',@Facility= null,@from_Date= null,@to_Date= null,@from= null,@to= null,@coder= null,@status='hold'	
 
 --select * from KEYING_ALLOTMENT
 --where BATCH_STATUS='hold'
GO
/****** Object:  StoredProcedure [dbo].[Test_Coder_Reconsolidation_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Test_Coder_Reconsolidation_Report]
	
	@FDate varchar (100),
	@TDate varchar (100),
	@PreDate varchar (100),
	@NextDate varchar (100)	
AS
BEGIN
	
	
IF(@FDate = @TDate)

  BEGIN
  
  SELECT HOSPITAL_LOG.RECEIVED_DATE,HOSPITAL_LOG.FACILITY, ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IN_HOSPITAL_LOG, ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IP_RECEIVED,

ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS TOTAL_INVENTORY_RECORD, ISNULL(CODED_ENTERED.ENTERED,0) AS ACCOUNTS_CODED_ER,

ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS ACCOUNTS_CODED_IP,ISNULL(CODED_ENTERED.ENTERED,0) + ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS TOTAL_CODED,

(ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0))  - ISNULL(CODED_ENTERED.ENTERED,0) AS PENDING_ACCOUNT_FROM_EPA,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) AS ACCOUNTS_BILLED_IN_AMD, ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS ACCOUNTS_BILLED_IP_AMD,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) + ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS TOTAL_BILLED_IN_AMD,

ISNULL(BILLED_OFFICE.BILLED_OFFICE,0) AS BILLED_OFFICE,

ISNULL(OTHERS.BILLED_OFFICE,0) AS OTHERS,

ISNULL(PREVIOUS.PRE,0) AS ACCOUNTS_FROM_PRE, ISNULL(PREVIOUS.PRE1,0) AS ACCOUNTS_FROM_NEXT, 

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) AS PENDING_WITH_CODING,

ISNULL(PENDING_WITH_PC.PC_PENDING,0) AS PENDING_WITH_PC,

ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS PENDING_WITH_EPA,

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) + ISNULL(PENDING_WITH_PC.PC_PENDING,0) + ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS BILLING_PENDING



 FROM (
 
SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT,I.FACILITY As FACILITY
 FROM tbl_IMPORT_TABLE I
WHERE I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 0
GROUP BY RECEIVED_DATE,FACILITY) AS HOSPITAL_LOG 

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 1
GROUP BY RECEIVED_DATE) AS IP_HOSPITAL_LOG

ON HOSPITAL_LOG.RECEIVED_DATE = IP_HOSPITAL_LOG.RECEIVED_DATE

LEFT JOIN 

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 0
 GROUP BY RECEIVED_DATE) AS CODED_ENTERED
 
 
 ON HOSPITAL_LOG.RECEIVED_DATE = CODED_ENTERED.RECEIVED_DATE
 
 LEFT JOIN 
 
 (SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS IP_ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 1
 GROUP BY RECEIVED_DATE) AS IP_CODED_ENTERED
 
 ON HOSPITAL_LOG.RECEIVED_DATE = IP_CODED_ENTERED.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '23'
GROUP BY DOS) AS BILLED_AMD

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '21'
GROUP BY DOS) AS BILLED_AMD_IP

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD_IP.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '11'
GROUP BY DOS) AS BILLED_OFFICE

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_OFFICE.DOS


LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = 'N/A'
GROUP BY DOS) AS OTHERS

ON HOSPITAL_LOG.RECEIVED_DATE = OTHERS.DOS

LEFT JOIN

(SELECT PRE1.RECEIVED_DATE,PRE,PRE1 FROM 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum,RECEIVED_DATE AS RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @PreDate AND @PreDate
GROUP BY RECEIVED_DATE) AS PRE


LEFT JOIN 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum1,RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE1 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @FDate AND @NextDate
GROUP BY RECEIVED_DATE) AS PRE1


ON PRE.RowNum = PRE1.RowNum1) AS PREVIOUS

ON HOSPITAL_LOG.RECEIVED_DATE = PREVIOUS.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(A.BATCH_ID) AS CODING_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Coding' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_CODING


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_CODING.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS PC_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Patient Calling' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_PC


on HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_PC.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS EPA_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='EPA' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_EPA


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_EPA.RECEIVED_DATE

GROUP BY HOSPITAL_LOG.RECEIVED_DATE, HOSPITAL_LOG.NO_OF_PATIENT,HOSPITAL_LOG.FACILITY,IP_HOSPITAL_LOG.NO_OF_PATIENT, CODED_ENTERED.ENTERED, IP_CODED_ENTERED.IP_ENTERED, BILLED_AMD.AMD_ENTERED,
BILLED_AMD_IP.AMD_ENTERED, PREVIOUS.PRE, PREVIOUS.PRE1, PENDING_WITH_CODING.CODING_PENDING, PENDING_WITH_PC.PC_PENDING, PENDING_WITH_EPA.EPA_PENDING,BILLED_OFFICE.BILLED_OFFICE,OTHERS.BILLED_OFFICE
  
  END 
  
  
  ELSE IF (@FDate != @TDate)
  
  BEGIN		
	
  SELECT HOSPITAL_LOG.RECEIVED_DATE,HOSPITAL_LOG.FACILITY, ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IN_HOSPITAL_LOG, ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS ACCOUNTS_IP_RECEIVED,

ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0) AS TOTAL_INVENTORY_RECORD, ISNULL(CODED_ENTERED.ENTERED,0) AS ACCOUNTS_CODED_ER,

ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS ACCOUNTS_CODED_IP,

ISNULL(CODED_ENTERED.ENTERED,0) + ISNULL(IP_CODED_ENTERED.IP_ENTERED,0) AS TOTAL_CODED,

(ISNULL(HOSPITAL_LOG.NO_OF_PATIENT,0) + ISNULL(IP_HOSPITAL_LOG.NO_OF_PATIENT,0))  - ISNULL(CODED_ENTERED.ENTERED,0) AS PENDING_ACCOUNT_FROM_EPA,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) AS ACCOUNTS_BILLED_IN_AMD, ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS ACCOUNTS_BILLED_IP_AMD,

ISNULL(BILLED_AMD.AMD_ENTERED ,0) + ISNULL(BILLED_AMD_IP.AMD_ENTERED,0) AS TOTAL_BILLED_IN_AMD,

ISNULL(BILLED_OFFICE.BILLED_OFFICE,0) AS BILLED_OFFICE,

ISNULL(OTHERS.BILLED_OFFICE,0) AS OTHERS,

ISNULL(PREVIOUS.PRE,0) AS ACCOUNTS_FROM_PRE, ISNULL(PREVIOUS.PRE1,0) AS ACCOUNTS_FROM_NEXT, 

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) AS PENDING_WITH_CODING,

ISNULL(PENDING_WITH_PC.PC_PENDING,0) AS PENDING_WITH_PC,

ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS PENDING_WITH_EPA,

ISNULL(PENDING_WITH_CODING.CODING_PENDING,0) + ISNULL(PENDING_WITH_PC.PC_PENDING,0) + ISNULL(PENDING_WITH_EPA.EPA_PENDING,0) AS BILLING_PENDING



 FROM (
 
SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT,I.FACILITY As FACILITY
 FROM tbl_IMPORT_TABLE I
WHERE I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 0
GROUP BY RECEIVED_DATE,FACILITY) AS HOSPITAL_LOG 

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  NO_OF_PATIENT
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN @FDate AND @TDate
AND I.IS_INPATIENT = 1
GROUP BY RECEIVED_DATE) AS IP_HOSPITAL_LOG

ON HOSPITAL_LOG.RECEIVED_DATE = IP_HOSPITAL_LOG.RECEIVED_DATE

LEFT JOIN 

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 0
 GROUP BY RECEIVED_DATE) AS CODED_ENTERED
 
 
 ON HOSPITAL_LOG.RECEIVED_DATE = CODED_ENTERED.RECEIVED_DATE
 
 LEFT JOIN 
 
 (SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(I.BATCH_ID) AS IP_ENTERED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND i.RECEIVED_DATE BETWEEN @FDate AND @TDate 
 AND I.IS_INPATIENT = 1
 GROUP BY RECEIVED_DATE) AS IP_CODED_ENTERED
 
 ON HOSPITAL_LOG.RECEIVED_DATE = IP_CODED_ENTERED.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate 
AND PATIENT_TYPE = '23'
GROUP BY DOS) AS BILLED_AMD

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE, DOS,103) AS RECEIVED_DATE, COUNT(distinct PATIENT_ID) AS AMD_ENTERED FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '21'
GROUP BY DOS) AS BILLED_AMD_IP

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_AMD_IP.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = '11'
GROUP BY DOS) AS BILLED_OFFICE

ON HOSPITAL_LOG.RECEIVED_DATE = BILLED_OFFICE.DOS


LEFT JOIN

(SELECT CONVERT(DATE,DOS,103) AS DOS,COUNT(distinct PATIENT_ID) AS BILLED_OFFICE FROM TBL_AMD_DATA
WHERE DOS BETWEEN @FDate AND @TDate
AND PATIENT_TYPE = 'N/A'
GROUP BY DOS) AS OTHERS

ON HOSPITAL_LOG.RECEIVED_DATE = OTHERS.DOS

LEFT JOIN


(SELECT PRE1.RECEIVED_DATE,PRE,PRE1 FROM 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum,RECEIVED_DATE AS RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @PreDate AND @TDate
GROUP BY RECEIVED_DATE) AS PRE


LEFT JOIN 

(SELECT ROW_NUMBER() OVER (ORDER BY i.received_date) AS RowNum1,RECEIVED_DATE,COUNT(I.BATCH_ID) AS PRE1 
FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND T.DOS_CHANGED != ''
AND RECEIVED_DATE BETWEEN @FDate AND @NextDate
GROUP BY RECEIVED_DATE) AS PRE1


ON PRE.RowNum = PRE1.RowNum1) AS PREVIOUS

ON HOSPITAL_LOG.RECEIVED_DATE = PREVIOUS.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, COUNT(A.BATCH_ID) AS CODING_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Coding' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_CODING


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_CODING.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS PC_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='Patient Calling' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_PC


on HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_PC.RECEIVED_DATE


LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,COUNT(A.BATCH_ID) AS EPA_PENDING FROM KEYING_ALLOTMENT A,KEYING_TRANSACTION T 
WHERE A.BATCH_ID = T.BATCH_ID
AND RESPONSIBILITY ='EPA' and CHARGE_STATUS ='Pending'
AND A.RECEIVED_DATE BETWEEN @FDate AND @TDate
GROUP BY RECEIVED_DATE) AS PENDING_WITH_EPA


ON HOSPITAL_LOG.RECEIVED_DATE = PENDING_WITH_EPA.RECEIVED_DATE

GROUP BY HOSPITAL_LOG.RECEIVED_DATE, HOSPITAL_LOG.NO_OF_PATIENT,HOSPITAL_LOG.FACILITY,IP_HOSPITAL_LOG.NO_OF_PATIENT, CODED_ENTERED.ENTERED, IP_CODED_ENTERED.IP_ENTERED, BILLED_AMD.AMD_ENTERED,
BILLED_AMD_IP.AMD_ENTERED, PREVIOUS.PRE, PREVIOUS.PRE1, PENDING_WITH_CODING.CODING_PENDING, PENDING_WITH_PC.PC_PENDING, PENDING_WITH_EPA.EPA_PENDING,BILLED_OFFICE.BILLED_OFFICE, OTHERS.BILLED_OFFICE

    END
    


END


GO
/****** Object:  StoredProcedure [dbo].[Test_sp_Facility]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Test_sp_Facility] 

AS
BEGIN
SELECT        A.FACILITY, A.RECEIVED_DATE AS DOS, ISNULL(A.RECEIVED, 0) AS RECEIVED, ISNULL(B.PENDING, 0) AS PENDING, ISNULL(C.CODED, 0) AS CODED, ISNULL(B.PENDING, 
                         0) AS TOTAL_PENDING


FROM

(SELECT FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
COUNT(I.BATCH_ID) AS  RECEIVED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
WHERE I.BATCH_ID = T.BATCH_ID
AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND GetDate()
GROUP BY FACILITY,RECEIVED_DATE) AS A

LEFT JOIN
 
(SELECT  CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,FACILITY,COUNT(I.BATCH_ID) AS PENDING
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND t.CODING_STATUS = 'Pending'
 AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND GetDate()
 GROUP BY FACILITY,RECEIVED_DATE) AS B 

ON A.FACILITY = B.FACILITY AND A.RECEIVED_DATE = B.RECEIVED_DATE

LEFT JOIN

(SELECT CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE, FACILITY,COUNT(I.BATCH_ID) AS CODED
 FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T
 WHERE I.BATCH_ID = T.BATCH_ID
 AND T.CODING_STATUS IN ('Completed','No Change')
 AND I.RECEIVED_DATE BETWEEN '2015-02-03' AND GetDate()
 GROUP BY FACILITY,RECEIVED_DATE) AS C
 
 ON A.FACILITY = C.FACILITY AND A.RECEIVED_DATE = C.RECEIVED_DATE 

 
 GROUP BY A.FACILITY,A.RECEIVED_DATE,A.Received,B.PENDING,C.Coded
 ORDER BY A.RECEIVED_DATE DESC
	
END

GO
/****** Object:  StoredProcedure [dbo].[TestKeyer_Error_Log_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TestKeyer_Error_Log_Report]
	-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

(@proj int=null,
@Facility varchar(450)=null,
@FromDos datetime=null,
@ToDos Datetime=null,@opType varchar(300)=null,@Query nvarchar(max)=null,@ntlg varchar(max)=null,@QcedDate datetime=null,@AccountType varchar(300)=null)
as

--set @Query='ERROR_COUNT,
--Keying_Error_Category,
--Keying_Error_Comments,
--Keying_Error_SubCategory'


Declare @sql nvarchar(max)
Declare @ParamList nvarchar(max)

Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))
if @opType='ReportFields'
begin
SELECT distinct DISPLAY_FIELD_NAME as DISPLAY_FIELDS, FIELD_NAME , 'ID'=1,REPORT_INDEX FROM DBO.TBL_ADDITIONAL_FIELDS P 

WHERE PROJECT_ID=@proj AND TASK_ID=10 and IS_DELETED='N'
order by REPORT_INDEX
end
if @opType='Select'
begin


if @AccessType='KEYER-TL' or @AccessType='KEYER MANAGER' or @AccessType='KEYER-QC-TL' or @AccessType='KEYER-QC-MANAGER'

begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],'+@Query+',KT.ERROR_LIST,KT.ACKNOWLEDGE_BY as [Acknowledge By],KT.ACK_DATE as [Acknowledge Date],KT.IS_ACKNOWLEDGE as [Acknowledge Status],KT.ACHNOWLEDGE_COMMENTS as [Acknowledge Comments],KT.QC_DATE as [Qced Date] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.ERROR_COUNT>0 and  KA.PROJECT_ID=@proj'


if(@AccountType='Regular')
begin 
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if(@AccountType='Pending')
begin 
set @sql=@sql+' And KA.FACILITY =@Facility'
end




if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null

begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end

if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.QC_DATE,101) = @QcedDate '


end
  
end

else if @AccessType='KEYER'

begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],'+@Query+',KT.ERROR_LIST,KT.ACKNOWLEDGE_BY as [Acknowledge By],KT.ACK_DATE as [Acknowledge Date],KT.IS_ACKNOWLEDGE as [Acknowledge Status],KT.ACHNOWLEDGE_COMMENTS as [Acknowledge Comments],KT.QC_DATE as [Qced Date]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.ERROR_COUNT>0 and  KA.PROJECT_ID=@proj'

if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null
begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end


if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.QC_DATE,101) = @QcedDate '


end

if @ntlg is not null

begin
set @sql=@sql+' And KEYED_BY=@ntlg'
end
end

else if @AccessType='KEYER-QC'
begin
set @sql='
select KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.QC_BY as QC,KT.QC_DATE as [Qced Date],'+@Query+',KT.ERROR_LIST,KT.ACKNOWLEDGE_BY as [Acknowledge By],KT.ACK_DATE as [Acknowledge Date],KT.IS_ACKNOWLEDGE as [Acknowledge Status],KT.ACHNOWLEDGE_COMMENTS as [Acknowledge Comments],KT.QC_DATE as [Qced Date]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.ERROR_COUNT>0 and  KA.PROJECT_ID=@proj'

if @Facility is not null
begin
set @sql=@sql+' And KA.FACILITY =@Facility'
end

if @FromDos is not null and @ToDos is null
begin
set @sql=@sql+' And KA.RECEIVED_DATE=@FromDos'
end

if @FromDos is not null and @ToDos is not null
begin
set @sql=@sql+' And KA.RECEIVED_DATE between @FromDos and @ToDos'

end


if @QcedDate is not null
begin
set @sql=@sql+' And convert(varchar(12),KT.QC_DATE,101)= @QcedDate '


end

if @ntlg is not null

begin
set @sql=@sql+' And QC_BY=@ntlg'
end
end


set @ParamList='@proj int=null,
@Facility varchar(450)=null,
@FromDos datetime=null,
@ToDos Datetime=null,@opType varchar(300)=null,@Query nvarchar(max)=null,@ntlg varchar(max)=null,@QcedDate datetime=null'

exec sp_Executesql @sql,@ParamList,@proj ,
@Facility ,
@FromDos ,
@ToDos ,@opType,@Query,@ntlg,@QcedDate


end

--exec Keyer_Error_Log_Report 8,null,null,null,'Select',null,'GokulnatJ'


GO
/****** Object:  StoredProcedure [dbo].[Tuned_Bind_Keyer_Facility_With_Responsibility]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[Tuned_Bind_Keyer_Facility_With_Responsibility](@tlntlg varchar(200)=null)
AS



SELECT CODE,[DESCRIPTION] FROM DBO.TBL_FACILITY

select distinct Responsibility from dbo.RESPONSIBILITY_MASTER


GO
/****** Object:  StoredProcedure [dbo].[UPDATE_Alloted_Keyers_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[UPDATE_Alloted_Keyers_QC] @KeyerDetailedList KeyerUpdate readonly,@STAT VARCHAR(200)=NULL,@proj int=null,@QC_TL varchar(200)=null,@Audit varchar(20)=null
as begin
set nocount on

IF @STAT='ALLOT'
BEGIN
update dbo.KEYING_TRANSACTION set QC_BY=Keyer_name from @KeyerDetailedList
where KEYING_TRANSACTION.BATCH_ID=batchid and PROJECT_ID=proId and PROJECT_ID=@proj--and ACCOUNT_NO=accID
end
ELSE IF @STAT='SUBMIT' and @Audit is null
BEGIN
update dbo.KEYING_TRANSACTION set QC_BY=Keyer_name,QC_STATUS='ALLOTTED' from @KeyerDetailedList
where KEYING_TRANSACTION.BATCH_ID=batchid and PROJECT_ID=proId and PROJECT_ID=@proj --and ACCOUNT_NO=accID

update dbo.KEYING_ALLOTMENT set BATCH_STATUS='QC',QC_ALLOTED_BY=@QC_TL from @KeyerDetailedList
where KEYING_ALLOTMENT.BATCH_ID=batchid and PROJECT_ID=proId and PROJECT_ID=@proj--and ACCOUNT_NO=accID

END

ELSE IF @STAT='SUBMIT' and @Audit='Skipped'
BEGIN
update dbo.KEYING_TRANSACTION set QC_BY=Keyer_name,QC_STATUS='Completed',IS_SKIPPED='Y',QC_DATE=GETDATE() from @KeyerDetailedList
where KEYING_TRANSACTION.BATCH_ID=batchid and PROJECT_ID=proId and PROJECT_ID=@proj --and ACCOUNT_NO=accID

update dbo.KEYING_ALLOTMENT set BATCH_STATUS='QC',QC_ALLOTED_BY=@QC_TL from @KeyerDetailedList
where KEYING_ALLOTMENT.BATCH_ID=batchid and PROJECT_ID=proId and PROJECT_ID=@proj--and ACCOUNT_NO=accID

END

--select GETDATE()

END
GO
/****** Object:  StoredProcedure [dbo].[Update_Keyer_QC_Transaction_With_MultipleSelection]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Update_Keyer_QC_Transaction_With_MultipleSelection] @datatable KEYER_QC_TRANS_WITH_MULTIPLE_SELECTION readonly
as
--update  KT set KT.RESPONSIBILITY=  from dbo.KEYING_TRANSACTION KT inner join @datatable 
select GETDATE()
GO
/****** Object:  StoredProcedure [dbo].[update_Keyer_Trans_when_Reallotting]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[update_Keyer_Trans_when_Reallotting]@dataset Keyer_Tran_Insert READONLY
as
begin
update dbo.KEYING_TRANSACTION set KEYING_STATUS='ALLOTTED' where PROJECT_ID in (select PROJECT_ID from @dataset)and
BATCH_ID in (select BATCH_ID from @dataset) and   TRANS_ID IN (select TRANS_ID from @dataset)
--select GETDATE()
end
GO
/****** Object:  StoredProcedure [dbo].[updateFieldIndexAndReportIndex]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updateFieldIndexAndReportIndex](@fieldindex int,@repIndex int,@taskid int,@PROJECT_ID int)
as
update dbo.tbl_ADDITIONAL_FIELDS set FIELD_INDEX=@fieldindex where TASK_ID=@taskid and PROJECT_ID=@PROJECT_ID
GO
/****** Object:  StoredProcedure [dbo].[usp_AR_QC_Clarification_Data]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_AR_QC_Clarification_Data]
	
	@ProjectId int,
	@ArBy varchar (100),
	@Facility varchar (100)
AS
BEGIN
	
	SELECT A.ALLOT_ID, A.RECEIVED_DATE,A.ACCOUNT_NO,A.PATIENT_NAME,A.AGE,A.DISPOSITION,T.NOTES,T.AR_STATUS,T.AR_Error_Category,AR_Sub_Error_Category,AR_QC_Comments,AR_Error_Comments,
	AR_Error_Count,AR_Error_List, A.BATCH_ID,A.PROJECT_ID,AR_Acknoledge_Comments
	FROM KEYING_ALLOTMENT A, KEYING_TRANSACTION T
	WHERE A.BATCH_ID = T.BATCH_ID
    AND T.AR_QC_Assigned_Status <> 'ALLOTTED'
    AND A.PROJECT_ID = @ProjectId
    AND AR_QC_Assigned_To = @ArBy
    AND T.AR_Error_Count > 0
   -- AND (NULLIF(@Facility,NULL)IS NULL OR A.FACILITY=@Facility) 
    AND  AR_IS_ACKNOWLEDGE = 'NO'

END

GO
/****** Object:  StoredProcedure [dbo].[usp_AR_QC_Feedback_Data]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_AR_QC_Feedback_Data]
	
	@ProjectId int,
	@ArBy varchar (100),
	@Facility varchar (100)
AS
BEGIN
	
	SELECT A.ALLOT_ID,CONVERT(date,A.RECEIVED_DATE,103) as RECEIVED_DATE,A.ACCOUNT_NO,A.PATIENT_NAME,A.AGE,A.DISPOSITION,T.NOTES,T.AR_STATUS,T.AR_Error_Category,AR_Sub_Error_Category,AR_QC_Comments,AR_Error_Comments,
	AR_Error_Count,AR_Error_List, A.BATCH_ID,A.PROJECT_ID
	FROM KEYING_ALLOTMENT A, KEYING_TRANSACTION T
	WHERE A.BATCH_ID = T.BATCH_ID
    AND T.AR_QC_Assigned_Status <> 'ALLOTTED'
    AND A.PROJECT_ID = @ProjectId
    AND AR_Assign_To = @ArBy
    AND T.AR_Error_Count > 0
    --AND (NULLIF(@Facility,NULL)IS NULL OR A.FACILITY=@Facility) 
    AND (NULLIF(AR_IS_ACKNOWLEDGE,NULL)IS NULL OR AR_IS_ACKNOWLEDGE='')

END

GO
/****** Object:  StoredProcedure [dbo].[USP_AR_QC_Production_Log_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,Venkat>
-- Create date: <Create Date,03/12/2015>
-- Description:	<Description,AR_QC_Production_Log_Report>
-- =============================================
CREATE PROCEDURE [dbo].[USP_AR_QC_Production_Log_Report] 
(@Facility varchar(200)=null,
@FromDos Datetime=null,
@ToDos Datetime=null,
@AccountNum varchar(50)=null,
@QcedDate datetime=null,
@QcNtlg varchar(100)=null,
@QcStatus varchar(25)=null
)	
AS
BEGIN

	Declare @acctype varchar(200)

	set @acctype=(select distinct ACCESS_TYPE from  dbo.tbl_ACCESS_TYPE where ACCESS_TYPE=(select ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@QcNtlg))

	if  @QcStatus = 'Audited' 
	

	begin
	
	select dense_rank() over (order by KA.batch_id) as S_No,
	KT.AR_STATUS,
	kt.NOTES,
	kt.AR_Updated_By,
	kt.AR_Updated_Date,
	kt.AR_QC_Assigned_By,
	kt.AR_QC_Completed_Date,
	KA.PROJECT_ID,
	KA.BATCH_ID, 
	KA.FACILITY as Facility,	
	convert(varchar(12),KA.RECEIVED_DATE,101) as [Arrival Date],
	KA.ACCOUNT_NO as [Patient Id],	
	KA.PATIENT_NAME as [Patient Name],
	KA.AGE as Age,
	KT.INSURANCE as Insurance,
	KTD.PROVIDER_MD as [Provider/MD Name],
	KTD.ASSISTANT_PROVIDER as [Assistant Provider /PA/NP Name],
	kt.PATIENT_STATUS as [Patient Status],
	convert(varchar(12),KT.DOI,101) as DOI,
	convert(varchar(12),KT.TOI,101) as TOI,
	KT.TYPE_OF_ACCIDENT as [Type of Accident],
	KT.SHARD_VISIT as [Shared Visit],
	KT.DISPOSITION as Disposition,
	KTD.CPT,
	KTD.ICD,
	'ICD'+CAST(ROW_NUMBER() over (partition	BY KA.ACCOUNT_NO,KTD.CPT_ORDER,KTD.CPT ORDER BY KTD.CPT) AS VARCHAR(MAX)) AS ICDlIST,
	KTD.MODIFIER as Modifier,
	KTD.UNITS as Units,
	KTD.COMMENTS as Comments,
	KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],
	KTD.DEFICIENCY_INDICATOR as [Deficiency Indicator],
	KT.DOS_CHANGED as [DOS Change],
	KTD.ACCOUNT_STATUS as [Account Status],
	kt.[W/O Attestation] as [Attestation], 
	kt.CHARGE_STATUS as [Charge Status],
	KT.KEYER_COMMENTS as [Keyer Comments],
	KT.AR_QC_Assigned_To as [Allocated to],
	AR_Assign_Status,
	KT.AR_QC_Assigned_Status, 
	ktd.CPT_ORDER  into #temp1 from dbo.KEYING_ALLOTMENT KA 
	inner join dbo.KEYING_TRANSACTION KT on KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID 
	inner join Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 	
	
	 where KT.PROJECT_ID=8  
	
	and (nullif(@AccountNum,null)is null or KA.ACCOUNT_NO=@AccountNum) and (nullif(@Facility,null)is null or KA.FACILITY=@Facility)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@FromDos,null)is null or [RECEIVED_DATE]=@FromDos)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@FromDos,null)is null and nullif(@ToDos,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@FromDos,101) and convert(varchar(12),@ToDos,101))) and 
	KT.AR_QC_Assigned_Status ='Completed'  and Kt.AR_Assign_Status='Completed' and 
	(nullif(@QcedDate,null)is null or convert(varchar(12),AR_QC_Completed_Date,101)=@QcedDate)
	and  AR_QC_Assigned_To =case when @acctype= 'ar-qc-tl' then  AR_QC_Assigned_To else @QcNtlg  end 
	
	select S_No as [S.No],AR_STATUS as [AR Status],NOTES, AR_Updated_By as [AR BY],AR_Updated_Date as [AR Date],AR_QC_Assigned_By as [Assigned BY],AR_QC_Completed_Date as [QC Completed Date],PROJECT_ID,BATCH_ID, Facility,[Arrival Date],[Patient Id],[Patient Name],AGE as Age,INSURANCE as Insurance, [Provider/MD Name],
	[Assistant Provider /PA/NP Name],[Patient Status],DOI,TOI,[Type of Accident],[Shared Visit],Disposition,CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,Modifier,Units,Comments,[Down Coding Comments],
	[Deficiency Indicator],[DOS Change],[Account Status],[Attestation], [Charge Status],[Keyer Comments],[Allocated to],AR_Assign_Status as [AR Account Status],AR_QC_Assigned_Status as [AR-QC Account Status] from #temp1
	Pivot 
	(
		max(ICD) for ICDlIST in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
	)
	as PIVOTEDTABLE order by BATCH_ID,CPT_ORDER
	drop table #temp1
	
	
	end
	
	else
	
	begin
	select dense_rank() over (order by KA.batch_id) as S_No,
	KT.AR_STATUS,
	kt.NOTES,
	kt.AR_Updated_By,
	kt.AR_Updated_Date,
	kt.AR_QC_Assigned_By,
	kt.AR_QC_Completed_Date,
	KA.PROJECT_ID,
	KA.BATCH_ID, 
	KA.FACILITY as Facility,	
	convert(varchar(12),KA.RECEIVED_DATE,101) as [Arrival Date],KA.ACCOUNT_NO as [Patient Id],	
	KA.PATIENT_NAME as [Patient Name],KA.AGE as Age,KT.INSURANCE as Insurance,
	KTD.PROVIDER_MD as [Provider/MD Name],KTD.ASSISTANT_PROVIDER as [Assistant Provider /PA/NP Name],
	kt.PATIENT_STATUS as [Patient Status],convert(varchar(12),KT.DOI,101) as DOI,
	convert(varchar(12),KT.TOI,101) as TOI,KT.TYPE_OF_ACCIDENT as [Type of Accident],
	KT.SHARD_VISIT as [Shared Visit],
	KT.DISPOSITION as Disposition,
	KTD.CPT,
	KTD.ICD,
	'ICD'+CAST(ROW_NUMBER() over (partition	BY KA.ACCOUNT_NO,KTD.CPT_ORDER,KTD.CPT ORDER BY KTD.CPT) AS VARCHAR(MAX)) AS ICDlIST,
	KTD.MODIFIER as Modifier,
	KTD.UNITS as Units,
	KTD.COMMENTS as Comments,
	KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],
	KTD.DEFICIENCY_INDICATOR as [Deficiency Indicator],
	KT.DOS_CHANGED as [DOS Change],
	KTD.ACCOUNT_STATUS as [Account Status],
	kt.[W/O Attestation] as [Attestation], 
	kt.CHARGE_STATUS as [Charge Status],
	KT.KEYER_COMMENTS as [Keyer Comments],
	KT.AR_QC_Assigned_To as [Allocated to],
	AR_Assign_Status,KT.AR_QC_Assigned_Status, 
	ktd.CPT_ORDER  into #temp12 from dbo.KEYING_ALLOTMENT KA 
	inner join dbo.KEYING_TRANSACTION KT on KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID 
	inner join Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
	
	 where KT.PROJECT_ID=8 and 
	 (nullif(@AccountNum,null)is null or KA.ACCOUNT_NO=@AccountNum) and (nullif(@Facility,null)is null or KA.FACILITY=@Facility)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@FromDos,null)is null or [RECEIVED_DATE]=@FromDos)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@FromDos,null)is null and nullif(@ToDos,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@FromDos,101) and convert(varchar(12),@ToDos,101))) and 
	
	(nullif(@QcedDate,null)is null or convert(varchar(12),AR_QC_Completed_Date,101)=@QcedDate)
	
	and AR_QC_Assigned_To =case when @acctype= 'ar-qc-tl' then  AR_QC_Assigned_To else @QcNtlg    end --case when @acctype='ar-qc-tl' then null else @QcNtlg end
	and KT.AR_QC_Assigned_Status ='Skip' and KT.AR_Is_Skipped=1 and Kt.AR_Assign_Status='Completed' 
	
	select S_No as [S.No],AR_STATUS as [AR Status],NOTES, AR_Updated_By as [AR BY],AR_Updated_Date as [AR Date],AR_QC_Assigned_By as [Assigned BY],AR_QC_Completed_Date as [QC Completed Date],PROJECT_ID,BATCH_ID, Facility,[Arrival Date],[Patient Id],[Patient Name],AGE as Age,INSURANCE as Insurance, [Provider/MD Name],
	[Assistant Provider /PA/NP Name],[Patient Status],DOI,TOI,[Type of Accident],[Shared Visit],Disposition,CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,Modifier,Units,Comments,[Down Coding Comments],
	[Deficiency Indicator],[DOS Change],[Account Status],[Attestation], [Charge Status],[Keyer Comments],[Allocated to],AR_Assign_Status as [AR Account Status],AR_QC_Assigned_Status as [AR-QC Account Status] from #temp12
	Pivot 
	(
		max(ICD) for ICDlIST in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
	)
	as PIVOTEDTABLE order by BATCH_ID,CPT_ORDER
	drop table #temp12
	end
	
END

--exec [USP_AR_QC_Production_Log_Report] null,null,null,null,null,'manoharr','Audited'

GO
/****** Object:  StoredProcedure [dbo].[USP_Bind_Data_BasedOnUserNTLG]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_Bind_Data_BasedOnUserNTLG]  --exec USP_Bind_Data_BasedOnUserNTLG 'RasmitaS'
(
@user_ntlg varchar(50)
)
as begin 
select max(TIME_TRACK_ID) AS [COUNT] from TBL_TIME_TRACKER WHERE NTLG=@user_ntlg
Select ACCESS_ID from  tbl_USER_ACCESS_TM where USER_NTLG =@user_ntlg 
--select ACCOUNT_NO from TBL_TIME_TRACKER WHERE TIME_TRACK_ID=@user_ntlg
end 

GO
/****** Object:  StoredProcedure [dbo].[USP_Bind_EmpDetails]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_Bind_EmpDetails]  --exec USP_Bind_Data_BasedOnUserNTLG 'RasmitaS'
(
@user_ntlg varchar(50)
)
as begin 
Select USER_NTLG,EMP_ID,LOCATION_ID,PROJECT_ID from  tbl_USER_ACCESS_TM where USER_NTLG = @user_ntlg AND IS_DELETED='N'

end 

GO
/****** Object:  StoredProcedure [dbo].[USP_Bind_Home_DropDown_Binding]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_Bind_Home_DropDown_Binding]  --exec USP_Bind_Home_DropDown_Binding 1
(
@Proj_Id int
)
as begin 
SELECT  SUB_PROJ_NAME FROM  TBL_SUB_PROJECT  where PROJECT_ID = @Proj_Id AND IS_DELETED='N'
SELECT  SPECIALITY FROM  TBL_SPECIALITY where PROJECT_ID = @Proj_Id AND IS_DELETED='N'
SELECT  SOFTWARE FROM  TBL_SOFTWARE_MASTER where PROJECT_ID = @Proj_Id  AND IS_DELETED='N'
end 


GO
/****** Object:  StoredProcedure [dbo].[USP_Bind_LocationDetails]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_Bind_LocationDetails]  --exec USP_Bind_Data_BasedOnUserNTLG 'RasmitaS'
(
@loc_id varchar(20)
)
as begin 

SELECT  LOCATION,LOCATION_id FROM [dbo].[TM_LOCATION]  where LOCATION_id=@loc_id
end 

GO
/****** Object:  StoredProcedure [dbo].[USP_Bind_ProjectDetails]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_Bind_ProjectDetails]  --exec USP_Bind_Data_BasedOnUserNTLG 'RasmitaS'
(
@proj_id varchar(50)
)
as begin 
SELECT PROJECT_ID, PROJECT_NAME FROM [dbo].tbl_PROJECT_MASTER_TM  where PROJECT_ID=@proj_id AND IS_DELETED='N'

end 
GO
/****** Object:  StoredProcedure [dbo].[usp_BIND_responsibility]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_BIND_responsibility]
as
select distinct Responsibility from dbo.RESPONSIBILITY_MASTER
GO
/****** Object:  StoredProcedure [dbo].[usp_cpt_QC]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_cpt_QC]
as
	SELECT (RANK() OVER(ORDER BY account_no,cpt)) AS ROWNO, cpt_order,
			T.QC_STATUS,D.DOWNLOADING_COMMENTS,I.BATCH_ID,DOS_CHANGED,I.FACILITY,CONVERT(date, RECEIVED_DATE ,103) AS RECEIVED_DATE,
			I.ACCOUNT_NO,
			I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,DOI AS DOI,T.TOI,T.TYPE_OF_ACCIDENT,CASE WHEN T.SHARD_VISIT = 'NOT SHARED' THEN '' ELSE T.SHARD_VISIT END AS SHARD_VISIT,T.CODED_BY,
			CPT,ICD,'ICD'+ cast(ROW_NUMBER() OVER(PARTITION BY ACCOUNT_NO, CPT,cpt_order
			ORDER BY ACCOUNT_NO) as varchar(10)) AS ICD_RESULT,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,CONVERT(date, T.CODED_DATE ,103) AS CODED_BY,[W/O_ATTESTATION]   FROM tbl_IMPORT_TABLE I, tbl_TRANSACTION T, tbl_TRANSACTION_DETAILS D
			WHERE I.BATCH_ID = T.BATCH_ID
			AND T.TRANS_ID = D.TRANS_ID
			AND I.BATCH_STATUS ='CODED'
			AND T.QC_STATUS = 'ASSIGNED TO QC'
			AND D.QC_STATUS  IS NULL 
			AND IS_AUDITED = 0
			AND SEND_TO_CODER IS NULL
			AND I.QC_BY = 'SenthilkS1'			
			GROUP BY cpt_order,T.TRANS_ID,D.TRANS_DETAIL_ID, D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,I.RECEIVED_DATE,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,T.PROVIDER_MD,T.ASSISTANT_PROVIDER,
			T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,T.CODED_BY,t.ERROR_CATEGORY,t.ERROR_SUBCATEGORY,T.CODED_DATE,[W/O_ATTESTATION]
			ORDER BY D.TRANS_DETAIL_ID
GO
/****** Object:  StoredProcedure [dbo].[usp_fetch_Keyer_Pend_PC_Ins_AR_Coding_Feilds]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[usp_fetch_Keyer_Pend_PC_Ins_AR_Coding_Feilds]
(
@Task int=null,@Project int=null
)
as

DECLARE @FIELD_NAME VARCHAR(MAX)
DECLARE @SQL VARCHAR(MAX)
declare @sql1 varchar(max)
DECLARE @TFIELD_NAME TABLE (Display varchar(max),FIELD_NAME VARCHAR(MAX),ID INT,Report int)
INSERT INTO @TFIELD_NAME

Select * from (
SELECT distinct DISPLAY_FIELD_NAME as DISPLAY_FIELDS, FIELD_NAME , 'ID'=1,REPORT_INDEX FROM DBO.TBL_ADDITIONAL_FIELDS P 

WHERE PROJECT_ID=@Project AND TASK_ID in (@Task) and IS_DELETED='N'
 --TASK_ID=7 

union all

SELECT distinct DISPLAY_FIELDS,FIELD_NAME, 'ID'=1,'REPORT_INDEX'=0  FROM DBO.tbl_MANDATORY_FIELD  P 
 WHERE TASK_ID in (@Task) and IS_DELETED='N')as T
 order by REPORT_INDEX--TASK_ID=7 

select * from @TFIELD_NAME

--exec usp_fetch_Keyer_Pend_PC_Ins_AR_Coding_Feilds 57,8

GO
/****** Object:  StoredProcedure [dbo].[usp_fetch_Keyer_Production_ReportFields]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE proc [dbo].[usp_fetch_Keyer_Production_ReportFields](@projid int=null)
as
DECLARE @FIELD_NAME VARCHAR(MAX)
DECLARE @SQL VARCHAR(MAX)
declare @sql1 varchar(max)
DECLARE @TFIELD_NAME TABLE (Display varchar(max),FIELD_NAME VARCHAR(MAX),ID INT,Report int)
INSERT INTO @TFIELD_NAME

--Select * from (
--SELECT distinct DISPLAY_FIELD_NAME as DISPLAY_FIELDS, FIELD_NAME , 'ID'=1,REPORT_INDEX FROM DBO.TBL_ADDITIONAL_FIELDS P 

--WHERE PROJECT_ID=@projid AND TASK_ID in (7,8) and IS_DELETED='N'
-- --TASK_ID=7 

--union all

--SELECT distinct DISPLAY_FIELDS,FIELD_NAME, 'ID'=1,'REPORT_INDEX'=0  FROM DBO.tbl_MANDATORY_FIELD  P 
-- WHERE TASK_ID in (7,8) and IS_DELETED='N')as T
-- order by REPORT_INDEX--TASK_ID=7 


Select * from (

 --TASK_ID=7 
 
 
 SELECT distinct DISPLAY_FIELDS,FIELD_NAME, 'ID'=1,REPORT_INDEX FROM DBO.tbl_MANDATORY_FIELD  P 
 WHERE TASK_ID in (7,8) and IS_DELETED='N'

union all
SELECT distinct DISPLAY_FIELD_NAME as DISPLAY_FIELDS, FIELD_NAME , 'ID'=1,REPORT_INDEX=0 FROM DBO.TBL_ADDITIONAL_FIELDS P 

WHERE PROJECT_ID=8 AND TASK_ID in (7,8) and IS_DELETED='N'


 )as T
 order by REPORT_INDEX asc

select distinct * from @TFIELD_NAME
order by Report

--exec [usp_fetch_Keyer_Production_ReportFields] 8
GO
/****** Object:  StoredProcedure [dbo].[usp_get_AccessType]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create procedure [dbo].[usp_get_AccessType](@ntlg varchar(300)=null)
as
Declare @AccessType varchar(100)

set @AccessType=(select access_type from dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select distinct ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))
Select @AccessType

GO
/****** Object:  StoredProcedure [dbo].[USP_Get_AR_QC_And_TLlist]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_Get_AR_QC_And_TLlist] --USP_Get_AR_QC_And_TLlist 
	
AS
BEGIN

select [USER_NAME],USER_NTLG from tbl_USER_ACCESS where access_type in ('AR-QC-TL','AR-QC') and IS_DELETED='N'
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_HourlyReport]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_HourlyReport] -- EXEC [dbo].[USP_HourlyReport] @Fromdate='30/06/2017',  @Todate ='30/06/2017', @user ='ReenajaA', @Software = NULL, @Vertical = NULL, @Project = NULL, @Speciality = NULL,@Status=null, @subproj=null
(   @Fromdate varchar(20)=NULL,
    @Todate varchar(20)=NULL,
    @user varchar(50)=NULL,           
    @Software VARCHAR(200)=NULL,
	@Vertical VARCHAR(200)=NULL,
	@Project VARCHAR(100)= NULL,
	@Speciality VARCHAR(200)=NULL,
	@Status varchar(50)=NULL,
	@subproj varchar(50)=null
)

AS BEGIN 

DECLARE @user1 VARCHAR(200)
DECLARE @Software1 VARCHAR(200)
DECLARE @Vertical1 varchar(200)
DECLARE @Project1 varchar(200)
DECLARE @Speciality1 VARCHAR(200)
DECLARE @Status1 varchar(50)
DECLARE @subproj1 VARCHAR(50)
DECLARE @QUERY NVARCHAR(MAX)

IF(@user IS NOT NULL)BEGIN SET @user1 ='AND [NTLG]='''+@user+'''' END ELSE BEGIN SET @user1 =' ' END 
IF(@Software IS NOT NULL) BEGIN SET @Software1 ='AND Software='''+@Software+'''' END ELSE  BEGIN SET @Software1 =' ' END
IF(@Vertical IS NOT NULL) BEGIN SET @Vertical1 ='AND Vertical_id='''+@Vertical+'''' END ELSE BEGIN SET @Vertical1 =' ' END
IF(@Project IS NOT NULL) BEGIN SET @Project1 ='AND Project_Name='''+@Project+'''' END ELSE BEGIN SET @Project1 =' ' END
IF (@Speciality IS NOT NULL) BEGIN SET @Speciality1 ='AND SPECIALITY_ID='''+@Speciality+'''' END ELSE BEGIN SET @Speciality1 =' ' END
IF(@Status IS NOT NULL) BEGIN SET @Status1 ='AND Status='''+@Status+'''' END ELSE BEGIN SET @Status1 =' ' END
IF(@subproj IS NOT NULL) BEGIN SET @subproj1 ='AND SUB_PROJ_NAME='''+@subproj+'''' END ELSE BEGIN SET @subproj1 =' ' END
  
if OBJECT_ID('tempdb..##HOURSBasis')is not null drop table ##HOURSBasis

SET @QUERY= 'SELECT * into ##HOURSBasis
FROM (SELECT  CAST(END_TIME AS DATE) [Date],EMP_ID AS [EMP ID], DATEPART(hour,END_TIME) [Hour], COUNT(1)  [account count],NTLG AS [NAME],LOCATION_NAME[FACILITY],
UPDATE_DATE,Project_name FROM TBL_TIME_TRACKER  where END_TIME IS NOT NULL  AND (convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate) '+@user1+' '+@Software1+' '+@Vertical1+' '+@Project1+' '+@Speciality1+' '+@Status1+' '+@subproj1+'
GROUP BY EMP_ID,[NTLG],LOCATION_NAME,UPDATE_DATE,Project_name, CAST(END_TIME AS DATE), (DATEPART(hour,END_TIME)) ) AS HourlySalesData PIVOT(SUM([account count])  FOR [Hour] IN ( [0] ,[1] , [2], [3], [4], [5], [6], [7], [8], [9], [10],[11], [12], [13], [14], [15], [16], 
[17], [18], [19], [20], [21], [22], [23]))  AS DatePivot 

select  ROW_NUMBER() OVER (ORDER BY (SELECT 100)) AS SNO, [EMP ID],[NAME], [8] as [8 AM - 9 AM],[9] as [9 AM - 10 AM],[10] as [10 AM - 11 AM],[11] as [11 AM - 12 AM],[12] as [12 AM - 1 PM], [13] as [1 PM - 2 PM],
[14] as [2 PM - 3 PM],[15] AS [3 PM - 4 PM],[16] as [4 PM - 5 PM],[17] as [5 PM - 6 PM],[18] AS [6 PM - 7 PM], [19] as [7 PM - 8 PM],[20] AS [8 PM - 9 PM] ,
[21] AS [9 PM - 10 PM] ,[22] AS [10 PM - 11 PM] ,[23] AS [11 PM - 12 AM] ,[0] AS [12 AM - 1 AM] , [1] AS [1 AM - 2 AM],
SUM(ISNULL([0],0)+ISNULL([1],0)+ISNULL([2],0)+ISNULL([8],0)+ISNULL([9],0)+ISNULL([10],0)+ISNULL([11],0)+ISNULL([12],0)+ISNULL([13],0)+ISNULL([14],0)+ISNULL([15],0)+
ISNULL([16],0)+ISNULL([17],0)+ISNULL([18],0)+ISNULL([19],0)+ISNULL([20],0)+ISNULL([21],0)+ISNULL([22],0)+ISNULL([23],0)) AS TOTAL from ##HOURSBasis GROUP BY DATE, [EMP ID], NAME, [0] ,[1] ,[2] ,[8] ,[9] ,[10] ,[11] ,[12] ,[13] ,[14] ,[15] ,[16] ,[17] ,[18] ,[19] ,[20],[21] ,[22] ,[23] '
print @QUERY
DECLARE @PARAMlIST NVARCHAR(max)
SET @PARAMlIST='@Fromdate varchar(20), @Todate varchar(20), @user varchar(50),@Software VARCHAR(200), @Vertical varchar(200),@Project varchar(200), @Speciality VARCHAR(200),@Status varchar(50),@subproj VARCHAR(50)'
EXECUTE sp_executesql @QUERY,@PARAMlIST,@Fromdate,@Todate,@user,@Software, @Vertical, @Project, @Speciality,@Status,@subproj
 END



 --ROW_NUMBER() OVER (ORDER BY (SELECT 100)) AS SNO,



GO
/****** Object:  StoredProcedure [dbo].[usp_Insert_Common_FieldsAllotment]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_Insert_Common_FieldsAllotment]
	@FieldName varchar(max),
	@TaskId int,
	@ProjectId int
AS
BEGIN  
  
   
   if(not exists(select * from tbl_COMMON_FIELD where TASK_ID=@TaskId and PROJECT_ID=@ProjectId))
   begin
   	INSERT INTO tbl_COMMON_FIELD (FIELD_NAME,TASK_ID,PROJECT_ID) VALUES (@FieldName,@TaskId,@ProjectId)

   end
   else 
   begin
          UPDATE tbl_COMMON_FIELD SET FIELD_NAME = @FieldName WHERE TASK_ID = @TaskId AND PROJECT_ID = @ProjectId

   end
	
END

GO
/****** Object:  StoredProcedure [dbo].[usp_Insert_Keyer_MasterList]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_Insert_Keyer_MasterList](@SelectedDropDown varchar(500)=null,@SubCatItem int=null,@SubCatValue varchar(200)=null,@itemValue varchar(500)=null,@insertParam varchar(50) out)
as
if(@SelectedDropDown='relation')
begin
if not exists (select distinct Responsibility from dbo.RESPONSIBILITY_MASTER where Responsibility=@itemValue)
begin
insert into dbo.RESPONSIBILITY_MASTER values(@itemValue,'N')
select @insertParam='Inserted'
end
else
begin
select @insertParam='Failed'

end

end
else if (@SelectedDropDown='Charge_Status')
begin

if not exists (select distinct Charge_Status from dbo.CHARGE_STATUS_MASTER where Charge_Status=@itemValue)
begin
insert into dbo.CHARGE_STATUS_MASTER values(@itemValue,'N')
select @insertParam='Inserted'
end

else
begin
select @insertParam='Failed'

end


end

else if (@SelectedDropDown='Err_Category')
begin
if not exists (select distinct Error_Category from dbo.KEYING_ERROR_CATEGORY where Error_Category=@itemValue)
begin
insert into dbo.KEYING_ERROR_CATEGORY values(@itemValue,'N')
select @insertParam='Inserted'
end
else
begin
select @insertParam='Failed'

end

end

else if (@SelectedDropDown='Err_Sub_Category')
begin

if not exists (select distinct Error_ID,Error_SubCategory from dbo.KEYING_ERROR_SUB_CATEGORY_MASTER where Error_ID=@SubCatItem and Error_SubCategory=@itemValue)
begin
insert into dbo.KEYING_ERROR_SUB_CATEGORY_MASTER values(@SubCatItem,@itemValue,'N')
select @insertParam='Inserted'
end

else
begin
select @insertParam='Failed'
end

end
--Select
else if (@SelectedDropDown='Select')
begin
select Error_Category  from dbo.KEYING_ERROR_CATEGORY
end
else if (@SelectedDropDown='FetchErr_ID')
begin
select Error_ID  from dbo.KEYING_ERROR_CATEGORY where Error_Category=@SubCatValue
end



GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_Client_select]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_Keyer_Client_select]
(@opType varchar(100)=null,@Facility varchar(250)=null,
@from_Date datetime=null,@to_Date datetime=null)
as begin
if @opType='PageLoad'
begin
--select t.PROJECT_ID,t.BATCH_ID,a.FACILITY as Practice,a.ACCOUNT_NO as [Account #],a.PATIENT_NAME as [Patient Name],convert(varchar(12), a.RECEIVED_DATE,101) as[DOS],t.EDMD,t.KEYER_COMMENTS as [Remarks],
--convert(varchar(12),t.KEYER_DATE,101) as [Keying_date],t.EPA_RESPONSE as[EPA Response],t.RESPONSIBILITY from KEYING_TRANSACTION t join dbo.KEYING_ALLOTMENT a 
--on t.PROJECT_ID=a.PROJECT_ID and t.BATCH_ID=a.BATCH_ID
-- where t.RESPONSIBILITY='EPA' and t.KEYING_STATUS ='PENDING' --( t.EPA_RESPONSE is null or t.EPA_RESPONSE ='')
 
 
 
SELECT DISTINCT t.PROJECT_ID, t.BATCH_ID, t.EDMD, t.KEYER_COMMENTS AS Remarks, CONVERT(varchar(12), t.KEYER_DATE, 101) AS Keying_date, 
               t.EPA_RESPONSE AS [EPA Response], t.RESPONSIBILITY, t.TRANS_ID,
               ts.FACILITY AS Practice, ts.ACCOUNT_NO AS [Account #], ts.PATIENT_NAME AS [Patient Name], CONVERT(varchar(12), ts.RECEIVED_DATE, 101) AS DOS
               ,STUFF((SELECT DISTINCT ', ' + A.PROVIDER_MD FROM Keying_Transaction_Detail A
Where A.BATCH_ID=t.BATCH_ID  FOR XML PATH('')),1,1,'') AS PROVIDER_MD INTO #TEMPTBL 
FROM            KEYING_TRANSACTION AS t join KEYING_ALLOTMENT AS ts on t.BATCH_ID=ts.BATCH_ID
WHERE        (t.RESPONSIBILITY = 'EPA') AND (t.KEYING_STATUS = 'PENDING')

--SELECT   CASE WHEN PROVIDER_MD LIKE '[ ,]%' THEN REPLACE( ELSE PROVIDER_MD END AS PMD,* FROM #TEMPTBL 
SELECT   Provider=case when left(PROVIDER_MD,2)=' ,' then SUBSTRING(PROVIDER_MD,3,LEN(PROVIDER_MD)) else PROVIDER_MD end ,* FROM #TEMPTBL 

DROP TABLE #TEMPTBL

 
 
 end
 
 
else if @opType='Reload'
begin
--select  t.PROJECT_ID,t.BATCH_ID,a.FACILITY as Practice,a.ACCOUNT_NO as [Account #],a.PATIENT_NAME as [Patient Name],convert(varchar(12), a.RECEIVED_DATE,101) as[DOS],t.EDMD,t.KEYER_COMMENTS as [Remarks],
--convert(varchar(12),t.KEYER_DATE,101) as [Keying_date],t.EPA_RESPONSE as[EPA Response],t.RESPONSIBILITY from KEYING_TRANSACTION t join dbo.KEYING_ALLOTMENT a 
--on t.PROJECT_ID=a.PROJECT_ID and t.BATCH_ID=a.BATCH_ID
-- where t.RESPONSIBILITY='EPA' and   t.KEYING_STATUS ='PENDING'
SELECT DISTINCT t.PROJECT_ID, t.BATCH_ID, t.EDMD, t.KEYER_COMMENTS AS Remarks, CONVERT(varchar(12), t.KEYER_DATE, 101) AS Keying_date, 
               t.EPA_RESPONSE AS [EPA Response], t.RESPONSIBILITY, t.TRANS_ID,
               ts.FACILITY AS Practice, ts.ACCOUNT_NO AS [Account #], ts.PATIENT_NAME AS [Patient Name], CONVERT(varchar(12), ts.RECEIVED_DATE, 101) AS DOS
               ,STUFF((SELECT DISTINCT ', ' + A.PROVIDER_MD FROM Keying_Transaction_Detail A
Where A.BATCH_ID=t.BATCH_ID  FOR XML PATH('')),1,1,'') AS PROVIDER_MD INTO #TEMPTBL1 
FROM            KEYING_TRANSACTION AS t join KEYING_ALLOTMENT AS ts on t.BATCH_ID=ts.BATCH_ID
WHERE        (t.RESPONSIBILITY = 'EPA') AND (t.KEYING_STATUS = 'PENDING')
  and 
 
 ((nullif(@Facility,null)is null or [FACILITY]=@Facility)) and
 ((nullif(@from_Date,null)is null or [RECEIVED_DATE]=@from_Date)or 
	((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@from_Date,101) and convert(varchar(12),@to_Date,101)))
	
SELECT   Provider=case when left(PROVIDER_MD,2)=' ,' then SUBSTRING(PROVIDER_MD,3,LEN(PROVIDER_MD)) else PROVIDER_MD end ,* FROM #TEMPTBL1 
	DROP TABLE #TEMPTBL1
end
 end
 
-- exec [usp_Keyer_Client_select] @opType='PageLoad' ,@Facility=null,@from_Date='10/02/2014',@to_Date='10/05/2014'


GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_Client_Update]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[usp_Keyer_Client_Update]

( @eparesponse varchar(500)=null, @response varchar(50)=null,@projectID varchar(50),@batchID varchar(50))
as 
begin
begin tran 


--update by Vishwa----

--if(@response is null)
--begin
--update KEYING_TRANSACTION set EPA_RESPONSE=@eparesponse,RESPONSIBILITY=@response,Pending_Update_From='EPA',CLIENT_UPDATEDATE=GETDATE()
--,KEYING_STATUS='ALLOTTED',QC_STATUS=null where PROJECT_ID=@projectID and BATCH_ID=@batchID

--update KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID=@projectID and BATCH_ID=@batchID


--end

--if @response='Coding' --and @chStatus='Pending'
--begin
--update tbl_TRANSACTION set CODING_STATUS='Pending',QC_STATUS=null,Pending_Updated_By='EPA' where BATCH_ID=@batchid and PROJECT_ID=@projectID --and TRANS_ID=@trans
--update KEYING_ALLOTMENT set BATCH_STATUS=null where PROJECT_ID=@projectID and BATCH_ID=@batchID
----need clarification
--end
---update end------




--update by Vishwa----

if(@response is null)
begin
update KEYING_TRANSACTION set EPA_RESPONSE=@eparesponse,RESPONSIBILITY=@response,Pending_Update_From='EPA',CLIENT_UPDATEDATE=GETDATE()
,KEYING_STATUS='ALLOTTED',QC_STATUS=null where PROJECT_ID=@projectID and BATCH_ID=@batchID

update KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID=@projectID and BATCH_ID=@batchID


end

if @response='Coding' --and @chStatus='Pending'
begin

update CT set CT.CODING_STATUS='Completed',CT.SEND_TO_CODER=null,CT.QC_STATUS=NULL,CT.IS_AUDITED=0,CT.Pending_Updated_By='EPA',CT.KEYING_COMMENTS=@eparesponse,CT.QC_BY=null from tbl_TRANSACTION CT where CT.BATCH_ID=@batchID and CT.PROJECT_ID=@projectid

update  CT set CT.QC_STATUS=NULL,CT.QC_BY=null,BATCH_STATUS='CODED' from dbo.tbl_IMPORT_TABLE CT where CT.PROJECT_ID=@projectid and CT.BATCH_ID=@batchID

--update tbl_TRANSACTION set CODING_STATUS='Pending',QC_STATUS=null,Pending_Updated_By='EPA' where BATCH_ID=@batchid and PROJECT_ID=@projectID --and TRANS_ID=@trans
update KEYING_ALLOTMENT set BATCH_STATUS=null where PROJECT_ID=@projectID and BATCH_ID=@batchID
update KEYING_TRANSACTION set KEYING_STATUS=null where PROJECT_ID=@projectID and BATCH_ID=@batchID
--need clarification
end
---update end------




commit tran
end






GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_Dynamic_Config_Log]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_Keyer_Dynamic_Config_Log](@dmloperation varchar(100)=null,@projectID int =null,@textBoxValue varchar(100)=null,@dropDownValue varchar(400)=null,@insertParam varchar(50) out)
as
if(@dmloperation='add')
begin
if not exists (select distinct REPORT_NAME from dbo.tbl_DYNAMIC_REPORT_LOG where REPORT_NAME=@textBoxValue)
begin
insert into dbo.tbl_DYNAMIC_REPORT_LOG values (@projectID,@textBoxValue)
select @insertParam='INSERTED'
end
else
begin
select @insertParam='INSERTED FAILED'

end
end
else if(@dmloperation='BindDropdown')
begin
select distinct REPORT_ID,REPORT_NAME from dbo.tbl_DYNAMIC_REPORT_LOG 
end

else if(@dmloperation='AdditionalListBox')
begin
select distinct DISPLAY_FIELDS as Display,FIELD_NAME from dbo.tbl_MANDATORY_FIELD where FIELD_NAME not in (select FIELD_NAME from dbo.tbl_DYNAMIC_REPORT_TABLE where PROJECT_ID=@projectID)
union all
select distinct DISPLAY_FIELD_NAME as Display,FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where PROJECT_ID=@projectID and FIELD_NAME not in (select FIELD_NAME from dbo.tbl_DYNAMIC_REPORT_TABLE where PROJECT_ID=@projectID)
end

else if(@dmloperation='FinalListBox')
begin
select  DISPLAY_FIELDS,FIELD_NAME  from dbo.tbl_DYNAMIC_REPORT_TABLE where IS_DELETED='N' and PROJECT_ID=@projectID and REPORT_ID=(select distinct REPORT_ID from dbo.tbl_DYNAMIC_REPORT_LOG where REPORT_NAME=@dropDownValue)
order by REPORT_INDEX --and --and DISPLAY_FIELDS is not null
end

--exec [usp_Keyer_Dynamic_Config_Log] 'FinalListBox',7,null,null,''



GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_Insert_Dynamic_Fields]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

--@ListBoxValue=fieldname
-- =============================================
CREATE PROCEDURE [dbo].[usp_Keyer_Insert_Dynamic_Fields](@dmloperation varchar(100)=null,@PROJECT_ID int=null,@ListBoxValue varchar(100)=null,@taskid int=null,@ReportID int=null,@reportindex int=null,@insertParam varchar(50) out)
as
declare @DisplayField varchar(200),@count int

if(@dmloperation='insert')
begin
if not exists(select FIELD_NAME,TASK_ID from dbo.tbl_DYNAMIC_REPORT_TABLE where PROJECT_ID=@PROJECT_ID and FIELD_NAME=@ListBoxValue and TASK_ID=@taskid)
begin
set @count=(select COUNT(FIELD_NAME) from dbo.tbl_ADDITIONAL_FIELDS where   FIELD_NAME=@ListBoxValue and TASK_ID=@taskid)-- and PROJECT_ID=@PROJECT_ID
if(@count=0)
begin
set @DisplayField=(select distinct DISPLAY_FIELDS from dbo.tbl_MANDATORY_FIELD where TASK_ID=@taskid and FIELD_NAME=@ListBoxValue)
end

else
begin
set @DisplayField=(select distinct DISPLAY_FIELD_NAME from dbo.tbl_ADDITIONAL_FIELDS where FIELD_NAME=@ListBoxValue and TASK_ID=@taskid)--and PROJECT_ID=@PROJECT_ID
end
insert into dbo.tbl_DYNAMIC_REPORT_TABLE (PROJECT_ID,FIELD_NAME,DISPLAY_FIELDS,TASK_ID,REPORT_ID,REPORT_INDEX,IS_DELETED)values(@PROJECT_ID,@ListBoxValue,@DisplayField,@taskid,@ReportID,@reportindex,'N')
select  @DisplayField

end
else
begin
update dbo.tbl_DYNAMIC_REPORT_TABLE set IS_DELETED='N' where PROJECT_ID=@PROJECT_ID and FIELD_NAME=@ListBoxValue and TASK_ID=@taskid
end
end
else if(@dmloperation='update')
begin
update dbo.tbl_DYNAMIC_REPORT_TABLE set IS_DELETED='Y' where PROJECT_ID=@PROJECT_ID and FIELD_NAME=@ListBoxValue and TASK_ID=@taskid

end

else if(@dmloperation='setReportIndex')
begin
update dbo.tbl_DYNAMIC_REPORT_TABLE set REPORT_INDEX=@reportindex where PROJECT_ID=@PROJECT_ID and TASK_ID=@taskid and FIELD_NAME=@ListBoxValue and IS_DELETED='N' and REPORT_ID=@ReportID
end

--exec [usp_Keyer_Insert_Dynamic_Fields] 'insert',7,'age',2,null,null,''

GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_QC_Clarification_Select]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_Keyer_QC_Clarification_Select]
(@facility varchar(200)=null,@Proj int=null,@QCntlg varchar(250)=null)
as
Declare @acctype varchar(200)

set @acctype=(select distinct ACCESS_TYPE from  dbo.tbl_ACCESS_TYPE where ACCESS_TYPE=(select ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@QCntlg))

if @acctype='KEYER-QC-TL'

begin

select ALLOT_ID,KA.BATCH_ID,KA.PROJECT_ID,KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.KEYING_ERROR_CATEGORY as [Error Category],KT.KEYING_ERROR_SUBCATEGORY as [Sub Category],KT.ERROR_COUNT as [Error Count],KT.KEYING_ERROR_COMMENTS+'-' as [Error Comments],KT.RESPONSIBILITY as [Responsibility],KT.CHARGE_STATUS as [Charge Status], ACHNOWLEDGE_COMMENTS AS [clarComments] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KA.PROJECT_ID=@proj and KT.QC_STATUS<>'ALLOTTED' and (nullif(@facility,null)is null or KA.FACILITY=@facility) 
and IS_ACKNOWLEDGE='NO'--(nullif(IS_ACKNOWLEDGE,null)is null or IS_ACKNOWLEDGE='')
and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Completed')

end

else
if @acctype='KEYER-QC'
begin
select ALLOT_ID,KA.BATCH_ID,KA.PROJECT_ID,KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.KEYING_ERROR_CATEGORY as [Error Category],KT.KEYING_ERROR_SUBCATEGORY as [Sub Category],KT.ERROR_COUNT as [Error Count],KT.KEYING_ERROR_COMMENTS+'-' as [Error Comments],KT.RESPONSIBILITY as [Responsibility],KT.CHARGE_STATUS as [Charge Status], ACHNOWLEDGE_COMMENTS AS [clarComments] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KA.PROJECT_ID=@proj and KT.QC_STATUS<>'ALLOTTED' and (nullif(@facility,null)is null or KA.FACILITY=@facility) 
and IS_ACKNOWLEDGE='NO'--(nullif(IS_ACKNOWLEDGE,null)is null or IS_ACKNOWLEDGE='') 
and KT.QC_BY=@QCntlg
and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Completed')

end


GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_QC_Feedback_Select]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_Keyer_QC_Feedback_Select](@facility varchar(200)=null,@Proj int=null,@Keyer varchar(200)=null)
as
select ALLOT_ID,KA.BATCH_ID,KA.PROJECT_ID,KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.ERROR_CORRECTION as [Error Correction], KT.KEYING_ERROR_CATEGORY as [Error Category],KT.KEYING_ERROR_SUBCATEGORY as [Sub Category],KT.ERROR_COUNT as [Error Count],KT.KEYING_ERROR_COMMENTS as [Error Comments],KT.RESPONSIBILITY as [Responsibility],KT.CHARGE_STATUS as [Charge Status],KT.KEYED_BY as [Keyer],KT.QC_BY as [QC] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.KEYED_BY=@Keyer and  KT.ERROR_COUNT>0 and KA.PROJECT_ID=@proj and KT.QC_STATUS<>'ALLOTTED' and (nullif(@facility,null)is null or KA.FACILITY=@facility) 
and (nullif(IS_ACKNOWLEDGE,null)is null or IS_ACKNOWLEDGE='') and KT.KEYING_STATUS='Completed'
and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) )

--exec usp_Keyer_QC_Feedback_Select null,8,'LakshmiV'
GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_QC_Pending_Clarification_Select]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[usp_Keyer_QC_Pending_Clarification_Select]
(@facility varchar(200)=null,@Proj int=null,@accType varchar(250)=null,@QCntlg varchar(250)=null)
as

Declare @acctype1 varchar(200)

set @acctype1=(select distinct ACCESS_TYPE from  dbo.tbl_ACCESS_TYPE where ACCESS_TYPE=(select ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@QCntlg))

if @acctype1='KEYER-QC-TL'

begin
select ALLOT_ID,KA.BATCH_ID,KA.PROJECT_ID,KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.KEYING_ERROR_CATEGORY as [Error Category],KT.KEYING_ERROR_SUBCATEGORY as [Sub Category],KT.ERROR_COUNT as [Error Count],KT.KEYING_ERROR_COMMENTS+'-' as [Error Comments],KT.RESPONSIBILITY as [Responsibility],KT.CHARGE_STATUS as [Charge Status], ACHNOWLEDGE_COMMENTS AS [clarComments] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KA.PROJECT_ID=@proj and KT.QC_STATUS<>'ALLOTTED' and (nullif(@facility,null)is null or KA.FACILITY=@facility) 
and IS_ACKNOWLEDGE='NO'--(nullif(IS_ACKNOWLEDGE,null)is null or IS_ACKNOWLEDGE='')
and  (KT.Pending_Update_From=@accType) 
or 
(

KT.QC_STATUS<>'ALLOTTED' and IS_ACKNOWLEDGE='NO' and 
 ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Completed'))
end

if @acctype1='KEYER-QC'
begin
select ALLOT_ID,KA.BATCH_ID,KA.PROJECT_ID,KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.KEYING_ERROR_CATEGORY as [Error Category],KT.KEYING_ERROR_SUBCATEGORY as [Sub Category],KT.ERROR_COUNT as [Error Count],KT.KEYING_ERROR_COMMENTS+'-' as [Error Comments],KT.RESPONSIBILITY as [Responsibility],KT.CHARGE_STATUS as [Charge Status], ACHNOWLEDGE_COMMENTS AS [clarComments] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KA.PROJECT_ID=@proj and KT.QC_STATUS<>'ALLOTTED' and (nullif(@facility,null)is null or KA.FACILITY=@facility) 
and IS_ACKNOWLEDGE='NO'--(nullif(IS_ACKNOWLEDGE,null)is null or IS_ACKNOWLEDGE='')
and  (KT.Pending_Update_From=@accType and KT.QC_BY=@QCntlg) or 
(

KT.QC_STATUS<>'ALLOTTED' and IS_ACKNOWLEDGE='NO' and 
 ka.Is_Coding_Pending=1	and @accType='Coding'  and KT.QC_BY=@QCntlg and(KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Completed'))

end


--exec [usp_Keyer_QC_Pending_Clarification_Select]null,8,'Coding' ,'Viswajitr'
GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_QC_Pending_Feedback_Select]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  proc [dbo].[usp_Keyer_QC_Pending_Feedback_Select](@facility varchar(200)=null,@Proj int=null,@Keyer varchar(200)=null,@accType varchar(350)=null)
as
select  Pending_Update_From,  ALLOT_ID,KA.BATCH_ID,KA.PROJECT_ID,KA.BATCH_NAME as [Batch Name],KA.FACILITY as [Facility],KA.RECEIVED_DATE as [Dos],KA.ACCOUNT_NO as [Patient ID],KT.ERROR_CORRECTION as [Error Correction], KT.KEYING_ERROR_CATEGORY as [Error Category],KT.KEYING_ERROR_SUBCATEGORY as [Sub Category],KT.ERROR_COUNT as [Error Count],KT.KEYING_ERROR_COMMENTS as [Error Comments],KT.RESPONSIBILITY as [Responsibility],KT.CHARGE_STATUS as [Charge Status],KT.KEYED_BY as [Keyer],KT.QC_BY as [QC] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID
where KT.KEYED_BY=@Keyer and  KT.ERROR_COUNT>0 and KA.PROJECT_ID=@proj and KT.QC_STATUS<>'ALLOTTED' and (nullif(@facility,null)is null or KA.FACILITY=@facility) 
and (nullif(IS_ACKNOWLEDGE,null)is null or IS_ACKNOWLEDGE='') 
and KT.KEYING_STATUS='Completed'
and  (KT.Pending_Update_From=@accType ) or ( (nullif(IS_ACKNOWLEDGE,null)is null or IS_ACKNOWLEDGE='') and KT.ERROR_COUNT>0 and KA.ALLOTED_TO=@Keyer and KT.KEYED_BY=@Keyer and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' )and KT.KEYING_STATUS='Completed' )
--
--exec [usp_Keyer_QC_Pending_Feedback_Select] null,8,'LakshmiV','Coding'
GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_QC_Select_Production_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[usp_Keyer_QC_Select_Production_Report](@Projid int=null,@Query varchar(max)=null,@operation varchar(250)=null,
@Facility varchar(300)=null,@Batch_name varchar(300)=null,@keyerDate datetime=null,
@FromDos datetime=null,@toDos datetime=null,@Keyer varchar(200)=null,@skip varchar(10)=null,
@KeyingStatus varchar(200)=null,@ProviderMD varchar(300)=null,@BillerName varchar(300)=null,@ntlg varchar(200)=null,@EnteredDate datetime=null)
as

Declare @sql nvarchar(max)
Declare @paramList nvarchar(max)
--set @operation=5
Declare @acctype varchar(200)

set @keyerDate=CONVERT(varchar(12),@keyerDate,101)
set @FromDos=CONVERT(varchar(12),@FromDos,101)
set @toDos=CONVERT(varchar(12),@toDos,101)
set @acctype=(select distinct ACCESS_TYPE from  dbo.tbl_ACCESS_TYPE where ACCESS_TYPE in (select ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@Keyer))

--set @Query='BATCH_NAME As [Batch Name /File Name],CODING_COMMENTS As [CODING COMMENTS],CPT As [CPT],FACILITY As [FACILITY],ICD As [ICD],LOCATION As [LOCATION],MODIFIER As [MODIFIER],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY],ATTENDING_PHY As [ATTENDING PHY],PATIENT_NAME As [Patient Name],ACCOUNT_NO As [ACCOUNT NO],KEYER_COMMENTS As [Keying Comments],CODED_DATE As [CODED DATE],ADMITTING_PHY As [ADMITTING PHY],CODER_NTLG As [CODED BY],Charge_Status As [Charge Status],INSURANCE As [INSURANCE],Responsibility As [Responsibility]'


--set @Query='ACCOUNT_NO As [ACCOUNT NO],ATTENDING_PHY As [ATTENDING PHY],CODER_NTLG As [CODED BY],CODED_DATE As [CODED DATE],KEYER_COMMENTS As [Keying Comments],PATIENT_NAME As [Patient Name],BATCH_NAME As [Batch Name /File Name],CODING_COMMENTS As [CODING COMMENTS],CPT As [CPT],FACILITY As [FACILITY],ICD As [ICD],LOCATION As [LOCATION],MODIFIER As [MODIFIER],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY]'
if @Query like '%DISPOSITION As%'
begin
set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
end


if @acctype='KEYER-TL' or @acctype='KEYER MANAGER' or @acctype='CLIENT' or @acctype='keyer-qc-tl'
begin
set @sql='Select KT.PROJECT_ID,KT.BATCH_ID, KT.QC_BY as QC,QC_status=case when IS_SKIPPED=''y'' then ''Skipped'' else ''Completed'' end,Convert(varchar(12),KT.QC_DATE,101) as [QCed Date],KT.KEYED_BY as [Biller],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo ,KT.RESPONSIBILITY,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
           where KT.QC_STATUS=''Completed'' and KT.PROJECT_ID=@Projid And 
           
           KA.BATCH_NAME=case when @Batch_name is not null then @Batch_name else  KA.BATCH_NAME end And
           FACILITY= case when @Facility is not null then @Facility else  FACILITY end And
           convert(varchar(12),KT.QC_DATE,101)= case when @keyerDate is not null then @keyerDate else  convert(varchar(12),KT.QC_DATE,101) end And
           KTD.PROVIDER_MD= case when @ProviderMD is not null then  @ProviderMD else KTD.PROVIDER_MD  end And
           KT.KEYED_BY=case when @BillerName is not null then  @BillerName  else KT.KEYED_BY end And
           [IS_SKIPPED]=case when @skip is not null and   @skip=''Skipped'' then ''Y'' else [IS_SKIPPED] end And
           KT.QC_BY=case when @Keyer is not null and @ntlg is not null then @Keyer else KT.QC_BY end
           
           '
         if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And  convert(varchar(12),[RECEIVED_DATE],101) = @FromDos '
	end  
           
           
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And  convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
		if @EnteredDate is not null
	begin
	  set @sql=@sql+' And convert(varchar(12),KT.KEYER_DATE,101)=convert(varchar(12),@EnteredDate,101)'
	
	end
	

	
	set @sql='Select * from  ('+@sql+')as tbl
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'
	end
	
	else
	begin
	set @sql='Select KT.PROJECT_ID,KT.BATCH_ID, KT.QC_BY as QC,QC_status=case when IS_SKIPPED=''y'' then ''Skipped'' else ''Completed'' end,convert(varchar(12),KT.QC_DATE,101) as [QCed Date],KT.KEYED_BY as [Biller],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo ,KT.RESPONSIBILITY,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
           where KT.QC_STATUS=''Completed'' and KT.PROJECT_ID=@Projid And
            KA.BATCH_NAME=case when @Batch_name is not null then @Batch_name else  KA.BATCH_NAME end And
           FACILITY= case when @Facility is not null then @Facility else  FACILITY end And
           convert(varchar(12),KT.QC_DATE,101)= case when @keyerDate is not null then @keyerDate else  convert(varchar(12),KT.QC_DATE,101) end And
           KTD.PROVIDER_MD= case when @ProviderMD is not null then  @ProviderMD else KTD.PROVIDER_MD  end And
           KT.KEYED_BY=case when @BillerName is not null then  @BillerName  else KT.KEYED_BY end And
          
           [IS_SKIPPED]=case when @skip is not null and   @skip=''Skipped'' then ''Y'' else [IS_SKIPPED] end And
           KT.QC_BY=case when @Keyer is not null then @Keyer else KT.QC_BY end
           '
          
          
          
	 if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And  convert(varchar(12),[RECEIVED_DATE],101) = @FromDos '
	end  
           
           
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And  convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
		if @EnteredDate is not null
	begin
	  set @sql=@sql+' And convert(varchar(12),KT.KEYER_DATE,101)=convert(varchar(12),@EnteredDate,101)'
	
	end
	
	
	 if @skip='Auditted'
	begin
	set @sql=@sql+' And [IS_SKIPPED]<>''Y'''
	end

	set @sql='Select * from  ('+@sql+')as tbl
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'

	end
           


set @paramList='@Projid int=null,@Query varchar(max)=null,@operation varchar(250)=null,@Facility varchar(300)=null,@Batch_name varchar(300)=null,@keyerDate datetime=null,@FromDos datetime=null,@toDos datetime=null,@Keyer varchar(200)=null,@skip varchar(10)=null,@KeyingStatus varchar(200)=null,@ProviderMD varchar(300)=null,@BillerName varchar(300)=null,@ntlg varchar(200)=null,@EnteredDate datetime=null'

execute sp_executesql @sql,@paramList,@Projid,@Query,@operation,@Facility ,@Batch_name,@keyerDate,@FromDos,@toDos,@Keyer,@skip,@KeyingStatus,@ProviderMD,@BillerName,@ntlg,@EnteredDate



--exec [usp_Keyer_QC_Select_Production_Report_Optimsed] 8,'ACCOUNT_NO As [ACCOUNT NO],AGE As [AGE],Charge_Status As [Charge Status],CODER_NTLG As [CODED BY],IS_AUDITED As [Coder Audited],INSURANCE As [INSURANCE],KEYER_COMMENTS As [Keying Comments],PATIENT_NAME As [Patient Name],BATCH_NAME As [Batch Name],RECEIVED_DATE As [RECEIVED_DATE],CODING_COMMENTS As [CODING COMMENTS],SPECIALITY As [SPECIALITY],FACILITY As [FACILITY],LOCATION As [LOCATION],CPT As [CPT],ICD As [ICD],MODIFIER As [MODIFIER]',
--null,null,null,'04-29-2015',null,null,'Khadirk','Auditted',null


GO
/****** Object:  StoredProcedure [dbo].[usp_Keyer_Select_Production_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Keyer_Select_Production_Report](@Projid int=null,
@Query varchar(max)=null,@operation varchar(250)=null,@ProviderMD varchar(300)=null,
@Facility varchar(300)=null,@Batch_name varchar(300)=null,@keyerDate datetime=null,
@FromDos datetime=null,@toDos datetime=null,@Keyer varchar(200)=null,@skip varchar(10)=null,
@KeyingStatus varchar(200)=null,@BillerName varchar(300)=null)
as

Declare @sql nvarchar(max)
Declare @paramList nvarchar(max)
set @keyerDate=CONVERT(varchar(12),@keyerDate,101)
set @FromDos=CONVERT(varchar(12),@FromDos,101)
set @toDos=CONVERT(varchar(12),@toDos,101)

Declare @acctype varchar(200)

set @acctype=(select distinct ACCESS_TYPE from  dbo.tbl_ACCESS_TYPE where ACCESS_TYPE=(select ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@Keyer))
--set @operation=5

----set @Query='BATCH_NAME As [Batch Name /File Name],CODING_COMMENTS As [CODING COMMENTS],CPT As [CPT],FACILITY As [FACILITY],ICD As [ICD],LOCATION As [LOCATION],MODIFIER As [MODIFIER],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY],ATTENDING_PHY As [ATTENDING PHY],PATIENT_NAME As [Patient Name],ACCOUNT_NO As [ACCOUNT NO],KEYER_COMMENTS As [Keying Comments],CODED_DATE As [CODED DATE],ADMITTING_PHY As [ADMITTING PHY],CODER_NTLG As [CODED BY],Charge_Status As [Charge Status],INSURANCE As [INSURANCE],Responsibility As [Responsibility]'


--set @Query='ACCOUNT_NO As [ACCOUNT NO],ATTENDING_PHY As [ATTENDING PHY],CODER_NTLG As [CODED BY],CODED_DATE As [CODED DATE],KEYER_COMMENTS As [Keying Comments],PATIENT_NAME As [Patient Name],BATCH_NAME As [Batch Name /File Name],CODING_COMMENTS As [CODING COMMENTS],CPT As [CPT],FACILITY As [FACILITY],ICD As [ICD],LOCATION As [LOCATION],MODIFIER As [MODIFIER],RECEIVED_DATE As [RECEIVED_DATE],SPECIALITY As [SPECIALITY]'
if @Query like '%DISPOSITION As%'
begin
set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
end

if @acctype='KEYER-TL' or @acctype='KEYER MANAGER'
begin

if @KeyingStatus='Completed'
begin
set @sql='Select KT.PROJECT_ID,KT.BATCH_ID,KT.KEYED_BY,KT.KEYER_DATE as [Keyed Date],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo ,KT.Pending_Update_From as Responsibility ,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],KT.DOS_CHANGED as [Dos Changed Comments],  KT.SHARD_VISIT AS [Shared Visit], KA.DISPOSITION, KT.PATIENT_STATUS AS [Patient Status], KT.DOI, KT.TOI, KT.TYPE_OF_ACCIDENT AS [Accident Type], KA.CODED_DATE AS [Coded Date]
,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
           where KEYING_STATUS = @KeyingStatus and KA.PROJECT_ID=@Projid'
           if(@Batch_name is not null)
           begin
           set @sql=@sql+' And KA.BATCH_NAME=@Batch_name'
           end
           if(@Facility is not null)
           begin
           set @sql=@sql+' And FACILITY=@Facility'
           end
           if(@keyerDate is not null)
           begin
           set @sql=@sql+' And convert(varchar(12),KEYER_DATE,101)=@keyerDate'
           end
           
           
           if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101)=@FromDos'
	end
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
	--set @sql='Select * from ('+@sql+') as tabl1
	--pivot 
	--(
	--max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,ICD9)
	--) as PivotTable'
	
	set @sql='Select * from  ('+@sql+')as tbl
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'
	
    end
    
    if @KeyingStatus='Pending'
begin
set @sql='Select KT.PROJECT_ID,KT.BATCH_ID,KT.KEYED_BY,KT.KEYER_DATE as [Keyed Date],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo ,KT.Responsibility ,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],KT.DOS_CHANGED as [Dos Changed Comments], KT.SHARD_VISIT AS [Shared Visit], KA.DISPOSITION, KT.PATIENT_STATUS AS [Patient Status], KT.DOI, KT.TOI, KT.TYPE_OF_ACCIDENT AS [Accident Type], KA.CODED_DATE AS [Coded Date]
,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
           where KEYING_STATUS = @KeyingStatus and KA.PROJECT_ID=@Projid'
           if(@Batch_name is not null)
           begin
           set @sql=@sql+' And KA.BATCH_NAME=@Batch_name'
           end
           if(@Facility is not null)
           begin
           set @sql=@sql+' And FACILITY=@Facility'
           end
           if(@keyerDate is not null)
           begin
           set @sql=@sql+' And convert(varchar(12),KEYER_DATE,101)=@keyerDate'
           end
           
           --if(@Keyer is not null)
           --begin
           --set @sql=@sql+' And KEYED_BY=@Keyer'
           --end
           if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101)=@FromDos'
	end
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
	--set @sql='Select * from ('+@sql+') as tabl1
	--pivot 
	--(
	--max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,ICD9)
	--) as PivotTable'
	
	set @sql='Select * from  ('+@sql+')as tbl
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'
	
    end
       if @KeyingStatus='Hold'
begin
set @sql='Select KT.PROJECT_ID,KT.BATCH_ID,KT.KEYED_BY,KT.KEYER_DATE as [Keyed Date],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo ,KT.Responsibility ,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],KT.DOS_CHANGED as [Dos Changed Comments], KT.SHARD_VISIT AS [Shared Visit], KA.DISPOSITION, KT.PATIENT_STATUS AS [Patient Status], KT.DOI, KT.TOI, KT.TYPE_OF_ACCIDENT AS [Accident Type], KA.CODED_DATE AS [Coded Date]
,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
           where KEYING_STATUS = @KeyingStatus and KA.PROJECT_ID=@Projid'
           if(@Batch_name is not null)
           begin
           set @sql=@sql+' And KA.BATCH_NAME=@Batch_name'
           end
           if(@Facility is not null)
           begin
           set @sql=@sql+' And FACILITY=@Facility'
           end
           if(@keyerDate is not null)
           begin
           set @sql=@sql+' And convert(varchar(12),KEYER_DATE,101)=@keyerDate'
           end
           
           --if(@Keyer is not null)
           --begin
           --set @sql=@sql+' And KEYED_BY=@Keyer'
           --end
           if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101)=@FromDos'
	end
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
	--set @sql='Select * from ('+@sql+') as tabl1
	--pivot 
	--(
	--max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,ICD9)
	--) as PivotTable'
	
	set @sql='Select * from  ('+@sql+')as tbl
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'
	
    end
    
    end
    
    else 
    
    begin
    if @KeyingStatus='Completed'
    begin
    set @sql='Select KT.PROJECT_ID,KT.BATCH_ID,KT.KEYED_BY,KT.KEYER_DATE as [Keyed Date],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.Pending_Update_From as Responsibility ,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],KT.DOS_CHANGED as [Dos Changed Comments], KT.SHARD_VISIT AS [Shared Visit], KA.DISPOSITION, KT.PATIENT_STATUS AS [Patient Status], KT.DOI, KT.TOI, KT.TYPE_OF_ACCIDENT AS [Accident Type], KA.CODED_DATE AS [Coded Date]
,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
          where KEYING_STATUS in ('+'@KeyingStatus' +')  and KA.PROJECT_ID=@Projid'
           -- where KEYING_STATUS in ('+'@KeyingStatus' +')  and KA.PROJECT_ID=@Projid
           if(@Batch_name is not null)
           begin
           set @sql=@sql+' And KA.BATCH_NAME=@Batch_name'
           end
           if(@Facility is not null)
           begin
           set @sql=@sql+' And FACILITY=@Facility'
           end
           if(@keyerDate is not null)
           begin
           --set @sql=@sql+' And KEYER_DATE=@keyerDate'
           set @sql=@sql+' And convert(varchar(12),KEYER_DATE,101)=@keyerDate'
           end
           
           if(@Keyer is not null)
           begin
           set @sql=@sql+' And KEYED_BY=@Keyer'
           end
           if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101)=@FromDos'
	end
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
	--set @sql='Select * from ('+@sql+') as tabl1
	--pivot 
	--(
	--max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,ICD9)
	--) as PivotTable'
	
	
	--commented by vishwa
	set @sql='Select * from  ('+@sql+')as tbl
	
	
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'
    end 
    
    
    else if @KeyingStatus='Pending'
    begin
    set @sql='Select KT.PROJECT_ID,KT.BATCH_ID,KT.KEYED_BY,KT.KEYER_DATE as [Keyed Date],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.Responsibility ,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],KT.DOS_CHANGED as [Dos Changed Comments],  KT.SHARD_VISIT AS [Shared Visit], KA.DISPOSITION, KT.PATIENT_STATUS AS [Patient Status], KT.DOI, KT.TOI, KT.TYPE_OF_ACCIDENT AS [Accident Type], KA.CODED_DATE AS [Coded Date]
,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
          where KEYING_STATUS in ('+'@KeyingStatus' +')  and KA.PROJECT_ID=@Projid'
           -- where KEYING_STATUS in ('+'@KeyingStatus' +')  and KA.PROJECT_ID=@Projid
           if(@Batch_name is not null)
           begin
           set @sql=@sql+' And KA.BATCH_NAME=@Batch_name'
           end
           if(@Facility is not null)
           begin
           set @sql=@sql+' And FACILITY=@Facility'
           end
           if(@keyerDate is not null)
           begin
           --set @sql=@sql+' And KEYER_DATE=@keyerDate'
           set @sql=@sql+' And convert(varchar(12),KEYER_DATE,101)=@keyerDate'
           end
           
           if(@Keyer is not null)
           begin
           set @sql=@sql+' And KEYED_BY=@Keyer'
           end
           if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101)=@FromDos'
	end
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
	--set @sql='Select * from ('+@sql+') as tabl1
	--pivot 
	--(
	--max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,ICD9)
	--) as PivotTable'
	
	
	--commented by vishwa
	set @sql='Select * from  ('+@sql+')as tbl
	
	
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'
    
    end
    
    
      else if @KeyingStatus='Hold'
    begin
    set @sql='Select KT.PROJECT_ID,KT.BATCH_ID,KT.KEYED_BY,KT.KEYER_DATE as [Keyed Date],KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.Responsibility ,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KTD.DOWNLOADING_COMMENTS as [Down Coding Comments],KT.DOS_CHANGED as [Dos Changed Comments],  KT.SHARD_VISIT AS [Shared Visit], KA.DISPOSITION, KT.PATIENT_STATUS AS [Patient Status], KT.DOI, KT.TOI, KT.TYPE_OF_ACCIDENT AS [Accident Type], KA.CODED_DATE AS [Coded Date]
,'+@Query+',''ICD''+cast(row_number() over(PARTITION BY ACCOUNT_NO,CPT,MODIFIER,CPT_ORDER
			ORDER BY ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
          where KEYING_STATUS in ('+'@KeyingStatus' +')  and KA.PROJECT_ID=@Projid'
           -- where KEYING_STATUS in ('+'@KeyingStatus' +')  and KA.PROJECT_ID=@Projid
           if(@Batch_name is not null)
           begin
           set @sql=@sql+' And KA.BATCH_NAME=@Batch_name'
           end
           if(@Facility is not null)
           begin
           set @sql=@sql+' And FACILITY=@Facility'
           end
           if(@keyerDate is not null)
           begin
           --set @sql=@sql+' And KEYER_DATE=@keyerDate'
           set @sql=@sql+' And convert(varchar(12),KEYER_DATE,101)=@keyerDate'
           end
           
           if(@Keyer is not null)
           begin
           set @sql=@sql+' And KEYED_BY=@Keyer'
           end
           if @FromDos is not null and @toDos is null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101)=@FromDos'
	end
	if @FromDos is not null and @toDos is not null
	begin
	set @sql=@sql+' And convert(varchar(12),[RECEIVED_DATE],101) between @FromDos and @toDos'
	end
	
	--set @sql='Select * from ('+@sql+') as tabl1
	--pivot 
	--(
	--max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,ICD9)
	--) as PivotTable'
	
	
	--commented by vishwa
	set @sql='Select * from  ('+@sql+')as tbl
	
	
	PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE
order by BATCH_ID,CPT_ORDER'
    
    end
    
    end     


--set @paramList='@Projid int=null,@Query varchar(max)=null,@operation varchar(250)=null,@Facility varchar(300)=null,@Batch_name varchar(300)=null,@keyerDate datetime=null,@FromDos datetime=null,@toDate datetime=null,@Keyer varchar(200)'


set @paramList='@Projid int=null,@Query varchar(max)=null,@operation varchar(250)=null,
@Facility varchar(300)=null,@Batch_name varchar(300)=null,@keyerDate datetime=null,
@FromDos datetime=null,@toDos datetime=null,@Keyer varchar(200)=null,@skip varchar(200)=null,@KeyingStatus varchar(200)=null,@BillerName varchar(300)=null'
execute sp_executesql @sql,@paramList,@Projid,@Query,@operation,@Facility ,@Batch_name,@keyerDate,@FromDos,@toDos,@Keyer,@skip,@KeyingStatus,@BillerName

--exec usp_Keyer_Select_Production_Report 8,null,null,null,null,'02/16/2015',null,null,'MohammedQ','','Completed'



GO
/****** Object:  StoredProcedure [dbo].[usp_pc_production_report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_pc_production_report]
(@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
@KeyedDate datetime=null,@Query nvarchar(max)=null,@ntlg varchar(100)=null,@acc varchar(300)=null)
as
Declare @sql nvarchar(max)
Declare @ParamList nvarchar(max)

Declare @acctype varchar(200)

set @acctype=(select distinct ACCESS_TYPE from  dbo.tbl_ACCESS_TYPE where ACCESS_TYPE=(select ACCESS_TYPE from dbo.tbl_USER_ACCESS where USER_NTLG=@ntlg))

if @RepType='patientCalling' and @ChargeStatus='Completed'

begin
set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,'+@Query+',KT.Pending_Update_From,KT.PC_Assign_Status as [PC Status],KT.PC_Assign_To as [PC By],KT.PC_Completed_Date as [PC Date] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where KT.PROJECT_ID=@Projid and KT.Pending_Update_From=''PatientCalling'' and KT.PC_Assign_Status=''Completed''  and @ntlg is not null'

--if @Responsibility is not null
--begin
----set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
--set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

--end


--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

if (@FromDos is not null and @Todos is null)
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And convert(varchar(12),PC_Completed_Date,101)=@KeyedDate'
	end
	
	if @ntlg is not null
	begin
	if @acctype='Patient Calling'
	begin
		set @sql=@sql+' And PC_Assign_To=@ntlg'

	end
	
	
	end
	
	if @acc is not null
	begin
	set @sql=@sql+' And KA.ACCOUNT_NO=@acc'
	end
	
end

if @RepType='patientCalling' and @ChargeStatus='Pending'

begin
set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,'+@Query+',KT.PC_Assign_Status,KT.PC_Assign_To as [PC By],KT.PC_Completed_Date as [PC Date] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where KT.PROJECT_ID=@Projid and PC_Assign_Status in (''Fresh'',''Allotted'',''Hold'') And KT.RESPONSIBILITY=''Patient Calling'' and @ntlg is not null'

--if @Responsibility is not null
--begin
--set @sql=@sql+' And KT.RESPONSIBILITY=''Patient Calling'''

--end
if @ChargeStatus is not null
begin
set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
end

if @Facility is not null
begin
set @sql=@sql+' And FACILITY=@Facility'

end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And convert(varchar(12),PC_Completed_Date,101)=@KeyedDate'
	end
	
	if @ntlg is not null
	begin
	if @acctype='Patient Calling'
	begin
		set @sql=@sql+' And PC_Assign_To=@ntlg'

	end
	
	
	end
	
	--if @acc is not null
	--begin
	--set @sql=@sql+' And ACCOUNT_NO=@acc'
	--end
	
end

set @ParamList='@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
@KeyedDate datetime=null,@Query nvarchar(max)=null,@ntlg varchar(100)=null,@acc varchar(300)=null'
exec sp_executesql @sql,@ParamList,@RepType,@Projid,@Facility,@FromDos,@Todos,@Responsibility,@ChargeStatus,@KeyedDate,@Query,@ntlg,@acc


--exec [usp_pc_production_report] 'patientCalling',8,null,null,null,null,'Completed',null,'PATIENT_NAME As [Patient Name],KEYER_COMMENTS As [Comments],AGE As [AGE],ACCOUNT_NO As [Pat_ID],CHARGE_STATUS As [Charge Status],FACILITY As [FAC],PATIENT_CALLING_COMMENTS As [Pt Calling Comments],RECEIVED_DATE As [DOS],RESPONSIBILITY As [Responsibility]','Viswajitr',null
GO
/****** Object:  StoredProcedure [dbo].[USP_PRODUCTION_SUMMARY]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_PRODUCTION_SUMMARY]
	
	@FromDate varchar(100),
	@ToDate varchar (100),
	@CoderName varchar (100),
	@Project varchar(100)

AS
BEGIN
	
	DECLARE @DataSet Time_Tracker_Production_Summary
	
	
	IF(@Project != '') AND (@Project != 'Select Project')
	
	BEGIN
	
	INSERT INTO @DataSet 
	
		SELECT NTLG,M.CLIENT_LOGIN,INVOICE_COUNT,TIME_SLOT,convert(varchar,(CONVERT(date,UPDATED_DATE,103)),103) AS UPDATED_DATE,MM.PROJECT
		from Time_Tracker_MSI M, MSI_MAPPING_TABLE MM
		WHERE M.NTLG = MM.SYSTEM_LOGIN
		AND MM.PROJECT = @Project
		order by NTLG,M.CLIENT_LOGIN,UPDATED_DATE
    END   
     
    ELSE
    
    BEGIN    
    
	INSERT INTO @DataSet 
	
		SELECT NTLG,M.CLIENT_LOGIN,INVOICE_COUNT,TIME_SLOT,convert(varchar,(CONVERT(date,UPDATED_DATE,103)),103) AS UPDATED_DATE ,MM.PROJECT
		from Time_Tracker_MSI M, MSI_MAPPING_TABLE MM
		WHERE M.NTLG = MM.SYSTEM_LOGIN		
		order by NTLG,M.CLIENT_LOGIN,UPDATED_DATE
    
    END 

IF(@FromDate != '') AND (@ToDate != '') AND (@CoderName != '') 

	BEGIN

		SELECT * FROM (SELECT NTLG,CLIENT_LOGIN,UPDATED_DATE, 
				
		CASE WHEN ([06:00AM to 07:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[06:00AM to 07:00AM]) End as Header1,
		CASE WHEN ([07:00AM to 08:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[07:00AM to 08:00AM]) End as Header2,
		CASE WHEN ([08:00AM to 09:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[08:00AM to 09:00AM]) End as Header3,
		CASE WHEN ([09:00AM to 10:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[09:00AM to 10:00AM]) End as Header4,
		CASE WHEN ([10:00AM to 11:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[10:00AM to 11:00AM]) End as Header5,
		CASE WHEN ([11:00AM to 12:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[11:00AM to 12:00PM]) End as Header6,
		CASE WHEN ([12:00PM to 01:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[12:00PM to 01:00PM]) End as Header7,
		CASE WHEN ([01:00PM to 02:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[01:00PM to 02:00PM]) End as Header8,
		CASE WHEN ([02:00PM to 03:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[02:00PM to 03:00PM]) End as Header9,		
        CASE WHEN (Others) IS NULL THEN '_' else CONVERT(varchar(100),Others) End as Header10,	
        	
		SUM(isnull([06:00AM to 07:00AM],0) + isnull([07:00AM to 08:00AM],0) + isnull([08:00AM to 09:00AM],0) +isnull([09:00AM to 10:00AM],0)+ isnull([10:00AM to 11:00AM],0)+
		isnull([11:00AM to 12:00PM],0)+ isnull([12:00PM to 01:00PM],0) +
		isnull([01:00PM to 02:00PM],0) + isnull([02:00PM to 03:00PM],0) + ISNULL(others,0)) as Total
		from @DataSet  
		PIVOT(SUM(INVOICE_COUNT)
		FOR TIME_SLOT IN ([06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],[01:00PM to 02:00PM],
		[02:00PM to 03:00PM],Others)
		) AS PivotSales
		where UPDATED_DATE between @FromDate and @ToDate
		AND NTLG = @CoderName		
		group by NTLG,CLIENT_LOGIN,UPDATED_DATE,[06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],[01:00PM to 02:00PM],[02:00PM to 03:00PM], Others) as aa
		order by NTLG,CLIENT_LOGIN,UPDATED_DATE

END

ELSE IF (@FromDate != '') AND (@ToDate != '')

BEGIN


 SELECT * FROM (SELECT NTLG,CLIENT_LOGIN,UPDATED_DATE, 
 		CASE WHEN ([06:00AM to 07:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[06:00AM to 07:00AM]) End as Header1,
		CASE WHEN ([07:00AM to 08:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[07:00AM to 08:00AM]) End as Header2,
		CASE WHEN ([08:00AM to 09:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[08:00AM to 09:00AM]) End as Header3,
		CASE WHEN ([09:00AM to 10:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[09:00AM to 10:00AM]) End as Header4,
		CASE WHEN ([10:00AM to 11:00AM]) IS NULL THEN '_' else CONVERT(varchar(100),[10:00AM to 11:00AM]) End as Header5,
		CASE WHEN ([11:00AM to 12:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[11:00AM to 12:00PM]) End as Header6,
		CASE WHEN ([12:00PM to 01:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[12:00PM to 01:00PM]) End as Header7,
		CASE WHEN ([01:00PM to 02:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[01:00PM to 02:00PM]) End as Header8,
		CASE WHEN ([02:00PM to 03:00PM]) IS NULL THEN '_' else CONVERT(varchar(100),[02:00PM to 03:00PM]) End as Header9,
		CASE WHEN (Others) IS NULL THEN '_' else CONVERT(varchar(100),Others) End as Header10,	
		SUM(isnull([06:00AM to 07:00AM],0) + isnull([07:00AM to 08:00AM],0) + isnull([08:00AM to 09:00AM],0) +isnull([09:00AM to 10:00AM],0)+ isnull([10:00AM to 11:00AM],0)+
		isnull([11:00AM to 12:00PM],0)+ isnull([12:00PM to 01:00PM],0) +
		isnull([01:00PM to 02:00PM],0) + isnull([02:00PM to 03:00PM],0)) as Total
		from @DataSet  
		PIVOT(SUM(INVOICE_COUNT)
		FOR TIME_SLOT IN ([06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],
		[01:00PM to 02:00PM],[02:00PM to 03:00PM],Others)
		) AS PivotSales
		where UPDATED_DATE between @FromDate and @ToDate		
		group by NTLG,CLIENT_LOGIN,UPDATED_DATE,[06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],[01:00PM to 02:00PM],[02:00PM to 03:00PM],Others) as aa
		order by NTLG,CLIENT_LOGIN,UPDATED_DATE
		

END 
  
  
  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_PRODUCTION_SUMMARY1]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_PRODUCTION_SUMMARY1]
	
	@FromDate varchar(100),
	@ToDate varchar (100),
	@CoderName varchar (100),
	@Project varchar(100)

AS
BEGIN
	
	DECLARE @DataSet Time_Tracker_Production_Summary
	
	
	IF(@Project != '') AND (@Project != 'Select Project')
	
	BEGIN
	
	INSERT INTO @DataSet 
	
		SELECT NTLG,M.CLIENT_LOGIN,INVOICE_COUNT,TIME_SLOT,convert(varchar,(CONVERT(date,UPDATED_DATE,103)),103) AS UPDATED_DATE,MM.PROJECT
		from Time_Tracker_MSI M, MSI_MAPPING_TABLE MM
		WHERE M.NTLG = MM.SYSTEM_LOGIN
		AND MM.PROJECT = @Project
		order by NTLG,M.CLIENT_LOGIN,UPDATED_DATE
    END   
     
    ELSE
    
    BEGIN    
    
	INSERT INTO @DataSet 
	
		SELECT NTLG,M.CLIENT_LOGIN,INVOICE_COUNT,TIME_SLOT,convert(varchar,(CONVERT(date,UPDATED_DATE,103)),103) AS UPDATED_DATE ,MM.PROJECT
		from Time_Tracker_MSI M, MSI_MAPPING_TABLE MM
		WHERE M.NTLG = MM.SYSTEM_LOGIN
		order by NTLG,M.CLIENT_LOGIN,UPDATED_DATE
    
    END 

IF(@FromDate != '') AND (@ToDate != '') AND (@CoderName != '') 

	BEGIN

		SELECT * FROM (SELECT NTLG,CLIENT_LOGIN,UPDATED_DATE, isnull([06:00AM to 07:00AM],0) as Header1,
		isnull([07:00AM to 08:00AM],0) as Header2,isnull([08:00AM to 09:00AM],0) as Header3,
		isnull([09:00AM to 10:00AM],0) as Header4,isnull([10:00AM to 11:00AM],0) as Header5,
		isnull([11:00AM to 12:00PM],0) as Header6,isnull([12:00PM to 01:00PM],0) as Header7,
		isnull([01:00PM to 02:00PM],0) as Header8,isnull([02:00PM to 03:00PM],0) as Header9,
		SUM(isnull([06:00AM to 07:00AM],0) + isnull([07:00AM to 08:00AM],0) + isnull([08:00AM to 09:00AM],0) +isnull([09:00AM to 10:00AM],0)+ isnull([10:00AM to 11:00AM],0)+
		isnull([11:00AM to 12:00PM],0)+ isnull([12:00PM to 01:00PM],0) +
		isnull([01:00PM to 02:00PM],0) + isnull([02:00PM to 03:00PM],0)) as Total
		from @DataSet  
		PIVOT(SUM(INVOICE_COUNT)
		FOR TIME_SLOT IN ([06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],[01:00PM to 02:00PM],[02:00PM to 03:00PM])
		) AS PivotSales
		where UPDATED_DATE between @FromDate and @ToDate
		AND NTLG = @CoderName		
		group by NTLG,CLIENT_LOGIN,UPDATED_DATE,[06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],[01:00PM to 02:00PM],[02:00PM to 03:00PM]) as aa
		order by NTLG,CLIENT_LOGIN,UPDATED_DATE

END

ELSE IF (@FromDate != '') AND (@ToDate != '')

BEGIN


 SELECT * FROM (SELECT NTLG,CLIENT_LOGIN,UPDATED_DATE, isnull([06:00AM to 07:00AM],0) as Header1,
		isnull([07:00AM to 08:00AM],0) as Header2,isnull([08:00AM to 09:00AM],0) as Header3,
		isnull([09:00AM to 10:00AM],0) as Header4,isnull([10:00AM to 11:00AM],0) as Header5,
		isnull([11:00AM to 12:00PM],0) as Header6,isnull([12:00PM to 01:00PM],0) as Header7,
		isnull([01:00PM to 02:00PM],0) as Header8,isnull([02:00PM to 03:00PM],0) as Header9,
		SUM(isnull([06:00AM to 07:00AM],0) + isnull([07:00AM to 08:00AM],0) + isnull([08:00AM to 09:00AM],0) +isnull([09:00AM to 10:00AM],0)+ isnull([10:00AM to 11:00AM],0)+
		isnull([11:00AM to 12:00PM],0)+ isnull([12:00PM to 01:00PM],0) +
		isnull([01:00PM to 02:00PM],0) + isnull([02:00PM to 03:00PM],0)) as Total
		from @DataSet  
		PIVOT(SUM(INVOICE_COUNT)
		FOR TIME_SLOT IN ([06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],[01:00PM to 02:00PM],[02:00PM to 03:00PM])
		) AS PivotSales
		where UPDATED_DATE between @FromDate and @ToDate		
		group by NTLG,CLIENT_LOGIN,UPDATED_DATE,[06:00AM to 07:00AM],[07:00AM to 08:00AM],[08:00AM to 09:00AM],[09:00AM to 10:00AM],[10:00AM to 11:00AM],[11:00AM to 12:00PM],[12:00PM to 01:00PM],[01:00PM to 02:00PM],[02:00PM to 03:00PM]) as aa
		order by NTLG,CLIENT_LOGIN,UPDATED_DATE
		

END 
  
  
  
END

GO
/****** Object:  StoredProcedure [dbo].[usp_select_Allotmentment_fields11]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[usp_select_Allotmentment_fields11] (@project_id int =null,@task_id int=null)
as begin

DECLARE @FIELD_NAME VARCHAR(MAX)
DECLARE @SQL VARCHAR(MAX)
declare @sql1 varchar(max)



DECLARE @TCOLUMN TABLE (COLUMN_NAME VARCHAR(MAX))


INSERT INTO @TCOLUMN
SELECT COLUMN_NAME  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TBL_TRANSACTION'




DECLARE @TFIELD_NAME TABLE (Display varchar(max),FIELD_NAME VARCHAR(MAX),ID INT,FieldIndex int)
INSERT INTO @TFIELD_NAME

Select * from(
SELECT distinct DISPLAY_FIELD_NAME as DISPLAY_FIELDS, FIELD_NAME , 'ID'=1,FIELD_INDEX FROM DBO.TBL_ADDITIONAL_FIELDS P 

WHERE PROJECT_ID=@project_id AND TASK_ID=@task_id and  IS_DELETED='N'--TASK_ID=7 

union all

SELECT distinct DISPLAY_FIELDS,FIELD_NAME, 'ID'=1,'FIELD_INDEX'=0 FROM DBO.tbl_MANDATORY_FIELD  P 
 WHERE TASK_ID=@task_id and  IS_DELETED='N') as T--TASK_ID=7 
order by FIELD_INDEX
select * from @TFIELD_NAME



END

--exec [usp_select_Allotmentment_fields11] 8,7



GO
/****** Object:  StoredProcedure [dbo].[usp_Select_Keyer_Inbox]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[usp_Select_Keyer_Inbox](@Keyerntlg varchar(300)=null,@DNLOPERATION varchar(300)=null,@facilty varchar(400)=null,
@fromDate datetime=null,@todate datetime=null,@proj int=null,@Account varchar(500)=null,
@accType varchar(350)=null,@ReopenStatus varchar(max)=null)
as

if @DNLOPERATION='BindGrid'

begin


select KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KT.TRANS_ID,KA.BATCH_NAME,  KA.ALLOTED_TO,KA.FACILITY as Facility,Convert(varchar(12),KA.RECEIVED_DATE,101) as DOS,KA.ACCOUNT_NO as PatientID,KA.PATIENT_NAME as PatientName,KA.AGE as Age,
KA.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,case when KT.SHARD_VISIT='not shared' then '' else KT.SHARD_VISIT end as SHARD_VISIT,--KT.SHARD_VISIT,
KTD.CPT,KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, cpt_order,CPT ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER,case when KTD.UNITS=0 then '' else KTD.UNITS end as UNITS,KT.KEYER_COMMENTS,KT.QC_Comments,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG,convert(varchar(12),ka.CODED_DATE,101) as CODED_DATE ,KT.Pending_Update_From,NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],KT.CODING_COMMENTS as [Coder Comments],Kt.IS_REOPEN, KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo

INTO #TEMPDATA from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID and KT.TRANS_ID=KTD.TRANS_ID
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@Keyerntlg and KA.PROJECT_ID=@proj 
 and   Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null )) --or Is_Coding_Pending<>1
and (nullif(@Account,null)is null or KA.ACCOUNT_NO=@Account) and (nullif(@facilty,null)is null or KA.FACILITY=@facilty)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@fromDate,null)is null or [RECEIVED_DATE]=@fromDate)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@fromDate,null)is null and nullif(@todate,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@fromDate,101) and convert(varchar(12),@todate,101)))
--order by KA.BATCH_ID ASC
--group by 
--KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KT.TRANS_ID,KA.BATCH_NAME,KA.ALLOTED_TO,KA.FACILITY,KA.RECEIVED_DATE,KA.ACCOUNT_NO ,KA.PATIENT_NAME ,KA.AGE ,
--KT.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KT.PROVIDER_MD,KT.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,KT.DOI,KT.TOI,KT.TYPE_OF_ACCIDENT,KT.SHARD_VISIT,KTD.CPT,KTD.ICD,KTD.MODIFIER,KTD.UNITS,KTD.COMMENTS,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG,ka.CODED_DATE
SELECT  ACCOUNT_NO,BATCH_ID,PROJECT_ID,TRANS_ID,BATCH_NAME as [Batch Name],ALLOTED_TO as [Alloted To],Facility, DOS, PatientID as [Patient ID], PatientName as [Patient Name],Age,
DISPOSITION as [Disposition],INSURANCE as [Insurance],PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],PATIENT_STATUS as [Patient Status],DOI,TOI,TYPE_OF_ACCIDENT as [Accident Type],SHARD_VISIT as [Shared Visit],CPT,ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],KEYER_COMMENTS as [Keyer Comments],QC_Comments as [QC Comments], DOWNLOADING_COMMENTS as [Downloading Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator],DOS_CHANGED as [Dos Changed],CODER_NTLG as [Coder],CODED_DATE as [Coded Date],Pending_Update_From as [Pending Updated From],[AR Notes],[AR Status],[PC Comments],[EPA Response],[Coder Comments],IS_REOPEN,CPT_ORDER,[SrNo]
 FROM #TEMPDATA
PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE


--order by BATCH_ID

order by BATCH_ID,CPT_ORDER
DROP TABLE #TEMPDATA





end


else if @DNLOPERATION='BindGrid_With_Pending'
begin

select KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KT.TRANS_ID,KA.BATCH_NAME,  KA.ALLOTED_TO,KA.FACILITY as Facility,Convert(varchar(12),KA.RECEIVED_DATE,101) as DOS,KA.ACCOUNT_NO as PatientID,KA.PATIENT_NAME as PatientName,KA.AGE as Age,
KA.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,case when KT.SHARD_VISIT='not shared' then '' else KT.SHARD_VISIT end as SHARD_VISIT,--KT.SHARD_VISIT,
KTD.CPT,KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, cpt_order,CPT ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER,case when KTD.UNITS=0 then '' else KTD.UNITS end as UNITS,KT.KEYER_COMMENTS,KT.QC_Comments,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG,convert(varchar(12),ka.CODED_DATE,101) as CODED_DATE ,KT.Pending_Update_From,NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],KT.CODING_COMMENTS as [Coder Comments],Kt.IS_REOPEN, KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo

INTO #TEMPDATA11 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID and KT.TRANS_ID=KTD.TRANS_ID
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@Keyerntlg and KA.PROJECT_ID=@proj 
 --and (KT.Pending_Update_From is not null and KT.Pending_Update_From<>'')	
and KT.Pending_Update_From=@accType or  (ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From=''))
and (nullif(@Account,null)is null or KA.ACCOUNT_NO=@Account) and (nullif(@facilty,null)is null or KA.FACILITY=@facilty)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@fromDate,null)is null or [RECEIVED_DATE]=@fromDate)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@fromDate,null)is null and nullif(@todate,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@fromDate,101) and convert(varchar(12),@todate,101)))
--order by KA.BATCH_ID ASC
--group by 
--KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KT.TRANS_ID,KA.BATCH_NAME,KA.ALLOTED_TO,KA.FACILITY,KA.RECEIVED_DATE,KA.ACCOUNT_NO ,KA.PATIENT_NAME ,KA.AGE ,
--KT.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KT.PROVIDER_MD,KT.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,KT.DOI,KT.TOI,KT.TYPE_OF_ACCIDENT,KT.SHARD_VISIT,KTD.CPT,KTD.ICD,KTD.MODIFIER,KTD.UNITS,KTD.COMMENTS,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG,ka.CODED_DATE
SELECT  ACCOUNT_NO,BATCH_ID,PROJECT_ID,TRANS_ID,BATCH_NAME as [Batch Name],ALLOTED_TO as [Alloted To],Facility, DOS, PatientID as [Patient ID], PatientName as [Patient Name],Age,
DISPOSITION as [Disposition],INSURANCE as [Insurance],PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],PATIENT_STATUS as [Patient Status],DOI,TOI,TYPE_OF_ACCIDENT as [Accident Type],SHARD_VISIT as [Shared Visit],CPT,ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],KEYER_COMMENTS as [Keyer Comments],QC_Comments as [QC Comments], DOWNLOADING_COMMENTS as [Downloading Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator],DOS_CHANGED as [Dos Changed],CODER_NTLG as [Coder],CODED_DATE as [Coded Date],Pending_Update_From as [Pending Updated From],[AR Notes],[AR Status],[PC Comments],[EPA Response],[Coder Comments],IS_REOPEN,CPT_ORDER,[SrNo]
 FROM #TEMPDATA11
PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE


--order by BATCH_ID

order by BATCH_ID,CPT_ORDER
DROP TABLE #TEMPDATA11



end





else if @DNLOPERATION='BindChar_Status'
begin
select distinct Charge_ID, Charge_Status  from dbo.CHARGE_STATUS_MASTER
end

--exec [usp_Select_Keyer_Inbox] 'Viswajitr','BindGrid',null,null,null,8
GO
/****** Object:  StoredProcedure [dbo].[usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ALTER proc [dbo].[usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report]
--(@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
--@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
--@KeyedDate datetime=null,@Query nvarchar(max)=null)
--as
--Declare @sql nvarchar(max)
--Declare @ParamList nvarchar(max)
----
----set @Query='FACILITY As [Practice],ACCOUNT_NO As [Account #],PATIENT_NAME As [Patient Name],EDMD As [EDMD (per Hosp Log)],RECEIVED_DATE As [DOS],KEYER_COMMENTS As [Remarks],EPA_RESPONSE As [EPA Response],KEYER_Date As [Keyer Date],RESPONSIBILITY As [Responsibility],CHARGE_STATUS As [Pending Claim Status],CLIENT_UPDATEDATE As [Client Date]'

--if @RepType='Pending'
--begin
--set @sql='Select  dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,'+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
--where KT.PROJECT_ID=@Projid and KT.Pending_Update_From=''EPA'''

--if @Responsibility is not null
--begin
----set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
--set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

--end
----if @ChargeStatus is not null
----begin
----set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
----end

--if @FromDos is not null and @Todos is null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
--	end
--	if @FromDos is not null and @Todos is not null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
--	end
	
--	if @KeyedDate is not null
--	begin
--	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
--	end


--end

--if @RepType='Insurance'
--begin

--set @sql='Select '+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
--where KT.PROJECT_ID=@Projid '

--if @Responsibility is not null
--begin
--set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
----set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

--end
--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

--if @FromDos is not null and @Todos is null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
--	end
--	if @FromDos is not null and @Todos is not null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
--	end
	
--	if @KeyedDate is not null
--	begin
--	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
--	end
	
	
--end

--if @RepType='patientCalling'

--begin
--set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,'+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
--where KT.PROJECT_ID=@Projid and KT.Pending_Update_From=''PatientCalling'''

----if @Responsibility is not null
----begin
------set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
----set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

----end


----if @ChargeStatus is not null
----begin
----set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
----end

--if @FromDos is not null and @Todos is null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
--	end
--	if @FromDos is not null and @Todos is not null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
--	end
	
--	if @KeyedDate is not null
--	begin
--	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
--	end
	
--end

--if @RepType='AR'
--begin
--if @Query like '%DISPOSITION As%'
--begin
--set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
--end

--if @Query like '%ACCOUNT_STATUS As%'
--begin
--set @Query=REPLACE(@Query,'ACCOUNT_STATUS As','KT.ACCOUNT_STATUS As')
--end

--set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.BATCH_ID,KT.PROJECT_ID,KTD.CPT_ORDER,'+@Query+',''ICD''+cast(row_number() over(partition by ACCOUNT_NO, cpt_order,CPT order by ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID
--where KT.PROJECT_ID=@Projid '
----and KT.RESPONSIBILITY=''AR''' 
--if @Responsibility is not null
--begin
----set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
--set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

--end
----if @ChargeStatus is not null
----begin
----set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
----end

--if @FromDos is not null and @Todos is null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
--	end
--	if @FromDos is not null and @Todos is not null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
--	end
	
--	if @KeyedDate is not null
--	begin
--	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
--	end
	
--	set @sql='Select * from('+@sql+')as T1
--	Pivot 
--	(
--	max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8) 
--	)as pt
--	order by BATCH_ID,CPT_ORDER'
	
--end

--if @RepType='Coding'
--begin

--if @Query like '%DISPOSITION As%'
--begin
--set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
--end

--if @Query like '%ACCOUNT_STATUS As%'
--begin
--set @Query=REPLACE(@Query,'ACCOUNT_STATUS As','KT.ACCOUNT_STATUS As')
--end

--set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.BATCH_ID,KT.PROJECT_ID,KTD.CPT_ORDER,'+@Query+',''ICD''+cast(row_number() over(partition by ACCOUNT_NO, cpt_order,CPT order by ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID
--where KT.PROJECT_ID=@Projid'

--if @Responsibility is not null
--begin
----set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
--set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

--end
----if @ChargeStatus is not null
----begin
----set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
----end

--if @FromDos is not null and @Todos is null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
--	end
--	if @FromDos is not null and @Todos is not null
--	begin
--	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
--	end
	
--	if @KeyedDate is not null
--	begin
--	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
--	end
	
	
--	set @sql='Select * from('+@sql+')as T1
--	Pivot 
--	(
--	max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8) 
--	)as pt
--	order by BATCH_ID,CPT_ORDER'

--end

--set @ParamList='@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
--@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
--@KeyedDate datetime=null,@Query nvarchar(max)=null'
--exec sp_executesql @sql,@ParamList,@RepType,@Projid,@Facility,@FromDos,@Todos,@Responsibility,@ChargeStatus,@KeyedDate,@Query


----exec usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report 'Pending',8,null,null,null,null,'Pending',null,'FACILITY As [Practice],ACCOUNT_NO As [Account #],PATIENT_NAME As [Patient Name],EDMD As [EDMD (per Hosp Log)],RECEIVED_DATE As [DOS],KEYER_COMMENTS As [Remarks],EPA_RESPONSE As [EPA Response],KEYER_Date As [Keyer Date],RESPONSIBILITY As [Responsibility],CHARGE_STATUS As [Pending Claim Status],CLIENT_UPDATEDATE As [Client Date]'

CREATE proc [dbo].[usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report]
(@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
@KeyedDate datetime=null,@Query nvarchar(max)=null)
as
Declare @sql nvarchar(max)
Declare @ParamList nvarchar(max)
--
--set @Query='FACILITY As [Practice],ACCOUNT_NO As [Account #],PATIENT_NAME As [Patient Name],EDMD As [EDMD (per Hosp Log)],RECEIVED_DATE As [DOS],KEYER_COMMENTS As [Remarks],EPA_RESPONSE As [EPA Response],KEYER_Date As [Keyer Date],RESPONSIBILITY As [Responsibility],CHARGE_STATUS As [Pending Claim Status],CLIENT_UPDATEDATE As [Client Date]'

if @RepType='Pending'
begin
set @sql='Select  distinct dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,'+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID and KT.TRANS_ID=KTD.TRANS_ID 
where KT.KEYING_STATUS=''Completed'' and  KT.PROJECT_ID=@Projid and KT.Pending_Update_From=''EPA'' and  KTD.PROVIDER_MD<>'''''

if @Responsibility is not null
begin
--set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

end
--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end


end

if @RepType='Insurance'
begin

set @sql='Select '+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where KT.PROJECT_ID=@Projid '

if @Responsibility is not null
begin
set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'

end
--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
	
end

if @RepType='patientCalling'

begin
set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.Pending_Update_From,'+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where KT.PROJECT_ID=@Projid and KT.Pending_Update_From=''PatientCalling'' and PC_Assign_Status=''Completed'''

--if @Responsibility is not null
--begin
----set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
--set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

--end


--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
end

if @RepType='AR'
begin
if @Query like '%DISPOSITION As%'
begin
set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
end

if @Query like '%ACCOUNT_STATUS As%'
begin
set @Query=REPLACE(@Query,'ACCOUNT_STATUS As','KT.ACCOUNT_STATUS As')
end

set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.BATCH_ID,KT.PROJECT_ID,KTD.CPT_ORDER,'+@Query+',''ICD''+cast(row_number() over(partition by ACCOUNT_NO, cpt_order,CPT order by ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID
where KT.PROJECT_ID=@Projid and KT.AR_Assign_Status =''Completed'' '
--and KT.RESPONSIBILITY=''AR''' 
if @Responsibility is not null
begin
--set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

end
--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
	set @sql='Select * from('+@sql+')as T1
	Pivot 
	(
	max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8) 
	)as pt
	order by BATCH_ID,CPT_ORDER'
	
end

if @RepType='Coding'
begin

if @Query like '%DISPOSITION As%'
begin
set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
end

if @Query like '%ACCOUNT_STATUS As%'
begin
set @Query=REPLACE(@Query,'ACCOUNT_STATUS As','KT.ACCOUNT_STATUS As')
end

set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.BATCH_ID,KT.PROJECT_ID,KTD.CPT_ORDER,'+@Query+',''ICD''+cast(row_number() over(partition by ACCOUNT_NO, cpt_order,CPT order by ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID
where KT.PROJECT_ID=@Projid'

if @Responsibility is not null
begin
--set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

end
--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
	
	set @sql='Select * from('+@sql+')as T1
	Pivot 
	(
	max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8) 
	)as pt
	order by BATCH_ID,CPT_ORDER'

end

set @ParamList='@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
@KeyedDate datetime=null,@Query nvarchar(max)=null'
exec sp_executesql @sql,@ParamList,@RepType,@Projid,@Facility,@FromDos,@Todos,@Responsibility,@ChargeStatus,@KeyedDate,@Query


--exec usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report 'Pending',8,null,null,null,null,'Pending',null,'FACILITY As [Practice],ACCOUNT_NO As [Account #],PATIENT_NAME As [Patient Name],EDMD As [EDMD (per Hosp Log)],RECEIVED_DATE As [DOS],KEYER_COMMENTS As [Remarks],EPA_RESPONSE As [EPA Response],KEYER_Date As [Keyer Date],RESPONSIBILITY As [Responsibility],CHARGE_STATUS As [Pending Claim Status],CLIENT_UPDATEDATE As [Client Date]'








GO
/****** Object:  StoredProcedure [dbo].[usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report_Pending]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  proc [dbo].[usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report_Pending]
(@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
@KeyedDate datetime=null,@Query nvarchar(max)=null)
as
Declare @sql nvarchar(max)
Declare @ParamList nvarchar(max)
--
--set @Query='FACILITY As [Practice],ACCOUNT_NO As [Account #],PATIENT_NAME As [Patient Name],EDMD As [EDMD (per Hosp Log)],RECEIVED_DATE As [DOS],KEYER_COMMENTS As [Remarks],EPA_RESPONSE As [EPA Response],KEYER_Date As [Keyer Date],RESPONSIBILITY As [Responsibility],CHARGE_STATUS As [Pending Claim Status],CLIENT_UPDATEDATE As [Client Date]'

if @RepType='Pending'
begin
set @sql='Select  distinct dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,'+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID and KT.TRANS_ID=KTD.TRANS_ID 

where KT.PROJECT_ID=@Projid and KT.KEYING_STATUS=''Pending'' and RESPONSIBILITY=''EPA'' and KTD.PROVIDER_MD<>'''''

if @Responsibility is not null
begin
--set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
set @sql=@sql+' And RESPONSIBILITY=@Responsibility'

end

if @Facility is not null
begin
set @sql=@sql+' And FACILITY=@Facility'

end
if @ChargeStatus is not null
begin
set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end

end

if @RepType='Insurance'
begin

set @sql='Select '+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where KT.PROJECT_ID=@Projid '

if @Responsibility is not null
begin
set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
--set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

end
if @ChargeStatus is not null
begin
set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
end

if @Facility is not null
begin
set @sql=@sql+' And FACILITY=@Facility'

end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
	
end

if @RepType='patientCalling'

begin
set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,'+@Query+' from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID 
where KT.PROJECT_ID=@Projid and PC_Assign_Status in (''Fresh'',''Hold'',''Allotted'') and Convert(varchar(12),KA.RECEIVED_DATE,101)>=''03/01/2015'''

if @Responsibility is not null
begin
--set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'

end
if @ChargeStatus is not null
begin
set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
end

if @Facility is not null
begin
set @sql=@sql+' And FACILITY=@Facility'

end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
end

if @RepType='AR'
begin
if @Query like '%DISPOSITION As%'
begin
set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
end

if @Query like '%ACCOUNT_STATUS As%'
begin
set @Query=REPLACE(@Query,'ACCOUNT_STATUS As','KT.ACCOUNT_STATUS As')
end

set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.BATCH_ID,KT.PROJECT_ID,KTD.CPT_ORDER,'+@Query+',''ICD''+cast(row_number() over(partition by  ACCOUNT_NO, cpt_order,CPT order by ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID
where KT.PROJECT_ID=@Projid and KT.RESPONSIBILITY=''AR'' and KT.AR_Assign_Status in (''Fresh'',''Hold'',''Allotted'') and KT.CHARGE_STATUS=''Completed''' 

--if @Responsibility is not null
--begin
--set @sql=@sql+' And KT.Pending_Update_From=@Responsibility'

--end

--temporary comments
--if @ChargeStatus is not null
--begin
--set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
--end

if @Facility is not null
begin
set @sql=@sql+' And FACILITY=@Facility'

end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
	set @sql='Select * from('+@sql+')as T1
	Pivot 
	(
	max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8) 
	)as pt
	order by BATCH_ID,CPT_ORDER'
	
end

if @RepType='Coding'
begin

if @Query like '%DISPOSITION As%'
begin
set @Query=REPLACE(@Query,'DISPOSITION As','KT.DISPOSITION As')
end

if @Query like '%ACCOUNT_STATUS As%'
begin
set @Query=REPLACE(@Query,'ACCOUNT_STATUS As','KT.ACCOUNT_STATUS As')
end

set @sql='Select dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo,KT.BATCH_ID,KT.PROJECT_ID,KTD.CPT_ORDER,'+@Query+',''ICD''+cast(row_number() over(partition by ACCOUNT_NO, cpt_order,CPT  order by ACCOUNT_NO) as varchar(max))as ICDList from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.PROJECT_ID=KTD.PROJECT_ID and KT.BATCH_ID=KTD.BATCH_ID
where KT.PROJECT_ID=@Projid'

if @Responsibility is not null
begin
--set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'
set @sql=@sql+' And KT.RESPONSIBILITY=@Responsibility'

end
if @ChargeStatus is not null
begin
set @sql=@sql+' And KT.CHARGE_STATUS=@ChargeStatus'
end

if @Facility is not null
begin
set @sql=@sql+' And FACILITY=@Facility'

end

if @FromDos is not null and @Todos is null
	begin
	set @sql=@sql+' And [RECEIVED_DATE]=@FromDos'
	end
	if @FromDos is not null and @Todos is not null
	begin
	set @sql=@sql+' And [RECEIVED_DATE] between @FromDos and @Todos'
	end
	
	if @KeyedDate is not null
	begin
	set @sql=@sql+' And KEYER_DATE=@KeyedDate'
	end
	
	
	set @sql='Select * from('+@sql+')as T1
	Pivot 
	(
	max(ICD) for ICDList in (ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8) 
	)as pt
	order by BATCH_ID,CPT_ORDER'

end








set @ParamList='@RepType varchar(200)=null,@Projid int,@Facility varchar(300)=null,@FromDos Datetime=null,
@Todos datetime=null,@Responsibility varchar(300)=null,@ChargeStatus varchar(300)=null,
@KeyedDate datetime=null,@Query nvarchar(max)=null'
exec sp_executesql @sql,@ParamList,@RepType,@Projid,@Facility,@FromDos,@Todos,@Responsibility,@ChargeStatus,@KeyedDate,@Query


--exec [usp_Select_Keyer_Pend_PC_Ins_AR_Coding_Report_Pending] 'Pending',8,null,null,null,null,'Pending',null,'FACILITY As [Practice],ACCOUNT_NO As [Account #],PATIENT_NAME As [Patient Name],EDMD As [EDMD (per Hosp Log)],RECEIVED_DATE As [DOS],KEYER_COMMENTS As [Remarks],EPA_RESPONSE As [EPA Response],KEYER_Date As [Keyer Date],RESPONSIBILITY As [Responsibility],CHARGE_STATUS As [Pending Claim Status],CLIENT_UPDATEDATE As [Client Date]'








GO
/****** Object:  StoredProcedure [dbo].[usp_select_KEYER_QC_INBOX]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select_KEYER_QC_INBOX]
(@QCntlg varchar(300)=null,@DNLOPERATION varchar(300)=null,@facilty varchar(400)=null,
@fromDate datetime=null,@todate datetime=null,@insurance varchar(max)=null,@PMD varchar(max)=null,@APMD varchar(max)=null,@Biller varchar(500)=null,
@startIndex		int=null,
	@pageSize		int=null
)
as

DECLARE @dataset table
(
[TRANS_DETAIL_ID] [int] NULL,
	[ACCOUNT_NO] [varchar](100) NULL,
	[BATCH_ID] [varchar](100) NULL,
	[PROJECTID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[BATCH_NAME] [varchar](100) NULL,
	[QC_By] [varchar](100) NULL,
	[FACILITY] [varchar](100) NULL,
	[DOS] [datetime] NULL,
	[PATIENT_NAME] [varchar](100) NULL,
	[AGE] [varchar](100) NULL,
	[DISPOSITION] [varchar](100) NULL,
	[EDMD] [varchar](100) NULL,
	[ADMITTING_PHY] [varchar](100) NULL,
	[ATTENDING_PHY] [varchar](100) NULL,
	[INSURANCE] [varchar](100) NULL,
	[PROVIDER_MD] [varchar](100) NULL,
	[ASSISTANT_PROVIDER] [varchar](100) NULL,
	[PATIENT_STATUS] [varchar](100) NULL,
	[DOI] [varchar](100) NULL,
	[TOI] [varchar](100) NULL,
	[TYPE_OF_ACCIDENT] [varchar](100) NULL,
	[SHARD_VISIT] [varchar](100) NULL,
	[CPT] [varchar](100) NULL,
	[ICD] [varchar](100) NULL,
	[ICDlIST] [varchar](100) NULL,
	[MODIFIER] [varchar](100) NULL,
	[UNITS] [varchar](100) NULL,
	[KEYER_COMMENTS] [varchar](500) NULL,
	[QC_Comments] [varchar](500) NULL,
	[DOWNLOADING_COMMENTS] [varchar](500) NULL,
	[DEFICIENCY_INDICATOR] [varchar](100) NULL,
	[DOS_CHANGED] [varchar](500) NULL,
	[Coder_ntlg][varchar](500) NULL,
	[CODED_DATE] [varchar](500) NULL,
	[Keyed_by][varchar](500) NULL,
	[Keyed_date][datetime]null,
	[Pending_Update_From] [varchar](500) NULL,
	[Notes][varchar](max) NULL,
	[AR_Status][varchar](max) NULL,
	[PATIENT_CALLING_COMMENTS] [varchar](max) NULL,
	[EPA_RESPONSE][varchar](max) NULL,
	[CODING_COMMENTS][varchar](max) NULL,
	[IS_REOPEN] [varchar](500) NULL,
	[CPT_ORDER] [varchar](100) NULL
) 
	
	
	if @DNLOPERATION='BindGrid'

begin
	INSERT INTO @dataset 	
	
	SELECT      
      DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS SrNo,I.ACCOUNT_NO as PatientID,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,
        T.QC_BY,I.FACILITY as Facility,Convert(varchar(12),I.RECEIVED_DATE,101) as DOS,I.PATIENT_NAME as PatientName,I.AGE as Age,
      I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),T.DOI,101)) end ,
      convert(varchar(12),T.TOI,101)as TOI,T.TYPE_OF_ACCIDENT,case when T.SHARD_VISIT='not shared' then '' else T.SHARD_VISIT end as SHARD_VISIT,--T.SHARD_VISIT,
      D.CPT,D.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, CPT,MODIFIER,CPT_ORDER ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,
      D.MODIFIER,case when D.UNITS=0 then '' else D.UNITS end as UNITS,T.KEYER_COMMENTS,T.QC_Comments,
      D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,T.DOS_CHANGED,I.CODER_NTLG, convert(varchar(12),I.CODED_DATE,101) as CODED_DATE ,
      
      T.KEYED_BY,T.KEYER_DATE,
      T.Pending_Update_From,t.NOTES ,T.AR_STATUS,[PATIENT_CALLING_COMMENTS],[EPA_RESPONSE],[CODING_COMMENTS],T.IS_REOPEN, REPLACE(cpt_order,'CPT','') AS CPT_ORDER

      FROM KEYING_ALLOTMENT I, KEYING_TRANSACTION T, Keying_Transaction_Detail D    
      WHERE I.BATCH_ID = T.BATCH_ID
      AND T.TRANS_ID = D.TRANS_ID               
      
      AND I.BATCH_STATUS='QC' 
      and T.QC_STATUS='ALLOTTED' and t.QC_BY=@QCntlg
      
      and (nullif(@facilty,null)is null or I.FACILITY=@facilty)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@fromDate,null)is null or Convert(varchar(12),[RECEIVED_DATE],101)=Convert(varchar(12),@fromDate,101)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@fromDate,null)is null and nullif(@todate,null)is null)or 
	Convert(varchar(12),[RECEIVED_DATE],101) between convert(varchar(12),@fromDate,101) and convert(varchar(12),@todate,101))))
	
	and (nullif(@insurance,null)is null or T.INSURANCE=@insurance)and 
 (nullif(@PMD,null)is null or D.PROVIDER_MD=@PMD)and 
 (nullif(@APMD,null)is null or D.ASSISTANT_PROVIDER=@APMD)and 

(nullif(@Biller,null)is null or T.KEYED_BY=@Biller) 
 
      
      
     -- or T.Pending_Update_From=@accType or  (I.Is_Coding_Pending=1	and @accType='Coding' and (T.Pending_Update_From is null or T.Pending_Update_From='' and T.KEYING_STATUS='ALLOTTED' and I.ACCOUNT_NO=@account))
      
      
      GROUP BY d.TRANS_DETAIL_ID, T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,D.COMMENTS, I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  
      T.QC_BY,I.FACILITY ,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.RECEIVED_DATE,I.DISPOSITION,T.KEYER_COMMENTS,T.QC_Comments,CODER_NTLG, CODED_DATE,KEYED_BY,KEYER_DATE, Pending_Update_From,NOTES,AR_STATUS,PATIENT_CALLING_COMMENTS,EPA_RESPONSE,CODING_COMMENTS,IS_REOPEN


		--SELECT PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],DOWNLOADING_COMMENTS as [Downcoding Comments]  FROM @dataset
		
		SELECT [ACCOUNT_NO],BATCH_ID,PROJECTID as PROJECT_ID,TRANS_ID,BATCH_NAME as [Batch Name],QC_BY as [Alloted To],Facility,DOS, ACCOUNT_NO as [Patient ID], PATIENT_NAME as [Patient Name],Age,
DISPOSITION as [Disposition],INSURANCE as [Insurance],PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],PATIENT_STATUS as [Patient Status],DOI,TOI,TYPE_OF_ACCIDENT as [Accident Type],SHARD_VISIT as [Shared Visit],CPT,ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],KEYER_COMMENTS as [Comments],DOWNLOADING_COMMENTS as [Downloading Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator],DOS_CHANGED as [Dos Changed],CODER_NTLG as [Coder],CODED_DATE as [Coded Date],KEYED_BY as [Keyed By],Keyed_date as [Keyed Date],Pending_Update_From as [Pending Updated From],NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],EPA_RESPONSE as [EPA Response],CODING_COMMENTS as [Coder Comments]
,IS_REOPEN,CPT_ORDER,TRANS_DETAIL_ID as  [SrNo]  into #tempSet from @dataset--[AR Notes],[AR Status],[PC Comments],[EPA Response],[Coder Comments]

		
		
		PIVOT(max(ICD) 
        FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID, ACCOUNT_NO, cpt_order	
		
		select * from (select ROW_NUMBER() over (order by [SrNo])as RefRow_no,* from #tempSet)as E  
		where SrNo BETWEEN(@startIndex -1) * @PageSize + 1 AND(((@startIndex -1) * @PageSize + 1) + @PageSize) - 1
		
		Select COUNT(distinct SrNo) from #tempSet
		drop table #tempSet

	
end

else if @DNLOPERATION='BindChar_Status'
begin
select distinct Charge_ID, Charge_Status  from dbo.CHARGE_STATUS_MASTER
end

--exec [usp_select_KEYER_QC_INBOX] 'Senthilvk','BindGrid',null,null,null,null,null,null,null,1,1000

GO
/****** Object:  StoredProcedure [dbo].[usp_select_KEYER_QC_INBOX_Test123]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_select_KEYER_QC_INBOX_Test123]
(@QCntlg varchar(300)=null,@DNLOPERATION varchar(300)=null,@facilty varchar(400)=null,
@fromDate datetime=null,@todate datetime=null,@insurance varchar(max)=null,@PMD varchar(max)=null,@APMD varchar(max)=null,@Biller varchar(500)=null)
as

DECLARE @dataset table
(
[TRANS_DETAIL_ID] [int] NULL,
	[ACCOUNT_NO] [varchar](100) NULL,
	[BATCH_ID] [varchar](100) NULL,
	[PROJECTID] [int] NULL,
	[TRANS_ID] [int] NULL,
	[BATCH_NAME] [varchar](100) NULL,
	[QC_By] [varchar](100) NULL,
	[FACILITY] [varchar](100) NULL,
	[DOS] [datetime] NULL,
	[PATIENT_NAME] [varchar](100) NULL,
	[AGE] [varchar](100) NULL,
	[DISPOSITION] [varchar](100) NULL,
	[EDMD] [varchar](100) NULL,
	[ADMITTING_PHY] [varchar](100) NULL,
	[ATTENDING_PHY] [varchar](100) NULL,
	[INSURANCE] [varchar](100) NULL,
	[PROVIDER_MD] [varchar](100) NULL,
	[ASSISTANT_PROVIDER] [varchar](100) NULL,
	[PATIENT_STATUS] [varchar](100) NULL,
	[DOI] [varchar](100) NULL,
	[TOI] [varchar](100) NULL,
	[TYPE_OF_ACCIDENT] [varchar](100) NULL,
	[SHARD_VISIT] [varchar](100) NULL,
	[CPT] [varchar](100) NULL,
	[ICD] [varchar](100) NULL,
	[ICDlIST] [varchar](100) NULL,
	[MODIFIER] [varchar](100) NULL,
	[UNITS] [varchar](100) NULL,
	[KEYER_COMMENTS] [varchar](500) NULL,
	[QC_Comments] [varchar](500) NULL,
	[DOWNLOADING_COMMENTS] [varchar](500) NULL,
	[DEFICIENCY_INDICATOR] [varchar](100) NULL,
	[DOS_CHANGED] [varchar](500) NULL,
	[Coder_ntlg][varchar](500) NULL,
	[CODED_DATE] [varchar](500) NULL,
	[Keyed_by][varchar](500) NULL,
	[Keyed_date][datetime]null,
	[Pending_Update_From] [varchar](500) NULL,
	[Notes][varchar](max) NULL,
	[AR_Status][varchar](max) NULL,
	[PATIENT_CALLING_COMMENTS] [varchar](max) NULL,
	[EPA_RESPONSE][varchar](max) NULL,
	[CODING_COMMENTS][varchar](max) NULL,
	[IS_REOPEN] [varchar](500) NULL,
	[CPT_ORDER] [varchar](100) NULL
) 
	
	
	if @DNLOPERATION='BindGrid'

begin
	INSERT INTO @dataset 	
	
	SELECT      
      DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS SrNo,I.ACCOUNT_NO as PatientID,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,
        T.QC_BY,I.FACILITY as Facility,Convert(varchar(12),I.RECEIVED_DATE,101) as DOS,I.PATIENT_NAME as PatientName,I.AGE as Age,
      I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),T.DOI,101)) end ,
      convert(varchar(12),T.TOI,101)as TOI,T.TYPE_OF_ACCIDENT,case when T.SHARD_VISIT='not shared' then '' else T.SHARD_VISIT end as SHARD_VISIT,--T.SHARD_VISIT,
      D.CPT,D.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, CPT,MODIFIER,CPT_ORDER ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,
      D.MODIFIER,case when D.UNITS=0 then '' else D.UNITS end as UNITS,T.KEYER_COMMENTS,T.QC_Comments,
      D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,T.DOS_CHANGED,I.CODER_NTLG, convert(varchar(12),I.CODED_DATE,101) as CODED_DATE ,
      
      T.KEYED_BY,T.KEYER_DATE,
      T.Pending_Update_From,t.NOTES ,T.AR_STATUS,[PATIENT_CALLING_COMMENTS],[EPA_RESPONSE],[CODING_COMMENTS],T.IS_REOPEN, REPLACE(cpt_order,'CPT','') AS CPT_ORDER

      FROM KEYING_ALLOTMENT I, KEYING_TRANSACTION T, Keying_Transaction_Detail D    
      WHERE I.BATCH_ID = T.BATCH_ID
      AND T.TRANS_ID = D.TRANS_ID               
      
      AND I.BATCH_STATUS='QC' 
      and T.QC_STATUS='ALLOTTED' and t.QC_BY=@QCntlg
      
      and (nullif(@facilty,null)is null or I.FACILITY=@facilty)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@fromDate,null)is null or [RECEIVED_DATE]=@fromDate)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@fromDate,null)is null and nullif(@todate,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@fromDate,101) and convert(varchar(12),@todate,101)))
	
	and (nullif(@insurance,null)is null or T.INSURANCE=@insurance)and 
 (nullif(@PMD,null)is null or D.PROVIDER_MD=@PMD)and 
 (nullif(@APMD,null)is null or D.ASSISTANT_PROVIDER=@APMD)and 

(nullif(@Biller,null)is null or T.KEYED_BY=@Biller) 
 
      
      
     -- or T.Pending_Update_From=@accType or  (I.Is_Coding_Pending=1	and @accType='Coding' and (T.Pending_Update_From is null or T.Pending_Update_From='' and T.KEYING_STATUS='ALLOTTED' and I.ACCOUNT_NO=@account))
      
      
      GROUP BY d.TRANS_DETAIL_ID, T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,D.COMMENTS, I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  
      T.QC_BY,I.FACILITY ,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.RECEIVED_DATE,I.DISPOSITION,T.KEYER_COMMENTS,T.QC_Comments,CODER_NTLG, CODED_DATE,KEYED_BY,KEYER_DATE, Pending_Update_From,NOTES,AR_STATUS,PATIENT_CALLING_COMMENTS,EPA_RESPONSE,CODING_COMMENTS,IS_REOPEN


		--SELECT PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],DOWNLOADING_COMMENTS as [Downcoding Comments]  FROM @dataset
		
		SELECT [ACCOUNT_NO],BATCH_ID,PROJECTID as PROJECT_ID,TRANS_ID,BATCH_NAME as [Batch Name],QC_BY as [Alloted To],Facility,DOS, ACCOUNT_NO as [Patient ID], PATIENT_NAME as [Patient Name],Age,
DISPOSITION as [Disposition],INSURANCE as [Insurance],PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],PATIENT_STATUS as [Patient Status],DOI,TOI,TYPE_OF_ACCIDENT as [Accident Type],SHARD_VISIT as [Shared Visit],CPT,ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],KEYER_COMMENTS as [Comments],DOWNLOADING_COMMENTS as [Downloading Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator],DOS_CHANGED as [Dos Changed],CODER_NTLG as [Coder],CODED_DATE as [Coded Date],KEYED_BY as [Keyed By],Keyed_date as [Keyed Date],Pending_Update_From as [Pending Updated From],NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],EPA_RESPONSE as [EPA Response],CODING_COMMENTS as [Coder Comments]
,IS_REOPEN,CPT_ORDER,TRANS_DETAIL_ID as  [SrNo] from @dataset--[AR Notes],[AR Status],[PC Comments],[EPA Response],[Coder Comments]

		
		
		PIVOT(max(ICD) 
        FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID, ACCOUNT_NO, cpt_order	

	
end

else if @DNLOPERATION='BindChar_Status'
begin
select distinct Charge_ID, Charge_Status  from dbo.CHARGE_STATUS_MASTER
end

--exec [usp_select_KEYER_QC_INBOX_ICD_Fixed] 'Arumughs','BindGrid',null

GO
/****** Object:  StoredProcedure [dbo].[usp_select_KEYER_QC_INBOX112]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[usp_select_KEYER_QC_INBOX112]
(@QCntlg varchar(300)=null,@DNLOPERATION varchar(300)=null,@facilty varchar(400)=null,
@fromDate datetime=null,@todate datetime=null,@startIndex int=null,
	@pageSize int=null)
as

Declare @counts int
if @DNLOPERATION='BindGrid'

begin
--select KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KA.ALLOTED_TO,KA.FACILITY as Facility,KA.RECEIVED_DATE as DOS,KA.ACCOUNT_NO as PatientID,KA.PATIENT_NAME as PatientName,KA.AGE as Age,
--KT.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KT.PROVIDER_MD,KT.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,KT.DOI,KT.TOI,KT.TYPE_OF_ACCIDENT,KT.SHARD_VISIT,KTD.CPT,KTD.ICD_RESULT,KTD.MODIFIER,KTD.UNITS,KTD.COMMENTS,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG

--from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID and KT.TRANS_ID=KTD.TRANS_ID
--where KA.ALLOTED_TO=@Keyerntlg and KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED'

Declare @upperBound int

  IF @startIndex  < 1 SET @startIndex = 1
  else if @startIndex  >= 1
  SET @startIndex =@startIndex + 1
  
  IF @pageSize < 1 SET @pageSize = 1
  
SET @upperBound = @startIndex + @pageSize



select KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KT.TRANS_ID,KA.BATCH_NAME,KT.QC_BY,KA.FACILITY as Facility,convert(varchar(12),KA.RECEIVED_DATE,101) as DOS,KA.ACCOUNT_NO as PatientID,KA.PATIENT_NAME as PatientName,KA.AGE as Age,
KA.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,convert(varchar(12),KT.TOI,101) as TOI,KT.TYPE_OF_ACCIDENT,case when KT.SHARD_VISIT='not shared' then '' else KT.SHARD_VISIT end as SHARD_VISIT,--KT.SHARD_VISIT,
KTD.CPT,KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (partition	BY ACCOUNT_NO, CPT,cpt_order ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER,case when KTD.UNITS=0 then '' else KTD.UNITS end as UNITS,KT.KEYER_COMMENTS as COMMENTS,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG,convert(varchar(12),KA.CODED_DATE,101) as CODED_DATE ,KT.KEYED_BY,convert(varchar(12),KT.KEYER_DATE,101) as KEYER_DATE,KT.Pending_Update_From,NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],KT.CODING_COMMENTS as [Coder Comments],Kt.IS_REOPEN,  KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo--,IDENTITY(int, 1,1) as rownumber
INTO #TEMPDATA from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID and KT.TRANS_ID=KTD.TRANS_ID
where  KA.BATCH_STATUS='QC' and KT.QC_STATUS='ALLOTTED' and KT.QC_BY=@QCntlg

--and ROW_NUMBER() over (order by KA.BATCH_ID)>=CONVERT(varchar(9),@startIndex) and ROW_NUMBER() over (order by KA.BATCH_ID)<=CONVERT(varchar(9), @upperBound)


and (nullif(@facilty,null)is null or KA.FACILITY=@facilty)and --((nullif(@fromDate,null) is null or KA.RECEIVED_DATE=@fromDate)or ((nullif(@fromDate,null) is null and nullif(@todate,null)is null)or KA.RECEIVED_DATE between CONVERT(varchar(11),@fromDate,101) and CONVERT(varchar(11),@todate,101)))
((nullif(@fromDate,null)is null or [RECEIVED_DATE]=@fromDate)or --(nullif(@to_Date,null)is null or [CODED_DATE]=@to_Date)or 
	--((nullif(@from_Date,null)is null and nullif(@to_Date,null)is null)or 
	((nullif(@fromDate,null)is null and nullif(@todate,null)is null)or 
	[RECEIVED_DATE] between convert(varchar(12),@fromDate,101) and convert(varchar(12),@todate,101)))

SELECT ACCOUNT_NO,BATCH_ID,PROJECT_ID,TRANS_ID,BATCH_NAME as [Batch Name],QC_BY as [Alloted To],Facility, DOS, PatientID as [Patient ID], PatientName as [Patient Name],Age,
DISPOSITION as [Disposition],INSURANCE as [Insurance],PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],PATIENT_STATUS as [Patient Status],DOI,TOI,TYPE_OF_ACCIDENT as [Accident Type],SHARD_VISIT as [Shared Visit],CPT,ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],COMMENTS as [Comments],DOWNLOADING_COMMENTS as [Downloading Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator],DOS_CHANGED as [Dos Changed],CODER_NTLG as [Coder],CODED_DATE as [Coded Date],KEYED_BY as [Keyed By],KEYER_DATE as [Keyed Date],Pending_Update_From as [Pending Updated From],[AR Notes],[AR Status],[PC Comments],[EPA Response],[Coder Comments],IS_REOPEN,CPT_ORDER,[SrNo]
into #temp FROM #TEMPDATA
PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE

order by BATCH_ID,CPT_ORDER



select   * ,ROW_NUMBER()over (order by BATCH_ID ) as rownumber into #temp2 from  #temp

select * from #temp2
where rownumber>=CONVERT(varchar(9),@startIndex) and rownumber < = CONVERT(varchar(12),@upperBound)

Select COUNT(distinct [SrNo]) from #TEMPDATA

DROP TABLE #TEMPDATA
drop table #temp
drop table #temp2




end

else if @DNLOPERATION='BindChar_Status'
begin
select distinct Charge_ID, Charge_Status  from dbo.CHARGE_STATUS_MASTER
end

--exec [usp_select_KEYER_QC_INBOX] 'Viswajitr','BindGrid',null,null,null,0,100

--select Convert(varchar(11),'26-11-2014 00:00:00',110)

--select getdate()
GO
/****** Object:  StoredProcedure [dbo].[usp_select_Keyer_Select_insurance_setupLog]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_select_Keyer_Select_insurance_setupLog]
(@accno int=null,@batch int=null,@project int=null,@trans_id int=null,@keyval varchar(20)=null,@val1 varchar(max)=null,@val2 varchar(max)=null,@val3 varchar(max)=null,@val4 varchar(max)=null,@val5 varchar(max)=null)
as
if @keyval='KeyerTran'
begin
select CURRENT_AMD_INSURANCE,CURRENT_AMD_ADDRESS,CHARTFILE_INSURANCE,CHARTFILE_INSURANCE_ADDRESS,CLIENT_COMMENTS  from dbo.KEYING_TRANSACTION
where PROJECT_ID= @project and BATCH_ID=@batch
end
else if @keyval='QCTran'
begin
select KEYING_ERROR_CATEGORY,KEYING_ERROR_SUBCATEGORY,KEYING_ERROR_COMMENTS,ERROR_COUNT,ERROR_CORRECTION  from dbo.KEYING_TRANSACTION
where PROJECT_ID= @project and BATCH_ID=@batch


end
else if @keyval='Update'
begin
update dbo.KEYING_TRANSACTION set CURRENT_AMD_INSURANCE=@val1,CURRENT_AMD_ADDRESS=@val2,CHARTFILE_INSURANCE=@val3,CHARTFILE_INSURANCE_ADDRESS=@val4,CLIENT_COMMENTS=@val5 where PROJECT_ID= @project and BATCH_ID=@batch
end

--exec [usp_select_Keyer_Select_insurance_setupLog] null,15,8,null,'KeyerTran'

GO
/****** Object:  StoredProcedure [dbo].[USP_TM_BIND_FILTERS]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_BIND_FILTERS] --  EXEC [dbo].[USP_TM_BIND_FILTERS]
--(
--@Fromdate varchar(20)=NULL,
  --  @Todate varchar(20)=NULL  )
AS BEGIN 

SELECT distinct LOCATION_NAME AS LOCATION FROM [dbo]. TBL_TIME_TRACKER
	-- where (convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate)

SELECT distinct VERTICAL_ID AS VERTICAL FROM [dbo]. TBL_TIME_TRACKER where vertical_id not like '%select vertical%'
-- where (convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate)

SELECT distinct PROJECT_NAME AS [PROJECT] FROM [dbo]. TBL_TIME_TRACKER 
--where (convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate)

SELECT distinct SPECIALITY_ID AS SPECIALITY FROM [dbo]. TBL_TIME_TRACKER 
-- where (convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate)

SELECT distinct SOFTWARE AS SOFTWARE FROM [dbo]. TBL_TIME_TRACKER  
--where (convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate)

SELECT distinct [STATUS] AS [STATUS] FROM [dbo]. TBL_TIME_TRACKER where [STATUS] is not null 
--where (convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate)

SELECT distinct SUB_PROJ_NAME  FROM [dbo].TBL_TIME_TRACKER

select distinct NTLG from tbl_USER_ACCESS_TM inner join TBL_TIME_TRACKER on tbl_USER_ACCESS_TM.EMP_ID=TBL_TIME_TRACKER.EMP_ID
 where tbl_USER_ACCESS_TM.ACCESS_ID=2

--- SELECT * FROM TBL_TIME_TRACKER where vertical_id like '%select vertical%'

end


--SELECT distinct LOCATION_NAME AS LOCATION 

--	FROM [dbo]. TBL_TIME_TRACKER where (convert(varchar(12),UPDATE_DATE,103) between '14-06-2017' and DATEADD(day,1,'14-06-2017'))
--select * from TBL_TIME_TRACKER




--SELECT distinct LOCATION_NAME AS LOCATION 

--	FROM [dbo]. TBL_TIME_TRACKER where (convert(varchar(12),UPDATE_DATE,103) between '14/06/2017' and '15/06/2017')
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_BIND_LOCATION]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_BIND_LOCATION] --  EXEC [dbo].[USP_TM_BIND_LOCATION]

AS BEGIN 

SELECT distinct LOCATION,LOCATION_ID  FROM [dbo].[TM_LOCATION] where IS_DELETED='N' order by LOCATION


END 


GO
/****** Object:  StoredProcedure [dbo].[USP_TM_BIND_LOCATION_PR]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_BIND_LOCATION_PR]

AS BEGIN 

SELECT distinct LOCATION_NAME FROM [dbo].[TBL_TIME_TRACKER] order by LOCATION_NAME

END 
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_BIND_PROJECT]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_BIND_PROJECT] --  EXEC [dbo].[USP_TM_BIND_PROJECT]

AS BEGIN 

SELECT distinct PROJECT_ID,PROJECT_NAME  FROM [dbo].tbl_PROJECT_MASTER_TM where IS_DELETED='N' order by PROJECT_name

END 

GO
/****** Object:  StoredProcedure [dbo].[USP_TM_BIND_SUBPROJECT]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_BIND_SUBPROJECT] --  EXEC [dbo].[USP_TM_BIND_LOCATION]

AS BEGIN 

SELECT distinct SUB_PROJ_ID,SUB_PROJ_NAME  FROM [dbo].TBL_SUB_PROJECT  


END 
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_BIND_VERTICAL]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_BIND_VERTICAL]

AS BEGIN 

SELECT distinct VERTICAL_NAME,VERTICAL_ID FROM [dbo].[tbl_VERTICAL_MASTER] order by VERTICAL_NAME

END 


GO
/****** Object:  StoredProcedure [dbo].[USP_TM_CHECK_ACC_NO]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_CHECK_ACC_NO]
(
@accountno varchar(200)
)
AS BEGIN 

declare @encrypt varbinary(200)

SELECT ACCOUNT_NO from TBL_TIME_TRACKER where ACCOUNT_NO= CONVERT(varchar(100),DecryptByPassPhrase('key',@encrypt))

END
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_CHECK_ACC_NO1]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_CHECK_ACC_NO1]
(
@accountno varbinary(200)
)
AS BEGIN 

declare @encrypt varbinary(200)
select @encrypt =ENCRYPTBYPASSPHRASE('key',@accountno)
--select @encrypt
SELECT CONVERT(varchar(100),DecryptByPassPhrase('key',@encrypt))  from TBL_TIME_TRACKER1 where ACCOUNT_NO=@encrypt 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_INSERT]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_TM_INSERT]
(
@empid int ,
@pname varchar (100),
@vertical Varchar (100),
@speciality Varchar (100),
@location varchar(100),
@software varchar(100),
@accno varchar(200),
@update datetime,
@ntlg varchar(100),
@subproj varchar(50)
--,@status varchar(50)
)
as
begin

Insert into TBL_TIME_TRACKER (EMP_ID,PROJECT_NAME,VERTICAL_ID,SPECIALITY_ID,LOCATION_NAME,SOFTWARE,ACCOUNT_NO,START_TIME,UPDATE_DATE,NTLG,PAUSED_AT_TIME,SUB_PROJ_NAME) values 
(@empid,@pname,@vertical,@speciality,@location,@software,@accno,convert(varchar,getdate(),113),convert(date,@update,103),@ntlg,convert(varchar,getdate(),113),@subproj)
--@status,convert(varchar,getdate(),113))

End
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_INSERT1]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_TM_INSERT1]
(
@empid int ,
@pname varchar (100),
@vertical Varchar (100),
@speciality Varchar (100),
@location varchar(100),
@software varchar(100),
@accno VARBINARY(200),
--@stime time(7),
--@etime time(7),
@update datetime,
@ntlg varchar(100)
)
as
begin

--Insert into TBL_TIME_TRACKER (EMP_ID,PROJECT_NAME,VERTICAL_ID,SPECIALITY_ID,LOCATION_NAME,SOFTWARE,ACCOUNT_NO,UPDATE_DATE,NTLG) values 
--(@empid,@pname,@vertical,@speciality,@location,@software,@accno,convert(date,@update,103),@ntlg)

declare @encrypt varbinary(200)

Insert into TBL_TIME_TRACKER1(EMP_ID,PROJECT_NAME,VERTICAL_ID,SPECIALITY_ID,LOCATION_NAME,SOFTWARE,ACCOUNT_NO,START_TIME,UPDATE_DATE,NTLG) values 
(@empid,@pname,@vertical,@speciality,@location,@software,ENCRYPTBYPASSPHRASE('key',@accno),convert(varchar,getdate(),8),convert(date,@update,103),@ntlg)

End


--declare @encrypt varbinary(200)
--select @encrypt =ENCRYPTBYPASSPHRASE('key','abc')

--select @encrypt


--select CONVERT(varchar(100),DecryptByPassPhrase('key',@encrypt))





GO
/****** Object:  StoredProcedure [dbo].[USP_TM_Last_TTRAC_ID]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_TM_Last_TTRAC_ID]
(
@NTLG varchar(200)
)
AS BEGIN 
select max(TIME_TRACK_ID) from TBL_TIME_TRACKER WHERE NTLG=@NTLG
END

GO
/****** Object:  StoredProcedure [dbo].[USP_TM_PAUSED_TIME]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_TM_PAUSED_TIME]
(
@time_track_id int,
@ntlg varchar(100)
)

as begin 
update TBL_TIME_TRACKER set  PAUSED_AT_TIME = convert(varchar,getdate(),113) where TIME_TRACK_ID=@time_track_id  AND NTLG = @ntlg  AND  END_TIME IS  NULL 
end 
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_PRODUCTION_REPORT]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_TM_PRODUCTION_REPORT] 
(
    @Fromdate VARCHAR (20)=NULL,
    @Todate VARCHAR (20)=NULL,           
    @Location VARCHAR (200)=NULL,  
    @Software VARCHAR(200)=NULL,
    @Vertical VARCHAR (200)=NULL , 
    @Project VARCHAR (200)=NULL,
	@Speciality VARCHAR(200)=NULL,
	@Status varchar(50)=NULL,
	@subproj varchar(50)=null)
    as begin 
DECLARE @Location1 VARCHAR(200)
DECLARE @Software1 VARCHAR(200)
DECLARE @Vertical1 varchar(200)
DECLARE @Project1 varchar(200)
DECLARE @Speciality1 VARCHAR(200)
DECLARE @Status1 varchar(50)
DECLARE @subproj1 VARCHAR(50)
DECLARE @QUERY NVARCHAR(MAX)

IF(@Location IS NOT NULL) BEGIN SET @Location1 ='AND LOCATION_NAME='''+@Location+'''' END ELSE BEGIN SET @Location1 =' ' END 
IF(@Software IS NOT NULL) BEGIN SET @Software1 ='AND Software='''+@Software+'''' END ELSE  BEGIN SET @Software1 =' ' END
IF(@Vertical IS NOT NULL) BEGIN SET @Vertical1 ='AND Vertical_id='''+@Vertical+'''' END ELSE BEGIN SET @Vertical1 =' ' END
IF(@Project IS NOT NULL)  BEGIN SET @Project1 ='AND Project_Name='''+@Project+'''' END ELSE BEGIN SET @Project1 =' ' END
IF(@Speciality IS NOT NULL) BEGIN SET @Speciality1 ='AND SPECIALITY_ID='''+@Speciality+'''' END ELSE BEGIN SET @Speciality1 =' ' END
IF(@Status IS NOT NULL) BEGIN SET @Status1 ='AND Status='''+@Status+'''' END ELSE BEGIN SET @Status1 =' ' END
IF(@subproj IS NOT NULL) BEGIN SET @subproj1 ='AND SUB_PROJ_NAME='''+@subproj+'''' END ELSE BEGIN SET @subproj1 =' ' END


	declare @PARAMlIST nvarchar(max)

	if OBJECT_ID('tempdb..##TimeDifference')is not null drop table ##TimeDifference
	
    set @QUERY='SELECT  EMP_ID as [EMP ID],SUB_PROJ_NAME,LOCATION_NAME AS LOCATION,VERTICAL_ID AS VERTICAL,PROJECT_NAME AS [PROJECT], 
	SPECIALITY_ID AS SPECIALITY, SOFTWARE,NTLG,ACCOUNT_NO AS[ACCOUNT NO],START_TIME AS [START TIME],END_TIME AS [END TIME],

	convert(varchar(5),DateDiff(s, START_TIME, END_TIME)/3600)+'':''+convert(varchar(5),DateDiff(s, START_TIME, END_TIME)%3600/60)+'':''+convert(varchar(5),(DateDiff(s, START_TIME, END_TIME)%60)) 
	as [TIME DIFFERENCE],
	
	convert(varchar(5),DateDiff(s, PAUSED_AT_TIME, RESUMED_AT_TIME)/3600)+'':''+convert(varchar(5),DateDiff(s, PAUSED_AT_TIME, RESUMED_AT_TIME)%3600/60)+'':''+convert(varchar(5),(DateDiff(s, PAUSED_AT_TIME, RESUMED_AT_TIME)%60)) 
	as [PAUSE TIME DIFFERENCE] into   ##TimeDifference
	 FROM TBL_TIME_TRACKER  where END_TIME is not null and 
	 
(convert(varchar(12),UPDATE_DATE,103) between @Fromdate and @Todate)  '+@Location1+' '+@Software1+' '+@Vertical1+' '+@Project1+' '+@Speciality1+'  '+@Status1+'  '+@subproj1+'   ' 

 set @PARAMlIST='@Fromdate  VARCHAR (20),@Todate  VARCHAR (20),@Location VARCHAR (200),@Software VARCHAR (200), @Vertical VARCHAR(200),@Project VARCHAR (200),@Speciality VARCHAR(200),@Status varchar(50),@subproj VARCHAR(50)'
 execute sp_executesql @query,@PARAMlIST,@Fromdate,@Todate,@Location,@Software,@Vertical,@Project,@Speciality,@Status,@subproj

  select [EMP ID],SUB_PROJ_NAME, LOCATION, VERTICAL, [PROJECT],SPECIALITY, SOFTWARE,NTLG,[ACCOUNT NO], [START TIME], [END TIME],[TIME DIFFERENCE],ISNULL([PAUSE TIME DIFFERENCE],'00:00:00') AS [PAUSE TIME DIFFERENCE] ,
 ISNULL( convert(varchar(5),DateDiff(s,  [PAUSE TIME DIFFERENCE],[TIME DIFFERENCE])/3600)+':'+convert(varchar(5),DateDiff(s, [PAUSE TIME DIFFERENCE],[TIME DIFFERENCE])%3600/60)+':'+convert(varchar(5),(DateDiff(s, [PAUSE TIME DIFFERENCE],[TIME DIFFERENCE])%60)),[TIME DIFFERENCE]) as [EXACT TIME DIFFERENCE]
	
	 from ##TimeDifference

 END
  print @query


  


--select  (convert(varchar(12),GETDATE(),103))


 -- (convert(varchar(12),UPDATE_DATE,101) between @Fromdate and @Todate)
--exec [USP_TM_PRODUCTION_REPORT]

--@Fromdate='15/06/2017',
--    @Todate ='15/06/2017',           
--    @Location =NULL,  
--    @Software =NULL,
--    @Vertical =NULL , 
--    @Project=NULL,
--	@Speciality=NULL,
--    @Status=NULL,
--@SUBPROJ='Roanoke'


--exec [USP_TM_PRODUCTION_REPORT]

--@Fromdate=NULL,
--    @Todate =NULL,           
--    @Location =NULL,  
--    @Software =NULL,
--    @Vertical =NULL , 
--    @Project=NULL,
--	@Speciality=NULL



	--SELECT EMP_ID as [EMP ID],LOCATION_NAME AS LOCATION,VERTICAL_ID AS VERTICAL,PROJECT_NAME AS [PROJECT], 
	--SPECIALITY_ID AS SPECIALITY, SOFTWARE,NTLG,ACCOUNT_NO AS[ACCOUNT NO],START_TIME AS [START TIME],END_TIME AS [END TIME],
	--convert(varchar(5),DateDiff(s, START_TIME, END_TIME)/3600)+':'+convert(varchar(5),DateDiff(s, START_TIME, END_TIME)%3600/60)+':'+convert(varchar(5),(DateDiff(s, START_TIME, END_TIME)%60)) 
	--as [TIME DIFFERENCE] FROM TBL_TIME_TRACKER  where END_TIME is not null and LOCATION_NAME= '@Location'
GO
/****** Object:  StoredProcedure [dbo].[USP_TM_RESUMED_TIME]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_TM_RESUMED_TIME]
(
@time_track_id int,
@ntlg varchar(100)
)

as begin 
update TBL_TIME_TRACKER set  RESUMED_AT_TIME = convert(varchar,getdate(),113) where TIME_TRACK_ID=@time_track_id  AND NTLG = @ntlg  AND  END_TIME IS  NULL 
end 


GO
/****** Object:  StoredProcedure [dbo].[USP_TM_UPDATE]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_TM_UPDATE]
(
@time_track_id int,
@ntlg varchar(100),
@status  varchar(50)
)

as begin 
update TBL_TIME_TRACKER set  END_TIME= convert(varchar,getdate(),113),[STATUS]=@status where TIME_TRACK_ID=@time_track_id  AND NTLG = @ntlg  AND  END_TIME IS  NULL 
end 






--select convert(varchar(5),DateDiff(s, convert(varchar,getdate(),109), May 10 2017  6:02:07:460PM)/3600)+':'+convert(varchar(5),DateDiff(s, START_TIME, END_TIME)%3600/60)+':'+convert(varchar(5),(DateDiff(s, START_TIME, END_TIME)%60))

GO
/****** Object:  StoredProcedure [dbo].[usp_upadte_Keying_Allot_Transaction]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_upadte_Keying_Allot_Transaction](@batchid int=null,@projectID int=null,@accno varchar(150)=null,@trans int=null,@chStatus varchar(100)=null,@respon varchar(100)=null,@Comments varchar(max)=null,
@currAmd1 varchar(300)=null,@currAmd2 varchar(300)=null,@currAmd3 varchar(300)=null,@currAmd4 varchar(300)=null,@currAmd5 varchar(300)=null,@update varchar(20) out)
as

update dbo.KEYING_TRANSACTION set KEYING_STATUS=@chStatus, CHARGE_STATUS=@chStatus,RESPONSIBILITY=@respon,KEYER_COMMENTS=@Comments,CURRENT_AMD_INSURANCE=@currAmd1,CURRENT_AMD_ADDRESS=@currAmd2,CHARTFILE_INSURANCE=@currAmd3,CHARTFILE_INSURANCE_ADDRESS=@currAmd4,CLIENT_COMMENTS=@currAmd5,KEYER_DATE=CONVERT(varchar(12),getdate(),101)
where BATCH_ID=@batchid and PROJECT_ID=@projectID --and TRANS_ID=@trans--and ACCOUNT_NO=@accno
select @update='update'

if @respon='Coding' and @chStatus='Pending'
begin
update tbl_TRANSACTION set CODING_STATUS='Pending',QC_STATUS=null,Pending_Updated_By='KEYING' where BATCH_ID=@batchid and PROJECT_ID=@projectID and TRANS_ID=@trans
end


GO
/****** Object:  StoredProcedure [dbo].[usp_update_Keyer_QC_Clarification]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_update_Keyer_QC_Clarification](@project int=null,@batch int=null,@type varchar(max)=null,@QCcomments varchar(max)=null)
as
if @type='Resend'
begin
update dbo.KEYING_TRANSACTION set IS_ACKNOWLEDGE=NULL, KEYING_ERROR_COMMENTS=case when @QCcomments is not null then KEYING_ERROR_COMMENTS+'***'+@QCcomments else KEYING_ERROR_COMMENTS end

where PROJECT_ID=@project and BATCH_ID=@batch and IS_ACKNOWLEDGE='No'
end
if @type='Acknowledge'

begin
update dbo.KEYING_TRANSACTION set IS_ACKNOWLEDGE='YES',KEYING_ERROR_COMMENTS=case when @QCcomments is not null then KEYING_ERROR_COMMENTS+'***'+@QCcomments else KEYING_ERROR_COMMENTS end
where PROJECT_ID=@project and BATCH_ID=@batch  and IS_ACKNOWLEDGE='No'

end
--exec usp_update_Keyer_QC_Clarification 8,14,'Resend',null
GO
/****** Object:  StoredProcedure [dbo].[usp_update_Keyer_QC_Transaction]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_update_Keyer_QC_Transaction](@acc varchar(300)=null,@batch int=null,@projectid int=null,@trans int=null,@responsibility varchar(200)=null,@chargeStatus varchar(230)=null,
@QC_Status varchar(200)=null,@comments varchar(max)=null,@errCat varchar(200)=null,
@errSubCat varchar(200)=null,@errorComments varchar(max)=null,@errCount int=null,
@ImpactErrCorrection varchar(20)=null,@ErrCountText varchar(450)=null,@update varchar(20) out)--,@update varchar(20) out
as

if @QC_Status='Skip'
begin
update dbo.KEYING_TRANSACTION set RESPONSIBILITY=case when @responsibility IS null then RESPONSIBILITY else @responsibility end,IS_SKIPPED='Y',CHARGE_STATUS=case  when @chargeStatus IS NULL  then CHARGE_STATUS else @chargeStatus end ,KEYING_STATUS=case  when @chargeStatus IS NULL  then CHARGE_STATUS else @chargeStatus end ,QC_STATUS='Completed',QC_Comments=@comments,QC_DATE=getdate()
,KEYING_ERROR_CATEGORY=@errCat,KEYING_ERROR_SUBCATEGORY=@errSubCat,KEYING_ERROR_COMMENTS=@errorComments,ERROR_COUNT=@errCount,
ERROR_CORRECTION=@ImpactErrCorrection,ERROR_LIST=@ErrCountText,
AR_Assign_Status=(case when @responsibility='AR' then 'Fresh' else AR_Assign_Status end),
PC_Assign_Status=(case when @responsibility='Patient Calling' then 'Fresh' else PC_Assign_Status end)

                                                                                                                                                                                                       
where BATCH_ID=@batch and PROJECT_ID=@projectid

end

else

if(@responsibility != 'Coding' or @responsibility is null )

begin
update dbo.KEYING_TRANSACTION set RESPONSIBILITY=case when @responsibility IS null then RESPONSIBILITY else @responsibility end,CHARGE_STATUS=case  when @chargeStatus IS NULL  then CHARGE_STATUS else @chargeStatus end ,KEYING_STATUS=case  when @chargeStatus IS NULL  then CHARGE_STATUS else @chargeStatus end ,QC_STATUS=@QC_Status,QC_Comments=@comments,QC_DATE=getdate()
,KEYING_ERROR_CATEGORY=@errCat,KEYING_ERROR_SUBCATEGORY=@errSubCat,KEYING_ERROR_COMMENTS=@errorComments,ERROR_COUNT=@errCount,ERROR_CORRECTION=@ImpactErrCorrection,ERROR_LIST=@ErrCountText,
AR_Assign_Status=(case when @responsibility='AR' then 'Fresh' else AR_Assign_Status end),
PC_Assign_Status=(case when @responsibility='Patient Calling' then 'Fresh' else PC_Assign_Status end)
where BATCH_ID=@batch and PROJECT_ID=@projectid
end
else if @responsibility='Coding'
begin

update dbo.KEYING_TRANSACTION set RESPONSIBILITY=case when @responsibility IS null then RESPONSIBILITY else @responsibility end,CHARGE_STATUS=case  when @chargeStatus IS NULL  then CHARGE_STATUS else @chargeStatus end ,KEYING_STATUS=case  when @chargeStatus IS NULL  then CHARGE_STATUS else @chargeStatus end ,QC_STATUS=@QC_Status,QC_Comments=@comments,QC_DATE=getdate()
,KEYING_ERROR_CATEGORY=@errCat,KEYING_ERROR_SUBCATEGORY=@errSubCat,KEYING_ERROR_COMMENTS=@errorComments,ERROR_COUNT=@errCount,ERROR_CORRECTION=@ImpactErrCorrection,ERROR_LIST=@ErrCountText
where BATCH_ID=@batch and PROJECT_ID=@projectid



update CT set CT.CODING_STATUS='Completed',CT.SEND_TO_CODER=null,CT.QC_STATUS=NULL,CT.IS_AUDITED=0,CT.Pending_Updated_By='KEYING-QC',CT.KEYING_COMMENTS=@comments,CT.QC_BY=null from tbl_TRANSACTION CT where CT.BATCH_ID=@batch and CT.PROJECT_ID=@projectid

update  CT set CT.QC_STATUS=NULL,CT.QC_BY=null,BATCH_STATUS='CODED' from dbo.tbl_IMPORT_TABLE CT where CT.PROJECT_ID=@projectid and CT.BATCH_ID=@batch
end


--select GETDATE()
select @update='updated'




GO
/****** Object:  StoredProcedure [dbo].[usp_Update_KeyerTrans_while_Reopen]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE procedure [dbo].[usp_Update_KeyerTrans_while_Reopen](@datatable dbo.KeyerUpdate readonly, @Proj int=null,@Batch int=null)
as
update dbo.KEYING_TRANSACTION set IS_REOPEN='YES',KEYING_STATUS='ALLOTTED',QC_STATUS=NULL,Pending_Update_From=NULL  where PROJECT_ID in (select proId from @datatable) and BATCH_ID in (select batchid from @datatable)
Update dbo.KEYING_ALLOTMENT set BATCH_STATUS='KEYING' where PROJECT_ID in (select proId from @datatable) and BATCH_ID in (select batchid from @datatable)
--select GETDATE()
GO
/****** Object:  StoredProcedure [dbo].[V_Keyer_OverAll_Count_Report]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[V_Keyer_OverAll_Count_Report](@FromDos datetime=null,@ToDos datetime=null,@Biller varchar(300)=null,
@Keyeddate datetime=null,@AllottedDate datetime=null,@GridType varchar(30)=null)
as


DECLARE @mydate DATETIME
SELECT @mydate = GETDATE()

Declare @stDate Datetime,@EndDate Datetime

set @stDate= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@mydate)-1),@mydate),101)

set @EndDate= CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@mydate))),DATEADD(mm,1,@mydate)),101) 

if(@GridType='Main')

begin
select Keyed_by as [Keyer],Alloted=COUNT(case when Keying_status in ('Allotted','Completed') then T.batch_id end),
Completed=count(case when KEYING_STATUS='Completed' then (T.batch_id) end),EPA=COUNT(case when (Keying_status in ('Pending')  and RESPONSIBILITY='EPA') OR (Pending_Update_From='EPA' and KEYING_STATUS='Allotted') then T.batch_id end),
AR=COUNT(case when Keying_status='Completed' and CHARGE_STATUS='Completed' and RESPONSIBILITY='AR' then T.BATCH_ID end),[Patient Calling]=COUNT(case when (Keying_status='Pending' and   RESPONSIBILITY='Patient Calling') OR (Pending_Update_From='PatientCalling' and KEYING_STATUS='Allotted') then T.BATCH_ID end),
[Coding Pending]=COUNT(case when (Keying_status='Pending'  and RESPONSIBILITY='Coding') or (Pending_Update_From='Coding' and KEYING_STATUS='Allotted')then T.batch_id end),
Hold=count(case when Keying_status='Hold' then T.Batch_id end),
[Pending In Box]=(COUNT(case when Keying_status='Allotted' and BATCH_STATUS='Keying' and Pending_Update_From  in ('EPA','CODING','PatientCalling') and KEYED_BY=@Biller  then T.batch_id end))
from KEYING_TRANSACTION T,KEYING_ALLOTMENT A
where t.BATCH_ID=A.BATCH_ID and t.KEYED_BY=case when @Biller is null then t.KEYED_BY else @Biller end

--and

--(nullif(@Biller,null)is null or t.KEYED_BY=@Biller)

-- and (nullif(CONVERT(varchar(12),@Keyeddate,101),null) is null or CONVERT(varchar(12),KEYER_DATE,101)=@Keyeddate )
and (nullif(CONVERT(varchar(12),@AllottedDate,101),null) is null or CONVERT(varchar(12),A.ALLOTED_DATE,101)=@AllottedDate ) and

((nullif(CONVERT(varchar(12),@FromDos,101),null) is null or CONVERT(varchar(12),A.RECEIVED_DATE,101)=@FromDos)or((nullif(CONVERT(varchar(12),@FromDos,101),null) is null and  nullif(CONVERT(varchar(12),@ToDos,101),null) is null) or CONVERT(varchar(12),A.RECEIVED_DATE,101) between @FromDos and @ToDos))

and CONVERT(varchar(12),KEYER_DATE,101) between  CONVERT(varchar(12),@stDate,101) and  CONVERT(varchar(12),@EndDate,101)
group by Keyed_by
order by Keyer

end

if(@GridType='Sub')
begin
select Convert(varchar(12),A.RECEIVED_DATE,101) as DOS, Alloted=COUNT(case when Keying_status in ('Allotted','Completed') then T.batch_id end),
Completed=count(case when KEYING_STATUS='Completed' then (T.batch_id) end),EPA=COUNT(case when (Keying_status in ('Pending')  and RESPONSIBILITY='EPA') OR (Pending_Update_From='EPA' and KEYING_STATUS='Allotted') then T.batch_id end),
AR=COUNT(case when Keying_status='Completed' and CHARGE_STATUS='Completed' and RESPONSIBILITY='AR' then T.BATCH_ID end),[Patient Calling]=COUNT(case when (Keying_status='Pending' and   RESPONSIBILITY='Patient Calling') OR (Pending_Update_From='PatientCalling' and KEYING_STATUS='Allotted') then T.BATCH_ID end),
[Coding Pending]=COUNT(case when (Keying_status='Pending'  and RESPONSIBILITY='Coding') or (Pending_Update_From='Coding' and KEYING_STATUS='Allotted')then T.batch_id end),
Hold=count(case when Keying_status='Hold' then T.Batch_id end),
[Pending In Box]=(COUNT(case when Keying_status='Allotted' and BATCH_STATUS='Keying' and Pending_Update_From  in ('EPA','CODING','PatientCalling') and KEYED_BY=@Biller  then T.batch_id end))
from KEYING_TRANSACTION T,KEYING_ALLOTMENT A
where t.BATCH_ID=A.BATCH_ID and
t.KEYED_BY=case when @Biller is null then t.KEYED_BY else @Biller end 

--and (nullif(@Biller,null)is null or t.KEYED_BY=@Biller)

-- and (nullif(CONVERT(varchar(12),@Keyeddate,101),null) is null or CONVERT(varchar(12),KEYER_DATE,101)=@Keyeddate )
and (nullif(CONVERT(varchar(12),@AllottedDate,101),null) is null or CONVERT(varchar(12),A.ALLOTED_DATE,101)=@AllottedDate ) and

((nullif(CONVERT(varchar(12),@FromDos,101),null) is null or CONVERT(varchar(12),A.RECEIVED_DATE,101)=@FromDos)or((nullif(CONVERT(varchar(12),@FromDos,101),null) is null and  nullif(CONVERT(varchar(12),@ToDos,101),null) is null) or CONVERT(varchar(12),A.RECEIVED_DATE,101) between @FromDos and @ToDos))

and  CONVERT(varchar(12),KEYER_DATE,101) between  CONVERT(varchar(12),@stDate,101) and  CONVERT(varchar(12),@EndDate,101)

group by Keyed_by,Convert(varchar(12),A.RECEIVED_DATE,101)
order by Keyed_by
end




GO
/****** Object:  StoredProcedure [dbo].[V_sp_Keyer_Inbox_with_New_Changes_Test]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[V_sp_Keyer_Inbox_with_New_Changes_Test](@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,
@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,
@startIndex		int=1,
	@pageSize		int=null,@RecordCount int=5
)
as
DECLARE
    @upperBound int

--IF @startIndex  < 1 SET @startIndex = 1
--  IF @pageSize < 1 SET @pageSize = 1
  
--  SET @upperBound = @startIndex + @pageSize


Declare @query nvarchar(max),@ParameterList nvarchar(max)
if(@account is null)
begin

set @query=' select distinct ACCOUNT_NO ,convert(varchar(12),RECEIVED_DATE,101) as RECEIVED_DATE,

  DENSE_RANK() over (Order by Ka.Account_no) as rowNum  from dbo.KEYING_ALLOTMENT  KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
and KT.PROJECT_ID=KTD.PROJECT_ID

where  KA.ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS=''KEYING'' and KT.KEYING_STATUS=''ALLOTTED'' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 


'-- and   Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null))
 
 if @DOS is not null
 begin
 set @query=@query+' And convert(varchar(12),[RECEIVED_DATE],101)=@DOS and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and  KT.KEYING_STATUS=''ALLOTTED'')'
 end
 if @Facility is not null
 begin
 set @query=@query+' And KA.FACILITY=@Facility and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'')'
 end
 
 if @Filter is not null
 
begin
if @Filter='Down Coding Comments'
begin
set @query=@query+' and   (Is_Coding_Pending =0  And KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED''  And KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null)'
end
else if @Filter='Patient Status'
begin
set @query=@query+' and  (Is_Coding_Pending =0 And KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null)'

end
else if @Filter='Dos Changed'
begin
set @query=@query+' and  (Is_Coding_Pending =0 And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null ) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null )'

end
else if @Filter='TOI'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.TOI<>'''' and KT.TOI is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.TOI<>'''' and KT.TOI is not null)'

end
else if @Filter='DOI'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.DOI<>'''' and KT.DOI is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.DOI<>'''' and KT.DOI is not null)'

end
else if @Filter='Accident Type'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null)'

end
end 

else if(@Facility is null or @DOS is null)
begin
set @query=@query+'  and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'')'
end

--set @query='Select * from ('+@query+') as T
--            where rowNum >= CONVERT(varchar(9), @startIndex)   AND
--                       rowNum <   ' + CONVERT(varchar(9), @upperBound)+''

Declare @query1 nvarchar(max)

set @query1='Select count(*) as Total from ('+@query+') as T11'







set @query='Select distinct * from ('+@query+') as T
            where rowNum BETWEEN(@startIndex -1) * @PageSize + 1 AND(((@startIndex -1) * @PageSize + 1) + @PageSize) - 1'


          



set @ParameterList='@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,@startIndex int=null,
	@pageSize int=null,@RecordCount int'
	
	
exec sp_executesql @query,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount

exec sp_executesql @query1,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount

--,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount



 
end



else if (@account<>'Counter')
begin
Select [FACILITY],[BATCH_NAME],[ACCOUNT_NO],CONVERT(VARCHAR(12),[RECEIVED_DATE],101) AS [RECEIVED_DATE],
AGE,PATIENT_NAME,'PAT_TYPE'=case when Is_In_Patient=1 then 'InPatient' else 'Outpatient' end ,KT.INSURANCE,
KT.SHARD_VISIT,KT.DOS_CHANGED,KA.DISPOSITION,KT.PATIENT_STATUS,
DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,
convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,CONVERT(VARCHAR(12),
KA.ALLOTED_DATE,101)AS [ALLOTED_DATE],KA.CODER_NTLG,CONVERT(VARCHAR(12),KA.CODED_DATE,101)AS [CODED_DATE],
DOS=case when DOS like '%1900%' then NULL else (CONVERT(varchar(12),DOS,101))end
 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where KEYING_STATUS='Allotted' and ALLOTED_TO=@ntlg and KA.ACCOUNT_NO=@account

DECLARE @dataset keyer_report 
	
	INSERT INTO @dataset 	
	
	SELECT      
      DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  I.ALLOTED_TO,I.FACILITY as Facility,Convert(varchar(12),I.RECEIVED_DATE,101) as DOS,I.PATIENT_NAME as PatientName,I.AGE as Age,
      I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),T.DOI,101)) end ,convert(varchar(12),T.TOI,101)as TOI,T.TYPE_OF_ACCIDENT,case when T.SHARD_VISIT='not shared' then '' else T.SHARD_VISIT end as SHARD_VISIT,--T.SHARD_VISIT,
      D.CPT,D.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, CPT,MODIFIER,CPT_ORDER ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,D.MODIFIER,case when D.UNITS=0 then '' else D.UNITS end as UNITS,T.KEYER_COMMENTS,T.QC_Comments,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,T.DOS_CHANGED,convert(varchar(12),I.CODED_DATE,101) as CODED_DATE ,T.Pending_Update_From,T.IS_REOPEN, REPLACE(cpt_order,'CPT','') AS CPT_ORDER

      FROM KEYING_ALLOTMENT I, KEYING_TRANSACTION T, Keying_Transaction_Detail D    
      WHERE I.BATCH_ID = T.BATCH_ID
      AND T.TRANS_ID = D.TRANS_ID               
      AND ACCOUNT_NO = @account
      AND I.BATCH_STATUS='KEYING' 
      and T.KEYING_STATUS='ALLOTTED' and I.ALLOTED_TO=@ntlg
      and   Is_Coding_Pending =0 
      and (T.Pending_Update_From is NULL or T.Pending_Update_From='' or (IS_REOPEN='YES' and T.Pending_Update_From is null ))     
      GROUP BY d.TRANS_DETAIL_ID, T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,D.COMMENTS, I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  
      I.ALLOTED_TO,I.FACILITY ,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.RECEIVED_DATE,I.DISPOSITION,T.KEYER_COMMENTS,T.QC_Comments, CODED_DATE,Pending_Update_From,NOTES,AR_STATUS,PATIENT_CALLING_COMMENTS,EPA_RESPONSE,CODING_COMMENTS,IS_REOPEN


		SELECT PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],DOWNLOADING_COMMENTS as [Downcoding Comments]  FROM @dataset
		PIVOT(max(ICD) 
        FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID, ACCOUNT_NO, cpt_order		
	

end

if(@account='Counter')
begin
Declare @downCount int
Declare @otherCount int
set  @downCount=(select COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0  and  (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null))
)
 Select @downCount as [Count]
 
select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0  and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null)  and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL))

 
 select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL))
 
 
 set @otherCount=(select count(distinct ACCOUNT_NO) from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL))) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL)))
  )
 --and
 -- (KTD.DOWNLOADING_COMMENTS ='' or KTD.DOWNLOADING_COMMENTS is null))
  select @otherCount-@downCount  as [Count]
end

if(@account='PendingCount')
begin
select count(distinct ACCOUNT_NO) as Count1 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and (Pending_Update_From in ('Coding','EPA','PatientCalling') or KA.Is_Coding_Pending=1)
end

--exec [V_sp_Keyer_Inbox_with_New_Changes_Test] 'Kameshwab',null,8,null,null,null,1,2,null


GO
/****** Object:  StoredProcedure [dbo].[V_sp_Keyer_Inbox_with_New_Changes_Test_opt1]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[V_sp_Keyer_Inbox_with_New_Changes_Test_opt1](@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,
@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,
@startIndex		int=1,
	@pageSize		int=null,@RecordCount int=5
)
as
DECLARE
    @upperBound int

--IF @startIndex  < 1 SET @startIndex = 1
--  IF @pageSize < 1 SET @pageSize = 1
  
--  SET @upperBound = @startIndex + @pageSize


Declare @query nvarchar(max),@ParameterList nvarchar(max)
if(@account is null)
begin

set @query=' select distinct ACCOUNT_NO ,convert(varchar(12),RECEIVED_DATE,101) as RECEIVED_DATE,

  DENSE_RANK() over (Order by Ka.Account_no) as rowNum  from dbo.KEYING_ALLOTMENT  KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
and KT.PROJECT_ID=KTD.PROJECT_ID

where  KA.ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS=''KEYING'' and KT.KEYING_STATUS=''ALLOTTED'' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 


'-- and   Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null))
 
 if @DOS is not null
 begin
 set @query=@query+' And convert(varchar(12),[RECEIVED_DATE],101)=@DOS and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and  KT.KEYING_STATUS=''ALLOTTED'')'
 end
 if @Facility is not null
 begin
 set @query=@query+' And KA.FACILITY=@Facility and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'')'
 end
 
 if @Filter is not null
 
begin
if @Filter='Down Coding Comments'
begin
set @query=@query+' and   (Is_Coding_Pending =0  And KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED''  And KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null)'
end
else if @Filter='Patient Status'
begin
set @query=@query+' and  (Is_Coding_Pending =0 And KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null)'

end
else if @Filter='Dos Changed'
begin
set @query=@query+' and  (Is_Coding_Pending =0 And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null ) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null )'

end
else if @Filter='TOI'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.TOI<>'''' and KT.TOI is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.TOI<>'''' and KT.TOI is not null)'

end
else if @Filter='DOI'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.DOI<>'''' and KT.DOI is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.DOI<>'''' and KT.DOI is not null)'

end
else if @Filter='Accident Type'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null)'

end
end 

else if(@Facility is null or @DOS is null)
begin
set @query=@query+'  and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'')'
end

--set @query='Select * from ('+@query+') as T
--            where rowNum >= CONVERT(varchar(9), @startIndex)   AND
--                       rowNum <   ' + CONVERT(varchar(9), @upperBound)+''

Declare @query1 nvarchar(max)

set @query1='Select count(*) as Total from ('+@query+') as T11'







set @query='Select distinct * from ('+@query+') as T
            where rowNum BETWEEN(@startIndex -1) * @PageSize + 1 AND(((@startIndex -1) * @PageSize + 1) + @PageSize) - 1'


          



set @ParameterList='@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,@startIndex int=null,
	@pageSize int=null,@RecordCount int'
	
	
exec sp_executesql @query,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount

exec sp_executesql @query1,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount

--,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount



 
end



else if (@account<>'Counter')
begin
Select [FACILITY],[BATCH_NAME],[ACCOUNT_NO],CONVERT(VARCHAR(12),[RECEIVED_DATE],101) AS [RECEIVED_DATE],
AGE,PATIENT_NAME,'PAT_TYPE'=case when Is_In_Patient=1 then 'InPatient' else 'Outpatient' end ,KT.INSURANCE,
KT.SHARD_VISIT,KT.DOS_CHANGED,KA.DISPOSITION,KT.PATIENT_STATUS,
DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,
convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,CONVERT(VARCHAR(12),
KA.ALLOTED_DATE,101)AS [ALLOTED_DATE],KA.CODER_NTLG,CONVERT(VARCHAR(12),KA.CODED_DATE,101)AS [CODED_DATE],
DOS=case when DOS like '%1900%' then NULL else (CONVERT(varchar(12),DOS,101))end
 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where KEYING_STATUS='Allotted' and ALLOTED_TO=@ntlg and KA.ACCOUNT_NO=@account

DECLARE @dataset keyer_report 
	
	INSERT INTO @dataset 	
	
	SELECT      
      DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  I.ALLOTED_TO,I.FACILITY as Facility,Convert(varchar(12),I.RECEIVED_DATE,101) as DOS,I.PATIENT_NAME as PatientName,I.AGE as Age,
      I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),T.DOI,101)) end ,convert(varchar(12),T.TOI,101)as TOI,T.TYPE_OF_ACCIDENT,case when T.SHARD_VISIT='not shared' then '' else T.SHARD_VISIT end as SHARD_VISIT,--T.SHARD_VISIT,
      D.CPT,D.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, CPT,MODIFIER,CPT_ORDER ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,D.MODIFIER,case when D.UNITS=0 then '' else D.UNITS end as UNITS,T.KEYER_COMMENTS,T.QC_Comments,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,T.DOS_CHANGED,convert(varchar(12),I.CODED_DATE,101) as CODED_DATE ,T.Pending_Update_From,T.IS_REOPEN, REPLACE(cpt_order,'CPT','') AS CPT_ORDER

      FROM KEYING_ALLOTMENT I, KEYING_TRANSACTION T, Keying_Transaction_Detail D    
      WHERE I.BATCH_ID = T.BATCH_ID
      AND T.TRANS_ID = D.TRANS_ID               
      AND ACCOUNT_NO = @account
      AND I.BATCH_STATUS='KEYING' 
      and T.KEYING_STATUS='ALLOTTED' and I.ALLOTED_TO=@ntlg
      and   Is_Coding_Pending =0 
      and (T.Pending_Update_From is NULL or T.Pending_Update_From='' or (IS_REOPEN='YES' and T.Pending_Update_From is null ))     
      GROUP BY d.TRANS_DETAIL_ID, T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,D.COMMENTS, I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  
      I.ALLOTED_TO,I.FACILITY ,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.RECEIVED_DATE,I.DISPOSITION,T.KEYER_COMMENTS,T.QC_Comments, CODED_DATE,Pending_Update_From,NOTES,AR_STATUS,PATIENT_CALLING_COMMENTS,EPA_RESPONSE,CODING_COMMENTS,IS_REOPEN


		SELECT PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],DOWNLOADING_COMMENTS as [Downcoding Comments]  FROM @dataset
		PIVOT(max(ICD) 
        FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID, ACCOUNT_NO, cpt_order		
	

end

if(@account='Counter')
begin
Declare @downCount int
Declare @otherCount int
set  @downCount=(select COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0  and  (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null))
)
 Select @downCount as [Count]
 
select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0  and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null)  and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL))

 
 select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL))
 
 
 set @otherCount=(select count(distinct ACCOUNT_NO) from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL))) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL)))
  )
 --and
 -- (KTD.DOWNLOADING_COMMENTS ='' or KTD.DOWNLOADING_COMMENTS is null))
  select @otherCount-@downCount  as [Count]
end

if(@account='PendingCount')
begin
select count(distinct ACCOUNT_NO) as Count1 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and (Pending_Update_From in ('Coding','EPA','PatientCalling') or KA.Is_Coding_Pending=1)
end

--exec [V_sp_Keyer_Inbox_with_New_Changes_Test] 'Kameshwab',null,8,null,null,null,1,2,null


GO
/****** Object:  StoredProcedure [dbo].[V_sp_Keyer_Inbox_with_New_Changes_Test_Optimiser1]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[V_sp_Keyer_Inbox_with_New_Changes_Test_Optimiser1](@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,
@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,
@startIndex		int=null,
	@pageSize		int=null,@RecordCount int=null
)
as
DECLARE
    @upperBound int

--IF @startIndex  < 1 SET @startIndex = 1
--  IF @pageSize < 1 SET @pageSize = 1
  
--  SET @upperBound = @startIndex + @pageSize


Declare @query nvarchar(max),@ParameterList nvarchar(max)
if(@account is null)
begin

set @query='select distinct ACCOUNT_NO ,convert(varchar(12),RECEIVED_DATE,101) as RECEIVED_DATE,

  DENSE_RANK() over (Order by Ka.Account_no) as rowNum  from dbo.KEYING_ALLOTMENT  KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID 
and KT.PROJECT_ID=KTD.PROJECT_ID

where  KA.ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS=''KEYING'' and KT.KEYING_STATUS=''ALLOTTED''  and KT.KEYED_BY=@ntlg 


'-- and   Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null))
 
 if @DOS is not null
 begin
 set @query=@query+' And convert(varchar(12),[RECEIVED_DATE],101)=@DOS and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and  KT.KEYING_STATUS=''ALLOTTED'')'
 end
 if @Facility is not null
 begin
 set @query=@query+' And KA.FACILITY=@Facility and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'')'
 end
 
 if @Filter is not null
 
begin
if @Filter='Down Coding Comments'
begin
set @query=@query+' and   (Is_Coding_Pending =0  And KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED''  And KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null)'
end
else if @Filter='Patient Status'
begin
set @query=@query+' and  (Is_Coding_Pending =0 And KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null)'

end
else if @Filter='Dos Changed'
begin
set @query=@query+' and  (Is_Coding_Pending =0 And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null ) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null )'

end
else if @Filter='TOI'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.TOI<>'''' and KT.TOI is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.TOI<>'''' and KT.TOI is not null)'

end
else if @Filter='DOI'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.DOI<>'''' and KT.DOI is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.DOI<>'''' and KT.DOI is not null)'

end
else if @Filter='Accident Type'
begin
set @query=@query+'  and  (Is_Coding_Pending =0 And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'' And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null)'

end
end 

else if(@Facility is null or @DOS is null)
begin
set @query=@query+'  and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''ALLOTTED'')'
end

--set @query='Select * from ('+@query+') as T
--            where rowNum >= CONVERT(varchar(9), @startIndex)   AND
--                       rowNum <   ' + CONVERT(varchar(9), @upperBound)+''

Declare @query1 nvarchar(max)

set @query1='Select count(*) as Total from ('+@query+') as T11'







set @query='Select distinct * from ('+@query+') as T
            where rowNum BETWEEN(@startIndex -1) * @PageSize + 1 AND(((@startIndex -1) * @PageSize + 1) + @PageSize) - 1'


          



set @ParameterList='@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,@startIndex int=null,
	@pageSize int=null,@RecordCount int'
	
	
exec sp_executesql @query,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount

exec sp_executesql @query1,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount

--,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@startIndex,@pageSize,@RecordCount



 
end



--else if (@account<>'Counter')
--begin
Select DENSE_RANK() over (Order by Ka.Account_no) as rowNum,[FACILITY],[BATCH_NAME],[ACCOUNT_NO],CONVERT(VARCHAR(12),[RECEIVED_DATE],101) AS [RECEIVED_DATE],
AGE,PATIENT_NAME,'PAT_TYPE'=case when Is_In_Patient=1 then 'InPatient' else 'Outpatient' end ,KT.INSURANCE,
KT.SHARD_VISIT,KT.DOS_CHANGED,KA.DISPOSITION,KT.PATIENT_STATUS,
DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,
convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,CONVERT(VARCHAR(12),
KA.ALLOTED_DATE,101)AS [ALLOTED_DATE],KA.CODER_NTLG,CONVERT(VARCHAR(12),KA.CODED_DATE,101)AS [CODED_DATE],
DOS=case when DOS like '%1900%' then NULL else (CONVERT(varchar(12),DOS,101))end

into #transData

 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where KEYING_STATUS='Allotted' and ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and KA.BATCH_STATUS='KEYING' --and KA.ACCOUNT_NO in ()
and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='ALLOTTED')

Select * into #transdata1 from #transData
 where rowNum BETWEEN(@startIndex -1) * @PageSize + 1 AND(((@startIndex -1) * @PageSize + 1) + @PageSize) - 1
 
 select * from #transdata1
drop table #transData
DECLARE @dataset keyer_report 
	
	INSERT INTO @dataset 	
	
	SELECT      
      DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  I.ALLOTED_TO,I.FACILITY as Facility,Convert(varchar(12),I.RECEIVED_DATE,101) as DOS,I.PATIENT_NAME as PatientName,I.AGE as Age,
      I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),T.DOI,101)) end ,convert(varchar(12),T.TOI,101)as TOI,T.TYPE_OF_ACCIDENT,case when T.SHARD_VISIT='not shared' then '' else T.SHARD_VISIT end as SHARD_VISIT,--T.SHARD_VISIT,
      D.CPT,D.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, CPT,MODIFIER,CPT_ORDER ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,D.MODIFIER,case when D.UNITS=0 then '' else D.UNITS end as UNITS,T.KEYER_COMMENTS,T.QC_Comments,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,T.DOS_CHANGED,convert(varchar(12),I.CODED_DATE,101) as CODED_DATE ,T.Pending_Update_From,T.IS_REOPEN, REPLACE(cpt_order,'CPT','') AS CPT_ORDER

      FROM KEYING_ALLOTMENT I, KEYING_TRANSACTION T, Keying_Transaction_Detail D    
      WHERE I.BATCH_ID = T.BATCH_ID
     AND T.TRANS_ID = D.TRANS_ID  
     
     and ACCOUNT_NO in (select ACCOUNT_NO from #transdata1)             
      --and T.BATCH_ID=D.BATCH_ID
      AND I.BATCH_STATUS='KEYING' 
      and T.KEYING_STATUS='ALLOTTED' and I.ALLOTED_TO=@ntlg and T.KEYED_BY=@ntlg
      and   Is_Coding_Pending =0 
      and (T.Pending_Update_From is NULL or T.Pending_Update_From='' or (IS_REOPEN='YES' and T.Pending_Update_From is null ))     
      GROUP BY d.TRANS_DETAIL_ID, T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,D.COMMENTS, I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  
      I.ALLOTED_TO,I.FACILITY ,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.RECEIVED_DATE,I.DISPOSITION,T.KEYER_COMMENTS,T.QC_Comments, CODED_DATE,Pending_Update_From,NOTES,AR_STATUS,PATIENT_CALLING_COMMENTS,EPA_RESPONSE,CODING_COMMENTS,IS_REOPEN


		
		
		SELECT TRANS_DETAIL_ID, ACCOUNT_NO,case when PROVIDER_MD ='-- Select --' then '' else PROVIDER_MD end as [Provider MD],case when ASSISTANT_PROVIDER='-- Select --' then '' else  ASSISTANT_PROVIDER end as [Assitant Provider],CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],DOWNLOADING_COMMENTS as [Downcoding Comments]  FROM @dataset
	
		PIVOT(max(ICD) 
        FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
        
		ORDER BY TRANS_DETAIL_ID, ACCOUNT_NO, cpt_order		
		drop table #transData1
		
		select count(distinct ACCOUNT_NO) as Count1 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and (Pending_Update_From in ('Coding','EPA','PatientCalling') or KA.Is_Coding_Pending=1)


		

--end

if(@account='Counter')
begin
Declare @downCount int
Declare @otherCount int
set  @downCount=(select COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0  and  (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null))
)
 Select @downCount as [Count]
 
select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0  and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null)  and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL))

 
 select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL))
 
 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL)) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL))
 
 
 set @otherCount=(select count(distinct ACCOUNT_NO) from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  where  ALLOTED_TO=@ntlg and 
KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and KA.PROJECT_ID=@proj 
 and   (Is_Coding_Pending =0 and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL))) and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL)))
  )
 --and
 -- (KTD.DOWNLOADING_COMMENTS ='' or KTD.DOWNLOADING_COMMENTS is null))
  select @otherCount-@downCount  as [Count]
end

if(@account='PendingCount')
begin
select count(distinct ACCOUNT_NO) as Count1 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and (Pending_Update_From in ('Coding','EPA','PatientCalling') or KA.Is_Coding_Pending=1)
end

--exec V_sp_Keyer_Inbox_with_New_Changes_Test_Optimiser1 'Kameshwab',null,8,null,null,null,1,10,null


GO
/****** Object:  StoredProcedure [dbo].[V_sp_Keyer_Inbox_with_New_Holded_Changes_Test]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[V_sp_Keyer_Inbox_with_New_Holded_Changes_Test](@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,
@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,@accType varchar(300)=null,
@startIndex		int=1,
@pageSize		int=null
)
as
Declare @query nvarchar(max),@ParameterList nvarchar(max)
if(@account is null)
begin
--Select ACCOUNT_NO ,convert(varchar(12),RECEIVED_DATE,101) as RECEIVED_DATE  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
--KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where  KEYED_BY=@ntlg and 
--KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg --and KA.PROJECT_ID=@proj 
-- and   Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null )) 
-- and (nullif(@DOS,null)is null or convert(varchar(12),[RECEIVED_DATE],101)=@DOS)and
-- (nullif(@Facility,null)is null or KA.FACILITY=@Facility)

set @query='select distinct ACCOUNT_NO ,convert(varchar(12),RECEIVED_DATE,101) as RECEIVED_DATE,

DENSE_RANK() over (Order by Ka.Account_no) as rowNum  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
where  KA.BATCH_STATUS=''KEYING'' and KT.KEYING_STATUS=''Hold'' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg
'--and KT.Pending_Update_From=@accType or (ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED''))'

 if @DOS is not null
 begin
 if @accType<>'Regular'
 begin
 set @query=@query+' And  convert(varchar(12),[RECEIVED_DATE],101)=@DOS and KT.Pending_Update_From=@accType or ( convert(varchar(12),[RECEIVED_DATE],101)=@DOS and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold'')) '
 end
 
 else
 begin
  set @query=@query+' And  convert(varchar(12),[RECEIVED_DATE],101)=@DOS and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

 end
 end
 if @Facility is not null
  begin
 if @accType<>'Regular'
 begin
 set @query=@query+' And (KA.FACILITY=@Facility and KT.Pending_Update_From=@accType and KT.Pending_Update_From=@accType) or (KA.FACILITY=@Facility and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold'')) '
 end
 else if @accType='Regular'
 begin
  set @query=@query+' And KA.FACILITY=@Facility and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

 end
 end
 
 if @Filter is not null
 
begin
if @Filter='Down Coding Comments'

 begin
 if @accType<>'Regular'
begin
set @query=@query+'  and (KT.Pending_Update_From=@accType and  KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null) or ( KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold'' and  KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null))'
end
else
 begin
  set @query=@query+' and  KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) ) and KT.KEYING_STATUS=''Hold'''

 end
 end

else if @Filter='Patient Status'

begin
 if @accType<>'Regular'
begin
set @query=@query+' And ( KT.Pending_Update_From=@accType and KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold'' and KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null))'

end
else
 begin
  set @query=@query+'  and KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

 end
 end

else if @Filter='Dos Changed'

begin
 if @accType<>'Regular'
begin
set @query=@query+'  and ( KT.Pending_Update_From=@accType and  KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold'' And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null))'

end
else
 begin
  set @query=@query+' and  KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

 end
 end


else if @Filter='TOI'

begin
 if @accType<>'Regular'
begin
set @query=@query+'  and  (KT.Pending_Update_From=@accType and  KT.TOI<>'''' and KT.TOI is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold'' and  KT.TOI<>'''' and KT.TOI is not null))'

end
else
 begin
  set @query=@query+' and  KT.TOI<>'''' and KT.TOI is not null and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

 end
 end

else if @Filter='DOI'
begin
 if @accType<>'Regular'

begin
set @query=@query+'  and  (KT.Pending_Update_From=@accType And KT.DOI<>'''' and KT.DOI is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold''  And KT.DOI<>'''' and KT.DOI is not null))'

end
else
 begin
  set @query=@query+' And KT.DOI<>'''' and KT.DOI is not null and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

 end
 end

else if @Filter='Accident Type'
begin
 if @accType<>'Regular'


begin
set @query=@query+' and  (KT.Pending_Update_From=@accType And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold'') And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null)'

end
else
 begin
  set @query=@query+' And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

 end
end 
end
else if(@DOS is null and @Facility is null and @Filter is null)
begin
if @accType<>'Regular'
begin
 set @query=@query+' and (KT.Pending_Update_From=@accType) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold''))'
end
if @accType='Regular'
begin
 set @query=@query+' and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='''' or (IS_REOPEN=''YES'' and KT.Pending_Update_From is null) and KT.KEYING_STATUS=''Hold'')'

end

--else
--begin
-- set @query=@query+' and (KT.Pending_Update_From=@accType) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''Hold''))'
--end

end

Declare @query1 nvarchar(max)

set @query1='Select count(*) as Total from ('+@query+') as T11'







set @query='Select distinct * from ('+@query+') as T
            where rowNum BETWEEN(@startIndex -1) * @PageSize + 1 AND(((@startIndex -1) * @PageSize + 1) + @PageSize) - 1'



set @ParameterList='@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,@accType varchar(350)=null,@startIndex int=null,
	@pageSize int=null'
exec sp_executesql @query,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@accType,@startIndex,@pageSize
exec sp_executesql @query1,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@accType,@startIndex,@pageSize







 
end
else if @account<>'Counter'
begin
--Select [FACILITY],[BATCH_NAME],[ACCOUNT_NO],CONVERT(VARCHAR(12),[RECEIVED_DATE],101) AS [RECEIVED_DATE],AGE,
--PATIENT_NAME,'PAT_TYPE'=case when Is_In_Patient=1 then 'InPatient' else 'Outpatient' end ,KT.INSURANCE,KT.SHARD_VISIT,
--KT.DOS_CHANGED,KA.DISPOSITION,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,
--convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,CONVERT(VARCHAR(12),KA.ALLOTED_DATE,101)AS [ALLOTED_DATE],KA.CODER_NTLG,
--PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],
--KT.KEYER_COMMENTS,
--KT.CODING_COMMENTS as [Coder Comments],
--CONVERT(VARCHAR(12),KA.CODED_DATE,101)AS [CODED_DATE] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
--KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where KEYING_STATUS='Allotted'  and KA.ACCOUNT_NO=@account and KA.ALLOTED_TO=@ntlg--and KEYED_BY=@ntlg


Select [FACILITY],[BATCH_NAME],[ACCOUNT_NO],CONVERT(VARCHAR(12),[RECEIVED_DATE],101) AS [RECEIVED_DATE],AGE,
PATIENT_NAME,'PAT_TYPE'=case when Is_In_Patient=1 then 'InPatient' else 'Outpatient' end ,KT.INSURANCE,KT.SHARD_VISIT,
KT.DOS_CHANGED,KA.DISPOSITION,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,
convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,CONVERT(VARCHAR(12),KA.ALLOTED_DATE,101)AS [ALLOTED_DATE],KA.CODER_NTLG,
KT.KEYER_COMMENTS,
PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],KT.CODING_COMMENTS as [Coder Comments],
CONVERT(VARCHAR(12),KA.CODED_DATE,101)AS [CODED_DATE],DOS=case when DOS like '%1900%' then NULL else (CONVERT(varchar(12),DOS,101))end

 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where KEYING_STATUS='Hold'  and KA.ACCOUNT_NO=@account and KA.ALLOTED_TO=@ntlg--and KEYED_BY=@ntlg

if @accType!='Regular'
begin
select KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KT.TRANS_ID,KA.BATCH_NAME,  KA.ALLOTED_TO,KA.FACILITY as Facility,Convert(varchar(12),KA.RECEIVED_DATE,101) as DOS,KA.ACCOUNT_NO as PatientID,KA.PATIENT_NAME as PatientName,KA.AGE as Age,
KA.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,case when KT.SHARD_VISIT='not shared' then '' else KT.SHARD_VISIT end as SHARD_VISIT,--KT.SHARD_VISIT,
KTD.CPT,KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO,CPT,MODIFIER,cpt_order ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER,case when KTD.UNITS=0 then '' else KTD.UNITS end as UNITS,KT.KEYER_COMMENTS,KT.QC_Comments,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG,convert(varchar(12),ka.CODED_DATE,101) as CODED_DATE ,KT.Pending_Update_From,NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],KT.CODING_COMMENTS as [Coder Comments],Kt.IS_REOPEN, KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo

INTO #TEMPDATA from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID and KT.TRANS_ID=KTD.TRANS_ID
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KA.ACCOUNT_NO=@account
 
and KT.Pending_Update_From=@accType or  (ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and KA.ACCOUNT_NO=@account))
SELECT  ACCOUNT_NO,PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],CPT,ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units], DOWNLOADING_COMMENTS as [Downcoding Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator]
--,DOS_CHANGED as [Dos Changed],CODER_NTLG as [Coder],CODED_DATE as [Coded Date],Pending_Update_From as [Pending Updated From],[AR Notes],[AR Status],[PC Comments],[EPA Response],[Coder Comments],IS_REOPEN,CPT_ORDER,[SrNo]
 FROM #TEMPDATA
PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE


--order by BATCH_ID

order by BATCH_ID,CPT_ORDER
DROP TABLE #TEMPDATA
end

else if @accType='Regular'
begin
select KA.ACCOUNT_NO,KA.BATCH_ID,KA.PROJECT_ID,KT.TRANS_ID,KA.BATCH_NAME,  KA.ALLOTED_TO,KA.FACILITY as Facility,Convert(varchar(12),KA.RECEIVED_DATE,101) as DOS,KA.ACCOUNT_NO as PatientID,KA.PATIENT_NAME as PatientName,KA.AGE as Age,
KA.DISPOSITION,KT.EDMD,KT.ADMITTING_PHY,KT.ATTENDING_PHY,KT.INSURANCE,KTD.PROVIDER_MD,KTD.ASSISTANT_PROVIDER,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,case when KT.SHARD_VISIT='not shared' then '' else KT.SHARD_VISIT end as SHARD_VISIT,--KT.SHARD_VISIT,
KTD.CPT,KTD.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO,CPT,MODIFIER,cpt_order ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,KTD.MODIFIER,case when KTD.UNITS=0 then '' else KTD.UNITS end as UNITS,KT.KEYER_COMMENTS,KT.QC_Comments,KTD.DOWNLOADING_COMMENTS,KTD.DEFICIENCY_INDICATOR,KT.DOS_CHANGED,KA.CODER_NTLG,convert(varchar(12),ka.CODED_DATE,101) as CODED_DATE ,KT.Pending_Update_From,NOTES as [AR Notes],AR_STATUS as [AR Status],PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],KT.CODING_COMMENTS as [Coder Comments],Kt.IS_REOPEN, KTD.CPT_ORDER,dense_rank() OVER (ORDER BY KA.BATCH_ID) as SrNo

INTO #TEMPDATA22 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on KA.BATCH_ID=KT.BATCH_ID and KA.PROJECT_ID=KT.PROJECT_ID inner join dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID and KT.TRANS_ID=KTD.TRANS_ID
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KA.ACCOUNT_NO=@account
 
and --KT.Pending_Update_From=@accType or  (ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and KA.ACCOUNT_NO=@account))
Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='ALLOTTED')
SELECT  ACCOUNT_NO,PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],CPT,ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units], DOWNLOADING_COMMENTS as [Downcoding Comments],DEFICIENCY_INDICATOR as [Deficiency Indicator]
--,DOS_CHANGED as [Dos Changed],CODER_NTLG as [Coder],CODED_DATE as [Coded Date],Pending_Update_From as [Pending Updated From],[AR Notes],[AR Status],[PC Comments],[EPA Response],[Coder Comments],IS_REOPEN,CPT_ORDER,[SrNo]
 FROM #TEMPDATA22
PIVOT 
(
MAX(ICD) FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)
)AS PIVOTEDTABLE


--order by BATCH_ID

order by BATCH_ID,CPT_ORDER
DROP TABLE #TEMPDATA22
end


end



 if @account='Counter'
begin
Declare @downCount int
Declare @otherCount int

if @accType<>'Regular'

begin


set  @downCount=(select COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  

where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg   

and (KT.Pending_Update_From=@accType and (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null))or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null))))

 Select @downCount
 
select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 
and (KT.Pending_Update_From=@accType and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL)))


 
 select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg

and (KT.Pending_Update_From=@accType and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL)) or  ( KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL)))

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
  where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg-- and  @Filter='TOI' 

and (KT.Pending_Update_From=@accType and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL)))

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and  @Filter='DOI' 
 
and (KT.Pending_Update_From=@accType and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL)))

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg  --and  @Filter='Accident Type' 

and (KT.Pending_Update_From=@accType and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold' and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL)))

 
 
 set @otherCount=(select count(distinct ACCOUNT_NO) from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
  where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 
   
  
and (KT.Pending_Update_From=@accType   and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL)))
  or  
 
 (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding'
 
  and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold'  and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL))))
 
 )


 --and
 -- (KTD.DOWNLOADING_COMMENTS ='' or KTD.DOWNLOADING_COMMENTS is null))
  select @otherCount-@downCount
end
--for fetching count of regular accounts
else 

begin

set  @downCount=(select COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  

where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg   

and  (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null) and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Hold') )

 Select @downCount
 
select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 
and (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL) and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Hold')


 
 select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg

and (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL) and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Hold')

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
  where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg-- and  @Filter='TOI' 

and (KT.TOI <> '') AND (KT.TOI IS NOT NULL) and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Hold')

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and  @Filter='DOI' 
 
and  (KT.DOI <> '') AND (KT.DOI IS NOT NULL) and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Hold')

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg  --and  @Filter='Accident Type' 

and   (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL) and Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Hold')

 
 
 set @otherCount=(select count(distinct ACCOUNT_NO) from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
  where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='Hold' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 
   
  
and (((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL)))
  and  Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null) and KT.KEYING_STATUS='Hold')  
 
 --(KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding'
 
 -- and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='Hold'  and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 --and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 --((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 --and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL)))
 
 )
 
 


 --and
 -- (KTD.DOWNLOADING_COMMENTS ='' or KTD.DOWNLOADING_COMMENTS is null))
  select @otherCount-@downCount

end

--end fetching count of regular accounts

end


--exec [V_sp_Keyer_Inbox_with_New_Pending_Changes_Test] 'Viswajitr','Counter',null,null,null,null,'PatientCalling'

--exec [V_sp_Keyer_Inbox_with_New_Holded_Changes_Test] 'Viswajitr',null,null,'C',null,null,'coding'


GO
/****** Object:  StoredProcedure [dbo].[V_sp_Keyer_Inbox_with_New_Pending_Changes_Test]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[V_sp_Keyer_Inbox_with_New_Pending_Changes_Test](@ntlg varchar(250)=null
,@account varchar(350)=null,@proj int=null,@Facility varchar(300)=null,@DOS datetime=null,
@Filter varchar(500)=null,@accType varchar(300)=null,
@startIndex		int=1,
@pageSize		int=null
)
as
Declare @query nvarchar(max),@ParameterList nvarchar(max)
if(@account is null)
begin
--Select ACCOUNT_NO ,convert(varchar(12),RECEIVED_DATE,101) as RECEIVED_DATE  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
--KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where  KEYED_BY=@ntlg and 
--KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg --and KA.PROJECT_ID=@proj 
-- and   Is_Coding_Pending =0 and (KT.Pending_Update_From is NULL or KT.Pending_Update_From='' or (IS_REOPEN='YES' and KT.Pending_Update_From is null )) 
-- and (nullif(@DOS,null)is null or convert(varchar(12),[RECEIVED_DATE],101)=@DOS)and
-- (nullif(@Facility,null)is null or KA.FACILITY=@Facility)

DEclare @newVal varchar(max)

if @accType='All'
begin
set @newVal='''EPA'',''Coding'',''PatientCalling'''
end

else
begin
set @newVal=''''+@accType+''''
end

set @query='select distinct ACCOUNT_NO ,convert(varchar(12),RECEIVED_DATE,101) as RECEIVED_DATE,

DENSE_RANK() over (Order by Ka.Account_no) as rowNum  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
where  KA.BATCH_STATUS=''KEYING'' and KT.KEYING_STATUS=''ALLOTTED'' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg
'--and KT.Pending_Update_From=@accType or (ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED''))'

 if @DOS is not null
 begin
 set @query=@query+' And   convert(varchar(12),[RECEIVED_DATE],101)=@DOS and KT.Pending_Update_From in ( '+@newVal+' ) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED'')) '
 end
 if @Facility is not null
 begin
 set @query=@query+' And KA.FACILITY=@Facility and KT.Pending_Update_From in ( '+@newVal+' ) and KT.Pending_Update_From in ( '+@newVal+' ) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED'')) '
 end
 
 if @Filter is not null
 
begin
if @Filter='Down Coding Comments'
begin
set @query=@query+'  and (KT.Pending_Update_From in ( '+@newVal+' ) and  KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null) or ( KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED'' and  KTD.DOWNLOADING_COMMENTS<>'''' and KTD.DOWNLOADING_COMMENTS is not null))'
end
else if @Filter='Patient Status'
begin
set @query=@query+' And (  KT.Pending_Update_From in ( '+@newVal+' ) and KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED'' and KT.PATIENT_STATUS<>'''' and KT.PATIENT_STATUS is not null))'

end
else if @Filter='Dos Changed'
begin
set @query=@query+'  and ( KT.Pending_Update_From in ( '+@newVal+' ) and  KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED'' And KT.DOS_CHANGED<>'''' and KT.DOS_CHANGED is not null))'

end
else if @Filter='TOI'
begin
set @query=@query+'  and  (KT.Pending_Update_From in ( '+@newVal+' ) and  KT.TOI<>'''' and KT.TOI is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED'' and  KT.TOI<>'''' and KT.TOI is not null))'

end
else if @Filter='DOI'
begin
set @query=@query+'  and  (KT.Pending_Update_From in ( '+@newVal+' ) And KT.DOI<>'''' and KT.DOI is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED''  And KT.DOI<>'''' and KT.DOI is not null))'

end
else if @Filter='Accident Type'
begin
set @query=@query+' and  (KT.Pending_Update_From in ( '+@newVal+' ) And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED'') And KT.TYPE_OF_ACCIDENT<>'''' and KT.TYPE_OF_ACCIDENT is not null)'

end
end 

else if(@DOS is null and @Facility is null and @Filter is null)
begin
 set @query=@query+' and (KT.Pending_Update_From in ( '+@newVal+' )) or (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType=''Coding'' and (KT.Pending_Update_From is null or KT.Pending_Update_From='''' and KT.KEYING_STATUS=''ALLOTTED''))'
end


Declare @query1 nvarchar(max)

set @query1='Select count(*) as Total from ('+@query+') as T11'







set @query='Select distinct * from ('+@query+') as T
            where rowNum BETWEEN(@startIndex -1) * @PageSize + 1 AND(((@startIndex -1) * @PageSize + 1) + @PageSize) - 1'




set @ParameterList='@ntlg varchar(250)=null,@account varchar(350)=null,@proj int=null,@Facility varchar(300)=null,@DOS datetime=null,@Filter varchar(500)=null,@accType varchar(350)=null, @startIndex int=null,
	@pageSize int=null'
exec sp_executesql @query,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@accType,@startIndex,@pageSize
exec sp_executesql @query1,@ParameterList,@ntlg,@account,@proj,@Facility,@DOS,@Filter,@accType,@startIndex,@pageSize






 
end

else if @account<>'Counter'
begin
Select [FACILITY],[BATCH_NAME],[ACCOUNT_NO],CONVERT(VARCHAR(12),[RECEIVED_DATE],101) AS [RECEIVED_DATE],AGE,
PATIENT_NAME,'PAT_TYPE'=case when Is_In_Patient=1 then 'InPatient' else 'Outpatient' end ,KT.INSURANCE,KT.SHARD_VISIT,
KT.DOS_CHANGED,KA.DISPOSITION,KT.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),KT.DOI,101)) end ,
convert(varchar(12),KT.TOI,101)as TOI,KT.TYPE_OF_ACCIDENT,CONVERT(VARCHAR(12),KA.ALLOTED_DATE,101)AS [ALLOTED_DATE],KA.CODER_NTLG,
KT.KEYER_COMMENTS,
PATIENT_CALLING_COMMENTS as [PC Comments],KT.EPA_RESPONSE as [EPA Response],KT.CODING_COMMENTS as [Coder Comments],
CONVERT(VARCHAR(12),KA.CODED_DATE,101)AS [CODED_DATE],DOS=case when DOS like '%1900%' then NULL else (CONVERT(varchar(12),DOS,101))end

 from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID where KEYING_STATUS='Allotted'  and KA.ACCOUNT_NO=@account and KA.ALLOTED_TO=@ntlg--and KEYED_BY=@ntlg




DECLARE @dataset keyer_report 
	
	INSERT INTO @dataset 	
	
	SELECT      
      DENSE_RANK() OVER(ORDER BY I.BATCH_ID) AS S_NO,I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  I.ALLOTED_TO,I.FACILITY as Facility,Convert(varchar(12),I.RECEIVED_DATE,101) as DOS,I.PATIENT_NAME as PatientName,I.AGE as Age,
      I.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,T.PATIENT_STATUS,DOI=case when DOI like '%1900%'then NULL else (convert(varchar(12),T.DOI,101)) end ,convert(varchar(12),T.TOI,101)as TOI,T.TYPE_OF_ACCIDENT,case when T.SHARD_VISIT='not shared' then '' else T.SHARD_VISIT end as SHARD_VISIT,--T.SHARD_VISIT,
      D.CPT,D.ICD,'ICD'+CAST(ROW_NUMBER() over (partition BY  ACCOUNT_NO, CPT,MODIFIER,CPT_ORDER ORDER BY ACCOUNT_NO) AS VARCHAR(MAX)) AS ICDlIST,D.MODIFIER,case when D.UNITS=0 then '' else D.UNITS end as UNITS,T.KEYER_COMMENTS,T.QC_Comments,D.DOWNLOADING_COMMENTS,D.DEFICIENCY_INDICATOR,T.DOS_CHANGED,convert(varchar(12),I.CODED_DATE,101) as CODED_DATE ,T.Pending_Update_From,T.IS_REOPEN, REPLACE(cpt_order,'CPT','') AS CPT_ORDER

      FROM KEYING_ALLOTMENT I, KEYING_TRANSACTION T, Keying_Transaction_Detail D    
      WHERE I.BATCH_ID = T.BATCH_ID
      AND T.TRANS_ID = D.TRANS_ID               
      AND ACCOUNT_NO = @account
      AND I.BATCH_STATUS='KEYING' 
      and T.KEYING_STATUS='ALLOTTED' and I.ALLOTED_TO=@ntlg 
      
      
     -- or T.Pending_Update_From=@accType or  (I.Is_Coding_Pending=1	and @accType='Coding' and (T.Pending_Update_From is null or T.Pending_Update_From='' and T.KEYING_STATUS='ALLOTTED' and I.ACCOUNT_NO=@account))
      
      
      GROUP BY d.TRANS_DETAIL_ID, T.TRANS_ID,cpt_order,D.TRANS_DETAIL_ID,D.MODIFIER,D.UNITS,D.DEFICIENCY_INDICATOR,T.QC_STATUS,D.DOWNLOADING_COMMENTS, I.BATCH_ID,T.DOS_CHANGED,I.FACILITY,T.DOS,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,T.DISPOSITION,T.EDMD,T.ADMITTING_PHY,T.ATTENDING_PHY,T.INSURANCE,D.PROVIDER_MD,D.ASSISTANT_PROVIDER,
      T.PATIENT_STATUS,T.DOI,T.TOI,T.TYPE_OF_ACCIDENT,T.SHARD_VISIT,T.DISPOSITION,CPT,ICD,D.COMMENTS, I.ACCOUNT_NO,I.BATCH_ID,I.PROJECT_ID,T.TRANS_ID,I.BATCH_NAME,  
      I.ALLOTED_TO,I.FACILITY ,I.ACCOUNT_NO,I.PATIENT_NAME,I.AGE,I.RECEIVED_DATE,I.DISPOSITION,T.KEYER_COMMENTS,T.QC_Comments, CODED_DATE,Pending_Update_From,NOTES,AR_STATUS,PATIENT_CALLING_COMMENTS,EPA_RESPONSE,CODING_COMMENTS,IS_REOPEN


		SELECT PROVIDER_MD as [Provider MD],ASSISTANT_PROVIDER as [Assitant Provider],CPT,ICD1,ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8,MODIFIER as [Modifier],UNITS as [Units],DOWNLOADING_COMMENTS as [Downcoding Comments]  FROM @dataset
		PIVOT(max(ICD) 
        FOR ICDlIST IN (ICD1, ICD2,ICD3,ICD4,ICD5,ICD6,ICD7,ICD8)) AS PVTTable
		ORDER BY TRANS_DETAIL_ID, ACCOUNT_NO, cpt_order	














end

 if @account='Counter'
begin
Declare @downCount int
Declare @otherCount int

if @accType='All'
begin
set @newVal='EPA,Coding,PatientCalling'
end

set  @downCount=(select COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  

where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg   

and (KT.Pending_Update_From in (select items from dbo.Splitt(@newVal,',')) and (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null))or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='ALLOTTED' and (KTD.DOWNLOADING_COMMENTS<>'')and (KTD.DOWNLOADING_COMMENTS is NOt null))))

 Select @downCount
 
select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID  
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 
and (KT.Pending_Update_From in (select items from dbo.Splitt(@newVal,',')) and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='ALLOTTED' and    (PATIENT_STATUS <> '') AND (PATIENT_STATUS IS NOT NULL)))


 
 select  COUNT(distinct Account_no) as [Count] from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg

and (KT.Pending_Update_From in (select items from dbo.Splitt(@newVal,',')) and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL)) or  ( KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='ALLOTTED' and    (KT.DOS_CHANGED <> '') AND (KT.DOS_CHANGED IS NOT NULL)))

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
  where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg-- and  @Filter='TOI' 

and (KT.Pending_Update_From in (select items from dbo.Splitt(@newVal,',')) and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='ALLOTTED' and    (KT.TOI <> '') AND (KT.TOI IS NOT NULL)))

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID 
 where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg  and KT.KEYED_BY=@ntlg--and  @Filter='DOI' 
 
and (KT.Pending_Update_From in (select items from dbo.Splitt(@newVal,',')) and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='ALLOTTED' and    (KT.DOI <> '') AND (KT.DOI IS NOT NULL)))

 
  select  COUNT(distinct Account_no) as [Count]  from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg  --and  @Filter='Accident Type' 

and (KT.Pending_Update_From in (select items from dbo.Splitt(@newVal,',')) and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL)) or  (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding' and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='ALLOTTED' and    (KT.TYPE_OF_ACCIDENT <> '') AND (KT.TYPE_OF_ACCIDENT IS NOT NULL)))

 
 
 set @otherCount=(select count(distinct ACCOUNT_NO) from dbo.KEYING_ALLOTMENT KA inner join dbo.KEYING_TRANSACTION KT on
KA.PROJECT_ID=KT.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID inner join  dbo.Keying_Transaction_Detail KTD on KT.BATCH_ID=KTD.BATCH_ID and KT.PROJECT_ID=KTD.PROJECT_ID
  where  KA.BATCH_STATUS='KEYING' and KT.KEYING_STATUS='ALLOTTED' and KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg 
   
  
and (KT.Pending_Update_From in (select items from dbo.Splitt(@newVal,','))   and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL)))
  or  
 
 (KA.ALLOTED_TO=@ntlg and KT.KEYED_BY=@ntlg and ka.Is_Coding_Pending=1	and @accType='Coding'
 
  and (KT.Pending_Update_From is null or KT.Pending_Update_From='' and KT.KEYING_STATUS='ALLOTTED'  and    ((KT.TYPE_OF_ACCIDENT = '') or (KT.TYPE_OF_ACCIDENT IS  NULL)) 
 and ((KT.DOI = '') or (KT.DOI IS NULL)) and 
 ((KT.TOI = '') or (KT.TOI IS NULL)) and ((KT.DOS_CHANGED = '') or (KT.DOS_CHANGED IS NULL)) 
 and ((PATIENT_STATUS = '') or (PATIENT_STATUS IS NULL))))
 
 )


 --and
 -- (KTD.DOWNLOADING_COMMENTS ='' or KTD.DOWNLOADING_COMMENTS is null))
  select @otherCount-@downCount
end

--exec [V_sp_Keyer_Inbox_with_New_Pending_Changes_Test] 'Viswajitr','Counter',null,null,null,null,'PatientCalling'

--exec [V_sp_Keyer_Inbox_with_New_Pending_Changes_Test] 'Kameshwab','Counter',8,null,null,null,'All',1,10


GO
/****** Object:  StoredProcedure [dbo].[V_Submit_Biller_Transaction]    Script Date: 7/5/2017 7:30:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[V_Submit_Biller_Transaction](@Responsibility varchar(200)=null,@ChargeStatus varchar(200)=null,@BillerComments varchar(max)=null,@acc varchar(250)=null,@Proj int=nul)
as
update  KT set KT.RESPONSIBILITY=@Responsibility,KT.CHARGE_STATUS=@ChargeStatus,KT.KEYING_STATUS=@ChargeStatus,KT.KEYER_COMMENTS=@BillerComments,KT.KEYER_DATE=GETDATE(),AR_Assign_Status=case when @Responsibility='AR' then 'Fresh' else NULL end,KT.PC_Assign_Status=case when @Responsibility='Patient Calling' then 'Fresh' else NULL end from KEYING_TRANSACTION KT inner join KEYING_ALLOTMENT KA on KT.PROJECT_ID=KA.PROJECT_ID and KA.BATCH_ID=KT.BATCH_ID and KA.ACCOUNT_NO=@acc

if @Responsibility='Coding'
Begin
update  CT set CT.CODING_STATUS='Completed',CT.QC_STATUS=NULL,CT.SEND_TO_CODER=NULL, CT.QC_BY=null,CT.IS_AUDITED=0,CT.Pending_Updated_By='KEYING',CT.KEYING_COMMENTS=@BillerComments from tbl_TRANSACTION CT inner join  tbl_IMPORT_TABLE D on CT.PROJECT_ID=D.PROJECT_ID and CT.BATCH_ID=D.Batch_Id and D.ACCOUNT_NO=@acc

update  CT set CT.QC_STATUS=NULL,CT.QC_BY=null,BATCH_STATUS='CODED' from dbo.tbl_IMPORT_TABLE CT 
where CT.PROJECT_ID=@Proj and CT.ACCOUNT_NO=@acc

end
GO
