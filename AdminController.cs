using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using McKesson_Denial_Coding.BAL.Generics;
using McKesson_Denial_Coding.BAL.Managers;
using McKesson_Denial_Coding.BAL.ViewModels;

namespace McKesson_Denial_Coding.Controllers
{
    public class AdminController : Controller
    {
        //
        // GET: /Admin/

        IAdminService managerObj = new AdminManager();



        public ActionResult Index()
        {
            //managerObj.GetProject_LocationList();
            //return View(managerObj.GetProject_LocationList());
            return View(managerObj.GetPracticeList());
        }

        public ActionResult LoadColumnInbox(AdminModel model)
        {
            return PartialView("_ColumnInbox", managerObj.GetColumnListData(model));
        }

        public ActionResult AddColumnList(string Practice,string ColumnName,string ColumnDisplay)
        {
            managerObj.ADDColumn(Practice,ColumnName,ColumnDisplay);
            return View();
        }

	}
}