using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace Denial_Coding.BAL.ViewModels
{
    public class AllotmentModel
    {
        public List<SelectListItem> Status { get; set; }
        //public List<SelectListItem> BatchList { get; set; }
        //public List<SelectListItem> FacilityList { get; set; }
        //public string BatchName { get; set; }
        //public string Facility { get; set; }
        public string FromDOS { get; set; }
        public string ToDOS { get; set; }
        public Int32 From { get; set; }
        public Int32 To { get; set; }
        public List<SelectListItem> CoderList { get; set; }
        public List<SelectListItem> QCList { get; set; }
        public string SeletedCoder { get; set; }
        public string Coder { get; set; }
        public string AccountNumber { get; set; }
        public string Location { get; set; }
        //public string Jobname { get; set; }
        public string Pagecount { get; set; }
        public string AllottedTo { get; set; }
        //public string BatchStatus { get; set; }
        public DateTime? DOS { get; set; }
        public string SessionAccounts { get; set; }
        public string CodedBy { get; set; }
        public DateTime? CodedDate { get; set; }
        public string SeletedQC { get; set; }
        public List<SelectListItem> QCStatusList { get; set; }
        public string QCStatus { get; set; }
        public List<SelectListItem> AuditTypeList { get; set; }
        public string AuditType { get; set; }
        public string ProjectId { get; set; }
        public List<SelectListItem> PracticeList { get; set; }
        public string SelectedPractice { get; set; }
    }
}
