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
    public class AllotmentController : Controller
    {

        IAllotmentService managerObj = new AllotmentManager();

        //
        // GET: /Allotment/
        public ActionResult CodingAllotment()
        {
            AllotmentModel model = new AllotmentModel();           
            model.CoderList = managerObj.getCoderNames(1, 2).OrderBy(x => x.Text).ToList();
            model.PracticeList = managerObj.GetPracticeList();
            return View(model);
        }
        public ActionResult GetAccountDetails(string status, string fromDos, string toDos, int practiceId)
        {
            return PartialView("_CoderAllotmentGrid", managerObj.GetAccountDetails(status, fromDos, toDos,practiceId));
        }
        [HttpPost]
        public JsonResult CodingAllotment(string listOfAccounts, string practiceId,string codername, string buttonText)
        {
            if (buttonText == "Allot")
            {
                 managerObj.AllotToCoder(listOfAccounts, practiceId,codername);
            }
            else if (buttonText == "Re-Allot")
            {
                managerObj.UpdateAllotToCoder(listOfAccounts, practiceId, codername);
            }
            return Json("", JsonRequestBehavior.AllowGet);
        }

	}
}