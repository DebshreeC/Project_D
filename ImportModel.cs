using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace Denial_Coding.BAL.ViewModels
{
    public class ImportModel
    {       
        public int IMPORT_ID { get; set; }
        public int CLIENT_ID { get; set; }
        public string ACCOUNT_NAME { get; set; }
        public DateTime? DOS { get; set; }
        public string ACCOUNT_NO { get; set; }
        public DateTime? DENIAL_WORKED_DT { get; set; }
        public string ERROR_CATEGORY { get; set; }
        public string SUB_CATEGORY_Error_Type { get; set; }
        public string CODER_LOGIN_ID { get; set; }
        public string QC_LOGIN_ID { get; set; }
        public string DENIAL_TYPE { get; set; }
        public string COMMENTS { get; set; }
        public string AUDITOR_NAME { get; set; }
        public int EMP_ID { get; set; }
        public string EMP_NAME { get; set; }
        public int LOCATION_ID { get; set; }
        public int PROJECT_ID { get; set; }
        public int PRACTICE_ID { get; set; }
        public string ENTER_BY { get; set; }
        public DateTime? ENTER_DATE { get; set; }
        public string UPDATE_BY { get; set; }
        public DateTime? UPDATE_DATE { get; set; }
        public string FieldName { get; set; }
        public int TotalExcelCount { get; set; }
        public int SuccessfullCount { get; set; }
        public int UnsuccessfullCount { get; set; }
        //public int Practice_Id { get; set; }
        //public string Practice { get; set; }
        public List<SelectListItem> PracticeList { get; set; }
        public string SelectedPractice { get; set; }
        public List<string> Headers { get; set; }
        public string SelectedHeader { get; set; }
        public string SearchText { get; set; }

        //public List<string> GridHeaders { get; set; }
        //public List<string> UniqueBatchList { get; set; }

        //public List<string> Headers { get; set; }

        //public DateTime? DOS { get; set; }

        //accountname=clientname

        //public string Clinet_Name { get; set; }
        public List<SelectListItem> ClientList { get; set; }
        public string SelectedClient { get; set; }
        public string Account_Name_db { get; set; }
        public List<SelectListItem> AccountNoList { get; set; }
        public string SelectedAccountNo { get; set; }

        public List<SelectListItem> ERRORCATEGORYList { get; set; }
        public string SelectedERRORCATEGORY { get; set; }
        public List<SelectListItem> SUBCATEGORYList { get; set; }
        public string SelectedSUBCATEGORY { get; set; }

    }
}
