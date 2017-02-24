using McKesson_Denial_Coding.BAL.Generics;
using McKesson_Denial_Coding.BAL.ViewModels;
using McKesson_Denial_Coding.DAL;

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

namespace McKesson_Denial_Coding.BAL.Managers
{

    public class AdminManager:IAdminService
    {
        #region Get Project Names
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
                                              Value = practice.PRACTICE
                                          }).ToList();

                    model.ProjectList = (from project in _context.tbl_PROJECT_MASTER
                                         join user in _context.tbl_USER_ACCESS on project.PROJECT_ID equals user.PROJECT_ID
                                         where user.USER_NTLG == userName
                                         select new SelectListItem
                                         {
                                             Text = project.PROJECT_NAME,
                                             Value = project.PROJECT_NAME
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


        public List<AdminModel> GetColumnListData(AdminModel model)
        {
            
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                string practice = model.SelectedPractice;
                //string userName = HttpContext.Current.Session[Constants.UserName].ToString();               
                if (practice != null)
                {
                    var query = (from c in _context.tbl_PRACTICE_MASTER
                                 where c.PRACTICE == practice
                                 select c.PRACTICE_ID).FirstOrDefault();

                    int practiceId = Convert.ToInt32(query.ToString());
                    List<AdminModel> list = (from data in _context.tbl_COLUMN_LIST

                                             where data.PROJECT_ID == projectId && data.PRACTICE_ID == 1

                                             select new AdminModel
                                             {
                                                 ColumnName = data.COLUMN_NAME,
                                                 Display_Name = data.DISPLAY_NAME,
                                                 UPDATED_BY = data.UPDATED_BY,
                                                 UPDATED_DATE = data.UPDATED_DATE
                                             }).ToList();
                    return (from item in list
                            select new AdminModel
                            {
                                ColumnName = item.ColumnName,
                                Display_Name = item.Display_Name,
                                UPDATED_BY = item.UPDATED_BY,
                                UPDATED_DATE = item.UPDATED_DATE
                            }).ToList();
                }
                else
                {
                    List<AdminModel> list = (from data in _context.tbl_COLUMN_LIST
                                             where data.PROJECT_ID == projectId
                                             select new AdminModel
                                             {
                                                 ColumnName = data.COLUMN_NAME,
                                                 Display_Name = data.DISPLAY_NAME,
                                                 UPDATED_BY = data.UPDATED_BY,
                                                 UPDATED_DATE = data.UPDATED_DATE
                                             }).ToList();

                    return (from item in list
                            select new AdminModel
                            {
                                ColumnName = item.ColumnName,
                                Display_Name = item.Display_Name,
                                UPDATED_BY = item.UPDATED_BY,
                                UPDATED_DATE = item.UPDATED_DATE
                            }).ToList();
                }
            }
        }
        





        //public DataTable GetColumnListData()
        //{
        //    DataSet dsCommon = new DataSet();
        //    using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
        //    {

        //        int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
        //        try
        //        {
        //            dsCommon.Clear();
        //            SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
        //            conObj.Open();
        //            SqlCommand cmdObj = new SqlCommand(Constants.SpColumnList, conObj);
        //            cmdObj.CommandType = CommandType.StoredProcedure;
        //            cmdObj.Parameters.AddWithValue("@PROJECTID", projectId);
        //            SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
        //            adapter1.Fill(dsCommon);
        //            conObj.Close();
        //            var tt = dsCommon;
        //        }
        //        catch (Exception e)
        //        {
        //            throw e;
        //        }

        //        return dsCommon.Tables[0];
        //    }
        //}
        #endregion

         
        public void ADDColumn(string Practice,string ColumnName,string ColumnDisplay)
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                

            }
        }


        #region GetMappingData
        public DataTable GetMappingData()
        {
            AdminModel model = new AdminModel();
            DataSet dsCommon = new DataSet();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {

                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);

                int practiceId = Convert.ToInt32(model.SelectedPractice);
                try
                {
                    dsCommon.Clear();
                    SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                    conObj.Open();
                    SqlCommand cmdObj = new SqlCommand(Constants.SpMappingList, conObj);
                    cmdObj.CommandType = CommandType.StoredProcedure;
                    cmdObj.Parameters.AddWithValue("@PROJECTID", projectId);
                    cmdObj.Parameters.AddWithValue("@PRACTICEID", practiceId);
                    SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                    adapter1.Fill(dsCommon);
                    conObj.Close();
                    var tt = dsCommon;
                }
                catch (Exception e)
                {
                    throw e;
                }

                return dsCommon.Tables[0];
            }
        }
        #endregion



    }
}
