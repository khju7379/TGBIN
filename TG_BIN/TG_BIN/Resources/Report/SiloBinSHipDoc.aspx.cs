using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PSM.Common;
using DataDynamics.ActiveReports;
using System.Data;

namespace TG_BIN.Resources.Report
{
    public partial class SiloBinSHipDoc : PageBase
    {
        public SiloBinSHipDoc()
        {
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string sDHANGCHA = this.Request.QueryString["val1"];
            string sDGOKJONG = this.Request.QueryString["val2"];
            string sDCORPGUBN = this.Request.QueryString["val3"];


            DataTable dt = UP_BindData(sDCORPGUBN, sDHANGCHA, sDGOKJONG);
            

            //ActiveReport rpt = new TYPSM.Report.SiloBinDoc_PRT();
            ActiveReport rpt = new TYPSM.Report.SiloBinDoc_PRT();
            rpt.DataSource = dt;
            this.arvMain.Report = rpt;
            rpt.Run();
        }

        #region Description : 출력 데이터 조회
        private DataTable UP_BindData(string sDCORPGUBN, string sDHANGCHA, string sDGOKJONG)
        {
            DataTable dt = new DataTable();

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3PJ2061", sDCORPGUBN, sDHANGCHA, sDGOKJONG);

            dt = this.DbConnector.ExecuteDataTable();

            return dt;
        }
        #endregion
    }
}