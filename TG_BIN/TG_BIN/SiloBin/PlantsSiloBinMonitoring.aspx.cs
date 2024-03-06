using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PSM.Common;
using Ext.Net;
using System.Data;

namespace TG_BIN.SiloBin
{
    public partial class PlantsSiloBinMonitoring : PageBase
    {
        private string fsHANGCHA = string.Empty;

        #region Description : 폼로드 이벤트
        public PlantsSiloBinMonitoring()
        {
            // 화면 로그인 권한 체크
            this.CheckLogin = true;
            this.CheckAuth = false;            
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                this.hidAuthGubn.SetValue("");
                this.hidAuthSABUN.SetValue("");
                this.hidMaxHangCha.SetValue("");
                this.hidMinHangCha.SetValue("");
                this.hidDisplayCheck.SetValue("chkALL");

                string sDate = string.Format("{0:yyyyMMdd}", DateTime.Today);

                stoPlantUnits.Data = GetUnitData("1", sDate);
                stoPlantUnits.DataBind();

                this.UP_ItemCodeList(sDate , "chkALL");
                this.UP_ItemSel(sDate);

                //특기사항
                stoBoardSpc.Data = GetBoardSpecialData();
                stoBoardSpc.DataBind();

                //입항하역계획
                stoShipLoad.Data = GetShipLoadData(sDate.Substring(0, 6));
                stoShipLoad.DataBind();

                //BIN 클리닝
                stoBinClean.Data = GetBinCleanData(sDate);
                stoBinClean.DataBind();

                //BIN 이고
                stoBinMove.Data = GetBinMoveData(sDate);
                stoBinMove.DataBind();

                //카길 이송
                stoBinCargill.Data = GetBinCargillData(sDate);
                stoBinCargill.DataBind();

                //bin 하역일지
                stoBinSHipDoc.Data = GetBinShipDocData("");
                stoBinSHipDoc.DataBind();

                //BIN하역일지 사용 곡종코드
                stoBinSHipDocGK.Data = GetBinShipDocGKData("");
                stoBinSHipDocGK.DataBind();

                //BIN SPACE
                stoBinSpaceInfos.Data = GetBoardSpaceData(sDate, "");
                stoBinSpaceInfos.DataBind();
                stoBinGKSpaceInfos.Data = GetBoardGKSpaceData(sDate, "");
                stoBinGKSpaceInfos.DataBind();

                //BIN 번호 조회(콤보박스) 
                stoBinNo.Data = GetBinNoCombo();
                stoBinNo.DataBind();

                //편집권한 체크
                string sAuthGubn = this.GetBinEditAuth();  // 오라클 테이블 생성
                
                X.Js.Call("setClientCall", sAuthGubn, PSUserInfo.EmpNo);
            }
        }
        #endregion

        #region Description : 내용 표시
        private void UP_ItemCodeList(string sDate, string sGroupCheck)
        {
            if (sGroupCheck == "chkALL")
            {
                sGroupCheck = "";
            }
            else if (sGroupCheck == "chkTYGT")
            {
                sGroupCheck = "T";
            }
            else if (sGroupCheck == "chkPTS")
            {
                sGroupCheck = "P";
            }
            else if (sGroupCheck == "chkGP1")
            {
                sGroupCheck = "1";
            }
            else if (sGroupCheck == "chkGP2")
            {
                sGroupCheck = "2";
            }
            else if (sGroupCheck == "chkGP3")
            {
                sGroupCheck = "3";
            }
            else if (sGroupCheck == "chkCH")
            {
                sGroupCheck = "CH";
            }


            stoGokJong.Data = GetGokJongData(sDate, sGroupCheck);
            stoGokJong.DataBind();

            stoWonSan.Data = GetWonSanData(sDate, sGroupCheck);
            stoWonSan.DataBind();

            stoHANGCHA.Data = GetHANGCHAData(sDate, sGroupCheck);
            stoHANGCHA.DataBind();
        }
        #endregion

        #region Description : 표시선택 항목 표시
        private void UP_ItemSel(string sDate)
        {
            stoITEMSEL.Data = GetItemData();
            stoITEMSEL.DataBind();
        }
        #endregion

        #region Description : 일정시간후 설비정보 읽어오기
        protected void UpdateMonitoringData(object sender, DirectEventArgs e)
        {
            string sDate = string.Format("{0:yyyyMMdd}", DateTime.Today);

            this.UP_ItemCodeList(sDate, hidDisplayCheck.Value.ToString());

            stoPlantUnits.Data = GetUnitData("2", sDate);
            stoPlantUnits.DataBind();
        }

        [DirectMethod]
        public void UpdateMonitoringData(string sGroupCheck)
        {
            string sDate = string.Format("{0:yyyyMMdd}", DateTime.Today);

            this.UP_ItemCodeList(sDate, sGroupCheck);

            stoPlantUnits.Data = GetUnitData("2", sDate);
            stoPlantUnits.DataBind();
        }
        #endregion

        #region Descriptinon : 회사구분 선택 후 곡종, 원산지, 항차 리스트 다시조회
        [DirectMethod]
        public void UpdateItemCodeList(string sGroupCheck)
        {
            string sDate = string.Format("{0:yyyyMMdd}", DateTime.Today);
            this.UP_ItemCodeList(sDate, sGroupCheck);
        }
        #endregion

        #region Description : 모니터링 설비 기초데이터 가져오기
        protected object GetUnitData(string sLoadGubn, string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            //this.DbConnector.Attach("TG_P_GS_B2OFB721", sLoadGubn, sDate);
            this.DbConnector.Attach("TG_P_GS_C33DU121", sLoadGubn, sDate);
            //this.DbConnector.Attach("TG_P_GS_D3VD0835", sLoadGubn, sDate);   // 테스트 용

            ds = this.DbConnector.ExecuteDataSet();
            return ds.Tables[0];
        }
        #endregion

        #region Description : 곡종 조회
        protected object GetGokJongData(string sDate, string sGroupCheck)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            if (sGroupCheck == "" || sGroupCheck == "T" || sGroupCheck == "P")
            {
                this.DbConnector.Attach("TG_P_GS_B3NH2029", sDate, sGroupCheck);
            }
            else if (sGroupCheck == "CH")
            {
                this.DbConnector.Attach("TG_P_GS_C6EDL568", sDate);
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B3NHE030", sDate, sGroupCheck);
            }
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : 원산지 조회
        protected object GetWonSanData(string sDate, string sGroupCheck)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            if (sGroupCheck == "" || sGroupCheck == "T" || sGroupCheck == "P")
            {
                this.DbConnector.Attach("TG_P_GS_B3OB5037", sDate, sGroupCheck);
            }
            else if (sGroupCheck == "CH")
            {
                this.DbConnector.Attach("TG_P_GS_C6EDM569", sDate);
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B3OB2036", sDate, sGroupCheck);
            }
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : 항차 조회
        protected object GetHANGCHAData(string sDate, string sGroupCheck)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            if (sGroupCheck == "" || sGroupCheck == "T" || sGroupCheck == "P")
            {
                this.DbConnector.Attach("TG_P_GS_B3OBG038", sDate, sGroupCheck);
            }
            else if (sGroupCheck == "CH")
            {
                this.DbConnector.Attach("TG_P_GS_C6EDN570", sDate);
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B3OBH039", sDate, sGroupCheck);
            }
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : 내용선택 기본 설정
        protected object GetItemData()
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2PI2739");
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : BIN 번호(콤보박스)
        protected object GetBinNoCombo()
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B34HJ813");
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : 특기사항
        protected object GetBoardSpecialData()
        {
            string Date = string.Format("{0:yyyyMMdd}", DateTime.Today);

            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B33EM789", Date);
            ds = this.DbConnector.ExecuteDataSet();

            return UP_DataTableChange(ds.Tables[0]);
        }

        [DirectMethod]
        public void UP_GetBoardData(string sBoardDate)
        {

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B33EM789", Get_Date(sBoardDate));
            stoBoardSpc.Data = UP_DataTableChange(this.DbConnector.ExecuteDataTable());
            stoBoardSpc.DataBind();

        }

        // 데이터셋 변환
        private DataTable UP_DataTableChange(DataTable dt)
        {
            DataTable rtnDt = new DataTable();
            DataRow row;

            rtnDt.Columns.Add("ROWNUM", typeof(System.String));
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

                row["ROWNUM"] = dt.Rows[i]["ROWNUM"].ToString();
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

        #region Description : 입항/하역계획 조회
        protected object GetShipLoadData(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BGW899", sDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }

        [DirectMethod]
        public void UP_GetShipLoadData(string sBoardDate)
        {
            sBoardDate = sBoardDate.Substring(0, 6);

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BGW899", sBoardDate);
            stoShipLoad.Data = this.DbConnector.ExecuteDataTable();
            stoShipLoad.DataBind();
        }
        #endregion



        #region Description : BIN 클리닝 조회
        protected object GetBinCleanData(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B34JV817", sDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }

        [DirectMethod]
        public void UP_GetBinCleanData(string sBoardDate)
        {

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B34JV817", sBoardDate);
            stoBinClean.Data = this.DbConnector.ExecuteDataTable();
            stoBinClean.DataBind();
        }
        #endregion

        #region Description : BIN SPACE 조회
        protected object GetBoardSpaceData(string sBoardDate, string sGROUP)
        {
            DataTable dt = null;
            this.DbConnector.CommandClear();
            //this.DbConnector.Attach("TG_P_GS_B33JP800", sBoardDate);
            this.DbConnector.Attach("TG_P_GS_B42DA103", sBoardDate, sGROUP);
            
            dt = this.DbConnector.ExecuteDataTable();

            return dt;
        }
        #endregion

        #region Description : BIN 곡종 SPACE 조회
        protected object GetBoardGKSpaceData(string sBoardDate, string sGROUP)
        {
            DataTable dt = null;
            this.DbConnector.CommandClear();
            //this.DbConnector.Attach("TG_P_GS_B33JT801", sBoardDate);
            this.DbConnector.Attach("TG_P_GS_B42DD104", sBoardDate, sGROUP);
            dt = this.DbConnector.ExecuteDataTable();

            return dt;
        }

        [DirectMethod]
        public void UP_GetBoardSpaceData(string sBoardDate, string sGROUP)
        {
            this.DbConnector.CommandClear();
            //this.DbConnector.Attach("TG_P_GS_B33JP800", sBoardDate);
            this.DbConnector.Attach("TG_P_GS_B42DA103", sBoardDate, sGROUP);
            stoBinSpaceInfos.Data = this.DbConnector.ExecuteDataTable();
            stoBinSpaceInfos.DataBind();

            this.DbConnector.CommandClear();
            //this.DbConnector.Attach("TG_P_GS_B33JT801", sBoardDate);
            this.DbConnector.Attach("TG_P_GS_B42DD104", sBoardDate, sGROUP);
            stoBinGKSpaceInfos.Data = this.DbConnector.ExecuteDataTable();
            stoBinGKSpaceInfos.DataBind();
        }
        #endregion

        #region Description : BIN 이고 조회
        protected object GetBinMoveData(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B33L0802", sDate, sDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }

        [DirectMethod]
        public void UP_GetBinMoveData(string sBoardDate)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B33L0802", sBoardDate, sBoardDate);
            stoBinMove.Data = this.DbConnector.ExecuteDataTable();
            stoBinMove.DataBind();
        }
        #endregion

        #region Description : 카길이송 조회
        protected object GetBinCargillData(string sDate)
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B46EU136", sDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }

        [DirectMethod]
        public void UP_GetBinCargillData(string sBoardDate)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B46EU136", sBoardDate);
            stoBinCargill.Data = this.DbConnector.ExecuteDataTable();
            stoBinCargill.DataBind();
        }
        #endregion

        #region Description : BIN 하역작업일지 조회
        protected object GetBinShipDocData(string sSCORPGUBN)
        {
            string sCORPGUBN = string.Empty;
            string sHANGCHA = string.Empty;
            string sGOKJONG = string.Empty;
            DataSet ds = null;

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3CDJ935", sSCORPGUBN);
            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                sCORPGUBN = ds.Tables[0].Rows[0]["DCORPGUBN"].ToString();
                sHANGCHA = ds.Tables[0].Rows[0]["MAXHANGHCA"].ToString();
                fsHANGCHA = ds.Tables[0].Rows[0]["MAXHANGHCA"].ToString();
                sGOKJONG = ds.Tables[0].Rows[0]["DGOKJONG"].ToString();
            }

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3CEH937", sCORPGUBN, sHANGCHA, sGOKJONG);
            ds = this.DbConnector.ExecuteDataSet();

            this.hidMaxHangCha.SetValue(ds.Tables[0].Rows[0]["MAXDHANGCHA"].ToString());
            this.hidMinHangCha.SetValue(ds.Tables[0].Rows[0]["MINDHANGCHA"].ToString());

            this.hidLoadMaxHangCha.SetValue(ds.Tables[0].Rows[0]["MAXDHANGCHA"].ToString());
            this.hidLoadMinHangCha.SetValue(ds.Tables[0].Rows[0]["MINDHANGCHA"].ToString());

            return ds.Tables[0];
        }

        #region Description : 항차선택 이벤트
        [DirectMethod]
        public void UP_GetShipDocData(string sCorpGubn)
        {
            //bin 하역일지
            stoBinSHipDoc.RemoveAll();
            stoBinSHipDoc.Data = GetBinShipDocData(sCorpGubn);
            stoBinSHipDoc.DataBind();

            //BIN하역일지 사용 곡종코드
            stoBinSHipDocGK.RemoveAll();
            stoBinSHipDocGK.Data = GetBinShipDocGKData(sCorpGubn);
            stoBinSHipDocGK.DataBind();

            X.Js.Call("setDocHangCha", fsHANGCHA);
        }
        #endregion

        [DirectMethod]
        public void UP_GetBinShipDocData(string sCorpGubn ,string sHangCha, string sGokJong)
        {
            DataTable dt = null;

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3CEH937", sCorpGubn, sHangCha, sGokJong);
            dt = this.DbConnector.ExecuteDataTable();
            if (dt.Rows.Count > 0)
            {
                this.hidMaxHangCha.SetValue(dt.Rows[0]["MAXDHANGCHA"].ToString());
                this.hidMinHangCha.SetValue(dt.Rows[0]["MINDHANGCHA"].ToString());

                this.hidLoadMaxHangCha.SetValue(dt.Rows[0]["MAXDHANGCHA"].ToString());
                this.hidLoadMinHangCha.SetValue(dt.Rows[0]["MINDHANGCHA"].ToString());

                stoBinSHipDoc.Data = dt;
                stoBinSHipDoc.DataBind();
            }
        }
        #endregion

        #region Description : BIN 하역작업일지 사용 곡종코드 조회
        protected object GetBinShipDocGKData(string sSCORPGUBN)
        {
            string sCORPGUBN = string.Empty;
            string sHANGCHA = string.Empty;
            
            DataSet ds = null;

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3CDJ935", sSCORPGUBN);
            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                sCORPGUBN = ds.Tables[0].Rows[0]["DCORPGUBN"].ToString();
                sHANGCHA = ds.Tables[0].Rows[0]["MAXHANGHCA"].ToString();
            }
            
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3CEN938", sCORPGUBN, sHANGCHA);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }

        [DirectMethod]
        public void UP_GetBinShipDocGKData(string sCorpGubn, string sHangCha)
        {
            stoBinSHipDocGK.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3CEN938", sCorpGubn, sHangCha);
            stoBinSHipDocGK.Data = this.DbConnector.ExecuteDataTable();
            stoBinSHipDocGK.DataBind();

            X.Js.Call("SetShipDocList");
        }
        #endregion

        #region Description : BIN 상세정보 차트 조회
        [DirectMethod]
        public void UP_GetBinRateChart(string sBINNO)
        {
            string sNowDate = System.DateTime.Now.ToString("yyyyMMdd");

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B34GH812", sNowDate, sBINNO);

            stoBinChart.Data = this.DbConnector.ExecuteDataTable();
            stoBinChart.DataBind();
        }
        #endregion

        #region Description : BIN 작업현황 상세정보 조회
        [DirectMethod]
        public void UP_GetBinStatusInfoData(string BINNO, string BINSTATUSCODE, string BTCHULIL, string BTTKNO, string BCCORPGUBN)
        {
            string sBinno = BINNO;
            string sNowDate = System.DateTime.Now.ToString("yyyyMMdd");

            stoBinStatusMoveInfos.RemoveAll();
            stoBinStatusCleanInfos.RemoveAll();
            stoBinStatusDOCLOADInfos.RemoveAll();
            stoBinStatusCHULInfos.RemoveAll();

            //이고                
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B34IT814", sNowDate, sNowDate, sBinno, sBinno);
            stoBinStatusMoveInfos.Data = this.DbConnector.ExecuteDataTable();
            stoBinStatusMoveInfos.DataBind();

            // 이송
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B47H0162", sNowDate, sBinno);
            stoBinStatusCargillInfos.Data = this.DbConnector.ExecuteDataTable();
            stoBinStatusCargillInfos.DataBind();

            //빈 클리닝
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3FDJ952", sNowDate, sBinno);
            stoBinStatusCleanInfos.Data = this.DbConnector.ExecuteDataTable();
            stoBinStatusCleanInfos.DataBind();

            //하역중
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3FD4951", sBinno);
            stoBinStatusDOCLOADInfos.Data = this.DbConnector.ExecuteDataTable();
            stoBinStatusDOCLOADInfos.DataBind();

            //출고중
            if (BTCHULIL != "")
            {
                this.DbConnector.CommandClear();

                if (BCCORPGUBN == "T")
                {
                    this.DbConnector.Attach("TG_P_GS_B34J0815", BTCHULIL, BTTKNO);
                }
                else
                {
                    this.DbConnector.Attach("TG_P_GS_B34J1816", BTCHULIL, BTTKNO);
                }
                stoBinStatusCHULInfos.Data = this.DbConnector.ExecuteDataTable();
                stoBinStatusCHULInfos.DataBind();
            }

            X.Js.Call("setBinStatusInfoPopList", sBinno);

        }
        #endregion

        #region Description : BIN 관리편집 권한 정보 조회
        private string GetBinEditAuth()
        {
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BFM894", "TGB3BFF893", PSUserInfo.EmpNo);
            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                return "Y";
            }
            else
            {
                return "N";
            }
        }
        #endregion

        #region Description : BIN 클리닝 작업
        [DirectMethod]
        public void UP_SetBinCleanDataProcess(string BINNO, string TIMEGUBN, string sDATE, string sSEQ, string sGroupCheck)
        {
            string sProCedureid = string.Empty;
            string sMessage = string.Empty;

            if (TIMEGUBN == "START")
            {
                sProCedureid = "TG_P_GS_B34KB818";
                sMessage = "BIN 클리닝 작업이 시작되었습니다.";
            }
            else if (TIMEGUBN == "END")
            {
                sProCedureid = "TG_P_GS_B34KB819";
                sMessage = "BIN 클리닝 작업이 종료되었습니다.";
            }
            else
            {
                sProCedureid = "TG_P_GS_B34KC820";
                sMessage = "BIN 클리닝 작업이 재시작되었습니다.";
            }

            this.DbConnector.CommandClear();
            this.DbConnector.Attach(sProCedureid, sDATE, sSEQ, BINNO);
            if (TIMEGUBN == "END")
            {
                // 클리닝 작업 종료
                this.DbConnector.Attach("TG_P_GS_B2IJS669", "0", PSUserInfo.EmpNo, sDATE, BINNO);

                //bin 상태관리 table에 bin출입일 넣기
                this.DbConnector.Attach("TG_P_GS_B2IJT670", sDATE, PSUserInfo.EmpNo, sDATE, BINNO);
            }
            else
            {
                // 클리닝 작업 (재)시작
                this.DbConnector.Attach("TG_P_GS_B2IJS669", "2", PSUserInfo.EmpNo, sDATE, BINNO);
            }
            this.DbConnector.ExecuteTranQueryList();

            X.MessageBox.Alert("확인", sMessage).Show();

            this.UP_GetBinCleanData(sDATE);

            this.UpdateMonitoringData(sGroupCheck);
        }
        #endregion

        #region Description : 특기사항 작업
        [DirectMethod]
        public void UP_SetBinSPECIALWorkPreCess(string SPDATE, string SPSEQ, string sBoardDate)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B33EP790", "Y", PSUserInfo.EmpNo, SPDATE, SPSEQ);
            this.DbConnector.ExecuteTranQuery();

            X.MessageBox.Alert("확인", "특기사항 게시가 종료되었습니다").Show();

            this.UP_GetBoardData(sBoardDate);
        }
        #endregion

        #region Description : BIN 이고 작업
        [DirectMethod]
        public void UP_SetBinMoveDataProcess(string MDATE, string MSEQ, string MGOKJONG, string MMVBINNO,
                                             string MIPBINNO, string MMOVEQTY, string TIMEGUBN, string sBoardDate, string sGroupCheck)
        {
            //출고빈, 이고빈 곡종 비교
            string sMMVBINNOGK = string.Empty;
            string sMIPBINNOGK = string.Empty;
            string sMMVBINNOGKNM = string.Empty;
            string sMIPBINNOGKNM = string.Empty;

            //작업전 화면 불일치로 한번더 체크한다.
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HHG632", MDATE, MSEQ);
            DataTable dc = this.DbConnector.ExecuteDataTable();
            if (dc.Rows.Count > 0)
            {
                if (TIMEGUBN == "START")
                {
                    if (dc.Rows[0]["MMSDATE"].ToString() != "" && dc.Rows[0]["MSTIME"].ToString() != "")
                    {
                        X.MessageBox.Alert("확인", "BIN 이고작업이 이미 시작되었습니다 !").Show();
                        return;
                    }
                }
                else
                {
                    if (dc.Rows[0]["MMEDATE"].ToString() != "" && dc.Rows[0]["METIME"].ToString() != "")
                    {
                        X.MessageBox.Alert("확인", "BIN 이고작업이 이미 종료되었습니다!").Show();
                        return;
                    }
                }
            }
            else
            {
                X.MessageBox.Alert("확인", "BIN 이고작업 자료가 존재하지않습니다!").Show();
                return;
            }

            //곡종 체크
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HHE631", "2", sBoardDate);
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


            this.DbConnector.CommandClear();
            if (TIMEGUBN == "START")
            {
                this.DbConnector.Attach("TG_P_GS_B2HHG633", "", "", MDATE.Trim(), MSEQ);
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B2HHJ636", MMOVEQTY, MDATE.Trim(), MSEQ);
                this.DbConnector.ExecuteNonQuery();
                //이고 종료일자 가져오기
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B2HHG632", MDATE, MSEQ);
                dc = this.DbConnector.ExecuteDataTable();
                string sMMEDATE = dc.Rows[0]["MMEDATE"].ToString().Replace(".", "");

                this.DbConnector.CommandClear();
                //이고입고량 
                this.DbConnector.Attach("TG_P_GS_B2HHI634", Get_Date(sMMEDATE.ToString()), MIPBINNO);
                //이고출고량
                this.DbConnector.Attach("TG_P_GS_B2HHJ635", Get_Date(sMMEDATE.ToString()), MMVBINNO);

                //BIN입고파일 그레인터미널, 평택싸이로
                this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), MIPBINNO);
                this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), MMVBINNO);
                this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), MIPBINNO);
                this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sMMEDATE.ToString()), MMVBINNO);

            }
            this.DbConnector.ExecuteNonQueryList();

            if (TIMEGUBN == "START")
            {
                X.MessageBox.Alert("확인", "BIN 이고작업이 시작되었습니다!").Show();
            }
            else
            {
                X.MessageBox.Alert("확인", "BIN 이고작업이 종료되었습니다!").Show();
            }

            this.UP_GetBinMoveData(sBoardDate);

            this.UpdateMonitoringData(sGroupCheck);
        }
        #endregion

        #region Description : BIN 이송 작업
        [DirectMethod]
        public void UP_SetBinCargillDataProcess(string TDATE, string TSEQ, string TGOKJONG, string TBINNO,
                                                string TTRANSQTY, string TIMEGUBN, string sBoardDate, string sGroupCheck)
        {
            //출고빈, 이고빈 곡종 비교
            string sTBINNOGK = string.Empty;
            string sTBINNOGKNM = string.Empty;

            //작업전 화면 불일치로 한번더 체크한다.
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B46FS137", TDATE, TSEQ);
            DataTable dc = this.DbConnector.ExecuteDataTable();
            if (dc.Rows.Count > 0)
            {
                if (TIMEGUBN == "START")
                {
                    if (dc.Rows[0]["TSDATE"].ToString() != "" && dc.Rows[0]["TSTIME"].ToString() != "")
                    {
                        X.MessageBox.Alert("확인", "BIN 이송작업이 이미 시작되었습니다 !").Show();
                        return;
                    }
                }
                else
                {
                    if (dc.Rows[0]["TEDATE"].ToString() != "" && dc.Rows[0]["TETIME"].ToString() != "")
                    {
                        X.MessageBox.Alert("확인", "BIN 이송작업이 이미 종료되었습니다!").Show();
                        return;
                    }
                }
            }
            else
            {
                X.MessageBox.Alert("확인", "BIN 이송작업 자료가 존재하지않습니다!").Show();
                return;
            }

            //곡종 체크
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HHE631", "2", sBoardDate);
            DataTable dt = this.DbConnector.ExecuteDataTable();
            if (dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Select("SBINNO = '" + TBINNO + "'"))
                {
                    sTBINNOGK = Convert.ToString(dr["SGOKJONG"]);
                    sTBINNOGKNM = Convert.ToString(dr["SGOKJONGNM"]);
                }

                if (TGOKJONG != sTBINNOGK)
                {
                    X.MessageBox.Alert("오류", "이송BIN:" + TBINNO + " 곡종:" + sTBINNOGKNM + " 선택하신 곡종이 다릅니다!").Show();
                    return;
                }
            }


            this.DbConnector.CommandClear();
            if (TIMEGUBN == "START")
            {
                this.DbConnector.Attach("TG_P_GS_B46GH140", "", "", TDATE.Trim(), TSEQ);
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B46GM141", TTRANSQTY, TDATE.Trim(), TSEQ);
                this.DbConnector.ExecuteNonQuery();
                //이고 종료일자 가져오기
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B46FS137", TDATE, TSEQ);
                dc = this.DbConnector.ExecuteDataTable();
                string sTEDATE = dc.Rows[0]["TEDATE"].ToString().Replace(".", "");

                this.DbConnector.CommandClear();
                //이송량 
                this.DbConnector.Attach("TG_P_GS_B46DL133", Get_Date(sTEDATE.ToString()), TBINNO, TGOKJONG);

                //BIN입고파일 그레인터미널, 평택싸이로
                this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(sTEDATE.ToString()), TBINNO);
                this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(sTEDATE.ToString()), TBINNO);

            }
            this.DbConnector.ExecuteNonQueryList();

            if (TIMEGUBN == "START")
            {
                X.MessageBox.Alert("확인", "BIN 이송작업이 시작되었습니다!").Show();
            }
            else
            {
                X.MessageBox.Alert("확인", "BIN 이송작업이 종료되었습니다!").Show();
            }

            this.UP_GetBinCargillData(sBoardDate);

            this.UpdateMonitoringData(sGroupCheck);
        }
        #endregion

        #region Description : BIN 하역작업일지 시작,종료 이벤트 함수
        [DirectMethod]
        public void UP_SetBinDCBoardDataProcess(string DCORPGUBN, string DHANGCHA, string DGOKJONG, string DLOADCODE,
                                                string DWKDATE, string DSEQ, string DLOADQTY, string DSUMQTY,
                                                string N_DCORPGUBN, string N_DHANGCHA, string N_DGOKJONG, string N_DLOADCODE,
                                                string N_DWKDATE, string N_DSEQ, string N_DLOADQTY, string N_DSUMQTY, string TIMEGUBN, string sGroupCheck)
        {
            //작업전 화면 불일치로 한번더 체크한다.
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BMC914", DCORPGUBN, DHANGCHA, DGOKJONG, DLOADCODE, DWKDATE, DSEQ);
            DataTable dt = this.DbConnector.ExecuteDataTable();
            if (dt.Rows.Count > 0)
            {
                if (TIMEGUBN == "START")
                {
                    if (dt.Rows[0]["DLSDATE"].ToString() != "" && dt.Rows[0]["DLSTIME"].ToString() != "")
                    {
                        X.MessageBox.Alert("확인", "BIN 하역작업일지가 이미 시작되었습니다 !").Show();
                        return;
                    }
                }
                else
                {
                    if (dt.Rows[0]["DLEDATE"].ToString() != "" && dt.Rows[0]["DLETIME"].ToString() != "")
                    {
                        X.MessageBox.Alert("확인", "BIN 하역작업일지가 이미 종료되었습니다!").Show();
                        return;
                    }
                }
            }
            else
            {
                X.MessageBox.Alert("확인", "BIN 하역작업일지 자료가 존재하지않습니다!").Show();
                return;
            }

            this.DbConnector.CommandClear();
            if (TIMEGUBN == "START")
            {
                //하역작업일지 마스타 시작 저장 
                this.DbConnector.Attach("TG_P_GS_B3CI2947", PSUserInfo.EmpNo, DCORPGUBN, DHANGCHA, DGOKJONG, DLOADCODE, DWKDATE, DSEQ);
            }
            else
            {
                //하역작업일지 마스타  종료 저장 
                this.DbConnector.Attach("TG_P_GS_B3CIA948", DLOADQTY, DSUMQTY, PSUserInfo.EmpNo, DCORPGUBN, DHANGCHA, DGOKJONG, DLOADCODE, DWKDATE, DSEQ);
            }
            this.DbConnector.ExecuteTranQuery();

            if (TIMEGUBN == "START")
            {
                X.MessageBox.Alert("확인", "BIN 하역작업이 시작되었습니다!").Show();
            }
            else
            {
                if (TIMEGUBN == "ENDSTART") //종료 후 다음 작업 연속 시작
                {
                    // 이미 시작 된자료 인지 체크
                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B3BMC914", N_DCORPGUBN, N_DHANGCHA, N_DGOKJONG, N_DLOADCODE, N_DWKDATE, N_DSEQ);
                    dt = this.DbConnector.ExecuteDataTable();
                    if (dt.Rows.Count > 0)
                    {
                        if (dt.Rows[0]["DSLSDATE"].ToString() != "" && dt.Rows[0]["DSLSTIME"].ToString() != "")
                        {
                            X.MessageBox.Alert("확인", "BIN 하역작업일지 다음작업이 이미 시작되었습니다 !").Show();
                            return;
                        }
                    }
                    else
                    {
                        X.MessageBox.Alert("확인", "BIN 하역작업일지 다음작업 자료가 존재하지않습니다!").Show();
                        return;
                    }

                    //하역작업일지 DETAIL 저장 
                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B3CI2947", PSUserInfo.EmpNo, N_DCORPGUBN, N_DHANGCHA, N_DGOKJONG, N_DLOADCODE, N_DWKDATE, N_DSEQ);
                    this.DbConnector.ExecuteTranQuery();

                    X.MessageBox.Alert("확인", "BIN 하역작업이 종료 후 시작되었습니다!").Show();
                }
                else
                {
                    X.MessageBox.Alert("확인", "BIN 하역작업이 종료되었습니다!").Show();
                }
            }

            this.UP_GetBinShipDocData(DCORPGUBN, DHANGCHA, DGOKJONG);

            this.UpdateMonitoringData(sGroupCheck);
        }
        #endregion
    }
}