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

    public class AdminManager:IAdminService
    {
        #region Get Practice Names
        public AdminModel GetPracticeList()
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    AdminModel model = new AdminModel();
                    string userName = System.Environment.UserName.ToString();

                    int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());                   

                    model.PracticeList = (from practice in _context.tbl_PRACTICE_MASTER
                                          join project in _context.tbl_PROJECT_MASTER on practice.PROJECT_ID equals project.PROJECT_ID
                                          where project.PROJECT_ID == Project_id
                                          select new SelectListItem
                                          {
                                              Text = practice.PRACTICE,
                                              Value = SqlFunctions.StringConvert((double)practice.PRACTICE_ID).Trim()
                                          }).ToList();

                    model.ProjectList = (from project in _context.tbl_PROJECT_MASTER
                                         join user in _context.tbl_USER_ACCESS on project.PROJECT_ID equals user.PROJECT_ID
                                         where user.USER_NTLG == userName
                                         select new SelectListItem
                                         {
                                             Text = project.PROJECT_NAME,
                                             Value = SqlFunctions.StringConvert((double)project.PROJECT_ID).Trim()
                                         }).ToList();

                    

                    return model;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion       

        #region GetColumnListData
        public List<AdminModel> GetColumnListData(int Practice_Id)
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                int practiceId = Convert.ToInt32(Practice_Id);

                List<AdminModel> list = (from data in _context.tbl_COLUMN_LIST

                                         where data.PROJECT_ID == projectId && data.PRACTICE_ID == practiceId

                                         select new AdminModel
                                              {
                                                  ColumnId = data.COLUMN_ID,
                                                  ColumnName = data.COLUMN_NAME,
                                                  Display_Name = data.DISPLAY_NAME,
                                                  UPDATED_BY = data.UPDATED_BY,
                                                  UPDATED_DATE = data.UPDATED_DATE
                                              }).ToList();
                return (from item in list
                        select new AdminModel
                        {
                            ColumnId = item.ColumnId,
                            ColumnName = item.ColumnName,
                            Display_Name = item.Display_Name,
                            UPDATED_BY = item.UPDATED_BY,
                            UPDATED_DATE = item.UPDATED_DATE
                        }).ToList();

            }
        }
        #endregion

        #region ADDColumn
        public void ADDColumn(AdminModel amodel)
        {
            AdminModel model = new AdminModel();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int practiceId = Convert.ToInt32(amodel.Practice_Id);
                _context.USP_Enter_Column_List(amodel.ColumnName,amodel.Display_Name,Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString()),System.Environment.UserName.ToString(),practiceId,amodel.DataType);               
                _context.SaveChanges();
            }
        }
        #endregion

        #region EDITColumn
        public void EDITColumn(AdminModel amodel)
        {
            AdminModel model = new AdminModel();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int practiceId = Convert.ToInt32(amodel.Practice_Id);                
                _context.USP_Enter_Column_List(amodel.ColumnName, amodel.Display_Name, Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString()), System.Environment.UserName.ToString(), practiceId, amodel.DataType);
                _context.SaveChanges();
            }
        }
        #endregion

        #region DELETEColumn
        public void DELETEColumn(int ColumnId, string ColumnName)
        {
            try
            {
                AdminModel model = new AdminModel();
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                    conObj.Open();
                    SqlCommand cmdObj = new SqlCommand(Constants.SpDeleteColumn, conObj);
                    cmdObj.CommandType = CommandType.StoredProcedure;
                    cmdObj.Parameters.AddWithValue("@COLUMN_ID", ColumnId);
                    cmdObj.Parameters.AddWithValue("@COLUMN_NAME", ColumnName);
                    cmdObj.ExecuteNonQuery();
                    conObj.Close();
                }
            }
            catch(Exception ex)
            {

            }
        }
        #endregion


        #region GetColumnDetails
        public AdminModel GetColumnDetails(int ColumnId, string ColumnName, string Display_Name)
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                AdminModel model = new AdminModel();
                model.ColumnId=ColumnId;
                model.ColumnName=ColumnName;
                model.ColumnName = Display_Name;
                return model;
            }
        }
        #endregion

        #region SaveAndUpdateColumnChanges
        public void SaveAndUpdateColumnChanges(AdminModel model)
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                _context.USP_Update_Column_List(model.ColumnId,model.ColumnName, model.Display_Name, System.Environment.UserName.ToString(), model.DataType);
                _context.SaveChanges();
            }
        }
        #endregion
       
        #region getDynamicMappingColumn
        public DataTable getDynamicMappingColumn(int Practice_Id)
        {
            int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
            AdminModel model = new AdminModel();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                DataSet dsCommon = new DataSet();
                conObj.Open();
                SqlCommand cmdObj = new SqlCommand(Constants.SpMappingList, conObj);
                cmdObj.CommandType = CommandType.StoredProcedure;
                cmdObj.Parameters.AddWithValue("@PROJECT_ID", projectId);
                cmdObj.Parameters.AddWithValue("@PRACTICE_ID", Practice_Id);
                SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                adapter1.Fill(dsCommon);
                conObj.Close();
                return dsCommon.Tables[0];
            }
        }
        #endregion

        #region ADDMappingColumn
        public void ADDMappingColumn(int Practice_Id, int ColumnID)
        {
            AdminModel model = new AdminModel();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());               

                _context.USP_Delete_Mapping_List(ColumnID, Project_id, Practice_Id);
                _context.SaveChanges();

                _context.USP_Enter_Mapping_List(ColumnID, Project_id, Practice_Id, System.Environment.UserName.ToString());
                _context.SaveChanges();

            }
        }
        #endregion

    
        #region GetClientListData
        public DataTable GetClientListData()
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);

                SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                DataSet dsCommon = new DataSet();
                conObj.Open();
                SqlCommand cmdObj = new SqlCommand(Constants.SPClientList, conObj);
                cmdObj.CommandType = CommandType.StoredProcedure;
                cmdObj.Parameters.AddWithValue("@PROJECT_ID", projectId);
                SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                adapter1.Fill(dsCommon);
                conObj.Close();
                return dsCommon.Tables[0];

            }
        }
        #endregion

        #region ADDClient
        public void ADDClient(int clientid, string clientname)
        {            
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                string username=System.Environment.UserName.ToString();
                _context.UPS_Enter_Client_Details(clientid, clientname, projectId, username);
                _context.SaveChanges();
            }
        }
        #endregion

        //#region GetClientDetails
        //public DataTable GetClientDetails(int CID)
        //{
        //    using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
        //    {
        //        int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);

        //        SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
        //        DataSet dsCommon = new DataSet();
        //        conObj.Open();
        //        SqlCommand cmdObj = new SqlCommand(Constants.SPClientDetailsList, conObj);
        //        cmdObj.CommandType = CommandType.StoredProcedure;
        //        cmdObj.Parameters.AddWithValue("@CID", CID);
        //        SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
        //        adapter1.Fill(dsCommon);
        //        conObj.Close();
        //        return dsCommon.Tables[0];

        //    }
        //}
        //#endregion

        #region DELETEClient
        public void DELETEClient(int ClientId)
        {
            try
            {               
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                    conObj.Open();
                    SqlCommand cmdObj = new SqlCommand(Constants.SpDeleteClient, conObj);
                    cmdObj.CommandType = CommandType.StoredProcedure;
                    cmdObj.Parameters.AddWithValue("@Client_ID", ClientId);                   
                    cmdObj.ExecuteNonQuery();
                    conObj.Close();
                }
            }
            catch (Exception ex)
            {

            }
        }
        #endregion

        #region GetAccountListData
        public DataTable GetAccountListData()
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);

                SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                DataSet dsCommon = new DataSet();
                conObj.Open();
                SqlCommand cmdObj = new SqlCommand(Constants.SPAccountList, conObj);
                cmdObj.CommandType = CommandType.StoredProcedure;
                cmdObj.Parameters.AddWithValue("@PROJECT_ID", projectId);
                SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                adapter1.Fill(dsCommon);
                conObj.Close();
                return dsCommon.Tables[0];

            }
        }
        #endregion


        #region ADDAccount
        public void ADDAccount(string Accountno, string Accountname)
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                string username = System.Environment.UserName.ToString();
                _context.UPS_Enter_Account_Details(Accountno, Accountname, projectId, username);
                _context.SaveChanges();
            }
        }
        #endregion

        #region DELETEAccount
        public void DELETEAccount(string AccountNo)
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                    conObj.Open();
                    SqlCommand cmdObj = new SqlCommand(Constants.SpDeleteAccount, conObj);
                    cmdObj.CommandType = CommandType.StoredProcedure;
                    cmdObj.Parameters.AddWithValue("@Account_No", AccountNo);
                    cmdObj.ExecuteNonQuery();
                    conObj.Close();
                }
            }
            catch (Exception ex)
            {

            }
        }
        #endregion

    }
}
