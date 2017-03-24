using Denial_Coding.BAL.ViewModels;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;

namespace Denial_Coding.BAL.Managers
{
    public interface IAllotmentService
    {
        
        List<SelectListItem> getCoderNames(int tl, int user);
        DataTable GetAccountDetails(string status, string fromDos, string toDos, int practiceId);
        List<SelectListItem> GetPracticeList();
        void AllotToCoder(string listOfAccounts, string practiceId, string codername);
        void UpdateAllotToCoder(string listOfAccounts, string practiceId, string codername);

    }
}
