using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Denial_Coding.BAL.Generics
{
   public class Constants
   {
       #region Session Variables
       public const string UserName = "UserName";
       public const string ProjectId = "ProjectId";
       public const string UserMenu = "UserMenu";
       public const string ClientId = "ClientId";
       public const string ProjectName = "ProjectName";
       public const string Flag = "flag";
       public const string LocationId = "LocationId";
       public const string LocationName = "LocationName";
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
       #region TableConstantMessages
       public const string ApplyAll = "Apply All";
       public const string Upload = "Upload";
       public const string Delete = "Delete";
      
       #endregion
       #region StoredProcedure
       public const string SpUnsuccessImportData = "UPS_Get_ImportData";
       public const string SpUnsuccessImportDataAccess = "UPS_Get_ImportData_Access";
       public const string SpMappingList = "USP_DynamicMappingColumn_Select";
       public const string SpDeleteColumn = "USP_Delete_Column_List";
       public const string SPCodingAllotment = "UPS_Get_AllotmentData";
       public const string SPClientList = "UPS_Get_CLIENTList";
       public const string SPClientDetailsList = "UPS_Get_CLIENTDetailsList";
       public const string SpDeleteClient = "UPS_delete_CLIENT";
       public const string SPAccountList = "UPS_Get_AccountList";
       public const string SPAccountDetailsList = "UPS_Get_AccountDetailsList";
       public const string SpDeleteAccount = "UPS_delete_Account";
       public const string ImportDataDetails = "UPS_Get_ImportDataDetails";
       public static string ConnectionString = ConfigurationManager.AppSettings["sqlCon"].ToString();

       #endregion


       #region DenialConstants
       public const string CLIENTID = "CLIENT_ID";
       public const string ACCOUNTNAME = "ACCOUNT_NAME";
       public const string DOS = "DOS";
       public const string ACCOUNTNO = "ACCOUNT_NO";
       public const string DENIALWORKEDDT = "DENIAL_WORKED_DT";
       public const string ERRORCATEGORY = "ERROR_CATEGORY";
       public const string SUBCATEGORY = "SUB_CATEGORY";
       public const string CODERLOGINID = "CODER_LOGIN_ID";
       public const string QCLOGINID = "QC_LOGIN_ID";
       public const string DENIALTYPE = "DENIAL_TYPE";
       public const string COMMENTS = "COMMENTS";
       public const string AUDITOR_NAME = "AUDITOR_NAME";
       public const string EMPID="EMP_ID";
       public const string EMPNAME = "EMP_NAME";
       
       ////reports
       //public static string EM_Analysis = ConfigurationSettings.AppSettings["EM_Analysis"].ToString();
       //public static string ErrorCommentLog = ConfigurationSettings.AppSettings["ErrorCommentLog"].ToString();
       //public static string TimeTrackerReport = ConfigurationSettings.AppSettings["TimeTrackerReport"].ToString();
       //public static string TATReport = ConfigurationSettings.AppSettings["TATReport"].ToString();
       //public static string AccurcyReportPerimeter = ConfigurationSettings.AppSettings["AccurcyReportPerimeter"].ToString();
       //public static string PDFPath=ConfigurationSettings.AppSettings["PDFPath"].ToString();
       #endregion
   }
}
