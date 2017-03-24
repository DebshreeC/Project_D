using System.Web;
using System.Web.Optimization;

namespace Denial_Coding
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include("~/Scripts/jquery-{version}.js"));

            bundles.Add(new StyleBundle("~/bundles/LoginStyles").Include("~/CustomStyles/js/bootstrap.min.js", "~/CustomStyles/css/bootstrap.min.css", "~/CustomStyles/css/maps/jquery-jvectormap-2.0.3.css"));
            bundles.Add(new ScriptBundle("~/bundles/LoginScripts").Include("~/CustomStyles/js/jquery.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/DownLayout").Include("~/CustomStyles/js/jquery.min.js",
                                                                         "~/CustomStyles/js/nprogress.js",
                                                                         "~/CustomStyles/js/bootstrap.min.js",
                                                                         "~/CustomStyles/js/icheck/icheck.min.js",
                                                                         "~/CustomStyles/js/moment/moment.min.js",
                                                                         "~/CustomStyles/js/datepicker/daterangepicker.js",
                                                                         "~/CustomStyles/js/custom.js",
                                                                          "~/CustomStyles/js/notify/pnotify.core.js",
                                                                          "~/CustomStyles/js/notify/pnotify.buttons.js",
                                                                         "~/CustomStyles/js/notify/pnotify.nonblock.js",
                                                                         "~/CustomStyles/ToasterMessages.js",
                                                                         "~/CustomStyles/js/pace/pace.min.js"));

            bundles.Add(new StyleBundle("~/CustomStyles/LayoutStyles").Include("~/CustomStyles/css/bootstrap.min.css",
                                                                             "~/CustomStyles/fonts/css/font-awesome.min.css",
                                                                             "~/CustomStyles/css/animate.min.css",
                                                                              "~/CustomStyles/css/custom.css",
                                                                             "~/CustomStyles/css/maps/jquery-jvectormap-2.0.3.css",
                                                                             "~/CustomStyles/css/icheck/flat/green.css",
                                                                             "~/CustomStyles/css/floatexamples.css"));

            bundles.Add(new ScriptBundle("~/bundles/DataTable").Include("~/CustomStyles/js/datatables/jquery.dataTables.min.js",
                                                                     "~/CustomStyles/js/datatables/dataTables.bootstrap.js",
                                                                     "~/CustomStyles/js/datatables/dataTables.buttons.min.js",
                                                                     "~/CustomStyles/js/datatables/buttons.bootstrap.min.js",
                                                                     "~/CustomStyles/js/datatables/jszip.min.js",
                                                                     "~/CustomStyles/js/datatables/pdfmake.min.js",
                                                                     "~/CustomStyles/js/datatables/vfs_fonts.js", "~/CustomStyles/js/datatables/buttons.html5.min.js",
                                                                     "~/CustomStyles/js/datatables/buttons.print.min.js",
                                                                     "~/CustomStyles/js/datatables/dataTables.fixedHeader.min.js",
                                                                     "~/CustomStyles/js/datatables/dataTables.keyTable.min.js", "~/CustomStyles/js/datatables/dataTables.responsive.min.js",
                                                                     "~/CustomStyles/js/datatables/responsive.bootstrap.min.js",
                                                                     "~/CustomStyles/js/datatables/dataTables.scroller.min.js"));

            bundles.Add(new StyleBundle("~/bundles/HomePageStyles").Include("~/Content/assets/global/plugins/font-awesome/css/font-awesome.min.css",
                "~/Content/assets/global/plugins/simple-line-icons/simple-line-icons.min.css",
                "~/Content/assets/global/plugins/bootstrap/css/bootstrap.min.css",
                "~/Content/assets/global/plugins/uniform/css/uniform.default.css",
                "~/Content/assets/global/plugins/bootstrap-switch/css/bootstrap-switch.min.css",
                "~/Content/assets/global/plugins/select2/select2.css",
                "~/Content/assets/admin/pages/css/login-soft.css",
                "~/Content/assets/global/css/components.css",
                "~/Content/assets/global/css/plugins.css",
                "~/Content/assets/admin/layout/css/layout.css",
                "~/Content/assets/admin/layout/css/themes/default.css",
                "~/Content/assets/admin/layout/css/custom.css"));

            bundles.Add(new ScriptBundle("~/bundles/HomePageScripts").Include("~/Content/assets/global/plugins/jquery-1.11.0.min.js",
                "~/Content/assets/global/plugins/jquery-migrate-1.2.1.min.js",
                "~/Content/assets/global/plugins/jquery-ui/jquery-ui-1.10.3.custom.min.js",
                "~/Content/assets/global/plugins/bootstrap/js/bootstrap.min.js",
                "~/Content/assets/global/plugins/bootstrap-hover-dropdown/bootstrap-hover-dropdown.min.js",
                "~/Content/assets/global/plugins/jquery-slimscroll/jquery.slimscroll.min.js",
                "~/Content/assets/global/plugins/jquery.blockui.min.js",
                "~/Content/assets/global/plugins/jquery.cokie.min.js",
                "~/Content/assets/global/plugins/uniform/jquery.uniform.min.js",
                "~/Content/assets/global/plugins/bootstrap-switch/js/bootstrap-switch.min.js",
                "~/Content/assets/global/plugins/jquery-validation/js/jquery.validate.min.js",
                "~/Content/assets/global/plugins/backstretch/jquery.backstretch.min.js",
                "~/Content/assets/global/plugins/select2/select2.min.js",
                "~/Content/assets/global/scripts/metronic.js",
                "~/Content/assets/admin/layout/scripts/layout.js",
                "~/Content/assets/admin/layout/scripts/quick-sidebar.js",
                "~/Content/assets/admin/layout/scripts/demo.js",
                "~/Content/assets/admin/pages/scripts/login-soft.js"));
        }
    }
}
