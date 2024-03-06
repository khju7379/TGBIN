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
    public partial class SiloBinBoardSpc : PageBase
    {
        public SiloBinBoardSpc()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                this.UP_DataBinding("19000101", "99991231", "N", "");
            }
        }

        #region Description : 검색 버튼
        protected void btnFind_Click(object sender, DirectEventArgs e)
        {
            string sSDATE = string.Format("{0:yyyyMMdd}", dtpSDATE.Value);
            string sEDATE = string.Format("{0:yyyyMMdd}", dtpEDATE.Value);

            if (cboGUBN.Value.ToString() != "N")
            {
                if (sSDATE == "00010101")
                {
                    X.MessageBox.Alert("확인", "일자를 입력하세요!", "SetTextFocus(5)").Show();
                    return;
                }
                if (sEDATE == "00010101")
                {
                    X.MessageBox.Alert("확인", "일자를 입력하세요!", "SetTextFocus(6)").Show();
                    return;
                }

                if (Convert.ToInt32(sSDATE.Trim()) > Convert.ToInt32(sEDATE.Trim()))
                {
                    X.MessageBox.Alert("확인", "시작일자는 종료일자보다 이전이어야 합니다!", "SetTextFocus(5)").Show();
                    return;
                }
            }

            if (sSDATE == "00010101")
            {
                sSDATE = "19000101";
            }
            if (sEDATE == "00010101")
            {
                sEDATE = "99991231";
            }
            string sGUBN = cboGUBN.Text.Trim();
            string sMEMO = txtMEMO.Text.Trim();

            this.UP_DataBinding(sSDATE, sEDATE, sGUBN, sMEMO);
        }
        #endregion

        #region Description : 마스타 그리드 데이터 바인딩
        private void UP_DataBinding(string sSDATE, string sEDATE, string sGUBN, string sMEMO)
        {

            this.stoBinBoard.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HDG603", sSDATE, sEDATE, sGUBN.Replace("1", ""), sMEMO);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            this.stoBinBoard.DataSource = UP_DataTableChange(ds.Tables[0]);
            this.stoBinBoard.DataBind();

        }
        #endregion

        #region Description : 데이터셋 변환
        private DataTable UP_DataTableChange(DataTable dt)
        {
            DataTable rtnDt = new DataTable();
            DataRow row;

            rtnDt.Columns.Add("SPDATE", typeof(System.String));
            rtnDt.Columns.Add("SPSEQ", typeof(System.String));
            rtnDt.Columns.Add("SPMEMO", typeof(System.String));
            rtnDt.Columns.Add("SPUPDATE", typeof(System.String));
            rtnDt.Columns.Add("SPDOWNDATE", typeof(System.String));
            rtnDt.Columns.Add("SPENDGUBN", typeof(System.String));
            rtnDt.Columns.Add("SPRANK", typeof(System.String));

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                row = rtnDt.NewRow();

                row["SPDATE"] = dt.Rows[i]["SPDATE"].ToString();
                row["SPSEQ"] = dt.Rows[i]["SPSEQ"].ToString();
                row["SPMEMO"] = dt.Rows[i]["SPMEMO"].ToString().Replace("\n", "<br>");
                row["SPUPDATE"] = dt.Rows[i]["SPUPDATE"].ToString();
                row["SPDOWNDATE"] = dt.Rows[i]["SPDOWNDATE"].ToString();
                row["SPENDGUBN"] = dt.Rows[i]["SPENDGUBN"].ToString();
                row["SPRANK"] = dt.Rows[i]["SPRANK"].ToString();

                rtnDt.Rows.Add(row);
            }

            return rtnDt;
        }
        #endregion

        #region Description : 필드 초기화
        private void UP_init()
        {
            btnDel.Hidden = true;
            dtpSPDATE.ReadOnly = false;
            ckbSPENDGUBN.ReadOnly = true;
            dtpSPDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));
            txtSPSEQ.Text = "";
            txtSPMEMO.Text = "";
            dtpSPUPDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));
            dtpSPDOWNDATE.Text = "";
            dtpSPDATE.FieldStyle = "background-color:White;";
            ckbSPENDGUBN.Checked = false;
            cboSPRANK.SetValue("0");
        }
        #endregion

        #region Description : 신규 버튼
        protected void btnNew_Click(object sender, DirectEventArgs e)
        {
            UP_init();
            BoradSpcPop.Show();
        }
        #endregion

        #region Description : 신규 버튼(관리화면)
        protected void btnWinNew_Click(object sender, DirectEventArgs e)
        {
            UP_init();
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

            string SPDOWNDATE = string.Format("{0:yyyyMMdd}", dtpSPDOWNDATE.Value);
            if (SPDOWNDATE == "00010101") SPDOWNDATE = "";

            string sSPENDGUBN = "N";

            if (ckbSPENDGUBN.Checked == true)
            {
                sSPENDGUBN = "Y";
            }

            // 신규등록
            if (txtSPSEQ.Text == "")
            {
                // 순번가져오기
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HDG604", string.Format("{0:yyyyMMdd}", dtpSPDATE.Value));
                DataTable dt = this.DbConnector.ExecuteDataTable();
                string sSEQ = dt.Rows[0]["SEQ"].ToString();

                this.DbConnector.Attach("TG_P_GS_B4CG4172", string.Format("{0:yyyyMMdd}", dtpSPDATE.Value),
                                                            sSEQ,
                                                            txtSPMEMO.Text,
                                                            string.Format("{0:yyyyMMdd}", dtpSPUPDATE.Value),
                                                            SPDOWNDATE,
                                                            sSPENDGUBN,
                                                            cboSPRANK.Value.ToString(),
                                                            PSUserInfo.EmpNo
                                                            );

                //this.DbConnector.Attach("TG_P_GS_B2HDI605", string.Format("{0:yyyyMMdd}", dtpSPDATE.Value),
                //                                            sSEQ,
                //                                            txtSPMEMO.Text,
                //                                            string.Format("{0:yyyyMMdd}", dtpSPUPDATE.Value),
                //                                            SPDOWNDATE,
                //                                            sSPENDGUBN,
                //                                            PSUserInfo.EmpNo
                //                                            );
                this.DbConnector.ExecuteNonQuery();

                txtSPSEQ.Text = Set_Fill3(sSEQ);
            }
            // 수정
            else
            {
                if (ckbSPENDGUBN.Checked == true)
                {
                    SPDOWNDATE = string.Format("{0:yyyyMMdd}", DateTime.Now);
                }
                else
                {
                    SPDOWNDATE = "";
                }

                this.DbConnector.Attach("TG_P_GS_B4CG7173", txtSPMEMO.Text,
                                                            string.Format("{0:yyyyMMdd}", dtpSPUPDATE.Value),
                                                            SPDOWNDATE,
                                                            sSPENDGUBN,
                                                            cboSPRANK.Value.ToString(),
                                                            PSUserInfo.EmpNo,
                                                            string.Format("{0:yyyyMMdd}", dtpSPDATE.Value),
                                                            txtSPSEQ.Text
                                                            );
                //this.DbConnector.Attach("TG_P_GS_B2HDJ606", txtSPMEMO.Text,
                //                                            string.Format("{0:yyyyMMdd}", dtpSPUPDATE.Value),
                //                                            SPDOWNDATE,
                //                                            sSPENDGUBN,
                //                                            PSUserInfo.EmpNo,
                //                                            string.Format("{0:yyyyMMdd}", dtpSPDATE.Value),
                //                                            txtSPSEQ.Text
                //                                            );
                this.DbConnector.ExecuteNonQuery();
            }

            X.Js.Call("SetOpenerCall");

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();

            string sSDATE = string.Format("{0:yyyyMMdd}", dtpSDATE.Value);
            string sEDATE = string.Format("{0:yyyyMMdd}", dtpEDATE.Value);
            if (sSDATE == "00010101")
            {
                sSDATE = "19000101";
            }
            if (sEDATE == "00010101")
            {
                sEDATE = "99991231";
            }

            this.UP_DataBinding(sSDATE, sEDATE, cboGUBN.Text, "");
            UP_PopDataSelect(string.Format("{0:yyyyMMdd}", dtpSPDATE.Value), txtSPSEQ.Text);
            dtpSPDATE.ReadOnly = true;
            dtpSPDATE.FieldStyle = "background-color:#E5E5E5;";
            ckbSPENDGUBN.ReadOnly = false;
            btnDel.Hidden = false;

        }
        #endregion

        #region : Description : 삭제버튼
        protected void btnDel_Click(object sender, DirectEventArgs e)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HDJ607", string.Format("{0:yyyyMMdd}", dtpSPDATE.Value),
                                                        txtSPSEQ.Text);
            this.DbConnector.ExecuteTranQuery();

            X.Js.Call("SetOpenerCall");

            X.MessageBox.Alert("확인", "삭제 되었습니다.").Show();

            string sSDATE = string.Format("{0:yyyyMMdd}", dtpSDATE.Value);
            string sEDATE = string.Format("{0:yyyyMMdd}", dtpEDATE.Value);
            if (sSDATE == "00010101")
            {
                sSDATE = "19000101";
            }
            if (sEDATE == "00010101")
            {
                sEDATE = "99991231";
            }

            this.UP_DataBinding(sSDATE, sEDATE, cboGUBN.Text, "");
            UP_init();
        }
        #endregion

        #region Description : 게시완료버튼
        [DirectMethod]
        public void btnProc_Click(string SPDATE, string SPSEQ, string SPMEMO, string SPUPDATE, string SDATE, string EDATE, string GUBN)
        {
            string SPDOWNDATE = string.Format("{0:yyyyMMdd}", DateTime.Now);

            this.DbConnector.CommandClear();
            
            this.DbConnector.Attach("TG_P_GS_B4CG7173", SPMEMO,
                                                        SPUPDATE.Replace(".", ""),
                                                        SPDOWNDATE,
                                                        "Y",
                                                        cboSPRANK.Value.ToString(),
                                                        PSUserInfo.EmpNo,
                                                        SPDATE.Replace(".", ""),
                                                        SPSEQ
                                                        );

            //this.DbConnector.Attach("TG_P_GS_B2HDJ606", SPMEMO,
            //                                            SPUPDATE.Replace(".", ""),
            //                                            SPDOWNDATE,
            //                                            "Y",
            //                                            cboSPRANK.Value.ToString(),
            //                                            PSUserInfo.EmpNo,
            //                                            SPDATE.Replace(".", ""),
            //                                            SPSEQ
            //                                            );
            this.DbConnector.ExecuteNonQuery();

            string sSDATE = SDATE;
            string sEDATE = EDATE;
            if (sSDATE == "")
            {
                sSDATE = "19000101";
            }
            if (sEDATE == "")
            {
                sEDATE = "99991231";
            }

            this.UP_DataBinding(sSDATE, sEDATE, GUBN, "");

            X.Js.Call("SetOpenerCall");
        }
        #endregion

        #region Description : 그리드 클릭
        protected void grdList_CellClick(object sender, DirectEventArgs e)
        {
            BoradSpcPop.Show();
            dtpSPDATE.ReadOnly = true;
            dtpSPDATE.FieldStyle = "background-color:#E5E5E5;";
            string[] datas;
            string[] checkDatas = e.ExtraParams["DATAS"].Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                UP_PopDataSelect(datas[0].ToString().Replace(".", ""), datas[1].ToString());
            }
        }
        #endregion

        #region Description : 윈도우 팝업 데이터 조회
        private void UP_PopDataSelect(string SPDATE, string SPSEQ)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HDK608", SPDATE, SPSEQ);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                dtpSPDATE.SetValue(ds.Tables[0].Rows[0]["SPDATE"].ToString().Substring(0, 4) + "-" + ds.Tables[0].Rows[0]["SPDATE"].ToString().Substring(4, 2) + "-" + ds.Tables[0].Rows[0]["SPDATE"].ToString().Substring(6, 2));
                txtSPSEQ.Text = ds.Tables[0].Rows[0]["SPSEQ"].ToString();
                txtSPMEMO.Text = ds.Tables[0].Rows[0]["SPMEMO"].ToString();
                dtpSPUPDATE.SetValue(ds.Tables[0].Rows[0]["SPUPDATE"].ToString().Substring(0, 4) + "-" + ds.Tables[0].Rows[0]["SPUPDATE"].ToString().Substring(4, 2) + "-" + ds.Tables[0].Rows[0]["SPUPDATE"].ToString().Substring(6, 2));
                if (ds.Tables[0].Rows[0]["SPDOWNDATE"].ToString() == "")
                {
                    dtpSPDOWNDATE.SetValue("");
                }
                else
                {
                    dtpSPDOWNDATE.SetValue(ds.Tables[0].Rows[0]["SPDOWNDATE"].ToString().Substring(0, 4) + "-" + ds.Tables[0].Rows[0]["SPDOWNDATE"].ToString().Substring(4, 2) + "-" + ds.Tables[0].Rows[0]["SPDOWNDATE"].ToString().Substring(6, 2));
                }
                if (ds.Tables[0].Rows[0]["SPENDGUBN"].ToString() == "Y")
                {
                    ckbSPENDGUBN.Checked = true;
                }
                else
                {
                    ckbSPENDGUBN.Checked = false;
                }
                cboSPRANK.SetValue(ds.Tables[0].Rows[0]["SPRANK"].ToString());

                ckbSPENDGUBN.ReadOnly = false;

                txtSPMEMO.Focus();

                btnDel.Hidden = false;
            }
        }
        #endregion

        #region Description : KeyCheck
        private bool UP_KeyCheck()
        {
            if (string.Format("{0:yyyyMMdd}", this.dtpSPDATE.Value) == "" || string.Format("{0:yyyyMMdd}", this.dtpSPDATE.Value) == "00010101")
            {
                X.MessageBox.Alert("확인", "일자를 입력하세요!", "SetTextFocus(1)").Show();
                return false;
            }

            if (this.txtSPMEMO.Text.Trim() == "")
            {
                X.MessageBox.Alert("확인", "내용을 입력하세요!", "SetTextFocus(2)").Show();
                return false;
            }

            if (string.Format("{0:yyyyMMdd}", this.dtpSPUPDATE.Value) == "" || string.Format("{0:yyyyMMdd}", this.dtpSPUPDATE.Value) == "00010101")
            {
                X.MessageBox.Alert("확인", "게시시작일자를 입력하세요!", "SetTextFocus(3)").Show();
                return false;
            }

            if (string.Format("{0:yyyyMMdd}", this.dtpSPDOWNDATE.Value) != "" && string.Format("{0:yyyyMMdd}", this.dtpSPDOWNDATE.Value) != "00010101")
            {
                if (Convert.ToInt32(string.Format("{0:yyyyMMdd}", this.dtpSPUPDATE.Value)) > Convert.ToInt32(string.Format("{0:yyyyMMdd}", this.dtpSPDOWNDATE.Value)))
                {
                    X.MessageBox.Alert("확인", "게시종료일이 시작일보다 빠릅니다!", "SetTextFocus(4)").Show();
                    return false;
                }
            }

            return true;
        }
        #endregion
    }
}