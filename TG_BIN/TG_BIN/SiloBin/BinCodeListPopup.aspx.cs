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
    public partial class BinCodeListPopup : PageBase
    {
        private string sCDINDEX;
        private string sCDCODE;

        public BinCodeListPopup()
        {
            this.CheckLogin = false;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                sCDINDEX = this.Request.QueryString[0];
                sCDCODE = this.Request.QueryString[1];

                hidCDINDEX.SetValue(this.Request.QueryString[0]);
                txtCDCODE.Text = this.Request.QueryString[1];

                UP_BinData();
            }
        }

        private void UP_BinData()
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HFS625", Convert.ToString(hidCDINDEX.Value),
                                                        Convert.ToString(txtCDCODE.Text),
                                                        Convert.ToString(txtCDDESC1.Text));
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