using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using System.Data;
using PSM.Common;

namespace TG_BIN.SiloBin
{
    public partial class CodeHelpBinNo : PageBase
    {
        private string sBINNO;

        public CodeHelpBinNo()
        {
            this.CheckLogin = false;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                sBINNO = this.Request.QueryString[0];

                txtCDCODE.Text = this.Request.QueryString[0];

                UP_BinData();
            }
        }

        private void UP_BinData()
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2JAJ674", Convert.ToString(txtCDCODE.Text));

            DataSet ds = this.DbConnector.ExecuteDataSet();

            this.stoGrid.DataSource = ds.Tables[0];
            this.stoGrid.DataBind();

            this.TbarText.Text = "조회가 완료되었습니다";


        }

        protected void btnSearch_Click(object sender, DirectEventArgs e)
        {
            UP_BinData();
        }
    }
}