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
    public partial class CodeHelpHangcha : PageBase
    {
        public CodeHelpHangcha()
        {
            this.CheckLogin = false;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                txtCDCODE.Text = this.Request.QueryString[0];
                hidDATE.Text = this.Request.QueryString[1];
                hidBINNO.Text = this.Request.QueryString[2];

                UP_BinData();
            }
        }

        private void UP_BinData()
        {
            string sCORPGUBN = string.Empty;

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35ET834", Convert.ToString(hidDATE.Text),
                                                        Convert.ToString(hidBINNO.Text));
            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                sCORPGUBN = ds.Tables[0].Rows[0]["RENTCORPGUBN"].ToString();
            }

            this.DbConnector.CommandClear();

            if (sCORPGUBN == "T")
            {
                this.DbConnector.Attach("TG_P_GS_B35DR832", Convert.ToString(txtCDCODE.Text),
                                                            Convert.ToString(txtCDDESC1.Text));
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B35EI833", Convert.ToString(txtCDCODE.Text),
                                                            Convert.ToString(txtCDDESC1.Text));
            }

            ds = this.DbConnector.ExecuteDataSet();

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