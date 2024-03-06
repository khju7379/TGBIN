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
    public partial class SiloBinStatus : PageBase
    {
        public string fsSDATE;
        public string fsSBINNO;
        public string fsSJUNILQTY;
        public string fsSIPGOQTY;
        public string fsSEPGOQTY;
        public string fsSEPCHQTY;
        public string fsSCHULQTY;
        public string fsSINCDECQTY;
        public string fsSJEGOQTY;
        public string fsSSURQTY;
        public string fsSGOKJONG;
        public string fsSWONSAN;
        public string fsSHANGCHA;
        public string fsSHANGCHANM;
        public string fsSIPDATE;
        public string fsSCLDATE;
        public string fsSBINSTATUS;
        public string fsSCHGN;

        public string fsSSOSOK;
        public string fsSMEMO;
        public string fsSCORPGUBN;
        public string fsSHWGCODE;

        public SiloBinStatus()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                dtpDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));
                string sSDATE = string.Format("{0:yyyyMMdd}", dtpDATE.Value);
                X.Js.Call("UP_run");
            }
        }
        [DirectMethod]
        public void UP_run(string sSDATE, string sCORPGUBN, string sRTGUBN)
        {
            this.UP_CodeDataBinding();
            this.UP_DataBinding(sSDATE, sCORPGUBN, sRTGUBN);
        }

        #region Description : UP_DataBinding 조회
        private void UP_DataBinding(string sDATE, string sCORPGUBN, string sRTGUBN)
        {
            string sCPGB = string.Empty;
            string sRTGB = string.Empty;

            if (sCORPGUBN == "A")
            {
                sCPGB = "";
                sRTGB = "";
            }
            else
            {
                if (sRTGUBN == "true")
                {
                    sCPGB = "";
                    sRTGB = sCORPGUBN;
                }
                else
                {
                    sCPGB = sCORPGUBN;
                    sRTGB = "";
                }
            }


            this.stoBinStatus.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35D1825", sDATE, sCPGB, sRTGB);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            this.stoBinStatus.DataSource = ds.Tables[0];
            this.stoBinStatus.DataBind();

            this.stoBinMoveTotal.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35D5826", sDATE, sCPGB, sRTGB);
            DataSet dt = this.DbConnector.ExecuteDataSet();

            this.stoBinMoveTotal.DataSource = dt.Tables[0];
            this.stoBinMoveTotal.DataBind();

            X.Js.Call("tab_BoardHtmlRenter");
            X.Js.Call("tab_BoardHtmlRenter_Total");
        }
        #endregion

        #region Description : UP_CodeDataBinding 조회
        private void UP_CodeDataBinding()
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35DC827");
            DataSet ds = this.DbConnector.ExecuteDataSet();

            this.stoCodeList.DataSource = ds.Tables[0];
            this.stoCodeList.DataBind();

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B38H2847");
            ds = this.DbConnector.ExecuteDataSet();

            this.stoSKCodeList.DataSource = ds.Tables[0];
            this.stoSKCodeList.DataBind();
        }
        #endregion

        #region Description : 신규 버튼
        protected void btnNew_Click(object sender, DirectEventArgs e)
        {
            UP_FiledClear();
            UP_BlankTableCrt();

            winBinStatus.Show();
        }
        #endregion

        #region Description : 필드 클리어
        private void UP_FiledClear()
        {
            dtpSDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));
            txtSBINNO.Text = "";
            txtSGOKJONG.Text = "";
            txtSGOKJONGNM.Text = "";
            txtSWONSAN.Text = "";
            txtSWONSANNM.Text = "";
            txtSHANGCHA.Text = "";
            txtSHANGCHANM.Text = "";

            dtpSCLDATE.SetValue("");
            dtpSIPDATE.SetValue("");

            cboSCHGN.SetValue("");

            txtSSOSOK.Text = "";
            txtSSOSOKNM.Text = "";

            txtSHWGCODE.Text = "";

            dtpSDATE.ReadOnly = false;
            txtSBINNO.ReadOnly = false;
            dtpSDATE.FieldStyle = "background-color:white;";
            txtSBINNO.FieldStyle = "background-color:white;";

        }
        #endregion

        #region Description : 그리드 클릭
        [DirectMethod]
        public void grdBinStatus_CellClick(string SDATE, string SBINNO)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35DL829", SDATE,
                                                        SBINNO);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dtpSDATE.SetValue(Set_Date(ds.Tables[0].Rows[0]["SDATE"].ToString()));
                txtSBINNO.Text = ds.Tables[0].Rows[0]["SBINNO"].ToString();
                txtSGOKJONG.Text = ds.Tables[0].Rows[0]["SGOKJONG"].ToString();
                txtSGOKJONGNM.Text = ds.Tables[0].Rows[0]["SGOKJONGNM"].ToString();
                txtSWONSAN.Text = ds.Tables[0].Rows[0]["SWONSAN"].ToString();
                txtSWONSANNM.Text = ds.Tables[0].Rows[0]["SWONSANNM"].ToString();
                txtSHANGCHA.Text = ds.Tables[0].Rows[0]["SHANGCHA"].ToString();
                txtSHANGCHANM.Text = ds.Tables[0].Rows[0]["SHANGCHANM"].ToString();

                dtpSCLDATE.SetValue(Set_Date(ds.Tables[0].Rows[0]["SCLDATE"].ToString()));
                dtpSIPDATE.SetValue(Set_Date(ds.Tables[0].Rows[0]["SIPDATE"].ToString()));

                cboSCHGN.SetValue(ds.Tables[0].Rows[0]["SCHGN"].ToString());

                txtSSOSOK.Text = ds.Tables[0].Rows[0]["SSOSOK"].ToString();
                txtSSOSOKNM.Text = ds.Tables[0].Rows[0]["SSOSOKNM"].ToString();

                txtSHWGCODE.Text = ds.Tables[0].Rows[0]["SHWGCODE"].ToString();

                txtSMEMO.Text = ds.Tables[0].Rows[0]["SMEMO"].ToString();

                dtpSDATE.ReadOnly = true;
                txtSBINNO.ReadOnly = true;
                dtpSDATE.FieldStyle = "background-color:#E5E5E5;";
                txtSBINNO.FieldStyle = "background-color:#E5E5E5;";

                stoBinStatusEdit.DataSource = ds.Tables[0];
                stoBinStatusEdit.DataBind();

                txtSGOKJONG.Focus();
            }

            winBinStatus.Show();
        }
        #endregion

        #region Description : 복사 화면 보이기 버튼
        protected void btnCopy_Click(object sender, DirectEventArgs e)
        {

            datStartDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));
            datCopyDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now.AddDays(1)));

            this.WinDateCopy.Show();
        }
        #endregion

        #region Description : 복사 버튼
        [DirectMethod]
        public void btnAccept_Click(string datStartDATE, string datCopyDATE)
        {
            //동일일자 체크
            if (string.Format("{0:yyyyMMdd}", datStartDATE) == string.Format("{0:yyyyMMdd}", datCopyDATE))
            {
                X.MessageBox.Alert("확인", "기준일자와 복사일자는 같을수 없습니다!").Show();
                return;
            }
            if (Convert.ToDouble(string.Format("{0:yyyyMMdd}", datStartDATE)) > Convert.ToDouble(string.Format("{0:yyyyMMdd}", datCopyDATE)))
            {
                X.MessageBox.Alert("확인", "기준일자가 복사일자보다 큽니다!").Show();
                return;
            }

            string sCopyDate = string.Empty;
            string sKijunDate = string.Empty;

            sKijunDate = string.Format("{0:yyyyMMdd}", datStartDATE);
            sCopyDate = string.Format("{0:yyyyMMdd}", datCopyDATE);

            string sOUTMSG = string.Empty;

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35DE828", sKijunDate, sCopyDate, PSUserInfo.EmpNo, sOUTMSG.ToString());   
            sOUTMSG = Convert.ToString(this.DbConnector.ExecuteScalar());

            X.MessageBox.Alert("확인", "자료 복사가 완료되었습니다.").Show();

        }
        #endregion

        #region Description : 신규 버튼
        protected void btnWinNew_Click(object sender, DirectEventArgs e)
        {
            this.UP_FiledClear();
            this.UP_BlankTableCrt();
        }
        #endregion

        #region Description : 저장 버튼
        [DirectMethod]
        public void btnWinSav_Click(string sSDATE, string sSBINNO, string sSJUNILQTY,
                                        string sSIPGOQTY, string sSEPGOQTY, string sSEPCHQTY,
                                        string sSCHULQTY, string sSINCDECQTY, string sSJEGOQTY, 
                                        string sSSURQTY, string sSGOKJONG, string sSWONSAN,
                                        string sSHANGCHA, string sSHANGCHANM, string sSIPDATE,
                                        string sSCLDATE, string sSBINSTATUS, string sSCHGN,
                                        string sSSOSOK, string sSMEMO, string sSHWGCODE, 
                                        string sCORPGUBN, string sRTGUBN)
        {
            fsSDATE = sSDATE;
            fsSBINNO = sSBINNO;
            fsSJUNILQTY = sSJUNILQTY;
            fsSIPGOQTY = sSIPGOQTY;
            fsSEPGOQTY = sSEPGOQTY;
            fsSEPCHQTY = sSEPCHQTY;
            fsSCHULQTY = sSCHULQTY;
            fsSINCDECQTY = sSINCDECQTY;
            fsSJEGOQTY = sSJEGOQTY;
            fsSSURQTY = sSSURQTY;
            fsSGOKJONG = sSGOKJONG;
            fsSWONSAN = sSWONSAN;
            fsSHANGCHA = sSHANGCHA;
            fsSHANGCHANM = sSHANGCHANM;
            fsSIPDATE = sSIPDATE;
            fsSCLDATE = sSCLDATE;
            fsSBINSTATUS = sSBINSTATUS;
            fsSCHGN = sSCHGN;
            fsSSOSOK = sSSOSOK;
            fsSMEMO = sSMEMO;
            fsSHWGCODE = sSHWGCODE;

            bool result = UP_KeyCheck();

            if (result == false)
            {
                return;
            }

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35DL829", sSDATE, sSBINNO);
            DataTable dt = this.DbConnector.ExecuteDataTable();

            if (dt.Rows.Count > 0)
            {
                //수정
                this.DbConnector.CommandClear();
                fsSJEGOQTY = fsSSURQTY;

                this.DbConnector.Attach("TG_P_GS_B3OLF052", fsSINCDECQTY,
                                                            fsSINCDECQTY,
                                                            fsSINCDECQTY,
                                                            fsSGOKJONG,
                                                            fsSWONSAN,
                                                            fsSHANGCHA,
                                                            fsSHANGCHANM,
                                                            fsSHWGCODE,
                                                            fsSIPDATE,
                                                            fsSCLDATE,
                                                            fsSSOSOK,
                                                            fsSMEMO,
                                                            PSUserInfo.EmpNo,
                                                            fsSDATE,
                                                            sSBINNO
                                                            );

                
                //this.DbConnector.Attach("TG_P_GS_B35DM830", fsSINCDECQTY,
                //                                            fsSINCDECQTY,
                //                                            fsSINCDECQTY,
                //                                            fsSGOKJONG,
                //                                            fsSWONSAN,
                //                                            fsSHANGCHA,
                //                                            fsSHANGCHANM,
                //                                            fsSHWGCODE,
                //                                            fsSIPDATE,
                //                                            fsSCLDATE,
                //                                            fsSCHGN,
                //                                            fsSSOSOK,
                //                                            fsSMEMO,
                //                                            PSUserInfo.EmpNo,
                //                                            fsSDATE,
                //                                            sSBINNO
                //                                            );

                // BIN입고파일 그레인, 평택싸이로
                this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, fsSDATE, sSBINNO);
                this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, fsSDATE, sSBINNO);
                
                this.DbConnector.ExecuteNonQueryList();
            }
            else
            {
                // 신규등록 불가
            }

            grdBinStatus_CellClick(fsSDATE, sSBINNO);

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();

            //this.UP_DataBinding(fsSDATE, sCORPGUBN, sRTGUBN);

            X.Js.Call("SetOpenerCall");
        }
        #endregion

        #region Description : 빈 테이블 생성
        private void UP_BlankTableCrt()
        {
            DataTable dt = new DataTable();

            DataRow row;

            dt.Columns.Add("SJUNILQTY", typeof(System.String));
            dt.Columns.Add("SIPGOQTY", typeof(System.String));
            dt.Columns.Add("SEPGOQTY", typeof(System.String));
            dt.Columns.Add("SEPCHQTY", typeof(System.String));
            dt.Columns.Add("SCHULQTY", typeof(System.String));
            dt.Columns.Add("SINCDECQTY", typeof(System.String));
            dt.Columns.Add("SJEGOQTY", typeof(System.String));
            dt.Columns.Add("SSURQTY", typeof(System.String));

            row = dt.NewRow();

            row["SJUNILQTY"] = 0;
            row["SIPGOQTY"] = 0;
            row["SEPGOQTY"] = 0;
            row["SEPCHQTY"] = 0;
            row["SCHULQTY"] = 0;
            row["SINCDECQTY"] = 0;
            row["SJEGOQTY"] = 0;
            row["SSURQTY"] = 0;

            dt.Rows.Add(row);

            this.stoBinStatusEdit.RemoveAll();
            this.stoBinStatusEdit.DataSource = dt;
            this.stoBinStatusEdit.DataBind();

        }
        #endregion

        #region Description : 키 체크
        private bool UP_KeyCheck()
        {
            DataTable dt = new DataTable();

            if (fsSDATE == "00010101")
            {
                X.MessageBox.Alert("확인", "일자를 입력하세요!", "SetTextFocus(1)").Show();
                return false;
            }

            if (fsSBINNO != "")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2JAJ674", fsSBINNO);
                dt = this.DbConnector.ExecuteDataTable();
                if (dt.Rows.Count == 0)
                {
                    X.MessageBox.Alert("확인", "BIN 번호를 확인하세요!", "SetTextFocus(2)").Show();
                    return false;
                }
            }
            else
            {
                X.MessageBox.Alert("확인", "BIN 번호를 입력하세요!", "SetTextFocus(2)").Show();
                return false;
            }

            if (fsSGOKJONG != "")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HFS625", "GK", fsSGOKJONG, "");
                dt = this.DbConnector.ExecuteDataTable();
                if (dt.Rows.Count == 0)
                {
                    X.MessageBox.Alert("확인", "곡종을 확인하세요!", "SetTextFocus(3)").Show();
                    return false;
                }
            }

            if (fsSWONSAN != "")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HFS625", "WN", fsSWONSAN, "");
                dt = this.DbConnector.ExecuteDataTable();
                if (dt.Rows.Count == 0)
                {
                    X.MessageBox.Alert("확인", "원산지를 확인하세요!", "SetTextFocus(4)").Show();
                    return false;
                }
            }

            if (fsSHANGCHA != "")
            {
                // BIN 임대여부 체크
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B35ET834", fsSDATE, fsSBINNO);
                dt = this.DbConnector.ExecuteDataTable();

                if (dt.Rows.Count > 0)
                {
                    this.DbConnector.CommandClear();

                    if (dt.Rows[0]["RENTCORPGUBN"].ToString() == "T")
                    {
                        this.DbConnector.Attach("TG_P_GS_B35G2835", fsSHANGCHA, "");
                    }
                    else
                    {
                        this.DbConnector.Attach("TG_P_GS_B35G3836", fsSHANGCHA, "");
                    }

                    dt = this.DbConnector.ExecuteDataTable();
                    if (dt.Rows.Count == 0)
                    {
                        X.MessageBox.Alert("확인", "항차를 확인하세요!", "SetTextFocus(5)").Show();
                        return false;
                    }
                }
            }

            if (fsSSOSOK != "")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HFS625", "SK", fsSSOSOK, "");
                dt = this.DbConnector.ExecuteDataTable();
                if (dt.Rows.Count == 0)
                {
                    X.MessageBox.Alert("확인", "소속을 확인하세요!", "SetTextFocus(7)").Show();
                    return false;
                }
            }

            return true;
        }
        #endregion

        #region Description : UP_WinBinStatushide 함수
        [DirectMethod]
        public void UP_WinBinStatushide(string sDATE, string sCORPGUBN, string sRTGUBN)
        {
            this.UP_DataBinding(sDATE, sCORPGUBN, sRTGUBN);
        }
        #endregion

        #region Description : UP_WinBinStatushide 함수 (조회화면 저장)
        [DirectMethod]
        public void UP_BinStatusArrayValue(string sArrayValue, string sCORPGUBN, string sRTGUBN)
        {
            string sDate = string.Empty;
            string[] datas;
            string[] checkDatas = sArrayValue.Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            this.DbConnector.CommandClear();
            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[0].ToString() != "" && datas[1].ToString() != "")
                {
                    //this.DbConnector.Attach("TG_P_GS_B3NBW024", datas[2].ToString(),
                    //                                            datas[3].ToString(),
                    //                                            datas[4].ToString(),
                    //                                            datas[11].ToString(),
                    //                                            datas[5].ToString(),
                    //                                            datas[6].ToString().Replace(".", ""),
                    //                                            datas[7].ToString().Replace(".", ""),
                    //                                            datas[8].ToString(),
                    //                                            datas[9].ToString(),
                    //                                            datas[10].ToString(),
                    //                                            PSUserInfo.EmpNo,
                    //                                            datas[0].ToString(),
                    //                                            datas[1].ToString());

                    this.DbConnector.Attach("TG_P_GS_B35GE837", datas[3].ToString(),    // 곡종
                                                                datas[4].ToString(),    // 원산지
                                                                datas[11].ToString(),   // WGCODE
                                                                datas[5].ToString(),    // 항차
                                                                datas[6].ToString().Replace(".", ""),   // 입고일자
                                                                datas[7].ToString().Replace(".", ""),   // CLEANING 일자
                                                                datas[9].ToString(),    // 협회
                                                                datas[10].ToString(),   // 비고
                                                                PSUserInfo.EmpNo,       
                                                                datas[0].ToString(),    // 일자
                                                                datas[1].ToString());   // BIN 번호

                    // BIN입고파일 그레인, 평택싸이로 
                    this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, datas[0].ToString(), datas[1].ToString());
                    this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, datas[0].ToString(), datas[1].ToString());

                    sDate = datas[0].ToString();
                }
            }
            this.DbConnector.ExecuteNonQueryList();

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();

            this.UP_DataBinding(sDate, sCORPGUBN, sRTGUBN);

            X.Js.Call("SetOpenerCall");

        }
        #endregion

        #region Description : 이전, 다음 달력 버튼 이벤트
        [DirectMethod]
        public void UP_DateMove(string sDate, string sCORPGUBN, string sRTGUBN)
        {
            this.UP_DataBinding(sDate, sCORPGUBN, sRTGUBN);
        }
        #endregion

        #region Description : 항차 체크
        [DirectMethod]
        public void UP_HANGCHACHECK(string HANGCHA, string HANGHCANMID, string SBINNO, string SDATE)
        {
            string[] sID = HANGHCANMID.Split('-');

            // BIN 임대여부 체크
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35ET834", SDATE, SBINNO);
            DataTable dt = this.DbConnector.ExecuteDataTable();

            if (dt.Rows.Count > 0)
            {
                this.DbConnector.CommandClear();

                if (dt.Rows[0]["RENTCORPGUBN"].ToString() == "T")
                {
                    this.DbConnector.Attach("TG_P_GS_B35GP838", HANGCHA);
                }
                else
                {
                    this.DbConnector.Attach("TG_P_GS_B35GP839", HANGCHA);
                }

                dt = this.DbConnector.ExecuteDataTable();

                if (dt.Rows.Count <= 0)
                {
                    X.MessageBox.Alert("확인", "항차코드를 확인하세요.").Show();
                }
                else
                {
                    X.Js.Call("settxtSHANGCHANM", sID[1] + "-" + sID[2],
                                                  dt.Rows[0]["IHHANGCHANM"].ToString(),
                                                  dt.Rows[0]["IHGOKJONG1"].ToString(),
                                                  dt.Rows[0]["IHGOKJONG1NM"].ToString(),
                                                  dt.Rows[0]["IHWONSAN1"].ToString(),
                                                  dt.Rows[0]["IHWONSAN1NM"].ToString());
                }
            }
        }
        #endregion
    }
}