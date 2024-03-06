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
    public partial class SiloBinCargill : PageBase
    {
        public SiloBinCargill()
        {
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {   
            string sSDATE = this.Request.QueryString["val1"];
            string sEDATE = this.Request.QueryString["val2"];
            string sBINNO = this.Request.QueryString["val3"];
            string sGUBN = this.Request.QueryString["val4"];

            DataTable dt = UP_BindData(sBINNO, sSDATE, sEDATE, sGUBN);

            ActiveReport rpt = new TYPSM.Report.SiloBinCargill_PRT();
            rpt.DataSource = dt;
            this.arvMain.Report = rpt;
            rpt.Run();
        }

        #region Description : 출력 데이터 조회
        private DataTable UP_BindData(string sSDATE, string sEDATE, string sBIN, string sGubn)
        {
            string sNowDate = System.DateTime.Now.ToString("yyyyMMdd");

            if (sGubn == "P")
            {
                sSDATE = "19900101";
                sEDATE = "20301231";
            }

            DataTable dt = new DataTable();

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B45EV123", sNowDate, sGubn, sSDATE, sEDATE, sBIN);

            dt = this.DbConnector.ExecuteDataTable();

            return dt;
        }
        #endregion
    }
}