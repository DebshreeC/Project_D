using Denial_Coding.BAL.Generics;
using Denial_Coding.BAL.ViewModels;
using DC.DAL;

using Microsoft.Win32.SafeHandles;
using System;
using System.Collections.Generic;
using System.Data;
//using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
//using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Data.Entity;
using System.Data.Entity.SqlServer;

namespace Denial_Coding.BAL.Managers
{
    public class ImportManager : IImportService
    {
        #region GetUnsuccessFullUploadData
        public DataTable GetFullUploadData(int Practice_Id)
        {
            DataSet dsCommon = new DataSet();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {

                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                string userName = HttpContext.Current.Session[Constants.UserName].ToString();
                try
                {
                    var access_id = (from use in _context.tbl_USER_ACCESS where use.USER_NTLG == userName select new { use.ACCESS_ID }).Single();
                     int acc_id = Convert.ToInt32(access_id.ACCESS_ID.ToString());
                     if (acc_id == 1)
                     {
                         dsCommon.Clear();
                         SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                         conObj.Open();
                         SqlCommand cmdObj = new SqlCommand(Constants.SpUnsuccessImportDataAccess, conObj);
                         cmdObj.CommandType = CommandType.StoredProcedure;
                         cmdObj.Parameters.AddWithValue("@Project_Id", projectId);
                         cmdObj.Parameters.AddWithValue("@Practice_Id", Practice_Id);
                         cmdObj.Parameters.AddWithValue("@CODED_TO", userName);
                         SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                         adapter1.Fill(dsCommon);
                         conObj.Close();
                         var tt = dsCommon;
                     }
                     else
                     {
                         dsCommon.Clear();
                         SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                         conObj.Open();
                         SqlCommand cmdObj = new SqlCommand(Constants.SpUnsuccessImportData, conObj);
                         cmdObj.CommandType = CommandType.StoredProcedure;
                         cmdObj.Parameters.AddWithValue("@Project_Id", projectId);
                         cmdObj.Parameters.AddWithValue("@Practice_Id", Practice_Id);
                         SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                         adapter1.Fill(dsCommon);
                         conObj.Close();
                         var tt = dsCommon;
                     }
                }
                catch (Exception e)
                {
                    throw e;
                }

                return dsCommon.Tables[0];
            }
        }
        #endregion

        #region Get Practice Names
        public List<SelectListItem> GetPracticeList()
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    //ImportModel model = new ImportModel();
                    string userName = System.Environment.UserName.ToString();

                    int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());

                    var list = (from practice in _context.tbl_PRACTICE_MASTER
                                          join project in _context.tbl_PROJECT_MASTER on practice.PROJECT_ID equals project.PROJECT_ID
                                          where project.PROJECT_ID == Project_id
                                          select new SelectListItem
                                          {
                                              Text = practice.PRACTICE,
                                              Value = SqlFunctions.StringConvert((double)practice.PRACTICE_ID).Trim()
                                          }).ToList();

                    return list;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion       

        #region InsertExcelData
        public ImportModel InsertExcelData(DataSet ds, string practiceId)
        {
            ImportModel model = new ImportModel();
            try
            {

                if (ds.Tables[0].Rows.Count > 0)
                {

                    model = uploadExcel(ds, practiceId);
                        ds.Clear();
                        ds = null;
                   
                }

            }

            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors.SelectMany(x => x.ValidationErrors).Select(x => x.ErrorMessage);
                var fullErrorMessage = string.Join(Constants.CommaSpace, errorMessages);
                var exceptionMessage = string.Concat(ex.Message, Constants.ValidationError, fullErrorMessage);
                throw new DbEntityValidationException(exceptionMessage, ex.EntityValidationErrors);
            }
            return model;

        }
        #endregion

        #region uploadExcel
        public ImportModel uploadExcel(DataSet ds,string practiceId)
        {

            int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
            int locationId = Convert.ToInt32(HttpContext.Current.Session[Constants.LocationId]);
            string userName = HttpContext.Current.Session[Constants.UserName].ToString();
            int practiceid = Convert.ToInt32(practiceId);

            ImportModel model = new ImportModel();
            model.TotalExcelCount = ds.Tables[0].Rows.Count;
            model.UnsuccessfullCount = 0;
            model.SuccessfullCount = 0;
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    StringBuilder builder = new StringBuilder();
                    string clientid = Convert.ToString(dr[Constants.CLIENTID]);
                    string accountname = Convert.ToString(dr[Constants.ACCOUNTNAME]);
                    DateTime? dos = null;
                    if (!string.IsNullOrEmpty(Convert.ToString(dr[Constants.DOS])))
                    {
                        string dtofservice = Convert.ToString(dr[Constants.DOS]);
                        dos = Convert.ToDateTime(dtofservice, System.Globalization.CultureInfo.GetCultureInfo("ur-PK").DateTimeFormat);
                    }                   
                    string accountno = Convert.ToString(dr[Constants.ACCOUNTNO]);
                    DateTime ?denialworkeddate = null;
                    if (!string.IsNullOrEmpty(Convert.ToString(dr[Constants.DENIALWORKEDDT])))
                    {
                        string denialdt = Convert.ToString(dr[Constants.DENIALWORKEDDT]);
                        denialworkeddate = Convert.ToDateTime(denialdt, System.Globalization.CultureInfo.GetCultureInfo("ur-PK").DateTimeFormat);
                    }
                    string errorcategory = Convert.ToString(dr[Constants.ERRORCATEGORY]);
                    string subcategory = Convert.ToString(dr[Constants.SUBCATEGORY]);
                    string coderloginid = Convert.ToString(dr[Constants.CODERLOGINID]);
                    string qcloginid = Convert.ToString(dr[Constants.QCLOGINID]);                    
                    string denialtype = Convert.ToString(dr[Constants.DENIALTYPE]);
                    string comments = Convert.ToString(dr[Constants.COMMENTS]);
                    string auditorname = Convert.ToString(dr[Constants.AUDITOR_NAME]);
                    int empid = 0;
                    if (!string.IsNullOrEmpty(Convert.ToString(dr[Constants.EMPID])))
                    {
                        empid = Convert.ToInt32(dr[Constants.EMPID]);
                    }                     
                    string empname = Convert.ToString(dr[Constants.EMPNAME]);

                                      
                        //tbl_IMPORT_TABLE record = new tbl_IMPORT_TABLE();
                        //record.CLIENT_ID =Convert.ToInt32(clientid);                        
                        //record.ACCOUNT_NAME = accountname;
                        //record.DOS = Convert.ToDateTime(dos);
                        //record.ACCOUNT_NO = accountno;
                        //record.DENIAL_WORKED_DT = Convert.ToDateTime(denialworkeddate);
                        //record.ERROR_CATEGORY = errorcategory;
                        //record.SUB_CATEGORY_Error_Type = subcategory;
                        //record.CODER_LOGIN_ID = coderloginid;
                        //record.QC_LOGIN_ID = qcloginid;
                        //record.DENIAL_TYPE = denialtype;
                        //record.COMMENTS = comments;
                        //record.AUDITOR_NAME = auditorname;
                        //record.LOCATION_ID = locationId;
                        //record.PROJECT_ID = projectId;
                        //record.PRACTICE_ID = practiceid;
                        //if (!string.IsNullOrEmpty(empid.ToString()))
                        //{
                        //    record.EMP_ID = Convert.ToInt32(empid);
                        //}
                        //else
                        //{
                        //    record.EMP_ID = 0;
                        //}                        
                        //record.EMP_NAME = empname;
                        //record.ENTER_BY = userName;
                        //record.ENTER_DATE = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                        //_context.tbl_IMPORT_TABLE.Add(record);

                    _context.USP_Enter_Import_Data_List(Convert.ToInt32(clientid), accountname, dos, accountno, denialworkeddate, errorcategory, subcategory, coderloginid, qcloginid, denialtype, comments, auditorname, empid, empname, locationId, projectId, practiceid, userName);


                        model.SuccessfullCount = model.SuccessfullCount + 1;                   
                }
                _context.SaveChanges();
            }

            return model;

        }

        #endregion

        #region Get Client Names
        public List<SelectListItem> GetClientList()
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    //ImportModel model = new ImportModel();
                    string userName = System.Environment.UserName.ToString();

                    int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());

                    var list = (from client in _context.tbl_CLIENT_TABLE
                                //join project in _context.tbl_PROJECT_MASTER on practice.PROJECT_ID equals project.PROJECT_ID
                                //where project.PROJECT_ID == Project_id
                                select new SelectListItem
                                {
                                    Text = SqlFunctions.StringConvert((double)client.Client_ID).Trim(),
                                    Value = SqlFunctions.StringConvert((double)client.Client_ID).Trim()
                                }).Distinct().ToList();

                    return list;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion       

        #region Get Account Names
        public List<SelectListItem> GetAccountList()
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    //ImportModel model = new ImportModel();
                    string userName = System.Environment.UserName.ToString();

                    int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());

                    var list = (from account in _context.tbl_ACCOUNT_TABLE
                                //join project in _context.tbl_PROJECT_MASTER on practice.PROJECT_ID equals project.PROJECT_ID
                                //where project.PROJECT_ID == Project_id
                                select new SelectListItem
                                {
                                    Text = account.Account_No.ToString(),
                                    Value = account.Account_No.ToString()
                                }).Distinct().ToList();

                    return list;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion   

        #region Get ErrorCategory Names
        public List<SelectListItem> GetErrorCategoryList()
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    //ImportModel model = new ImportModel();
                    string userName = System.Environment.UserName.ToString();

                    int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());

                    var list = (from error in _context.tbl_ERROR_CAT_TABLE
                                //join project in _context.tbl_PROJECT_MASTER on practice.PROJECT_ID equals project.PROJECT_ID
                                //where project.PROJECT_ID == Project_id
                                select new SelectListItem
                                {
                                    Text = error.Error_Category.ToString(),
                                    Value = error.Error_Category.ToString()
                                }).Distinct().ToList();

                    return list;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion 


        #region Get SubCategory Names
        public List<SelectListItem> GetSubCategoryList(string errorId)
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    //ImportModel model = new ImportModel();
                    string userName = System.Environment.UserName.ToString();

                    int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());

                    var list = (from sub in _context.tbl_ERROR_CAT_TABLE
                                where sub.Error_Category == errorId
                                select new SelectListItem
                                {
                                    Text = sub.Sub_Category.ToString(),
                                    Value = sub.Sub_Category.ToString()
                                }).Distinct().ToList();

                    return list;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion 





        public ImportModel ImportData(ImportModel model)
        {

            int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
            int locationId = Convert.ToInt32(HttpContext.Current.Session[Constants.LocationId]);
            string userName = HttpContext.Current.Session[Constants.UserName].ToString();
            int practiceid = Convert.ToInt32(model.SelectedPractice);

           
            //model.TotalExcelCount = ds.Tables[0].Rows.Count;
            //model.UnsuccessfullCount = 0;
            //model.SuccessfullCount = 0;
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {


                string clientid = Convert.ToString(model.CLIENT_ID);
                string accountname = Convert.ToString(model.ACCOUNT_NAME);
                DateTime? dos = null;
                if (!string.IsNullOrEmpty(Convert.ToString(model.DOS)))
                {
                    string dtofservice = Convert.ToString(model.DOS);
                    string[] parts = dtofservice.Split('/');
                    if(parts[0].Length<2)
                    {
                        parts[0] = "0" + parts[0];
                    }
                    if(parts[1].Length<2)
                    {
                        parts[1] = "0" + parts[1];
                    }
                    dtofservice = parts[1] + "/" + parts[0] + "/" + parts[2];
                    //string[] formats = {"MM/dd/yyyy" };
                    //string converted = DateTime.ParseExact(, formats, CultureInfo.InvariantCulture, DateTimeStyles.None).ToString("dd/MM/yyyy");
                    dos = Convert.ToDateTime(dtofservice, System.Globalization.CultureInfo.GetCultureInfo("ur-PK").DateTimeFormat);
                }
                string accountno = Convert.ToString(model.ACCOUNT_NO);
                DateTime? denialworkeddate = null;
                if (!string.IsNullOrEmpty(Convert.ToString(model.DENIAL_WORKED_DT)))
                {
                    string denialdt = Convert.ToString(model.DENIAL_WORKED_DT);
                    string[] parts = denialdt.Split('/');
                    if (parts[0].Length < 2)
                    {
                        parts[0] = "0" + parts[0];
                    }
                    if (parts[1].Length < 2)
                    {
                        parts[1] = "0" + parts[1];
                    }
                    denialdt = parts[1] + "/" + parts[0] + "/" + parts[2];
                    denialworkeddate = Convert.ToDateTime(denialdt, System.Globalization.CultureInfo.GetCultureInfo("ur-PK").DateTimeFormat);
                }
                string errorcategory = Convert.ToString(model.ERROR_CATEGORY);
                string subcategory = Convert.ToString(model.SUB_CATEGORY_Error_Type);
                string coderloginid = Convert.ToString(model.CODER_LOGIN_ID);
                string qcloginid = Convert.ToString(model.QC_LOGIN_ID);
                string denialtype = Convert.ToString(model.DENIAL_TYPE);
                string comments = Convert.ToString(model.COMMENTS);
                string auditorname = Convert.ToString(model.AUDITOR_NAME);
                int empid = 0;
                if (!string.IsNullOrEmpty(Convert.ToString(model.EMP_ID)))
                {
                    empid = Convert.ToInt32(model.EMP_ID);
                }
                string empname = Convert.ToString(model.EMP_NAME);
                _context.USP_Enter_Import_Data_List(Convert.ToInt32(clientid), accountname, dos, accountno, denialworkeddate, errorcategory, subcategory, coderloginid, qcloginid, denialtype, comments, auditorname, empid, empname, locationId, projectId, practiceid, userName);
                var access_id = (from use in _context.tbl_USER_ACCESS where use.USER_NTLG == userName select new { use.ACCESS_ID }).Single();
                int acc_id = Convert.ToInt32(access_id.ACCESS_ID.ToString());
                if (acc_id == 1)
                {
                    //var user_id = (from imp in _context.tbl_IMPORT_TABLE where imp.ENTER_BY == userName select new { imp.IMPORT_ID }).Max();
                    //var user_id = _context.tbl_IMPORT_TABLE.Where(tr => (string)tr["ENTER_BY"] == userName).Max(tr => (double)tr["IMPORT_ID"]);
                    int imp_id = _context.tbl_IMPORT_TABLE.Max(p => p.IMPORT_ID);
                    //int imp_id = Convert.ToInt32(user_id.IMPORT_ID.ToString());
                    _context.USP_Enter_Transaction_List(Convert.ToInt32(practiceid), Convert.ToInt32(imp_id), userName, userName);                   
                }
                _context.SaveChanges();
            }

            return model;

        }

        #region ManageImportAccounts
        public void ManageImportAccounts(List<ImportModel> model, string status)
        {
            if (status == Constants.Upload)
            {
                ReUploadAccounts(model);
            }
            else if (status == Constants.Delete)
            {
                DeleteUnsuccessfullRecords(model);
            }
        }
        #endregion        

        #region ReUploadAccounts
        public void ReUploadAccounts(List<ImportModel> model)
        {
            try
            {
                if (model.Count > 0)
                {
                    int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                    using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                    {
                        foreach (var item in model)
                        {
                            int import_id = item.IMPORT_ID;
                            //var import = _context.tbl_IMPORT_TABLE.Where(x => x.IMPORT_ID == import_id && x.PROJECT_ID == projectId).FirstOrDefault();

                            var batch = _context.tbl_IMPORT_TABLE.Where(x => x.IMPORT_ID == item.IMPORT_ID).FirstOrDefault();
                            if (batch != null)
                            {
                                //batch.RECORD_STATUS = item.RECORD_STATUS;
                                string abc = model[0].SelectedHeader.ToString();
                                abc.Replace(" ", "_");
                                _context.USP_Update_Import_Data_List(model[0].SelectedHeader.ToString().Replace(" ", "_"), model[0].SearchText, HttpContext.Current.Session[Constants.UserName].ToString(), import_id);

                            }
                        }
                        _context.SaveChanges();
                    }
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors.SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);
                var fullErrorMessage = string.Join(Constants.CommaSpace, errorMessages);
                var exceptionMessage = string.Concat(ex.Message, Constants.ValidationError, fullErrorMessage);
                throw new DbEntityValidationException(exceptionMessage, ex.EntityValidationErrors);
            }
        }
        #endregion

        #region DeleteUnsuccessfullRecords
        public void DeleteUnsuccessfullRecords(List<ImportModel> model)
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    foreach (var item in model)
                    {
                        if (item.IMPORT_ID != 0)
                        {
                            var batch = _context.tbl_IMPORT_TABLE.Where(x => x.IMPORT_ID == item.IMPORT_ID).FirstOrDefault();
                            _context.tbl_IMPORT_TABLE.Remove(batch);
                            // _context.SaveChanges();
                        }
                    }
                    _context.SaveChanges();
                }
            }
            catch (DbEntityValidationException ex)
            {
                var errorMessages = ex.EntityValidationErrors.SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);
                var fullErrorMessage = string.Join(Constants.CommaSpace, errorMessages);
                var exceptionMessage = string.Concat(ex.Message, Constants.ValidationError, fullErrorMessage);
                throw new DbEntityValidationException(exceptionMessage, ex.EntityValidationErrors);
            }
        }
        #endregion

    }
}
