using McKesson_Denial_Coding.BAL.Generics;
using McKesson_Denial_Coding.BAL.Managers;
using McKesson_Denial_Coding.BAL.ViewModels;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;

namespace McKesson_Denial_Coding.Controllers
{
    public class ImportController : Controller
    {
        //
        // GET: /Import/
        IUserMenuService managerObj = new UserMenuManager();

        public ActionResult Index(UserMenuModel model)
        {
            managerObj.SaveSessionDetails(model);
            managerObj.GetSideMenu();
            return View();
        }
        public ActionResult Import()
        {
            //ImportModel model = new ImportModel();
            //model.ProjectId = Session[Constants.ProjectId].ToString();
            //return View(model);
            return View();
        }
        [HttpPost]
        //public ActionResult Import(HttpPostedFileBase file, ImportModel modal)
        public ActionResult Import(HttpPostedFileBase file)
        {

            //if (Request != null)
            //{

            //    if ((file != null) && (file.ContentLength > 0) && !string.IsNullOrEmpty(file.FileName))
            //    {
            //        string fileName = file.FileName;
            //        string fileContentType = file.ContentType;
            //        modal = ReadExcel(fileName, file, 1, string.Empty);

            //    }
            //}
            //modal.ProjectId = Session[Constants.ProjectId].ToString();
            //return View(modal);
            return View();

        }
	}
}