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
    public interface ITransactionService
    {
        List<TransactionModel> LoadCoderInboxData();
        DataTable EditTransactionList(string Import_ID);
        List<SelectListItem> GetClientList();
        List<SelectListItem> GetAccountList();
        List<SelectListItem> GetErrorCategoryList();
        List<SelectListItem> GetSubCategoryList(string errorId);
        void UpdateTransaction(FormCollection frm, int import_id);
    }
}
