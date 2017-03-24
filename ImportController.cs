using Denial_Coding.BAL.Generics;
using Denial_Coding.BAL.Managers;
using Denial_Coding.BAL.ViewModels;
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



namespace Denial_Coding.Controllers
{
    public class ImportController : Controller
    {

        

        //
        // GET: /Import/
        public ActionResult Index()
        {
            return View();
        }

        IUserMenuService managerObj = new UserMenuManager();
        IImportService managerObjImp = new ImportManager();
        //IAdminService managerObjad = new AdminManager();

        public ActionResult ImportIndex(UserMenuModel model)
        {
            managerObj.SaveSessionDetails(model);
            managerObj.GetSideMenu();            
            return View();
        }
        public ActionResult Import()
        {
            ImportModel model = new ImportModel();
            model.PracticeList = managerObjImp.GetPracticeList();           
            model.PROJECT_ID =Convert.ToInt32(Session[Constants.ProjectId].ToString());             
            return View(model);
        }
        [HttpPost]
        public ActionResult Import(HttpPostedFileBase file, ImportModel model)
        {
            try
            {
                int practiceId = Convert.ToInt32(model.SelectedPractice);
                if (practiceId == 0)
                {
                    ViewBag.Message = "Select Practice for Import";
                }
                else
                {
                    if (Request != null)
                    {
                        if ((file != null) && (file.ContentLength > 0) && !string.IsNullOrEmpty(file.FileName))
                        {
                            string fileName = file.FileName;
                            string fileContentType = file.ContentType;
                            model = ReadExcel(fileName, file, 1, practiceId.ToString());
                        }
                    }
                }
                model.PracticeList = managerObjImp.GetPracticeList();
                model.PROJECT_ID = Convert.ToInt32(Session[Constants.ProjectId].ToString());

            }
            catch (Exception ex)
            {

            }
            return View(model);
        }
       
        private ImportModel ReadExcel(string FileName, HttpPostedFileBase FilePath, int CId, string practiceId)
        {
            string excelConnectionString = string.Empty;

            ImportModel modal = new ImportModel();
            DataSet ds = new DataSet();
            try
            {
                if (Request.Files["file"].ContentLength > 0)
                {
                    string fileExtension = System.IO.Path.GetExtension(Request.Files["file"].FileName);

                    if (fileExtension == ".xls" || fileExtension == ".xlsx")
                    {
                        string fileLocation = Path.Combine(Server.MapPath("~/Scripts"), Path.GetFileName(FilePath.FileName));
                        if (System.IO.File.Exists(fileLocation))
                        {
                            System.IO.File.Delete(fileLocation);
                        }
                        // File is saving into Input Folder 

                        Request.Files["file"].SaveAs(fileLocation);

                        //excelConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"";

                        //connection String for xls file format.

                        if (fileExtension.Trim() == ".xls")
                        {
                            excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fileLocation + ";Extended Properties=\"Excel 8.0;IMEX=1;HDR=YES;TypeGuessRows=0;ImportMixedTypes=Text\"";
                        }
                        else if (fileExtension.Trim() == ".xlsx")
                        {
                            excelConnectionString = @"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fileLocation + @";Extended Properties=""Excel 12.0;IMEX=1;HDR=YES;TypeGuessRows=0;ImportMixedTypes=Text""";
                        }

                        //Create Connection to Excel work book and add oledb namespace
                        OleDbConnection excelConnection = new OleDbConnection(excelConnectionString);
                        excelConnection.Open();

                        string query = string.Format("Select * from [Sheet1$]");

                        using (OleDbDataAdapter dataAdapter = new OleDbDataAdapter(query, excelConnection))
                        {
                            dataAdapter.Fill(ds);
                        }
                        excelConnection.Close();
                    }
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        ViewBag.Message = "Data has been Uploaded";
                        return managerObjImp.InsertExcelData(ds, practiceId);
                    }
                    else
                    {
                        ViewBag.Message = "Data is not availble in uploaded Excel";
                        return modal;
                    }
                }
                else
                {
                    return modal;
                }
            }
            catch (Exception ex)
            {
                ViewBag.Message = "Excel is not in correct format";
                return modal;
            }
        }
        public ActionResult MasterData()
        {
            ImportModel model = new ImportModel();
            model.PracticeList = managerObjImp.GetPracticeList();
            model.ClientList = managerObjImp.GetClientList();
            model.AccountNoList = managerObjImp.GetAccountList();
            model.ERRORCATEGORYList = managerObjImp.GetErrorCategoryList();
            //model.SUBCATEGORYList = managerObjImp.GetSubCategoryList();
            model.PROJECT_ID = Convert.ToInt32(Session[Constants.ProjectId].ToString());
            return View(model);
        }

        [HttpPost]
        public JsonResult ImportData(ImportModel model)
        {           
            model.PracticeList = managerObjImp.GetPracticeList();
            model.PROJECT_ID = Convert.ToInt32(Session[Constants.ProjectId].ToString());
            if(model.CLIENT_ID==0 && model.ACCOUNT_NAME==null && model.DOS==null && model.ACCOUNT_NO==null && model.DENIAL_WORKED_DT==null && model.ERROR_CATEGORY==null && model.SUB_CATEGORY_Error_Type==null && model.CODER_LOGIN_ID==null && model.QC_LOGIN_ID==null && model.DENIAL_TYPE==null && model.COMMENTS==null && model.AUDITOR_NAME==null && model.EMP_ID==0 && model.EMP_NAME==null)
            {
                ViewBag.Message = "Enter Valid Data";
            }
            else
            {
            managerObjImp.ImportData(model);
            }
            return Json("", JsonRequestBehavior.AllowGet);
        }

        public ActionResult LoadImportInbox(int Practice_Id)
        {
             string connectionString = ConfigurationManager.ConnectionStrings["McKesson_GVLEntities"].ConnectionString;
             return PartialView("_ImportPartialGrid", managerObjImp.GetFullUploadData(Practice_Id));
        }
        [HttpPost]
        public ActionResult UpdateInnerGrid(List<ImportModel> modelList, string operation)
        {
            managerObjImp.ManageImportAccounts(modelList, operation);

            return Json("Success", JsonRequestBehavior.AllowGet);
        }
        public JsonResult SubCategorySelection(string errorId)
        {
            return Json(managerObjImp.GetSubCategoryList(errorId), JsonRequestBehavior.AllowGet);
        }

	}
}