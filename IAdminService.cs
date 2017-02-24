using McKesson_Denial_Coding.BAL.ViewModels;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace McKesson_Denial_Coding.BAL.Managers
{
    public interface IAdminService
    {
        AdminModel GetPracticeList();
        //UserMenuModel GetProject_LocationList();

        List<AdminModel> GetColumnListData(AdminModel model);
        //DataTable GetColumnListData();
        DataTable GetMappingData();
    }
}
