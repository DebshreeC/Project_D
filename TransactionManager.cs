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
    public class TransactionManager:ITransactionService
    {
        #region LoadCoderInboxData
        public List<TransactionModel> LoadCoderInboxData()
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                string userName = HttpContext.Current.Session[Constants.UserName].ToString();

                List<TransactionModel> list = (from data in _context.tbl_IMPORT_TABLE
                                               join tran in _context.tbl_TRANSACTION on data.IMPORT_ID equals tran.IMPORT_ID
                                               join tranD in _context.tbl_TRANSACTION_DETAILS on tran.TRANS_ID equals tranD.TRANS_ID
                                               where data.PROJECT_ID == projectId && tranD.CODED_TO == userName && tranD.CODED_STATUS == "Coding Allotted"

                                               select new TransactionModel
                                              {
                                                  IMPORT_ID=data.IMPORT_ID,
                                                  ACCOUNT_NO=data.ACCOUNT_NO,
                                                  CLIENT_ID=SqlFunctions.StringConvert((double)data.CLIENT_ID).Trim(),
                                                  DOS=data.DOS
                                              }).ToList();
                return (from item in list
                        select new TransactionModel
                        {
                            IMPORT_ID = item.IMPORT_ID,
                            ACCOUNT_NO = item.ACCOUNT_NO,
                            CLIENT_ID = item.CLIENT_ID,
                            DOS = item.DOS
                        }).ToList();

            }
        }
        #endregion

        //#region EditTransactionList
        //public TransactionModel EditTransactionList(string Import_ID)
        //{
        //    using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
        //    {
        //        int importid = Convert.ToInt32(Import_ID.ToString());


        //        var m = (from data in _context.tbl_IMPORT_TABLE

        //                 where data.IMPORT_ID == importid

        //                 select new
        //      {
        //          data.IMPORT_ID,
        //          data.ACCOUNT_NO,
        //          data.CLIENT_ID,
        //          data.DOS,
        //          data.ACCOUNT_NAME,
        //          data.DENIAL_WORKED_DT,
        //          data.ERROR_CATEGORY,
        //          data.SUB_CATEGORY_Error_Type,
        //          data.CODER_LOGIN_ID,
        //          data.QC_LOGIN_ID,
        //          data.DENIAL_TYPE,
        //          data.AUDITOR_NAME,
        //          data.EMP_ID,
        //          data.EMP_NAME
        //      }).FirstOrDefault();

        //        TransactionModel model = new TransactionModel();
        //        model.IMPORT_ID = m.IMPORT_ID;
        //        model.ACCOUNT_NO = m.ACCOUNT_NO;
        //        model.CLIENT_ID = m.CLIENT_ID.ToString();
        //        model.DOS = m.DOS;
        //        model.ACCOUNT_NAME = m.ACCOUNT_NAME;
        //        model.DENIAL_WORKED_DT = m.DENIAL_WORKED_DT;
        //        model.ERROR_CATEGORY = m.ERROR_CATEGORY;
        //        model.SUB_CATEGORY_Error_Type = m.SUB_CATEGORY_Error_Type;
        //        model.CODER_LOGIN_ID = m.CODER_LOGIN_ID;
        //        model.QC_LOGIN_ID = m.QC_LOGIN_ID;
        //        model.DENIAL_TYPE = m.DENIAL_TYPE;
        //        model.AUDITOR_NAME = m.AUDITOR_NAME;
        //        model.EMP_ID = m.EMP_ID.ToString();
        //        model.EMP_NAME = m.EMP_NAME;

        //        return model;
        //    }
        //}
        //#endregion
        public DataTable EditTransactionList(string Import_ID)
        {
            DataTable dt = new DataTable();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                //PipelineManager objP = new PipelineManager();
                ImportManager objP = new ImportManager();
                SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                conObj.Open();
                SqlCommand cmdObj = new SqlCommand(Constants.ImportDataDetails, conObj);
                cmdObj.CommandType = CommandType.StoredProcedure;
                cmdObj.Parameters.AddWithValue("@Project_Id", projectId);
                cmdObj.Parameters.AddWithValue("@IMPORT_ID", Import_ID);
                SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                adapter1.Fill(dt);
                conObj.Close();              
            }

            return dt;

        } 

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
                                where error.Error_Category != null || error.Error_Category != ""
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


        #region UpdateTransaction
        public void UpdateTransaction(FormCollection frm,int import_id)
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                var _tr = _context.tbl_IMPORT_TABLE.Where(x => x.IMPORT_ID == import_id).SingleOrDefault();

                 if (_tr != null)
                 {

                     foreach (var key in frm.AllKeys)
                     {
                         if (key == "CLIENT_ID")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.CLIENT_ID = Convert.ToInt32(frm[key]);
                             }
                         }
                         if (key == "ACCOUNT_NAME")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.ACCOUNT_NAME = frm[key];
                             }
                         }
                         if (key == "DOS")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.DOS = Convert.ToDateTime(frm[key]);
                             }
                         }
                         if (key == "ACCOUNT_NO")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.ACCOUNT_NO = frm[key];
                             }
                         }
                         if (key == "DENIAL_WORKED_DT")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.DENIAL_WORKED_DT = Convert.ToDateTime(frm[key]);
                             }
                         }
                         if (key == "ERROR_CATEGORY")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.ERROR_CATEGORY = frm[key];
                             }
                         }
                         if (key == "SUB_CATEGORY_Error_Type")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.SUB_CATEGORY_Error_Type = frm[key];
                             }
                         }
                         if (key == "CODER_LOGIN_ID")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.CODER_LOGIN_ID = frm[key];
                             }
                         }
                         if (key == "QC_LOGIN_ID")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.QC_LOGIN_ID = frm[key];
                             }
                         }
                         if (key == "DENIAL_TYPE")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.DENIAL_TYPE = frm[key];
                             }
                         }
                         if (key == "COMMENTS")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.COMMENTS = frm[key];
                             }
                         }
                         if (key == "AUDITOR_NAME")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.AUDITOR_NAME = frm[key];
                             }
                         }
                         if (key == "EMP_ID")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.EMP_ID = Convert.ToInt32(frm[key]);
                             }
                         }
                         if (key == "EMP_NAME")
                         {
                             if (Convert.ToString(frm[key]) != "")
                             {
                                 _tr.EMP_NAME = frm[key];
                             }
                         }
                     }
                 }
                 _context.SaveChanges();
                 var _tr_id = (from sub in _context.tbl_TRANSACTION where sub.IMPORT_ID == import_id select new {sub.TRANS_ID}).Single();

                 int trans_id = Convert.ToInt32(_tr_id.TRANS_ID.ToString());

                 var _tr_details = _context.tbl_TRANSACTION_DETAILS.Where(x => x.TRANS_ID == trans_id).SingleOrDefault();

                 if (_tr_details != null)
                 {
                     _tr_details.CODED_STATUS = "Coding Completed";
                        
                 }
                 _context.SaveChanges();

            }
        }
        #endregion

    }
}
