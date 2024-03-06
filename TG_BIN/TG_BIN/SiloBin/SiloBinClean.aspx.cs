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
    public partial class SiloBinClean : PageBase
    {
        public SiloBinClean()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                string sSDATE = "19900101";
                string sEDATE = "20301231";

                string sDate = string.Format("{0:yyyyMMdd}", DateTime.Today);

                this.UP_DataBinding(sSDATE, sEDATE, txtBIN.Text.Trim(), "P");

                this.hidAuthSABUN.SetValue(PSUserInfo.EmpNo);

                //BIN번호
                stoBINNO.Data = GetBINNOData(sDate);
                stoBINNO.DataBind();
            }
        }

        #region Description : UP_DataBinding 조회
        private void UP_DataBinding(string sSDATE, string sEDATE, string sBIN, string sGubn)
        {
            if (sGubn == "P")
            {
                sSDATE = "19900101";
                sEDATE = "20301231";
            }

            this.stoBinClean.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2IJG667", sGubn, sSDATE, sEDATE, sBIN);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            this.stoBinClean.DataSource = ds.Tables[0];
            this.stoBinClean.DataBind();

        }

        [DirectMethod]
        public void UP_SetDataBinding(string sSDATE, string sEDATE, string sBIN, string sGubn)
        {
            if (sGubn == "P")
            {
                sSDATE = "19900101";
                sEDATE = "20301231";
            }
            this.UP_DataBinding(sSDATE, sEDATE, sBIN, sGubn);
        }
        #endregion

        #region Description : BIN번호 조회
        protected object GetBINNOData(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2NEZ710", "2", sDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion   

        #region Description : 검색 버튼
        protected void btnFind_Click(object sender, DirectEventArgs e)
        {
            string sSDATE = string.Format("{0:yyyyMMdd}", dtpSDATE.Value);
            string sEDATE = string.Format("{0:yyyyMMdd}", dtpEDATE.Value);

            if (this.cboSearch.SelectedItem.Value.ToString() != "P")
            {
                if (sSDATE.Trim() == "00010101")
                {
                    X.MessageBox.Alert("확인", "시작일자를 입력하세요!", "SetTextFocus(1)").Show();
                    return;
                }

                if (sEDATE.Trim() == "00010101")
                {
                    X.MessageBox.Alert("확인", "종료일자를 입력하세요!", "SetTextFocus(2)").Show();
                    return;
                }

                if (Convert.ToInt32(sSDATE.Trim()) > Convert.ToInt32(sEDATE.Trim()))
                {
                    X.MessageBox.Alert("확인", "시작일자는 종료일자보다 이전이어야 합니다!", "SetTextFocus(1)").Show();
                    return;
                }
            }

            this.UP_DataBinding(sSDATE, sEDATE, txtBIN.Text.Trim(), this.cboSearch.SelectedItem.Value.ToString());
        }
        #endregion

        #region Description : UP_BinCleanArrayValue 함수 (저장)
        [DirectMethod]
        public void UP_BinCleanArrayValue(string sArrayValue, string SDATE, string EDATE, string BIN, string GUBN)
        {
            string sCLDATE = string.Empty;
            string sCLSEQ = string.Empty;
            string sCLBINNO = string.Empty;
            string sCLSSUTIME = string.Empty;
            string sCLESUTIME = string.Empty;
            string sCLBIGO = string.Empty;
            string sCLSTATUS = string.Empty;
            string sNowDate = string.Empty;

            string[] datas;
            string[] checkDatas = sArrayValue.Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            sNowDate = System.DateTime.Now.ToString("yyyyMMdd");

            this.DbConnector.CommandClear();
            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[0].ToString() != "" && datas[1].ToString() != "" && datas[2].ToString() != "")
                {
                    sCLDATE = datas[0].ToString().Replace("-", "");
                    sCLSEQ = datas[1].ToString().Replace("-", "");
                    sCLBINNO = datas[2].ToString();
                    sCLSSUTIME = datas[3].ToString().Replace(":", "");
                    sCLESUTIME = datas[4].ToString().Replace(":", "");
                    sCLBIGO = datas[5].ToString();
                    sCLSTATUS = datas[6].ToString();

                    if (sCLSTATUS == "N")
                    {
                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B2JDN678", Get_Date(sCLDATE.ToString()));
                        string sSeq = this.DbConnector.ExecuteScalar().ToString();
                        sCLSEQ = sSeq;
                    }

                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B2IJN668", sCLDATE,
                                                                sCLSEQ,
                                                                sCLSSUTIME,
                                                                sCLESUTIME,
                                                                sCLBIGO,
                                                                PSUserInfo.EmpNo,
                                                                sCLDATE,
                                                                sCLSEQ,
                                                                sCLBINNO,
                                                                sCLSSUTIME,
                                                                sCLESUTIME,
                                                                sCLBIGO,
                                                                PSUserInfo.EmpNo
                                                                );
                    //시작 
                    if (sCLSSUTIME != "" && sCLESUTIME == "")
                    {
                        this.DbConnector.Attach("TG_P_GS_B2IJS669", "2", PSUserInfo.EmpNo, sNowDate, sCLBINNO);
                    }
                    else if (sCLSSUTIME != "" && sCLESUTIME != "")
                    {
                        this.DbConnector.Attach("TG_P_GS_B2IJS669", "0", PSUserInfo.EmpNo, sNowDate, sCLBINNO);

                        //bin 상태관리 table에 bin출입일 넣기
                        this.DbConnector.Attach("TG_P_GS_B2IJT670", sCLDATE, PSUserInfo.EmpNo, sNowDate, sCLBINNO);
                    }
                    else
                    {
                        this.DbConnector.Attach("TG_P_GS_B2IJS669", "1", PSUserInfo.EmpNo, sNowDate, sCLBINNO);
                    }
                    this.DbConnector.ExecuteTranQueryList();
                }
            }
            

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();

            this.UP_DataBinding(SDATE, EDATE, BIN, GUBN);

            X.Js.Call("SetOpenerCall");

        }
        #endregion

        #region Description : UP_SetBinMoveArrayValue 함수 (삭제)
        [DirectMethod]
        public void UP_SetBinCleanArrayDelValue(string sArrayValue, string SDATE, string EDATE, string BIN, string GUBN)
        {
            string sCLDATE = string.Empty;
            string sCLSEQ = string.Empty;
            string sCLBINNO = string.Empty;
            string sNowDate = string.Empty;

            string[] datas;
            string[] checkDatas = sArrayValue.Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            sNowDate = System.DateTime.Now.ToString("yyyyMMdd");

            this.DbConnector.CommandClear();
            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[0].ToString() != "" && datas[1].ToString() != "")
                {
                    sCLDATE = datas[0].ToString().Replace("-", "");
                    sCLSEQ = datas[1].ToString();
                    sCLBINNO = datas[2].ToString();

                    this.DbConnector.Attach("TG_P_GS_B2IKC671", Get_Date(sCLDATE.ToString()), sCLSEQ, sCLBINNO);

                    this.DbConnector.Attach("TG_P_GS_B2IJS669", "0", PSUserInfo.EmpNo, sNowDate, sCLBINNO);
                }
            }
            if (this.DbConnector.CommandCount > 0)
            {
                this.DbConnector.ExecuteNonQueryList();
            }

            this.UP_DataBinding(SDATE, EDATE, BIN, GUBN);

            X.Js.Call("SetOpenerCall");

            X.MessageBox.Alert("확인", "삭제 되었습니다.").Show();
        }
        #endregion
    }
}