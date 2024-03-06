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
    public partial class SiloBinCapa : PageBase
    {
        public SiloBinCapa()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                this.UP_DataBinding("", "", "");
            }
        }

        #region : Description : 그리드 데이터 바인딩
        private void UP_DataBinding(string sCGROUP, string sCBINNO, string sCORPGB)
        {

            this.stoBinCapa.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HKH648", sCGROUP.Replace("A", ""), 
                                                        sCBINNO,
                                                        sCORPGB.Replace("A", ""));
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

            this.stoBinCapa.DataSource = ds.Tables[0];
            this.stoBinCapa.DataBind();

        }
        #endregion

        #region Description : 검색 버튼
        protected void btnFind_Click(object sender, DirectEventArgs e)
        {
            string sBINNO = txtBINNO.Text.Trim();
            string sGROUP = cboGROUP.Text.Trim();
            string sCORPGB = cboCORPGB.Text.Trim();

            this.UP_DataBinding(sGROUP, sBINNO, sCORPGB);
        }
        #endregion

        #region Description : 신규 버튼
        protected void btnNew_Click(object sender, DirectEventArgs e)
        {
            btnSave.Hidden = false;
            btnDel.Hidden = true;

            txtBCBINNO.ReadOnly = false;
            txtBCBINNO.FieldStyle = "background-color:White;";

            txtBCBINNO.Text = "";
            cboBCGROUP.SetValueAndFireSelect("1");
            cboBCLCGUBN.SetValueAndFireSelect("R");
            txtBCCAPA.Text = "";
            txtBCYONGJUCK.Text = "";
            txtBCCORPGUBN.Text = "";
            BoradCapaPop.Show();
        }
        #endregion

        protected void btnWinNew_Click(object sender, DirectEventArgs e)
        {
            btnDel.Hidden = true;

            txtBCBINNO.ReadOnly = false;
            txtBCBINNO.FieldStyle = "background-color:White;";

            txtBCBINNO.Text = "";
            cboBCGROUP.SetValueAndFireSelect("1");
            cboBCLCGUBN.SetValueAndFireSelect("R");
            txtBCCAPA.Text = "";
            txtBCYONGJUCK.Text = "";
            txtBCCORPGUBN.Text = "";
        }

        #region Description : 저장량 일괄 저장 버튼
        [DirectMethod]
        public void btnMSave_Click(string BCBINNO, string BCCAPA, string BCYONGJUCK)
        {
            string[] sBCBINNO = BCBINNO.Split(',');
            string[] sBCCAPA = BCCAPA.Split(',');
            string[] sBCYONGJUCK = BCYONGJUCK.Split(',');

            this.DbConnector.CommandClear();

            for (int i = 0; i < sBCBINNO.Length; i++)
            {
                this.DbConnector.Attach("TG_P_GS_B2HKJ649", sBCCAPA[i],
                                                            sBCYONGJUCK[i],
                                                            PSUserInfo.EmpNo,
                                                            sBCBINNO[i]
                                                            );
            }

            this.DbConnector.ExecuteNonQueryList();

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();


        }
        #endregion

        #region Description : 저장 버튼
        protected void btnSave_Click(object sender, DirectEventArgs e)
        {
            bool result = UP_KeyCheck();

            if (result == false)
            {
                return;
            }

            this.DbConnector.Attach("TG_P_GS_B2IA7653", txtBCBINNO.Text,
                                                        cboBCGROUP.Text,
                                                        cboBCLCGUBN.Text,
                                                        txtBCCAPA.Text,
                                                        txtBCYONGJUCK.Text,
                                                        txtBCCORPGUBN.Text,
                                                        PSUserInfo.EmpNo,
                                                        txtBCBINNO.Text,
                                                        cboBCGROUP.Text,
                                                        cboBCLCGUBN.Text,
                                                        txtBCCAPA.Text,
                                                        txtBCYONGJUCK.Text,
                                                        txtBCCORPGUBN.Text,
                                                        PSUserInfo.EmpNo
                                                        );

            this.DbConnector.ExecuteNonQuery();

            btnDel.Hidden = false;
            txtBCBINNO.ReadOnly = true;
            txtBCBINNO.FieldStyle = "background-color:#E5E5E5;";

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();

            this.UP_DataBinding(cboGROUP.Text, txtBINNO.Text, cboCORPGB.Text);
        }
        #endregion

        private bool UP_KeyCheck()
        {
            if (this.txtBCBINNO.Text.Trim() == "")
            {
                X.MessageBox.Alert("확인", "BIN번호를 입력하세요!", "SetTextFocus(1)").Show();
                return false;
            }
            else
            {
                if (txtBCBINNO.Text.Trim().Substring(0, 1) == "3")
                {
                    txtBCCORPGUBN.Text = "P";
                }
                else
                {
                    txtBCCORPGUBN.Text = "T";
                }
            }

            if (this.txtBCCAPA.Text.Trim() == "")
            {
                X.MessageBox.Alert("확인", "저장량을 입력하세요!", "SetTextFocus(2)").Show();
                return false;
            }

            return true;
        }

        #region : Description : 그리드 클릭
        protected void grdList_CellClick(object sender, DirectEventArgs e)
        {
            BoradCapaPop.Show();
            txtBCBINNO.ReadOnly = true;
            txtBCBINNO.FieldStyle = "background-color:#E5E5E5;";
            string[] datas;
            string[] checkDatas = e.ExtraParams["DATAS"].Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2IA3654", datas[0].ToString().Trim());
                DataSet ds = this.DbConnector.ExecuteDataSet();

                if (ds.Tables[0].Rows.Count > 0)
                {

                    txtBCBINNO.Text = ds.Tables[0].Rows[0]["BCBINNO"].ToString();
                    cboBCGROUP.Text = ds.Tables[0].Rows[0]["BCGROUP"].ToString();
                    cboBCLCGUBN.Text = ds.Tables[0].Rows[0]["BCLCGUBN"].ToString();
                    txtBCCAPA.Text = ds.Tables[0].Rows[0]["BCCAPA"].ToString();
                    txtBCYONGJUCK.Text = ds.Tables[0].Rows[0]["BCYONGJUCK"].ToString();
                    txtBCCORPGUBN.Text = ds.Tables[0].Rows[0]["BCCORPGUBN"].ToString();

                    txtBCBINNO.Focus();
                    btnDel.Hidden = false;
                    btnSave.Hidden = false;
                }
            }
        }
        #endregion

        #region : Description : 삭제버튼
        protected void btnDel_Click(object sender, DirectEventArgs e)
        {
            // 삭제 체크 추가 필요 로직 생각해볼것 ex) 좌표 등록여부 등등


            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2IA4655", txtBCBINNO.Text);
            this.DbConnector.ExecuteTranQuery();

            X.MessageBox.Alert("확인", "삭제 되었습니다.").Show();

            this.UP_DataBinding(cboGROUP.Text, txtBINNO.Text, cboCORPGB.Text);

            BoradCapaPop.Hide();
        }
        #endregion
    }
}