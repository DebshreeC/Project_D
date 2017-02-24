using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace McKesson_Denial_Coding.BAL.ViewModels
{
    public class UserMenuModel
    {
        public string UserName { get; set; }
        ////public List<string> ListOfMainMenu { get; set; }
        ////public List<string> ListOfSubMenu { get; set; }
        //public string MainMenu { get; set; }
        //public string SubMenu { get; set; }
        public List<SelectListItem> ProjectList { get; set; }
        public string SelectedProject { get; set; }
        public List<SelectListItem> LocationList { get; set; }
        public string SelectedLocation { get; set; }
    }
}
