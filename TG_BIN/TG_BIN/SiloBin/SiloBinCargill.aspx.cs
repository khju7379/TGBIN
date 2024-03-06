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
    public partial class SiloBinCargill : PageBase
    {
        public SiloBinCargill()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                string sDate = string.Format("{0:yyyyMMdd}", DateTime.Today);

                string sSDATE = "19900101";
                string sEDATE = "20301231";

                this.UP_DataBinding(sSDATE, sEDATE, "", "P");

                //곡종코드
                stoGOKJONG.Data = GetGokJongData(sDate);
                stoGOKJONG.DataBind();

                //BIN번호
                stoBINNO.Data = GetBINNOData(sDate);
                stoBINNO.DataBind();
            }
        }

        #region Description : UP_DataBinding 조회
        private void UP_DataBinding(string sSDATE, string sEDATE, string sBIN, string sGubn)
        {
            string sNowDate = System.DateTime.Now.ToString("yyyyMMdd");

            if (sGubn == "P")
            {
                sSDATE = "19900101";
                sEDATE = "20301231";
            }

            this.stoBinMove.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B45EV123", sNowDate,sGubn, sSDATE, sEDATE, sBIN);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                btnPrt.Hidden = false;
            }

            this.stoBinMove.DataSource = ds.Tables[0];
            this.stoBinMove.DataBind();

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

        #region Description : 곡종 조회
        protected object GetGokJongData(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HHC630", sDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : BIN번호 조회
        protected object GetBINNOData(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HHE631", "2", sDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : 검색 버튼
        protected void btnFind_Click(object sender, DirectEventArgs e)
        {
            string sSDATE = string.Format("{0:yyyyMMdd}", dtpSDATE.Value);
            string sEDATE = string.Format("{0:yyyyMMdd}", dtpEDATE.Value);
            string sBIN = txtBIN.Text.Trim();

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

            this.UP_DataBinding(sSDATE, sEDATE, sBIN, this.cboSearch.SelectedItem.Value.ToString());
        }
        #endregion

        #region Description : UP_SetBinMoveArrayValue 함수
        [DirectMethod]
        public void UP_SetBinMoveArrayValue(string sArrayValue, string SDATE, string EDATE, string BIN, string GUBN)
        {
            string sDate = string.Empty;
            string sTRSTATUS = string.Empty;
            string sTDATE = string.Empty;
            string sTSEQ = string.Empty;
            string sTGOKJONG = string.Empty;
            string sTBINNO = string.Empty;
            string sTSDATE = string.Empty;
            string sTSTIME = string.Empty;
            string sTEDATE = string.Empty;
            string sTETIME = string.Empty;
            string sTHSTIME = string.Empty;
            string sTTRANSQTY = string.Empty;
            string sTBIGO = string.Empty;

            //출고빈, 이고빈 곡종 비교
            string sTBINNOGK = string.Empty;
            string sTBINNOGKNM = string.Empty;

            //출고빈, 이고빈 작업상태 확인
            string sTBINNOSTAUS = string.Empty;

            string[] datas;
            string[] checkDatas = sArrayValue.Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            this.DbConnector.CommandClear();
            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[0].ToString() != "" && datas[1].ToString() != "")
                {
                    sTRSTATUS = datas[0].ToString();
                    sTDATE = datas[1].ToString().Replace("-", "");
                    sTSEQ = datas[2].ToString();
                    sTGOKJONG = datas[3].ToString();
                    sTBINNO = datas[4].ToString();
                    sTSDATE = datas[5].ToString().Replace("-", "");
                    sTSTIME = datas[6].ToString().Replace(":", "");
                    sTEDATE = datas[7].ToString().Replace("-", "");
                    sTETIME = datas[8].ToString().Replace(":", "");
                    sTHSTIME = datas[9].ToString().Replace(":", "");
                    sTTRANSQTY = datas[10].ToString();
                    sTBIGO = datas[11].ToString();

                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B2HHE631", "2", sTDATE);
                    DataTable dt = this.DbConnector.ExecuteDataTable();
                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dt.Select("SBINNO = '" + sTBINNO + "'"))
                        {
                            sTBINNOGK = Convert.ToString(dr["SGOKJONG"]);
                            sTBINNOGKNM = Convert.ToString(dr["SGOKJONGNM"]);
                            sTBINNOSTAUS = Convert.ToString(dr["SBINSTATUS"]);
                        }

                        if (sTGOKJONG != sTBINNOGK)
                        {
                            X.MessageBox.Alert("오류", "이송BIN:" + sTBINNO + " 곡종:" + sTBINNOGKNM + " 선택하신 곡종이 다릅니다!").Show();
                            return;
                        }

                        if (sTBINNOSTAUS != "0")
                        {
                            X.MessageBox.Alert("오류", "이송BIN:" + sTBINNO + " 이송 작업을 할 수 없는 BIN입니다!").Show();
                            return;
                        }
                    }
                    else
                    {
                        X.MessageBox.Alert("오류", "BIN 상태관리 자료가 없습니다! 해당일자로 이월후 작업하세요!").Show();
                        return;
                    }

                    sTHSTIME = "";
                    if (sTSDATE != "" && sTSTIME != "" && sTEDATE != "" && sTETIME != "")
                    {
                        sTHSTIME = get_time(sTSDATE, sTSTIME, sTEDATE, sTETIME);
                    }

                    if (sTRSTATUS == "N") //신규등록
                    {
                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B45F0128", Get_Date(sTDATE.ToString()));
                        string sSeq = this.DbConnector.ExecuteScalar().ToString();
                        sTSEQ = sSeq;

                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B45FK129", Get_Date(sTDATE.ToString()), sTSEQ, sTGOKJONG, sTBINNO, sTSDATE,
                                                                    sTSTIME, sTEDATE, sTETIME, sTHSTIME, sTTRANSQTY, sTBIGO, PSUserInfo.EmpNo);

                        //이송량 
                        this.DbConnector.Attach("TG_P_GS_B46DL133", Get_Date(sTEDATE.ToString()), sTBINNO, sTGOKJONG);
                        ////BIN입고파일 그레인터미널, 평택싸이로 
                        this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sTEDATE.ToString()), sTBINNO);
                        this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sTEDATE.ToString()), sTBINNO);

                        DbConnector.ExecuteNonQueryList();
                    }
                    else
                    {
                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B45FO130", sTGOKJONG, sTBINNO, sTSDATE, sTSTIME, sTEDATE, sTETIME, sTHSTIME, sTTRANSQTY,
                                                                    sTBIGO, PSUserInfo.EmpNo, Get_Date(sTDATE.ToString()), sTSEQ);

                        //이송량 
                        this.DbConnector.Attach("TG_P_GS_B46DL133", Get_Date(sTEDATE.ToString()), sTBINNO, sTGOKJONG);
                        ////BIN입고파일 그레인터미널, 평택싸이로 
                        this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sTEDATE.ToString()), sTBINNO);
                        this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sTEDATE.ToString()), sTBINNO);

                        DbConnector.ExecuteNonQueryList();
                    }

                }
            }

            this.UP_DataBinding(SDATE, EDATE, BIN, GUBN);

            X.Js.Call("SetOpenerCall");

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();
        }
        #endregion

        #region Description : UP_SetBinMoveArrayValue 함수
        [DirectMethod]
        public void UP_SetBinMoveArrayDelValue(string sArrayValue, string SDATE, string EDATE, string BIN, string GUBN)
        {
            string sDate = string.Empty;
            string sTDATE = string.Empty;
            string sTSEQ = string.Empty;
            string sTBINNO = string.Empty;
            string sTEDATE = string.Empty;
            string sTGOKJONG = string.Empty;

            string[] datas;
            string[] checkDatas = sArrayValue.Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            this.DbConnector.CommandClear();
            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[0].ToString() != "" && datas[1].ToString() != "")
                {
                    sTDATE = datas[0].ToString().Replace("-", "");
                    sTSEQ = datas[1].ToString();
                    sTBINNO = datas[2].ToString();
                    sTEDATE = datas[3].ToString();
                    sTGOKJONG = datas[4].ToString();

                    this.DbConnector.Attach("TG_P_GS_B46E9134", Get_Date(sTDATE.ToString()), sTSEQ);

                    //이송량 
                    this.DbConnector.Attach("TG_P_GS_B46DL133", Get_Date(sTDATE.ToString()), sTBINNO, sTGOKJONG);
                    ////BIN입고파일 그레인터미널, 평택싸이로
                    this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sTDATE.ToString()), sTBINNO);
                    this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sTDATE.ToString()), sTBINNO);

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

        #region Description : 시간 계산
        private string get_time(string SDATE, string STIME, string EDATE, string ETIME)
        {

            DateTime dtSdate = Convert.ToDateTime(SDATE.Substring(0, 4) + "-" + SDATE.Substring(4, 2) + "-" + SDATE.Substring(6, 2) + " 00:00:00");
            DateTime dtEdate = Convert.ToDateTime(EDATE.Substring(0, 4) + "-" + EDATE.Substring(4, 2) + "-" + EDATE.Substring(6, 2) + " 00:00:00");

            TimeSpan dateDiff = dtEdate - dtSdate;

            int diffDay = dateDiff.Days;

            ETIME = Set_Fill4((Convert.ToInt32(ETIME) + (diffDay * 2400)).ToString());

            string rntValue = string.Empty;
            string sTm1 = STIME.Substring(0, 2);
            string sTm2 = STIME.Substring(2, 2);
            string eTm1 = ETIME.Substring(0, 2);
            string eTm2 = ETIME.Substring(2, 2);
            int Time1 = 0;
            int Time2 = 0;
            int sTime = 0;
            int eTime = 0;
            int temp = 0;

            sTime = Convert.ToInt32(sTm1) * 60 + Convert.ToInt32(sTm2);
            eTime = Convert.ToInt32(eTm1) * 60 + Convert.ToInt32(eTm2);
            temp = eTime - sTime;
            Time1 = temp / 60;
            Time2 = temp % 60;

            rntValue = Set_Fill2(Time1.ToString()) + Set_Fill2(Time2.ToString());
            return rntValue;
        }
        #endregion
    }
}