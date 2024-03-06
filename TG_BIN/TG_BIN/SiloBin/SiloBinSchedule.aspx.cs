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
    public partial class SiloBinSchedule : PageBase
    {

        public SiloBinSchedule()
        {
            this.CheckLogin = false;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                dtpSDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));

                dtpCurrentDate.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));

                string sSDATE = string.Format("{0:yyyyMMdd}", dtpSDATE.Value);

                this.UP_DataBinding(sSDATE);

                string sDate = string.Format("{0:yyyyMM}", Convert.ToDateTime(this.dtpSDATE.Text + "-01"));
            }
        }

        private void UP_DataBinding(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BGW899", sDate.Substring(0, 6));

            ds = this.DbConnector.ExecuteDataSet();

            stoShipList.RemoveAll();
            stoShipList.DataSource = ds.Tables[0];
            stoShipList.DataBind();
        }

        #region Description : 검색 버튼
        protected void btnFind_Click(object sender, DirectEventArgs e)
        {
            string sSDATE = string.Format("{0:yyyyMMdd}", dtpSDATE.Value);

            this.UP_DataBinding(sSDATE);
        }
        #endregion

        #region Description : 선박입항 현황 데이터 가져오기
        [DirectMethod]
        public void UP_DateMove(string sDate, string sGubn)
        {
            string wkdate = string.Empty;

            if (sGubn == "2")
            {
                wkdate = string.Format("{0:yyyy-MM}", Convert.ToDateTime(sDate).AddMonths(1));
            }
            else if (sGubn == "1")
            {
                wkdate = string.Format("{0:yyyy-MM}", Convert.ToDateTime(sDate).AddMonths(-1));
            }
            else
            {
                dtpSDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));
                dtpCurrentDate.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));

                string sNow_Date = string.Format("{0:yyyy-MM}", Convert.ToDateTime(this.dtpSDATE.Text + "-01"));

                wkdate = sNow_Date;
            }

            sDate = string.Format("{0:yyyy-MM-dd}", Convert.ToDateTime(wkdate + "-01"));

            //선박스케줄 조회           

            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BGW899", Get_Date(sDate).Substring(0, 6));
            ds = this.DbConnector.ExecuteDataSet();
            if (ds.Tables[0].Rows.Count > 0)
            {
                this.dtpSDATE.Text = string.Format("{0:yyyy-MM}", Convert.ToDateTime(sDate));

                stoShipList.RemoveAll();
                stoShipList.DataSource = ds.Tables[0];
                stoShipList.DataBind();
            }
            else
            {
                X.MessageBox.Alert("확인", "해당월에 자료가 존재하지 않습니다.").Show();
            }
        }
        #endregion
    }
}