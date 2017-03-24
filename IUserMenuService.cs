using Denial_Coding.BAL.ViewModels;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Denial_Coding.BAL.Managers
{
   public interface IUserMenuService
    {
       UserMenuModel GetProject_locationList();
       void SaveSessionDetails(UserMenuModel model);
       void GetSideMenu();
       //void ManageImportAccounts(List<ImportModel> model, string status);
       //ImportModel InsertExcelData(DataSet ds,string type);
       //DataTable GetUnsuccessFullUploadData();
       //void GetHeaderCounts();
       //List<ImportModel> GetHCCUploadedAccounts();
    }
}
