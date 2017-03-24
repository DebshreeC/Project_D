using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Denial_Coding.BAL.Generics;
using Denial_Coding.BAL.Managers;
using Denial_Coding.BAL.ViewModels;

namespace Denial_Coding.Controllers
{
    public class TransactionController : Controller
    {
        //
        // GET: /Transaction/
        ITransactionService managerObj = new TransactionManager();
        public ActionResult CodingTransaction()
        {
            return View();
        }
        public ActionResult LoadCoderInbox()
        {
            return PartialView("_CoderInbox", managerObj.LoadCoderInboxData());
        }

        public ActionResult EditTransactionList(string Import_ID)
        {
            ViewBag.CLIENTID=managerObj.GetClientList();
            ViewBag.ACCOUNTNO=managerObj.GetAccountList();
            ViewBag.ERRORCATEGORY = managerObj.GetErrorCategoryList().ToList();
            //ViewBag.SUBCATEGORYErrorType=managerObj.GetSubCategoryList();
            return PartialView("_TransactionImport", managerObj.EditTransactionList(Import_ID));            
        }

        [HttpPost]
        public JsonResult UpdateTransaction(FormCollection frm)
        {
            int import_id = Convert.ToInt32(frm["IMPORT_ID"]);
            managerObj.UpdateTransaction(frm, import_id);
            //System.Web.HttpContext.Current.Session[Constants.Flag] = true;
            return Json("", JsonRequestBehavior.AllowGet);
        }
        public JsonResult SubCategorySelection(string errorId)
        {
            return Json(managerObj.GetSubCategoryList(errorId), JsonRequestBehavior.AllowGet);
        }

	}
}