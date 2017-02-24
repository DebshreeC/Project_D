using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace McKesson_Denial_Coding.BAL.Generics
{
   public class Constants
   {
       #region Session Variables
       public const string UserName = "UserName";
       public const string ProjectId = "ProjectId";
       public const string UserMenu = "UserMenu";
       public const string PracticeId = "PracticeId";
       public const string ProjectName = "ProjectName";
       #endregion
       #region FontIcons
       public const string FontImport = "fa fa-download";
       public const string FontTransaction = "fa fa-cc-mastercard";
       public const string FontAllotment = "fa fa-archive";
       public const string FontReports = "fa fa-edit";
       public const string FontErrorLog = "fa fa-bug";
       public const string FontFeedBack = "fa fa-book";
       public const string Allottment = "fa fa-users";
       public const string Clarification = "fa fa-sliders";
       public const string QCTransaction="fa fa-newspaper-o";
       public const string ReleaseScreen = "fa fa-check-square-o";
       #endregion
       #region Static Messages
       public const string CommaSpace = "; ";
       public const string ValidationError = "The validation errors are: ";
       #endregion
       #region ProjectNames
       //public const string PeriMeter = "16";
       //public const string MedData = "17";
       //public const string HighMark = "18";
       #endregion
       #region TableConstantMessages
       public const string ApplyAll="Apply All";
       public const string Upload = "Upload";
       public const string Delete = "Delete";
       public const string JobName="Job Name";
       public const string DateImage = "Date Image";
       public const string PageCount="Page Count";
       public const string ImagingType="Imaging Type";
       public const string Description = "Description";
       public const string BatchNo = "Batch No";
       public const string Location = "Location";

       public const string TrackingCode="Tracking Code";
       public const string BatchName = "Batch Name";
       public const string ECI = "ECI";
       public const string UMI = "UMI";
       public const string HIC = "HIC";
       public const string MemberFirstName="Member First Name";
       public const string MemberLastName = "Member Last Name";
       public const string MemberDob="MEMBER DOB";
       public const string EncounterType="ENCOUNTER TYPE";
       public const string MemberGender="Member Gender";
       public const string PerformingProviderNPI="Performing Provider NPI";
       public const string PerformingProviderBSID="Performing Provider BSID";
       public const string BillingProviderNPI="Billing Provider NPI";
       public const string BillingProviderBSID="Billing Provider BSID";
       public const string ScheduledRetrievalDate = "Scheduled Retrieval Date";
       #endregion
       #region HeaderCounts
       public const string HeaderFresh = "Fresh";
       public const string HeaderAllotted = "Allotted";
       public const string HeaderCoded = "Coded";
       public const string HeaderQced = "Qced";
       public const string HeaderReleased = "Completed";
       public const string HeaderCodingInProcess = "CodingInProcess";
       public const string Completed = "Completed";
       public const string CodingInProgress = "In Process";

       public const string HeaderFreshtoday = "Freshtoday";
       public const string HeaderAllottedtoday = "Allottedtoday";
       public const string HeaderCodedtoday = "Codedtoday";
       public const string HeaderQcedtoday = "Qcedtoday";
       public const string HeaderReleasedtoday = "Completedtoday";
       public const string HeaderCodingInProcesstoday = "CodingInProcesstoday";
       public const string Completedtoday = "Completedtoday";
       public const string CodingInProgresstoday = "In Processtoday";
       #endregion
       #region StoredProcedure
       public const string SpColumnList = "SP_Get_Column_List";
       public const string SpMappingList = "SP_Get_Column_List";
       //public const string SpReleaseScreen = "ups_Get_ReleaseScreenData";
       //public const string SpQcAllotment = "ups_Get_QcAllotmentData";
       //public const string SpQcAllotmentHighMark = "ups_Get_QcAllotmentDataHighMark";
       //public const string SPCodingAllotment = "ups_Get_AllotmentData";
       //public const string SPQcFeedBackData = "ups_Get_QcFeedBackData";
       //public const string SPQcClarificationData = "ups_Get_QcClarificationData";
       //public const string SPIncrementalAccountDetails ="USP_SELECT_INCREMENTAL_ACCOUNT_DETAILS";
       //public const string SPMasterList = "sp_Master_list";
       //public const string AllotedDetails = "usp_getCoderAndQCAllotedDetails";
       //public const string PeriProductionReport = "sp_Production_Report_ICD10Validate";
       //public const string ProductionTransDetails = "sp_Trans_Details";
       

       //public const string SPErrorAccoumts = "ups_Check_Error_Accounts";
       //public static string ReportIpAddress = ConfigurationSettings.AppSettings["reportServer"].ToString();
       public static string ConnectionString = ConfigurationSettings.AppSettings["sqlCon"].ToString();
       ////CBI_Anes_High_UAT
       //public static string ErrorLog = ConfigurationSettings.AppSettings["ErrorLog"].ToString();
       //public static string ProductionReport = ConfigurationSettings.AppSettings["ProductionReport"].ToString();
       //public static string QCProductionReport = ConfigurationSettings.AppSettings["QCProductionReport"].ToString(); 
       ////public const string ReleasedReport = "/CBI_UAT_Reports/Reports/CBI_ReleaseProdReport";
       //public static string ReleasedReport = ConfigurationSettings.AppSettings["ReleasedReport"].ToString();
       ////public static string AccurcyReport = ConfigurationSettings.AppSettings["AccurcyReport"].ToString();
       //public static string AccurcyReport = ConfigurationSettings.AppSettings["AccurcyReportHighMark"].ToString();
       //public static string HighMarkReleasedReport = ConfigurationSettings.AppSettings["HighMarkReleasedReport"].ToString(); 

      // CBI_Anes_High_Live
       //public const string ConnectionString = "data source=BLRVMDB95;initial catalog=CBIPlus;integrated security=True;multipleactiveresultsets=True;";
       //public const string ErrorLog = "/CBI Plus/Reports/ErrorLog";
       //public const string ProductionReport = "/CBI Plus/Reports/CodingProductionReport";
       //public const string QCProductionReport = "/CBI Plus/Reports/QCProductionReport";
       //public const string ReleasedReport = "/CBI Plus/Reports/ReleaseReport";
       //public const string AccurcyReport = "/CBI Plus/Reports/AccuracyReport";
       //public const string AccurcyReportHighMark = "/CBI Plus/Reports/AccuracyReportHighMark";

       #endregion
    

       #region PeriMeterConstants
       //public const string AccountNumber = "ACCOUNT_NO";
       //public const string Facility = "FACILITY";
       //public const string MRN = "MRN";
       //public const string FirstName = "First_Name";
       //public const string LastName = "Last_Name";
       //public const string PatientName = "PATIENT_NAME";
       //public const string ReceivedDate = "RECEIVED_DATE";
       //public const string PayerClass = "PAYER_CLASS";
       //public const string Speciality = "SPECIALITY";
       //public const string IcdCode = "ICD_CODE";
       //public const string DOS = "DOS";
       //public const string PeriBatchName = "BATCH_NAME";
       ////reports
       //public static string ErrorCommentLog = ConfigurationSettings.AppSettings["ErrorCommentLog"].ToString();
       //public static string AccurcyReportPerimeter = ConfigurationSettings.AppSettings["AccurcyReportPerimeter"].ToString();
       //public static string PDFPath=ConfigurationSettings.AppSettings["PDFPath"].ToString();
       #endregion
   }
}
