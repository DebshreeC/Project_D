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
    public class HomeController : Controller
    {
        IUserMenuService managerObj = new UserMenuManager();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult Home()
        {
            managerObj.GetProject_LocationList();
            return View(managerObj.GetProject_LocationList());
        }
        [HttpPost]
        public ActionResult LoadClientMenu(UserMenuModel model)
        {
            return RedirectToAction("Index", "Import", model);
        }

        #region SignOut

        /// <summary>
        ///     This function used to logout from application and kill all the sessions
        /// </summary>
        /// <returns></returns>
        public ActionResult SignOut()
        {
            Session[Constants.UserName] = null;
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();
            return RedirectToAction("Home");

        }

        #endregion

    }
}