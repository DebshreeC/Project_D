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
    public interface IImportService
    {

        DataTable GetFullUploadData(int Practice_Id);
        List<SelectListItem> GetPracticeList();
        ImportModel InsertExcelData(DataSet ds, string practiceId);
        ImportModel ImportData(ImportModel model);
        void ManageImportAccounts(List<ImportModel> model, string status);
        List<SelectListItem> GetClientList();
        List<SelectListItem> GetAccountList();
        List<SelectListItem> GetErrorCategoryList();
        List<SelectListItem> GetSubCategoryList(string errorId);
    }
}
