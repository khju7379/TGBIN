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
    public partial class SiloBinManager : PageBase
    {
        public SiloBinManager()
        {
            this.CheckLogin = false;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            this.UP_SethiddenValue();
        }

        private void UP_SethiddenValue()
        {
            //Tab 인데스 
            //0 - 특기사항
            //1 - 입항/하역계획
            //2 - 하역작업일지
            //3 - BIN이고관리
            //4 - 카길이송
            //5 - BIN클리닝
            //6 - BIN상태관리
            //7 - BIN용량관리 
            //8 - 곡종별 색상관리
            string sTabStr = string.Empty;
            string sTabid = string.Empty;
            Int16 iTabIndex = 0;

            if (Request.QueryString.Count > 0)
            {
                sTabStr = Request.QueryString[0].ToString();
                sTabid = Request.QueryString[1].ToString();

                if (sTabStr == "BIN")
                {
                    iTabIndex = 5;
                }
                else if (sTabStr == "BOR")
                {
                    switch (sTabid)
                    {
                        case "SP_Board":
                            iTabIndex = 0;
                            break;
                        case "SH_Board":
                            iTabIndex = 1;
                            break;
                        case "BN_Board":
                            iTabIndex = 5;
                            break;
                        case "MV_Board":
                            iTabIndex = 3;
                            break;
                        case "DC_Board":
                            iTabIndex = 2;
                            break;
                        case "CG_Board":
                            iTabIndex = 4;
                            break;
                    }
                }
                else if (sTabStr == "COL")
                {
                    iTabIndex = 7;
                }
                else
                {
                    iTabIndex = 6;
                }


                this.tpnPage.SetActiveTab(iTabIndex);
            }
        }
    }
}