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
    public class AllotmentManager : IAllotmentService
    {
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


        #region Get Coder Names
        public List<SelectListItem> getCoderNames(int tl, int user)
        {
            try
            {
                using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
                {
                    int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                    string userName = Convert.ToString(HttpContext.Current.Session[Constants.UserName]);
                    int locationid = Convert.ToInt32(HttpContext.Current.Session[Constants.LocationId]);

                    var list = (from coder in _context.tbl_USER_ACCESS
                                where coder.PROJECT_ID == projectId && (coder.ACCESS_ID == tl || coder.ACCESS_ID == user) && coder.LOCATION_ID == locationid
                                select new SelectListItem
                                {
                                    Text = coder.USER_NTLG,
                                    Value = SqlFunctions.StringConvert((double)coder.USER_ID).Trim()
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

        #region Get Accoun tDetails
        public DataTable GetAccountDetails(string status, string fromDos, string toDos, int practiceId)
        {
            int Project_id = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId].ToString());           
            DataSet dsCommon = new DataSet();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                //if (HttpContext.Current.Session["CodingAllotment"]==null)
                //{
                try
                {
                    dsCommon.Clear();
                    SqlConnection conObj = new SqlConnection(Constants.ConnectionString);
                    conObj.Open();
                    SqlCommand cmdObj = new SqlCommand(Constants.SPCodingAllotment, conObj);
                    cmdObj.CommandType = CommandType.StoredProcedure;
                    cmdObj.Parameters.AddWithValue("@Status", status);
                    cmdObj.Parameters.AddWithValue("@FromDate", fromDos);
                    cmdObj.Parameters.AddWithValue("@ToDate", toDos);
                    cmdObj.Parameters.AddWithValue("@Project_Id", Project_id);
                    cmdObj.Parameters.AddWithValue("@Practice_Id", practiceId);
                    SqlDataAdapter adapter1 = new SqlDataAdapter(cmdObj);
                    adapter1.Fill(dsCommon);
                    conObj.Close();
                    HttpContext.Current.Session["CodingAllotment"] = dsCommon;
                    return dsCommon.Tables[0];
                }
                catch (Exception e)
                {
                    throw e;
                    //return null;
                }
                
            }
        }
        #endregion

        #region AllotToCoder
        public void AllotToCoder(string listOfAccounts, string practiceId, string codername)
        {
            string[] array = listOfAccounts.Split(',').Select(x => x.Trim()).ToArray();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                string userName = HttpContext.Current.Session[Constants.UserName].ToString();
                for (int i = 0; i < array.Length; i++)
                {
                    _context.USP_Enter_Transaction_List(Convert.ToInt32(practiceId), Convert.ToInt32(array[i].ToString()), userName, codername);
                    _context.SaveChanges();
                }

            }
        }
        #endregion

        #region UpdateAllotToCoder
        public void UpdateAllotToCoder(string listOfAccounts, string practiceId, string codername)
        {
            string[] array = listOfAccounts.Split(',').Select(x => x.Trim()).ToArray();
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                int projectId = Convert.ToInt32(HttpContext.Current.Session[Constants.ProjectId]);
                string userName = HttpContext.Current.Session[Constants.UserName].ToString();
                for (int i = 0; i < array.Length; i++)
                {
                    _context.USP_Update_Transaction_List(Convert.ToInt32(practiceId), Convert.ToInt32(array[i].ToString()), userName, codername);
                    _context.SaveChanges();
                }

            }
        }
        #endregion
    }
}
