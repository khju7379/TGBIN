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
    public partial class SiloBinGKColor : PageBase
    {
        public SiloBinGKColor()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                this.UP_DataBinding();
            }
        }

        #region : Description : 그리드 데이터 바인딩
        private void UP_DataBinding()
        {

            this.stoBinGKColor.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HFA616");
            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                btnMSave.Hidden = false;
                tsMSave.Hidden = false;
            }
            else
            {
                btnMSave.Hidden = false;
                tsMSave.Hidden = false;
            }

            this.stoBinGKColor.DataSource = ds.Tables[0];
            this.stoBinGKColor.DataBind();

        }
        #endregion

        #region Description : 검색 버튼
        protected void btnFind_Click(object sender, DirectEventArgs e)
        {
            this.UP_DataBinding();
        }
        #endregion

        #region Description : 신규 버튼
        protected void btnNew_Click(object sender, DirectEventArgs e)
        {
            btnSave.Hidden = false;
            btnDel.Hidden = true;

            txtGGOKJONG.Text = "";
            txtGGOKJONGNM.Text = "";
            txtGKCOLOR.Text = "";

            txtGGOKJONG.ReadOnly = false;
            txtGGOKJONG.FieldStyle = "background-color:white;";

            BoradColorPop.Show();
        }
        #endregion

        #region Description : 팝업 신규버튼 클릭
        protected void btnWinNew_Click(object sender, DirectEventArgs e)
        {
            txtGGOKJONG.Text = "";
            txtGGOKJONGNM.Text = "";
            txtGKCOLOR.Text = "";

            txtGGOKJONG.ReadOnly = false;
            txtGGOKJONG.FieldStyle = "background-color:white;";

            btnDel.Hidden = true;
        }
        #endregion

        #region Description : 일괄 저장 버튼
        [DirectMethod]
        public void btnMSave_Click(string GGOKJONG, string GCOLOR)
        {
            string[] sGGOKJONG = GGOKJONG.Split(',');
            string[] sGCOLOR = GCOLOR.Split(',');

            this.DbConnector.CommandClear();

            for (int i = 0; i < sGGOKJONG.Length; i++)
            {
                this.DbConnector.Attach("TG_P_GS_B2HFB617", sGCOLOR[i].Replace("#", ""),
                                                            PSUserInfo.EmpNo,
                                                            sGGOKJONG[i]
                                                            );
            }

            this.DbConnector.ExecuteNonQueryList();

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();

            X.Js.Call("SetOpenerCall");
        }
        #endregion

        #region Description : 저장 버튼
        protected void btnSave_Click(object sender, DirectEventArgs e)
        {
            // 등록확인
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HFG620", txtGGOKJONG.Value);
            DataTable dt = this.DbConnector.ExecuteDataTable();

            // 신규등록
            if (dt.Rows.Count == 0)
            {
                this.DbConnector.Attach("TG_P_GS_B2HFF619", txtGGOKJONG.Text,
                                                            txtGKCOLOR.Text.Replace("#", ""),
                                                            PSUserInfo.EmpNo
                                                            );
            }
            // 수정
            else
            {
                this.DbConnector.Attach("TG_P_GS_B2HFB617", txtGKCOLOR.Text.Replace("#", ""),
                                                            PSUserInfo.EmpNo,
                                                            txtGGOKJONG.Text
                                                            );
            }
            this.DbConnector.ExecuteNonQuery();

            btnDel.Hidden = false;
            txtGGOKJONG.ReadOnly = true;
            txtGGOKJONG.FieldStyle = "background-color:#E5E5E5;";

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();

            X.Js.Call("SetOpenerCall");

            this.UP_DataBinding();
        }
        #endregion

        #region : Description : 그리드 클릭
        protected void grdList_CellClick(object sender, DirectEventArgs e)
        {
            BoradColorPop.Show();
            txtGGOKJONG.ReadOnly = true;
            txtGGOKJONG.FieldStyle = "background-color:#E5E5E5;";
            string[] datas;
            string[] checkDatas = e.ExtraParams["DATAS"].Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HFG620", datas[0].ToString().Trim());
                DataSet ds = this.DbConnector.ExecuteDataSet();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    txtGGOKJONG.Text = ds.Tables[0].Rows[0]["GGOKJONG"].ToString();
                    txtGGOKJONGNM.Text = ds.Tables[0].Rows[0]["GGOKJONGNM"].ToString();
                    txtGKCOLOR.Text = ds.Tables[0].Rows[0]["GCOLOR"].ToString();

                    btnDel.Hidden = false;
                    btnSave.Hidden = false;
                }
            }
        }
        #endregion

        #region : Description : 삭제버튼
        protected void btnDel_Click(object sender, DirectEventArgs e)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HFH621", txtGGOKJONG.Text);
            this.DbConnector.ExecuteTranQuery();

            X.MessageBox.Alert("확인", "삭제 되었습니다.").Show();

            this.UP_DataBinding();

            BoradColorPop.Hide();
        }
        #endregion

        #region Description : 곡종 변경
        [DirectMethod]
        public void UP_GOKJONGChange(string GOKJONG)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HFG620", GOKJONG);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                txtGGOKJONG.Text = ds.Tables[0].Rows[0]["GGOKJONG"].ToString();
                txtGGOKJONGNM.Text = ds.Tables[0].Rows[0]["GGOKJONGNM"].ToString();
                txtGKCOLOR.Text = ds.Tables[0].Rows[0]["GCOLOR"].ToString();

                btnDel.Hidden = false;
                btnSave.Hidden = false;

                txtGGOKJONG.ReadOnly = true;
                txtGGOKJONG.FieldStyle = "background-color:#E5E5E5;";
            }
        }
        #endregion
    }
}