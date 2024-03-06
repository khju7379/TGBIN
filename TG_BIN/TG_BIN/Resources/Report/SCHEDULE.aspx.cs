using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PSM.Common;
using DataDynamics.ActiveReports;
using System.Data;

namespace TG_BIN.Resources.Report
{
    public partial class SCHEDULE : PageBase
    {
        public DataSet _ds = new DataSet();
        public string _sSANAME = string.Empty;
        public string _sTONAME = string.Empty;
        public SCHEDULE()
        {
            this.CheckAuth = false;
        }

        #region Description : 페이지 로드
        protected void Page_Load(object sender, EventArgs e)
        {
            string[] sData = this.Request.QueryString["val1"].Split(new string[] { "_" }, StringSplitOptions.RemoveEmptyEntries);

            DataTable dt = new DataTable();

            if (sData.Length == 4)
            {
                dt = UP_Bind_SCHEDULE(sData[0], sData[1], sData[2], sData[3]);
                UP_GetCombo(sData[0], sData[1], sData[2], sData[3]);
                byte[][] images = UP_GetImage(sData[0] + sData[1] + sData[2] + sData[3], _ds.Tables[0].Rows.Count,"06");
                byte[][] toolimages = UP_GetImage(sData[0] + sData[1] + sData[2] + sData[3], _ds.Tables[0].Rows.Count, "07");
                
                ActiveReport rpt = new TYPSM.Report.SCHEDULE_PRT(dt, _sSANAME, _sTONAME, images, toolimages);
                rpt.DataSource = _ds.Tables[0];
                this.arvMain.Report = rpt;
                rpt.Run();
            }
            else if (sData.Length == 10)
            {   
                dt = UP_Bind_SCHEDULEWK(sData[0], sData[1], sData[2], sData[3], sData[4], sData[5], sData[6], sData[7], sData[8], sData[9]);
                UP_GetCombo(sData[0], sData[1], sData[2], sData[3], sData[4], sData[5], sData[6], sData[7], sData[8], sData[9]);
                byte[][] images = UP_GetImage(sData[0] + sData[1] + sData[2] + string.Format("{0:000}", Convert.ToInt32(sData[3])) + sData[4] + string.Format("{0:000}", Convert.ToInt32(sData[5]))
                    + sData[6] + sData[7] + sData[8] + string.Format("{0:000}", Convert.ToInt32(sData[9])), _ds.Tables[0].Rows.Count,"06");
                byte[][] toolimages = UP_GetImage(sData[0] + sData[1] + sData[2] + string.Format("{0:000}", Convert.ToInt32(sData[3])) + sData[4] + string.Format("{0:000}", Convert.ToInt32(sData[5]))
                    + sData[6] + sData[7] + sData[8] + string.Format("{0:000}", Convert.ToInt32(sData[9])), _ds.Tables[0].Rows.Count, "07");

                ActiveReport rpt = new TYPSM.Report.SCHEDULE_PRT(dt, _sSANAME, _sTONAME, images, toolimages);
                rpt.DataSource = _ds.Tables[0];
                this.arvMain.Report = rpt;
                rpt.Run();
            }
        }
        #endregion  

        #region Description : 출력데이터 가져오기(SCHEDULE관리)
        private DataTable UP_Bind_SCHEDULE(string sJSMBLASS, string sJSMMLASS, string sJSMSLASS, string sJSMSEQ)
        {
            string sOUTMSG = string.Empty;

            DataSet ds = new DataSet();

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS491HR715", sJSMBLASS, sJSMMLASS, sJSMSLASS, sJSMSEQ);
            ds = this.DbConnector.ExecuteDataSet();

            // 임시테이블 생성
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49BBM790", Session.SessionID, sJSMBLASS, sJSMMLASS, sJSMSLASS, sJSMSEQ, PSUserInfo.EmpNo, sOUTMSG.ToString());
            sOUTMSG = Convert.ToString(this.DbConnector.ExecuteScalar());

            // 임시테이블 조회
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49BD7792", Session.SessionID);
            _ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : 출력데이터 가져오기(변경관리,일일SCHEDULE)
        private DataTable UP_Bind_SCHEDULEWK(string sWKGUBN, string sWKTEAM, string sWKDATE,
                                 string sWKSEQ, string sDATE, string sSEQ,
                                 string sJSMBLASS, string sJSMMLASS, string sJSMSLASS,
                                 string sJSMSEQ)
        {
            string sOUTMSG = string.Empty;

            DataSet ds = new DataSet();
            // 마스타테이블 조회
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49GAW856", sWKGUBN, sWKTEAM, sWKDATE, sWKSEQ, sDATE, sSEQ, sJSMBLASS, sJSMMLASS, sJSMSLASS, sJSMSEQ);
            ds = this.DbConnector.ExecuteDataSet();

            // 임시테이블 생성
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49FK4844", Session.SessionID, sWKGUBN, sWKTEAM,
                                                  sWKDATE, sWKSEQ, sDATE,
                                                  sSEQ, sJSMBLASS, sJSMMLASS,
                                                  sJSMSLASS, sJSMSEQ, PSUserInfo.EmpNo,
                                                  sOUTMSG.ToString());
            sOUTMSG = Convert.ToString(this.DbConnector.ExecuteScalar());

            // 임시테이블 조회
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49FKG853", Session.SessionID, sWKGUBN);
            _ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion

        #region Description : 안전보호구 및 안전장비(SCHEDULE 관리)
        private void UP_GetCombo(string sJSMBLASS, string sJSMMLASS, string sJSMSLASS, string sJSMSEQ)
        {
            int i = 0;
            string sValue = string.Empty;
            string sText = string.Empty;

            DataSet ds = new DataSet();

            // 안전보호구 콤보
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS493AQ737", sJSMBLASS, sJSMMLASS, sJSMSLASS, sJSMSEQ, "1");
            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                for (i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (i == ds.Tables[0].Rows.Count - 1)
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString();
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString();
                    }
                    else
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString() + ",";
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString() + ", ";
                    }
                }
            }

            _sSANAME = sText.ToString();

            sValue = "";
            sText = "";

            // 안전장비 콤보 원본
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS493AQ737", sJSMBLASS, sJSMMLASS, sJSMSLASS, sJSMSEQ, "2");
            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                for (i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (i == ds.Tables[0].Rows.Count - 1)
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString();
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString();
                    }
                    else
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString() + ",";
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString() + ", ";
                    }
                }
            }
            _sTONAME = sText.ToString();
        }
        #endregion

        #region Description : 안전보호구 및 안전장비(변경관리,일일SCHEDULE)
        private void UP_GetCombo(string sJSLWKGUBN, string sJSLWKTEAM, string sJSLWKDATE,
                                 string sJSLWKSEQ, string sJSLDATE, string sJSLSEQ,
                                 string sJSMBLASS, string sJSMMLASS, string sJSMSLASS,
                                 string sJSMSEQ)
        {
            int i = 0;
            string sValue = string.Empty;
            string sText = string.Empty;

            DataSet ds = new DataSet();

            // 안전보호구 콤보
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49GB8857", sJSLWKGUBN, sJSLWKTEAM, sJSLWKDATE,
                                                  sJSLWKSEQ, sJSLDATE, sJSLSEQ,
                                                  sJSMBLASS, sJSMMLASS, sJSMSLASS,
                                                  sJSMSEQ, "1");

            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                for (i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (i == ds.Tables[0].Rows.Count - 1)
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString();
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString();
                    }
                    else
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString() + ",";
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString() + ", ";
                    }
                }
            }

            sValue = "";
            sText = "";
            _sSANAME = sText.ToString();

            // 안전장비 콤보 원본
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49GB8857", sJSLWKGUBN, sJSLWKTEAM, sJSLWKDATE,
                                                  sJSLWKSEQ, sJSLDATE, sJSLSEQ,
                                                  sJSMBLASS, sJSMMLASS, sJSMSLASS,
                                                  sJSMSEQ, "2");

            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                for (i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    if (i == ds.Tables[0].Rows.Count - 1)
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString();
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString();
                    }
                    else
                    {
                        sValue += ds.Tables[0].Rows[i]["CODE"].ToString() + ",";
                        sText += ds.Tables[0].Rows[i]["NAME"].ToString() + ", ";
                    }
                }
            }
            _sTONAME = sText.ToString();
        }
        #endregion

        #region Description : 작업단계 이미지 가져오기
        private byte[][] UP_GetImage(string sAFDOCNUM, int iRcount, string GUBN)
        {
            byte[][] sImage;

            DataSet ds = new DataSet();

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49HHN916", GUBN, sAFDOCNUM);
            ds = this.DbConnector.ExecuteDataSet();
            sImage = new byte[iRcount][];

            // 임시테이블 생성
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("PS49HHP918", GUBN, sAFDOCNUM);
            ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    sImage[Convert.ToInt32(ds.Tables[0].Rows[i]["AFSEQ"])] = ds.Tables[0].Rows[i]["AFBINARY"] as byte[];
                }
            }

            return sImage;
        }
        #endregion
    }
}