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
    public partial class SiloBinMove : PageBase
    {
        public SiloBinMove()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                //hidCALLGUBN.Text = "";

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
            this.DbConnector.Attach("TG_P_GS_B2HHA629", sNowDate, sNowDate, sGubn, sSDATE, sEDATE, sBIN);
            DataSet ds = this.DbConnector.ExecuteDataSet();

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

        #region Description : UP_SetBinMoveDataProcess 서버 호출 함수
        [DirectMethod]
        public void UP_SetBinMoveDataProcess(string MDATE, string MSEQ, string MMVDATE, string MMVTIME, string MMOVEQTY, string sBin, string TIMEGUBN, string SDATE, string EDATE, string GUBN)
        {
            string sMessage = string.Empty;

            if (TIMEGUBN == "S")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HHG632", MDATE.Replace("/", "").ToString(), MSEQ);
                DataSet ds = this.DbConnector.ExecuteDataSet();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B2HHG633", MMVDATE, MMVTIME, MDATE.Replace("/", "").ToString(), MSEQ);
                    this.DbConnector.ExecuteTranQueryList();
                }
                sMessage = "BIN 이고작업이 시작되었습니다.";
            }
            else
            {
                //BIN 상태관리에 이고량 등록
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HHG632", MDATE.Replace("/", "").ToString(), MSEQ);
                DataSet ds = this.DbConnector.ExecuteDataSet();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    this.DbConnector.CommandClear();
                    //이고입고량 
                    this.DbConnector.Attach("TG_P_GS_B2HHI634", MMOVEQTY, MMOVEQTY, ds.Tables[0].Rows[0]["MIPBINNO"].ToString());
                    //이고출고량
                    this.DbConnector.Attach("TG_P_GS_B2HHJ635", MMOVEQTY, MMOVEQTY, ds.Tables[0].Rows[0]["MMVBINNO"].ToString());
                    //이고관리 이고량, 종료시간 저장
                    if (MMVDATE.Trim() == "" && MMVTIME.Trim() == "")
                    {
                        //시스템 시간 
                        this.DbConnector.Attach("TG_P_GS_B2HHJ636", MMOVEQTY, MDATE.Replace("/", "").ToString(), MSEQ);
                    }
                    else
                    {
                        //사용자 입력 시간
                        this.DbConnector.Attach("TG_P_GS_B2HHL637", MMVDATE, MMVTIME.Replace(":", ""), MMVDATE, MMVTIME.Replace(":", ""), MMOVEQTY, MDATE.Replace("/", "").ToString(), MSEQ);
                    }
                    this.DbConnector.ExecuteTranQueryList();
                }

                sMessage = "BIN 이고작업이 종료되었습니다.";
            }

            X.MessageBox.Alert("확인", sMessage).Show();
            this.UP_DataBinding(SDATE, EDATE, sBin, GUBN);
        }
        #endregion

        #region Description : UP_SetBinMoveDataSave 서버 호출 함수
        [DirectMethod]
        public void UP_SetBinMoveDataSave(string MDATE, string MSEQ, string MGOKJONG, string MMVBINNO, string MIPBINNO, string MMSDATE,
                                          string MSTIME, string MMEDATE, string METIME, string MHSTIME, string MMOVEQTY, string MSTCHECK1,
                                          string MSTCHECK2, string MSTCHECK3, string MBIGO, string TIMEGUBN, string SDATE, string EDATE, string BIN, string GUBN)
        {
            string sMessage = string.Empty;

            //출고빈, 이고빈 곡종 비교
            string sMMVBINNOGK = string.Empty;
            string sMIPBINNOGK = string.Empty;
            string sMMVBINNOGKNM = string.Empty;
            string sMIPBINNOGKNM = string.Empty;
            string sNowDate = System.DateTime.Now.ToString("yyyyMMdd");

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HHE631", "2", sNowDate);
            DataTable dt = this.DbConnector.ExecuteDataTable();
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Select("SBINNO = '" + MMVBINNO + "'"))
                {
                    sMMVBINNOGK = Convert.ToString(dr["SGOKJONG"]);
                    sMMVBINNOGKNM = Convert.ToString(dr["SGOKJONGNM"]);
                }
                foreach (DataRow dr in dt.Select("SBINNO = '" + MIPBINNO + "'"))
                {
                    sMIPBINNOGK = Convert.ToString(dr["SGOKJONG"]);
                    sMIPBINNOGKNM = Convert.ToString(dr["SGOKJONGNM"]);
                }
                if (sMMVBINNOGK != sMIPBINNOGK)
                {
                    X.MessageBox.Alert("오류", "출고BIN:" + MMVBINNO + " 곡종:" + sMMVBINNOGKNM + "<br>" + "입고BIN:" + MIPBINNO + " 곡종:" + sMIPBINNOGKNM + "<br>" + "서로 곡종이 다릅니다! 등록할수 없습니다.").Show();
                    return;
                }

                if (MGOKJONG != sMMVBINNOGK)
                {
                    X.MessageBox.Alert("오류", "출고BIN:" + MMVBINNO + " 곡종:" + sMMVBINNOGKNM + " 선택하신 곡종이 다릅니다!").Show();
                    return;
                }

                if (MGOKJONG != sMIPBINNOGK)
                {
                    X.MessageBox.Alert("오류", "입고BIN:" + MIPBINNO + " 곡종:" + sMIPBINNOGKNM + " 선택하신 곡종이 다릅니다!").Show();
                    return;
                }
            }


            //등록
            if (TIMEGUBN == "Add")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HHM639", Get_Date(MDATE.ToString()));
                string sSeq = this.DbConnector.ExecuteScalar().ToString();
                MSEQ = sSeq;

                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HIG642", Get_Date(MDATE.ToString()), MSEQ, MGOKJONG, MMVBINNO, MIPBINNO, MMSDATE,
                                                      MSTIME, MMEDATE, METIME, MHSTIME, MMOVEQTY, MSTCHECK1, MSTCHECK2, MSTCHECK3, MBIGO, PSUserInfo.EmpNo);
                this.DbConnector.ExecuteTranQuery();

                sMessage = "저장 되었습니다";
            }

            if (TIMEGUBN == "Edit")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HIE641", MGOKJONG, MMVBINNO, MIPBINNO, MBIGO, PSUserInfo.EmpNo, Get_Date(MDATE.ToString()), MSEQ);
                this.DbConnector.ExecuteTranQuery();

                sMessage = "저장 되었습니다";
            }

            if (TIMEGUBN == "Delete")
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HII644", Get_Date(MDATE.ToString()), MSEQ);
                this.DbConnector.ExecuteTranQuery();
                sMessage = "삭제 되었습니다";
            }

            this.UP_DataBinding(SDATE, EDATE, BIN, GUBN);

            X.MessageBox.Alert("확인", sMessage).Show();

        }
        #endregion

        #region Description : UP_SetBinMoveArrayValue 함수
        [DirectMethod]
        public void UP_SetBinMoveArrayValue(string sArrayValue, string SDATE, string EDATE, string BIN, string GUBN)
        {
            string sDate = string.Empty;
            string sMVSTATUS = string.Empty;
            string sMDATE = string.Empty;
            string sMSEQ = string.Empty;
            string sSGOKJONG1 = string.Empty;
            string sMMVBINNO = string.Empty;
            string sMIPBINNO = string.Empty;
            string sMMSDATE = string.Empty;
            string sMSTIME = string.Empty;
            string sMMEDATE = string.Empty;
            string sMETIME = string.Empty;
            string sMHSTIME = string.Empty;
            string sMMOVEQTY = string.Empty;
            string sMBIGO = string.Empty;

            //출고빈, 이고빈 곡종 비교
            string sMMVBINNOGK = string.Empty;
            string sMIPBINNOGK = string.Empty;
            string sMMVBINNOGKNM = string.Empty;
            string sMIPBINNOGKNM = string.Empty;

            //출고빈, 이고빈 작업상태 확인
            string sMMVBINNOSTAUS = string.Empty;
            string sMIPBINNOSTAUS = string.Empty;

            string[] datas;
            string[] checkDatas = sArrayValue.Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            this.DbConnector.CommandClear();
            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[0].ToString() != "" && datas[1].ToString() != "")
                {
                    sMVSTATUS = datas[0].ToString();
                    sMDATE = datas[1].ToString().Replace("-", "");
                    sMSEQ = datas[2].ToString();
                    sSGOKJONG1 = datas[3].ToString();
                    sMMVBINNO = datas[4].ToString();
                    sMIPBINNO = datas[5].ToString();
                    sMMSDATE = datas[6].ToString().Replace("-", "");
                    sMSTIME = datas[7].ToString().Replace(":", "");
                    sMMEDATE = datas[8].ToString().Replace("-", "");
                    sMETIME = datas[9].ToString().Replace(":", "");
                    sMHSTIME = datas[10].ToString().Replace(":", "");
                    sMMOVEQTY = datas[11].ToString();
                    sMBIGO = datas[12].ToString();

                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B2HHE631", "2", sMDATE);
                    DataTable dt = this.DbConnector.ExecuteDataTable();
                    if (dt.Rows.Count > 0)
                    {
                        foreach (DataRow dr in dt.Select("SBINNO = '" + sMMVBINNO + "'"))
                        {
                            sMMVBINNOGK = Convert.ToString(dr["SGOKJONG"]);
                            sMMVBINNOGKNM = Convert.ToString(dr["SGOKJONGNM"]);
                            sMMVBINNOSTAUS = Convert.ToString(dr["SBINSTATUS"]);
                        }
                        foreach (DataRow dr in dt.Select("SBINNO = '" + sMIPBINNO + "'"))
                        {
                            sMIPBINNOGK = Convert.ToString(dr["SGOKJONG"]);
                            sMIPBINNOGKNM = Convert.ToString(dr["SGOKJONGNM"]);
                            sMIPBINNOSTAUS = Convert.ToString(dr["SBINSTATUS"]);
                        }
                        if (sMMVBINNOGK != sMIPBINNOGK)
                        {
                            X.MessageBox.Alert("오류", "출고BIN:" + sMMVBINNO + " 곡종:" + sMMVBINNOGKNM + "<br>" + "입고BIN:" + sMIPBINNO + " 곡종:" + sMIPBINNOGKNM + "<br>" + "서로 곡종이 다릅니다! 등록할수 없습니다.").Show();
                            return;
                        }

                        if (sSGOKJONG1 != sMMVBINNOGK)
                        {
                            X.MessageBox.Alert("오류", "출고BIN:" + sMMVBINNO + " 곡종:" + sMMVBINNOGKNM + " 선택하신 곡종이 다릅니다!").Show();
                            return;
                        }

                        if (sSGOKJONG1 != sMIPBINNOGK)
                        {
                            X.MessageBox.Alert("오류", "입고BIN:" + sMIPBINNO + " 곡종:" + sMIPBINNOGKNM + " 선택하신 곡종이 다릅니다!").Show();
                            return;
                        }
                        if (sMMVBINNOSTAUS != "0")
                        {
                            X.MessageBox.Alert("오류", "출고BIN:" + sMMVBINNO + " 출고 작업을 할 수 없는 BIN입니다!").Show();
                            return;
                        }
                        if (sMIPBINNOSTAUS != "0")
                        {
                            X.MessageBox.Alert("오류", "입고BIN:" + sMIPBINNO + " 입고 작업을 할 수 없는 BIN입니다!").Show();
                            return;
                        }
                    }
                    else
                    {
                        X.MessageBox.Alert("오류", "BIN 상태관리 자료가 없습니다! 해당일자로 이월후 작업하세요!").Show();
                        return;
                    }

                    sMHSTIME = "";
                    if (sMMSDATE != "" && sMSTIME != "" && sMMEDATE != "" && sMETIME != "")
                    {
                        sMHSTIME = get_time(sMMSDATE, sMSTIME, sMMEDATE, sMETIME);
                    }

                    if (sMVSTATUS == "N") //신규등록
                    {
                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B2HHM639", Get_Date(sMDATE.ToString()));
                        string sSeq = this.DbConnector.ExecuteScalar().ToString();
                        sMSEQ = sSeq;

                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B2HIG642", Get_Date(sMDATE.ToString()), sMSEQ, sSGOKJONG1, sMMVBINNO, sMIPBINNO, sMMSDATE,
                                                              sMSTIME, sMMEDATE, sMETIME, sMHSTIME, sMMOVEQTY, "", "", "", sMBIGO, PSUserInfo.EmpNo);
                        
                        //이고입고량 
                        this.DbConnector.Attach("TG_P_GS_B2HHI634", Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                        //이고출고량
                        this.DbConnector.Attach("TG_P_GS_B2HHJ635", Get_Date(sMMEDATE.ToString()), sMMVBINNO);
                        //BIN입고파일 그레인터미널, 평택싸이로
                        this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                        this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMMVBINNO);
                        this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                        this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMMVBINNO);
                        DbConnector.ExecuteNonQueryList();
                    }
                    else
                    {
                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B3UE2086", sSGOKJONG1, sMMVBINNO, sMIPBINNO, sMMSDATE, sMSTIME, sMMEDATE, sMETIME, sMHSTIME, sMMOVEQTY,
                                                              sMBIGO, PSUserInfo.EmpNo, Get_Date(sMDATE.ToString()), sMSEQ);

                        
                        //이고입고량 
                        this.DbConnector.Attach("TG_P_GS_B2HHI634", Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                        //이고출고량
                        this.DbConnector.Attach("TG_P_GS_B2HHJ635", Get_Date(sMMEDATE.ToString()), sMMVBINNO);
                        //BIN입고파일 그레인터미널, 평택싸이로 
                        this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                        this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMMVBINNO);
                        this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                        this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMMVBINNO);
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
            string sMDATE = string.Empty;
            string sMSEQ = string.Empty;
            string sMIPBINNO = string.Empty;
            string sMMVBINNO = string.Empty;
            string sMMEDATE = string.Empty;

            string[] datas;
            string[] checkDatas = sArrayValue.Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            this.DbConnector.CommandClear();
            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[0].ToString() != "" && datas[1].ToString() != "")
                {
                    sMDATE = datas[0].ToString().Replace("-", "");
                    sMSEQ = datas[1].ToString();
                    sMMVBINNO = datas[2].ToString();
                    sMIPBINNO = datas[3].ToString();
                    sMMEDATE = datas[4].ToString();

                    this.DbConnector.Attach("TG_P_GS_B2HII644", Get_Date(sMDATE.ToString()), sMSEQ);

                    //이고입고량 
                    this.DbConnector.Attach("TG_P_GS_B2HHI634", Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                    //이고출고량
                    this.DbConnector.Attach("TG_P_GS_B2HHJ635", Get_Date(sMMEDATE.ToString()), sMMVBINNO);
                    //BIN입고파일 그레인터미널, 평택싸이로
                    this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                    this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMMVBINNO);
                    this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMIPBINNO);
                    this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), sMMVBINNO);

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