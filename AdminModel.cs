using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace Denial_Coding.BAL.ViewModels
{
    public class AdminModel
    {
        public int ColumnId { get; set; }
        public string ColumnName { get; set; }
        public List<SelectListItem> ColumnList { get; set; }
        public string SelectedColumn { get; set; }        
        public string Display_Name{ get; set; }
        public int Project_Id{ get; set; }        
        public int Practice_Id { get; set; }
        public int Mapping_Id { get; set; }
        public string Practice { get; set; }
        public List<SelectListItem> PracticeList { get; set; }
        public List<SelectListItem> MappingList { get; set; }
        public string SelectedPractice { get; set; }
        public string UPDATED_BY{ get; set; }
        public string UPDATED_DATE { get; set; }
        public List<SelectListItem> ProjectList { get; set; }
        public string SelectedProject { get; set; }
        public string DataType { get; set; }
    }
}
