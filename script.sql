USE [McKesson_GVL]
GO
/****** Object:  Table [dbo].[tbl_ACCESS_TYPE]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_ACCESS_TYPE](
	[ACCESS_ID] [int] IDENTITY(1,1) NOT NULL,
	[ACCESS_TYPE] [varchar](50) NULL,
	[PROJECT_ID] [int] NULL,
 CONSTRAINT [PK_tbl_ACCESS_TYPE] PRIMARY KEY CLUSTERED 
(
	[ACCESS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_ACCOUNT_TABLE]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_ACCOUNT_TABLE](
	[AID] [int] IDENTITY(1,1) NOT NULL,
	[Account_No] [varchar](50) NOT NULL,
	[Account_Name] [varchar](50) NULL,
	[Project_ID] [int] NULL,
	[ENTER_BY] [varchar](50) NULL,
	[ENTER_DATE] [date] NULL,
 CONSTRAINT [PK_tbl_ACCOUNT_TABLE] PRIMARY KEY CLUSTERED 
(
	[Account_No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_CLIENT_TABLE]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_CLIENT_TABLE](
	[CID] [int] IDENTITY(1,1) NOT NULL,
	[Client_ID] [int] NOT NULL,
	[Clinet_Name] [varchar](50) NULL,
	[Project_ID] [int] NULL,
	[ENTER_BY] [varchar](50) NULL,
	[ENTER_DATE] [date] NULL,
 CONSTRAINT [PK_tbl_CLIENT_TABLE] PRIMARY KEY CLUSTERED 
(
	[Client_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_COLUMN_LIST]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_COLUMN_LIST](
	[COLUMN_ID] [int] IDENTITY(1,1) NOT NULL,
	[COLUMN_NAME] [varchar](50) NULL,
	[DISPLAY_NAME] [varchar](150) NULL,
	[PROJECT_ID] [int] NULL,
	[UPDATED_BY] [varchar](50) NULL,
	[UPDATED_DATE] [varchar](50) NULL,
	[PRACTICE_ID] [int] NULL,
 CONSTRAINT [PK_COLUMN_LIST] PRIMARY KEY CLUSTERED 
(
	[COLUMN_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_ERROR_CAT_TABLE]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_ERROR_CAT_TABLE](
	[Error_ID] [int] IDENTITY(1,1) NOT NULL,
	[Error_Type] [varchar](50) NULL,
	[Error_Category] [varchar](50) NULL,
	[Sub_Category] [varchar](50) NULL,
	[Project_ID] [int] NULL,
	[ENTER_BY] [varchar](50) NULL,
	[ENTER_DATE] [date] NULL,
 CONSTRAINT [PK_tbl_ERROR_CAT_TABLE] PRIMARY KEY CLUSTERED 
(
	[Error_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_IMPORT_TABLE]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_IMPORT_TABLE](
	[IMPORT_ID] [int] IDENTITY(1,1) NOT NULL,
	[CLIENT_ID] [int] NULL,
	[ACCOUNT_NAME] [varchar](500) NULL,
	[DOS] [datetime] NULL,
	[ACCOUNT_NO] [varchar](500) NULL,
	[DENIAL_WORKED_DT] [datetime] NULL,
	[ERROR_CATEGORY] [varchar](50) NULL,
	[SUB_CATEGORY_Error_Type] [varchar](50) NULL,
	[CODER_LOGIN_ID] [varchar](50) NULL,
	[QC_LOGIN_ID] [varchar](50) NULL,
	[DENIAL_TYPE] [varchar](50) NULL,
	[COMMENTS] [varchar](100) NULL,
	[AUDITOR_NAME] [varchar](50) NULL,
	[EMP_ID] [int] NULL,
	[EMP_NAME] [varchar](50) NULL,
	[LOCATION_ID] [int] NULL,
	[PROJECT_ID] [int] NULL,
	[PRACTICE_ID] [int] NULL,
	[ENTER_BY] [varchar](50) NULL,
	[ENTER_DATE] [datetime] NULL,
	[UPDATE_BY] [varchar](50) NULL,
	[UPDATE_DATE] [datetime] NULL,
 CONSTRAINT [PK_tbl_IMPORT_TABLE] PRIMARY KEY CLUSTERED 
(
	[IMPORT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_LOCATION]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_LOCATION](
	[LOCATION_ID] [int] IDENTITY(1,1) NOT NULL,
	[LOCATION] [varchar](100) NULL,
	[IS_DELETED] [varchar](10) NULL,
 CONSTRAINT [PK_tbl_LOCATION] PRIMARY KEY CLUSTERED 
(
	[LOCATION_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_MAIN_MENU]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_MAIN_MENU](
	[MENU_ID] [int] IDENTITY(1,1) NOT NULL,
	[MENU_NAME] [varchar](100) NULL,
	[PROJECT_ID] [int] NULL,
	[ACCESS_ID] [int] NULL,
	[MENU_ORDER_BY] [int] NULL,
 CONSTRAINT [PK_tbl_MAIN_MENU] PRIMARY KEY CLUSTERED 
(
	[MENU_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_MAPPING_COLUMN_LIST]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_MAPPING_COLUMN_LIST](
	[MAPPING_ID] [int] IDENTITY(1,1) NOT NULL,
	[COLUMN_ID] [int] NULL,
	[PROJECT_ID] [int] NULL,
	[PRACTICE_ID] [int] NULL,
	[UPDATED_BY] [varchar](50) NULL,
	[UPDATED_DATE] [varchar](50) NULL,
 CONSTRAINT [PK_MAPPING_COLUMN_LIST] PRIMARY KEY CLUSTERED 
(
	[MAPPING_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_PRACTICE_MASTER]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_PRACTICE_MASTER](
	[PRACTICE_ID] [int] IDENTITY(1,1) NOT NULL,
	[PROJECT_ID] [int] NOT NULL,
	[PRACTICE] [varchar](50) NULL,
	[IS_DELETED] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_PRACTICE_MASTER] PRIMARY KEY CLUSTERED 
(
	[PRACTICE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_PROJECT_MASTER]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_PROJECT_MASTER](
	[PROJECT_ID] [int] IDENTITY(1,1) NOT NULL,
	[PROJECT_NAME] [varchar](100) NULL,
	[IS_DELETED] [varchar](1) NULL,
 CONSTRAINT [PK_tbl_PROJECT_MASTER] PRIMARY KEY CLUSTERED 
(
	[PROJECT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_SUB_MENU]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_SUB_MENU](
	[SUB_MENU_ID] [int] IDENTITY(1,1) NOT NULL,
	[MENU_ID] [int] NULL,
	[SUB_MENU_NAME] [varchar](100) NULL,
	[URL] [varchar](500) NULL,
	[PROJECT_ID] [int] NULL,
	[SUB_MENU_ORDER_BY] [int] NULL,
 CONSTRAINT [PK_tbl_SUB_MENU] PRIMARY KEY CLUSTERED 
(
	[SUB_MENU_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_TRANSACTION]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_TRANSACTION](
	[TRANS_ID] [int] IDENTITY(1,1) NOT NULL,
	[PRACTICE_ID] [int] NULL,
	[IMPORT_ID] [int] NULL,
	[ENTER_BY] [varchar](50) NULL,
	[ENTER_DATE] [date] NULL,
	[UPDATE_BY] [varchar](50) NULL,
	[UPDATE_DATE] [date] NULL,
 CONSTRAINT [PK_tbl_TRANSACTION] PRIMARY KEY CLUSTERED 
(
	[TRANS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_TRANSACTION_DETAILS]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_TRANSACTION_DETAILS](
	[TRANS_DETAIL_ID] [int] IDENTITY(1,1) NOT NULL,
	[TRANS_ID] [int] NULL,
	[COMMENTS] [varchar](500) NULL,
	[CODED_TO] [varchar](50) NULL,
	[CODED_BY] [varchar](50) NULL,
	[CODED_DATE] [date] NULL,
	[CODED_STATUS] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_TRANSACTION_DETAILS] PRIMARY KEY CLUSTERED 
(
	[TRANS_DETAIL_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_USER_ACCESS]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_USER_ACCESS](
	[USER_ID] [int] IDENTITY(1,1) NOT NULL,
	[EMP_ID] [int] NULL,
	[PROJECT_ID] [int] NULL,
	[USER_NAME] [varchar](50) NULL,
	[USER_NTLG] [varchar](50) NULL,
	[ACCESS_ID] [int] NULL,
	[TL_NTLG] [varchar](50) NULL,
	[TL_NAME] [varchar](500) NULL,
	[OM_NTLG] [varchar](50) NULL,
	[OM_NAME] [varchar](500) NULL,
	[SM_NTLG] [varchar](50) NULL,
	[SM_NAME] [varchar](500) NULL,
	[IS_DELETED] [varchar](1) NULL,
	[UPDATED_DATE] [datetime] NULL,
	[UPDATED_BY] [varchar](50) NULL,
	[LOCATION_ID] [int] NULL,
 CONSTRAINT [PK_tbl_USER_ACCESS] PRIMARY KEY CLUSTERED 
(
	[USER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tbl_ACCOUNT_TABLE]  WITH CHECK ADD  CONSTRAINT [FK_tbl_ACCOUNT_TABLE_tbl_PROJECT_MASTER] FOREIGN KEY([Project_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_ACCOUNT_TABLE] CHECK CONSTRAINT [FK_tbl_ACCOUNT_TABLE_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_CLIENT_TABLE]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CLIENT_TABLE_tbl_PROJECT_MASTER] FOREIGN KEY([Project_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_CLIENT_TABLE] CHECK CONSTRAINT [FK_tbl_CLIENT_TABLE_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_COLUMN_LIST]  WITH CHECK ADD  CONSTRAINT [FK_tbl_COLUMN_LIST_tbl_PRACTICE_MASTER] FOREIGN KEY([PRACTICE_ID])
REFERENCES [dbo].[tbl_PRACTICE_MASTER] ([PRACTICE_ID])
GO
ALTER TABLE [dbo].[tbl_COLUMN_LIST] CHECK CONSTRAINT [FK_tbl_COLUMN_LIST_tbl_PRACTICE_MASTER]
GO
ALTER TABLE [dbo].[tbl_COLUMN_LIST]  WITH CHECK ADD  CONSTRAINT [FK_tbl_COLUMN_LIST_tbl_PROJECT_MASTER] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_COLUMN_LIST] CHECK CONSTRAINT [FK_tbl_COLUMN_LIST_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_ERROR_CAT_TABLE]  WITH CHECK ADD  CONSTRAINT [FK_tbl_ERROR_CAT_TABLE_tbl_PROJECT_MASTER] FOREIGN KEY([Project_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_ERROR_CAT_TABLE] CHECK CONSTRAINT [FK_tbl_ERROR_CAT_TABLE_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_IMPORT_TABLE]  WITH CHECK ADD  CONSTRAINT [FK_tbl_IMPORT_TABLE_tbl_LOCATION] FOREIGN KEY([LOCATION_ID])
REFERENCES [dbo].[tbl_LOCATION] ([LOCATION_ID])
GO
ALTER TABLE [dbo].[tbl_IMPORT_TABLE] CHECK CONSTRAINT [FK_tbl_IMPORT_TABLE_tbl_LOCATION]
GO
ALTER TABLE [dbo].[tbl_IMPORT_TABLE]  WITH CHECK ADD  CONSTRAINT [FK_tbl_IMPORT_TABLE_tbl_PRACTICE_MASTER] FOREIGN KEY([PRACTICE_ID])
REFERENCES [dbo].[tbl_PRACTICE_MASTER] ([PRACTICE_ID])
GO
ALTER TABLE [dbo].[tbl_IMPORT_TABLE] CHECK CONSTRAINT [FK_tbl_IMPORT_TABLE_tbl_PRACTICE_MASTER]
GO
ALTER TABLE [dbo].[tbl_IMPORT_TABLE]  WITH CHECK ADD  CONSTRAINT [FK_tbl_IMPORT_TABLE_tbl_PROJECT_MASTER] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_IMPORT_TABLE] CHECK CONSTRAINT [FK_tbl_IMPORT_TABLE_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_MAIN_MENU]  WITH CHECK ADD  CONSTRAINT [FK_tbl_MAIN_MENU_tbl_ACCESS_TYPE] FOREIGN KEY([ACCESS_ID])
REFERENCES [dbo].[tbl_ACCESS_TYPE] ([ACCESS_ID])
GO
ALTER TABLE [dbo].[tbl_MAIN_MENU] CHECK CONSTRAINT [FK_tbl_MAIN_MENU_tbl_ACCESS_TYPE]
GO
ALTER TABLE [dbo].[tbl_MAIN_MENU]  WITH CHECK ADD  CONSTRAINT [FK_tbl_MAIN_MENU_tbl_PROJECT_MASTER] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_MAIN_MENU] CHECK CONSTRAINT [FK_tbl_MAIN_MENU_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_MAPPING_COLUMN_LIST]  WITH CHECK ADD  CONSTRAINT [FK_tbl_MAPPING_COLUMN_LIST_tbl_COLUMN_LIST] FOREIGN KEY([COLUMN_ID])
REFERENCES [dbo].[tbl_COLUMN_LIST] ([COLUMN_ID])
GO
ALTER TABLE [dbo].[tbl_MAPPING_COLUMN_LIST] CHECK CONSTRAINT [FK_tbl_MAPPING_COLUMN_LIST_tbl_COLUMN_LIST]
GO
ALTER TABLE [dbo].[tbl_MAPPING_COLUMN_LIST]  WITH CHECK ADD  CONSTRAINT [FK_tbl_MAPPING_COLUMN_LIST_tbl_PRACTICE_MASTER] FOREIGN KEY([PRACTICE_ID])
REFERENCES [dbo].[tbl_PRACTICE_MASTER] ([PRACTICE_ID])
GO
ALTER TABLE [dbo].[tbl_MAPPING_COLUMN_LIST] CHECK CONSTRAINT [FK_tbl_MAPPING_COLUMN_LIST_tbl_PRACTICE_MASTER]
GO
ALTER TABLE [dbo].[tbl_MAPPING_COLUMN_LIST]  WITH CHECK ADD  CONSTRAINT [FK_tbl_MAPPING_COLUMN_LIST_tbl_PROJECT_MASTER] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_MAPPING_COLUMN_LIST] CHECK CONSTRAINT [FK_tbl_MAPPING_COLUMN_LIST_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_PRACTICE_MASTER]  WITH CHECK ADD  CONSTRAINT [FK_tbl_PRACTICE_MASTER_tbl_PROJECT_MASTER] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_PRACTICE_MASTER] CHECK CONSTRAINT [FK_tbl_PRACTICE_MASTER_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_SUB_MENU]  WITH CHECK ADD  CONSTRAINT [FK_tbl_SUB_MENU_tbl_MAIN_MENU] FOREIGN KEY([MENU_ID])
REFERENCES [dbo].[tbl_MAIN_MENU] ([MENU_ID])
GO
ALTER TABLE [dbo].[tbl_SUB_MENU] CHECK CONSTRAINT [FK_tbl_SUB_MENU_tbl_MAIN_MENU]
GO
ALTER TABLE [dbo].[tbl_SUB_MENU]  WITH CHECK ADD  CONSTRAINT [FK_tbl_SUB_MENU_tbl_PROJECT_MASTER] FOREIGN KEY([PROJECT_ID])
REFERENCES [dbo].[tbl_PROJECT_MASTER] ([PROJECT_ID])
GO
ALTER TABLE [dbo].[tbl_SUB_MENU] CHECK CONSTRAINT [FK_tbl_SUB_MENU_tbl_PROJECT_MASTER]
GO
ALTER TABLE [dbo].[tbl_TRANSACTION]  WITH CHECK ADD  CONSTRAINT [FK_tbl_TRANSACTION_tbl_IMPORT_TABLE] FOREIGN KEY([IMPORT_ID])
REFERENCES [dbo].[tbl_IMPORT_TABLE] ([IMPORT_ID])
GO
ALTER TABLE [dbo].[tbl_TRANSACTION] CHECK CONSTRAINT [FK_tbl_TRANSACTION_tbl_IMPORT_TABLE]
GO
ALTER TABLE [dbo].[tbl_TRANSACTION]  WITH CHECK ADD  CONSTRAINT [FK_tbl_TRANSACTION_tbl_PRACTICE_MASTER] FOREIGN KEY([PRACTICE_ID])
REFERENCES [dbo].[tbl_PRACTICE_MASTER] ([PRACTICE_ID])
GO
ALTER TABLE [dbo].[tbl_TRANSACTION] CHECK CONSTRAINT [FK_tbl_TRANSACTION_tbl_PRACTICE_MASTER]
GO
ALTER TABLE [dbo].[tbl_TRANSACTION_DETAILS]  WITH CHECK ADD  CONSTRAINT [FK_tbl_TRANSACTION_DETAILS_tbl_TRANSACTION] FOREIGN KEY([TRANS_ID])
REFERENCES [dbo].[tbl_TRANSACTION] ([TRANS_ID])
GO
ALTER TABLE [dbo].[tbl_TRANSACTION_DETAILS] CHECK CONSTRAINT [FK_tbl_TRANSACTION_DETAILS_tbl_TRANSACTION]
GO
ALTER TABLE [dbo].[tbl_USER_ACCESS]  WITH CHECK ADD  CONSTRAINT [FK_tbl_USER_ACCESS_tbl_ACCESS_TYPE] FOREIGN KEY([ACCESS_ID])
REFERENCES [dbo].[tbl_ACCESS_TYPE] ([ACCESS_ID])
GO
ALTER TABLE [dbo].[tbl_USER_ACCESS] CHECK CONSTRAINT [FK_tbl_USER_ACCESS_tbl_ACCESS_TYPE]
GO
ALTER TABLE [dbo].[tbl_USER_ACCESS]  WITH CHECK ADD  CONSTRAINT [FK_tbl_USER_ACCESS_tbl_LOCATION] FOREIGN KEY([LOCATION_ID])
REFERENCES [dbo].[tbl_LOCATION] ([LOCATION_ID])
GO
ALTER TABLE [dbo].[tbl_USER_ACCESS] CHECK CONSTRAINT [FK_tbl_USER_ACCESS_tbl_LOCATION]
GO
/****** Object:  StoredProcedure [dbo].[spx_ImportFromExcel07]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spx_ImportFromExcel07]
	@SheetName varchar(20),
    @FilePath varchar(100),
	@HDR varchar(3),
	@TableName varchar(50)
AS
BEGIN
    DECLARE @SQL nvarchar(1000)
	
	IF OBJECT_ID (@TableName,'U') IS NOT NULL
		SET @SQL = 'INSERT INTO ' + @TableName + ' SELECT * FROM OPENDATASOURCE'
	ELSE
		SET @SQL = 'SELECT * INTO ' + @TableName + ' FROM OPENDATASOURCE'

    SET @SQL = @SQL + '(''Microsoft.ACE.OLEDB.12.0'',''Data Source='
    SET @SQL = @SQL + @FilePath + ';Extended Properties=''''Excel 12.0;HDR=' 
    SET @SQL = @SQL + @HDR + ''''''')...[' 
    SET @SQL = @SQL + @SheetName + ']'
	EXEC sp_executesql @SQL
END

GO
/****** Object:  StoredProcedure [dbo].[UPS_delete_Account]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_delete_Account]
  
  @Account_No varchar(50)

  as
 begin


SET NOCOUNT ON;
	
	delete from tbl_Account_TABLE where Account_No=@Account_No


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_delete_CLIENT]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_delete_CLIENT]
  
  @Client_ID int

  as
 begin


SET NOCOUNT ON;
	
	delete from tbl_CLIENT_TABLE where Client_ID=@Client_ID


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Enter_Account_Details]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Enter_Account_Details]
  
  @Account_No varchar(50),
  @Account_Name varchar(50),
  @Project_ID int,
  @ENTER_BY varchar(50)

  as
 begin


SET NOCOUNT ON;
	INSERT INTO tbl_Account_TABLE values(@Account_No,@Account_Name,@Project_ID,@ENTER_BY,GETDATE())
  


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Enter_Client_Details]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Enter_Client_Details]
  
  @Client_ID int,
  @Clinet_Name varchar(50),
  @Project_ID int,
  @ENTER_BY varchar(50)

  as
 begin


SET NOCOUNT ON;
	INSERT INTO tbl_CLIENT_TABLE values(@Client_ID,@Clinet_Name,@Project_ID,@ENTER_BY,GETDATE())
  


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Get_AccountList]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  Create procedure [dbo].[UPS_Get_AccountList]
  
  @Project_Id int

  as
 begin


SET NOCOUNT ON;
	
	select 	AID,Account_No,Account_Name,ENTER_BY,ENTER_DATE from tbl_Account_TABLE where Project_ID=@Project_Id
  


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Get_AllotmentData]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Get_AllotmentData]
  
  @Status varchar(50),
  @FromDate date,
  @ToDate date,
  @Project_Id int,
  @Practice_Id int

  as
 begin


SET NOCOUNT ON;
 
  DECLARE @listStr varchar(MAX) 
	select @listStr= coalesce(@listStr+',a.','')+a.Column_Name+' as ['+Display_Name +']' from tbl_COLUMN_LIST a inner join tbl_MAPPING_COLUMN_LIST b on a.Column_Id=b.Column_Id where b.Project_Id=@Project_Id

IF(@Status='' and @FromDate!='' and  @ToDate!='')
BEGIN 


   DECLARE @query varchar(MAX) = 'select a.IMPORT_ID as [ID],'+ @listStr+',d.CODED_TO as [CODED TO],d.CODED_DATE as [CODED DATE] from tbl_IMPORT_TABLE a left outer join (select b.IMPORT_ID,c.CODED_TO,c.CODED_DATE,c.CODED_STATUS from tbl_TRANSACTION b inner join 
   tbl_TRANSACTION_DETAILS c on b.TRANS_ID=c.TRANS_ID) d on a.IMPORT_ID=d.IMPORT_ID where a.Project_Id='''+CONVERT(varchar(10),@Project_Id)+''' and a.Practice_Id='''+CONVERT(varchar(10),@Practice_Id)+''' and d.CODED_STATUS is null 
   and convert(varchar(10),a.ENTER_DATE,101) between '''+convert(varchar(10),@FromDate,101)+''' and '''+convert(varchar(10),@ToDate,101)+'''';

   --print(@query)
  execute(@query)

  END
  
  ELSE IF(@Status!='' and @FromDate='' and  @ToDate='')
BEGIN 


   DECLARE @query1 varchar(MAX) = 'select a.IMPORT_ID as ID,'+ @listStr+',d.CODED_TO as [CODED TO],d.CODED_DATE as [CODED DATE] from tbl_IMPORT_TABLE a left outer join (select b.IMPORT_ID,c.CODED_TO,c.CODED_DATE,c.CODED_STATUS from tbl_TRANSACTION b inner join 
   tbl_TRANSACTION_DETAILS c on b.TRANS_ID=c.TRANS_ID) d on a.IMPORT_ID=d.IMPORT_ID where a.Project_Id='''+CONVERT(varchar(10),@Project_Id)+''' and a.Practice_Id='''+CONVERT(varchar(10),@Practice_Id)+''' 
   and d.CODED_STATUS='''+CONVERT(varchar(50),@Status)+'''';

   --print(@query1)
  execute(@query1)

  END
  ELSE IF(@Status='' and @FromDate='' and  @ToDate='')
BEGIN 


   DECLARE @query2 varchar(MAX) = 'select a.IMPORT_ID as ID,'+ @listStr+',d.CODED_TO as [CODED TO],d.CODED_DATE as [CODED DATE] from tbl_IMPORT_TABLE a left outer join (select b.IMPORT_ID,c.CODED_TO,c.CODED_DATE,c.CODED_STATUS from tbl_TRANSACTION b inner join 
   tbl_TRANSACTION_DETAILS c on b.TRANS_ID=c.TRANS_ID) d on a.IMPORT_ID=d.IMPORT_ID where a.Project_Id='''+CONVERT(varchar(10),@Project_Id)+''' and a.Practice_Id='''+CONVERT(varchar(10),@Practice_Id)+''' and d.CODED_STATUS is null';

   --print(@query2)
  execute(@query2)

  END
  ELSE
  BEGIN

     DECLARE @query3 varchar(MAX) = 'select a.IMPORT_ID as ID,'+ @listStr+',d.CODED_TO as [CODED TO],d.CODED_DATE as [CODED DATE] from tbl_IMPORT_TABLE a left outer join (select b.IMPORT_ID,c.CODED_TO,c.CODED_DATE,c.CODED_STATUS from tbl_TRANSACTION b inner join 
   tbl_TRANSACTION_DETAILS c on b.TRANS_ID=c.TRANS_ID) d on a.IMPORT_ID=d.IMPORT_ID where a.Project_Id='''+CONVERT(varchar(10),@Project_Id)+''' and a.Practice_Id='''+CONVERT(varchar(10),@Practice_Id)+''' and   
   d.CODED_STATUS='''+CONVERT(varchar(50),@Status)+''' and convert(varchar(10),a.ENTER_DATE,101) between '''+convert(varchar(10),@FromDate,101)+''' and '''+convert(varchar(10),@ToDate,101)+'''';
   

  --print(@query3)
  execute(@query3)



  END
  

 END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Get_CLIENTDetailsList]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Get_CLIENTDetailsList]
  
  @CID int

  as
 begin


SET NOCOUNT ON;
	
	select 	CID,Client_ID,Clinet_Name from tbl_CLIENT_TABLE where CID=@CID


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Get_CLIENTList]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Get_CLIENTList]
  
  @Project_Id int

  as
 begin


SET NOCOUNT ON;
	
	select 	CID,Client_ID,Clinet_Name,ENTER_BY,ENTER_DATE from tbl_CLIENT_TABLE where Project_ID=@Project_Id
  


  END

GO
/****** Object:  StoredProcedure [dbo].[UPS_Get_ImportData]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Get_ImportData]
  
  @Project_Id int,
  @Practice_Id int

  as
 begin


SET NOCOUNT ON;
	DECLARE @listStr varchar(MAX) 
	select @listStr= coalesce(@listStr+',','')+a.Column_Name+' as ['+Display_Name +']' from tbl_COLUMN_LIST a inner join tbl_MAPPING_COLUMN_LIST b on a.Column_Id=b.Column_Id where b.Project_Id=@Project_Id
  
  --print(@listStr)


   DECLARE @query varchar(MAX) = 'select IMPORT_ID as ID,'+ @listStr+' from tbl_IMPORT_TABLE where Project_Id='''+CONVERT(varchar(10),@Project_Id)+''' and Practice_Id='''+CONVERT(varchar(10),@Practice_Id)+'''';
   --print(@query)

   execute(@query)
  


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Get_ImportData_Access]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Get_ImportData_Access]
  
  @Project_Id int,
  @Practice_Id int,
  @CODED_TO varchar(50)

  as
 begin


SET NOCOUNT ON;
	DECLARE @listStr varchar(MAX) 
	select @listStr= coalesce(@listStr+',','')+a.Column_Name+' as ['+Display_Name +']' from tbl_COLUMN_LIST a inner join tbl_MAPPING_COLUMN_LIST b on a.Column_Id=b.Column_Id where b.Project_Id=@Project_Id
  
  --print(@listStr)


   DECLARE @query varchar(MAX) = 'select IMPORT_ID as ID,'+ @listStr+' from tbl_IMPORT_TABLE where IMPORT_ID in(select IMPORT_ID from tbl_TRANSACTION a inner join tbl_TRANSACTION_DETAILS b 
   on a.TRANS_ID=b.TRANS_ID where b.CODED_TO ='''+CONVERT(varchar(10),@CODED_TO)+''') and Project_Id='''+CONVERT(varchar(10),@Project_Id)+''' and Practice_Id='''+CONVERT(varchar(10),@Practice_Id)+'''';
   --print(@query)

   execute(@query)
  


  END
GO
/****** Object:  StoredProcedure [dbo].[UPS_Get_ImportDataDetails]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
  CREATE procedure [dbo].[UPS_Get_ImportDataDetails]
  
  @Project_Id int,
  @IMPORT_ID int

  as
 begin


SET NOCOUNT ON;
	DECLARE @listStr varchar(MAX) 
	select @listStr= coalesce(@listStr+',','')+a.Column_Name+' as ['+Display_Name +']' from tbl_COLUMN_LIST a inner join tbl_MAPPING_COLUMN_LIST b on a.Column_Id=b.Column_Id where b.Project_Id=@Project_Id
  



   DECLARE @query varchar(MAX) = 'select IMPORT_ID,'+ @listStr+' from tbl_IMPORT_TABLE where IMPORT_ID='''+CONVERT(varchar(10),@IMPORT_ID)+'''';
   --print(@query)

   execute(@query)
  


  END
GO
/****** Object:  StoredProcedure [dbo].[USP_Delete_Column_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Delete_Column_List]
	
	@COLUMN_ID int,
	@COLUMN_NAME varchar(50)

AS
BEGIN	

Delete from tbl_COLUMN_LIST where COLUMN_ID=@COLUMN_ID


DECLARE @tsql varchar (200)
SET @tsql = 'ALTER TABLE tbl_IMPORT_TABLE DROP COLUMN ['+@COLUMN_NAME+']'
EXEC(@tsql)
	
END
ALTER TABLE table_name
DROP  column_name

GO
/****** Object:  StoredProcedure [dbo].[USP_Delete_Mapping_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Delete_Mapping_List]
	
	@COLUMN_ID int,
	@PROJECT_ID int,	
	@PRACTICE_ID int
	
AS
BEGIN	

Delete from tbl_MAPPING_COLUMN_LIST where COLUMN_ID=@COLUMN_ID and PROJECT_ID=@PROJECT_ID and PRACTICE_ID=@PRACTICE_ID

	
END

--EXEC [dbo].[SP_Enter_Column_List] 

--	@COLUMN_ID=1,
--	@PROJECT_ID=1,
--	@PRACTICE_ID=1,
--	@UPDATED_BY='DebshreeC'


GO
/****** Object:  StoredProcedure [dbo].[USP_DynamicMappingColumn_Select]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[USP_DynamicMappingColumn_Select]
	@PROJECT_ID int,
	@PRACTICE_ID int
AS
BEGIN
      SET NOCOUNT ON;
	Select a.Column_Id,Column_Name,CASE WHEN b.Column_Id IS NULL THEN 'false' ELSE 'true' End AS check_list_odd,
a.column_id+1 as cid_sec,(Select Column_Name from tbl_COLUMN_LIST where Column_Id=(a.Column_Id +1) )as cname_sec,
CASE WHEN (select d.Column_Id from tbl_COLUMN_LIST c inner join(select * from tbl_MAPPING_COLUMN_LIST where PROJECT_ID=1 and PRACTICE_ID=1) d 
on c.Column_Id=d.Column_Id where d.Column_Id=a.column_id+1)
IS NULL THEN 'false' ELSE 'true' End AS check_list_even_sec,
a.column_id+2 as cid_third,(Select Column_Name from tbl_COLUMN_LIST where Column_Id= (a.Column_Id +2) )as cname_third,

CASE WHEN (select d.Column_Id from tbl_COLUMN_LIST c inner join(select * from tbl_MAPPING_COLUMN_LIST where PROJECT_ID=1 and PRACTICE_ID=1) d 
on c.Column_Id=d.Column_Id where d.Column_Id=a.column_id+2)
IS NULL THEN 'false' ELSE 'true' End AS check_list_even_third,

a.column_id+3 as cid_four,(Select Column_Name from tbl_COLUMN_LIST where Column_Id= (a.Column_Id +3) )as cname_four,

CASE WHEN (select d.Column_Id from tbl_COLUMN_LIST c inner join(select * from tbl_MAPPING_COLUMN_LIST where PROJECT_ID=1 and PRACTICE_ID=1) d 
on c.Column_Id=d.Column_Id where d.Column_Id=a.column_id+3)
IS NULL THEN 'false' ELSE 'true' End AS check_list_even_four
	 
from tbl_COLUMN_LIST a left outer join 
(select * from tbl_MAPPING_COLUMN_LIST where PROJECT_ID=1 and PRACTICE_ID=1) b on a.Column_Id=b.Column_Id
	 
	   where (a.Column_Id % 4) = 1;
RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Enter_Column_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Enter_Column_List]
	
	@COLUMN_NAME varchar(50),
	@DISPLAY_NAME varchar(150),
	@PROJECT_ID int,
	@UPDATED_BY varchar(50),
	@PRACTICE_ID int,
	@DATATYPE varchar(50)
	
AS
BEGIN	

Insert into tbl_COLUMN_LIST(COLUMN_NAME,DISPLAY_NAME,PROJECT_ID,UPDATED_BY,UPDATED_DATE,PRACTICE_ID) values 
(@COLUMN_NAME,@DISPLAY_NAME,@PROJECT_ID,@UPDATED_BY,GETDATE(),@PRACTICE_ID)


DECLARE @tsql varchar (200)
SET @tsql = 'ALTER TABLE tbl_IMPORT_TABLE ADD ['+@COLUMN_NAME+']'+@DATATYPE
EXEC(@tsql)
	
END

--EXEC [dbo].[SP_Enter_Column_List] 

--	@COLUMN_NAME='test',
--	@DISPLAY_NAME='test',
--	@PROJECT_ID=1,
--	@UPDATED_BY='DebshreeC',
--	@PRACTICE_ID=1,
--	@DATATYPE='int'





GO
/****** Object:  StoredProcedure [dbo].[USP_Enter_Import_Data_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Enter_Import_Data_List]
	
		@CLIENT_ID int
      ,@ACCOUNT_NAME varchar(500)
      ,@DOS datetime
      ,@ACCOUNT_NO varchar(500)
      ,@DENIAL_WORKED_DT datetime
      ,@ERROR_CATEGORY varchar(50)
      ,@SUB_CATEGORY_Error_Type varchar(50)
      ,@CODER_LOGIN_ID varchar(50)
      ,@QC_LOGIN_ID varchar(50)
      ,@DENIAL_TYPE varchar(50)
      ,@COMMENTS varchar(100)
      ,@AUDITOR_NAME varchar(50)
      ,@EMP_ID int
      ,@EMP_NAME varchar(50)
      ,@LOCATION_ID int
      ,@PROJECT_ID int
      ,@PRACTICE_ID int
      ,@ENTER_BY varchar(50)      
	
AS
BEGIN	

Insert into tbl_IMPORT_TABLE([CLIENT_ID]
      ,[ACCOUNT_NAME]
      ,[DOS]
      ,[ACCOUNT_NO]
      ,[DENIAL_WORKED_DT]
      ,[ERROR_CATEGORY]
      ,[SUB_CATEGORY_Error_Type]
      ,[CODER_LOGIN_ID]
      ,[QC_LOGIN_ID]
      ,[DENIAL_TYPE]
      ,[COMMENTS]
      ,[AUDITOR_NAME]
      ,[EMP_ID]
      ,[EMP_NAME]
      ,[LOCATION_ID]
      ,[PROJECT_ID]
      ,[PRACTICE_ID]
      ,[ENTER_BY]
      ,[ENTER_DATE]
      ,[UPDATE_BY]
      ,[UPDATE_DATE]) values 
(@CLIENT_ID
      ,@ACCOUNT_NAME
      ,CONVERT(varchar(10), @DOS, 101)
      ,@ACCOUNT_NO
      ,CONVERT(varchar(10), @DENIAL_WORKED_DT, 101)
      ,@ERROR_CATEGORY
      ,@SUB_CATEGORY_Error_Type
      ,@CODER_LOGIN_ID
      ,@QC_LOGIN_ID
      ,@DENIAL_TYPE
      ,@COMMENTS
      ,@AUDITOR_NAME
      ,@EMP_ID
      ,@EMP_NAME
      ,@LOCATION_ID
      ,@PROJECT_ID
      ,@PRACTICE_ID
      ,@ENTER_BY
      ,GETDATE()
      ,null
      ,null)



END
GO
/****** Object:  StoredProcedure [dbo].[USP_Enter_Mapping_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Enter_Mapping_List]
	
	@COLUMN_ID int,
	@PROJECT_ID int,	
	@PRACTICE_ID int,
	@UPDATED_BY varchar(50)
	
AS
BEGIN	

Insert into tbl_MAPPING_COLUMN_LIST(COLUMN_ID,PROJECT_ID,PRACTICE_ID,UPDATED_BY,UPDATED_DATE) values 
(@COLUMN_ID,@PROJECT_ID,@PRACTICE_ID,@UPDATED_BY,GETDATE())

	
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Enter_Transaction_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Enter_Transaction_List]

	@PRACTICE_ID int,
	@IMPORT_ID int,
	@ENTER_BY varchar(50),
	@CODED_TO varchar(50)
	
	
AS
BEGIN	
SET NOCOUNT ON;
BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO [dbo].[tbl_TRANSACTION] ([PRACTICE_ID],[IMPORT_ID],[ENTER_BY],[ENTER_DATE]) VALUES (@PRACTICE_ID,@IMPORT_ID,@ENTER_BY,GETDATE())

	INSERT INTO [dbo].[tbl_TRANSACTION_DETAILS]([TRANS_ID],[CODED_TO],[CODED_BY],[CODED_DATE],[CODED_STATUS])VALUES((select max(TRANS_ID) from tbl_TRANSACTION),@CODED_TO,@ENTER_BY,GETDATE(),'Coding Allotted')
	
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH

    ROLLBACK TRANSACTION;
END CATCH;
	
END

GO
/****** Object:  StoredProcedure [dbo].[USP_Get_Menu_Details]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_Get_Menu_Details]
	@USERNTLG VARCHAR (100),
	@PROJECT VARCHAR (10)
AS
BEGIN	


	
	
	select MENU_NAME,SUB_MENU_NAME,URL from tbl_MAIN_MENU M inner join tbl_SUB_MENU S on M.MENU_ID = S.MENU_ID and m.ACCESS_ID in 
	(SELECT ACCESS_ID FROM tbl_ACCESS_TYPE WHERE ACCESS_ID IN (SELECT ACCESS_ID FROM tbl_USER_ACCESS WHERE USER_NTLG = @USERNTLG and PROJECT_ID=@PROJECT)) and M.PROJECT_ID=@PROJECT
	ORDER BY M.MENU_ORDER_BY,S.SUB_MENU_ORDER_BY
	
	
	
	
END

--exec [SP_Get_Menu_Details] 'padmalatv',17

GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Column_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Update_Column_List]
	
	@COLUMN_ID int,
	@COLUMN_NAME varchar(50),
	@DISPLAY_NAME varchar(150),
	@UPDATED_BY varchar(50),
	@DATATYPE varchar(50)
	
AS
BEGIN	

Update tbl_COLUMN_LIST set COLUMN_NAME=@COLUMN_NAME,DISPLAY_NAME=@DISPLAY_NAME,UPDATED_BY=@UPDATED_BY,UPDATED_DATE=GETDATE() where COLUMN_ID=@COLUMN_ID


DECLARE @tsql varchar (200)
SET @tsql = 'ALTER TABLE tbl_IMPORT_TABLE ALTER COLUMN ['+@COLUMN_NAME+']'+@DATATYPE
EXEC(@tsql)
	
END

--EXEC [dbo].[SP_Enter_Column_List] 

--	@COLUMN_NAME='test',
--	@DISPLAY_NAME='test',
--	@UPDATED_BY='DebshreeC',
--	@DATATYPE='int'



GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Import_Data_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Update_Import_Data_List]
	
	@colname varchar(50),
	@colvalue varchar(50),
	@updateby varchar(50),
	@import_id int	 
	
AS
BEGIN	

DECLARE @query varchar(MAX) = 'update tbl_IMPORT_TABLE set '+ @colname+' ='''+@colvalue+''',UPDATE_BY='''+@updateby+''',UPDATE_DATE='''+CONVERT(varchar(20),getdate())+''' where IMPORT_ID='''+CONVERT(varchar(10),@import_id)+'''';
   --print(@query)

   execute(@query) 


END
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Transaction_List]    Script Date: 3/24/2017 8:15:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Update_Transaction_List]

	@PRACTICE_ID int,
	@IMPORT_ID int,
	@ENTER_BY varchar(50),
	@CODED_TO varchar(50)
	
	
AS
BEGIN	
SET NOCOUNT ON;
BEGIN TRANSACTION;

BEGIN TRY
    
	UPDATE [dbo].[tbl_TRANSACTION] SET [ENTER_BY]=@ENTER_BY,[ENTER_DATE]=GETDATE() WHERE [PRACTICE_ID]=@PRACTICE_ID AND [IMPORT_ID]=@IMPORT_ID
	

	UPDATE [dbo].[tbl_TRANSACTION_DETAILS] SET [CODED_TO]=@CODED_TO,[CODED_BY]=@ENTER_BY,[CODED_DATE]=GETDATE()  
	WHERE [TRANS_ID]=(select TRANS_ID from tbl_TRANSACTION WHERE [PRACTICE_ID]=@PRACTICE_ID AND [IMPORT_ID]=@IMPORT_ID)
	
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH

    ROLLBACK TRANSACTION;
END CATCH;
	
END
GO
