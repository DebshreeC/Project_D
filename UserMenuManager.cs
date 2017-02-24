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
    public class UserMenuManager : IUserMenuService
    {


        #region Get Project Names
        public UserMenuModel GetProject_LocationList()
        {
            try
            { 
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                UserMenuModel model = new UserMenuModel();
                string userName = System.Environment.UserName.ToString();

                model.ProjectList = (from project in _context.tbl_PROJECT_MASTER
                                     join user in _context.tbl_USER_ACCESS on project.PROJECT_ID equals user.PROJECT_ID
                                     where user.USER_NTLG == userName
                                     select new SelectListItem
                                      {
                                          Text = project.PROJECT_NAME,
                                          Value = project.PROJECT_NAME
                                      }).ToList();


                model.LocationList = (from location in _context.tbl_LOCATION
                                      join project in _context.tbl_PROJECT_MASTER on location.PROJECT_ID equals project.PROJECT_ID
                                      join user in _context.tbl_USER_ACCESS on location.LOCATION_ID equals user.LOCATION_ID
                                      where user.USER_NTLG == userName
                                      select new SelectListItem
                                      {
                                          Text = location.LOCATION,
                                          Value = location.LOCATION
                                      }).ToList();                

                return model;
            }
        }
        catch(Exception ex)
            {
                throw ex;
        }
        }
        #endregion

        #region GetUserMenu
        public void GetSideMenu()
        {

            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                string menuName = string.Empty;
                string subMenu = string.Empty;
                string oldMenuName = string.Empty;
                string menuDiv = string.Empty;

                int count = 0;
                int menuCount = 0;
                string projectid = HttpContext.Current.Session[Constants.ProjectId].ToString();


                var httpContext = new HttpContextWrapper(System.Web.HttpContext.Current);
                var menuList = _context.SP_Get_Menu_Details(HttpContext.Current.Session[Constants.UserName].ToString(), HttpContext.Current.Session[Constants.ProjectId].ToString()).ToList();
                var urlHelper = new UrlHelper(new RequestContext(httpContext, new RouteData()));
                for (int i = 0; i < menuList.Count; i++)
                {
                    string url = string.Empty;
                    menuName = menuList[i].MENU_NAME;
                    if (menuList[i].URL.ToString().Contains("/"))
                    {
                        string[] arry = menuList[i].URL.Split('/'); ;
                        url = urlHelper.Action(arry[1], arry[0], new RouteValueDictionary());
                    }

                    if (count == 0)
                    {
                        menuCount = menuList.Where(x => x.MENU_NAME == menuName).Select(x => x.MENU_NAME).Count();
                        menuDiv += "<li>";
                    }
                    subMenu = menuList[i].SUB_MENU_NAME;
                    if (menuName != oldMenuName)
                    {
                        count = menuCount;
                        menuDiv += "<a><i class='" + GetFontIcons("Font" + menuName.Replace(" ", string.Empty)) + "'></i>" + menuName + " <span class='fa fa-chevron-down'></span></a>";
                        menuDiv += "<ul class='nav child_menu' style='display: none' tabindex='1'>";
                    }
                    if (subMenu != null && subMenu != string.Empty)
                    {
                        menuDiv += "<li><a href=" + url + ">" + subMenu + "</a></li>";
                    }
                    count = count - 1;
                    if (count == 0)
                    {
                        menuDiv += "</ul>";
                        menuDiv += "</li>";
                    }
                    oldMenuName = menuName;
                }
                HttpContext.Current.Session[Constants.UserMenu] = menuDiv;

            }

        }
        #endregion
        #region GetFontIcon

        public string GetFontIcons(string iconName)
        {
            if (iconName == "FontImport")
            {
                return Constants.FontImport;
            }
            else if (iconName == "FontTransaction")
            {
                return Constants.FontTransaction;
            }
            else if (iconName == "FontAllotment")
            {
                return Constants.FontAllotment;
            }
            else if (iconName == "FontReports")
            {
                return Constants.FontReports;
            }
            else if (iconName == "FontErrorLog")
            {
                return Constants.FontErrorLog;
            }
            else if (iconName == "FontFeedBack")
            {
                return Constants.FontFeedBack;
            }
            else if (iconName == "FontAllottment")
            {
                return Constants.Allottment;
            }
            else if (iconName == "FontClarification")
            {
                return Constants.Clarification;
            }
            else if (iconName == "FontQCTransaction")
            {
                return Constants.QCTransaction;
            }
            else if (iconName == "FontReleaseScreen")
            {
                return Constants.ReleaseScreen;
            }
            else
            {
                return string.Empty;
            }
        }
        #endregion

        #region Store SessionDetails
        public void SaveSessionDetails(UserMenuModel model)
        {
            using (McKesson_GVLEntities _context = new McKesson_GVLEntities())
            {
                string projectname = model.SelectedProject;

                if (HttpContext.Current.Session[Constants.ProjectId]==null)
                {
                    
                    var project = (from p in _context.tbl_PROJECT_MASTER
                                   join l in _context.tbl_LOCATION on p.PROJECT_ID equals l.PROJECT_ID
                                   where p.PROJECT_NAME == projectname
                                   select new
                                   {
                                       p.PROJECT_NAME,
                                       p.PROJECT_ID
                                   }).FirstOrDefault();

                    HttpContext.Current.Session[Constants.ProjectId] = project.PROJECT_ID;
                    HttpContext.Current.Session[Constants.ProjectName] = project.PROJECT_NAME;
                    HttpContext.Current.Session[Constants.UserName] = System.Environment.UserName.ToString();

                }
                else
                {
                    HttpContext.Current.Session[Constants.ProjectId] = HttpContext.Current.Session[Constants.ProjectId];
                    HttpContext.Current.Session[Constants.ProjectName] = HttpContext.Current.Session[Constants.ProjectName];
                    HttpContext.Current.Session[Constants.UserName] = System.Environment.UserName.ToString();
                }
            }

        }
        #endregion

    }
}
