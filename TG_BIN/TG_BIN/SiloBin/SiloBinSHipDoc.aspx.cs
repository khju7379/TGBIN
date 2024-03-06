using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Ext.Net;
using System.Data;
using PSM.Common;
using System.Xml;
using System.Xml.Xsl;

namespace TG_BIN.SiloBin
{
    public partial class SiloBinSHipDoc : PageBase
    {
        private string fsDCORPGUBN;
        private string fsDHANGCHA;
        private string fsDHANGCHANM;
        private string fsDGOKJONG;
        private string fsDLOADCODE;
        private string fsDWKDATE;
        private string fsDSEQ;
        private string fsDWORKTEXT;
        private string fsDSUNCHANG;
        private string fsDLSDATE;
        private string fsDLSTIME;
        private string fsDLEDATE;
        private string fsDLETIME;
        private string fsDSHSTIME;
        private string fsDSHETIME;
        private string fsDLOADQTY;
        private string fsDSUMQTY;

        private string fsDSBINSEQ;
        private string fsDSBINNO;
        private string fsDSLOADQTY;
        private string fsDSBINNOHD;

        private string fsDSBINNOPRE;
        private string fsDSLOADQTYPRE;
        private string fsDSUNCHANGPRE;

        private string fsDLSDATEPRE = "null";
        private string fsDLSTIMEPRE = "null";
        private string fsDLEDATEPRE = "null";
        private string fsDLETIMEPRE = "null";
        private string fsDSUMQTYPRE = "0";
        private string fsDLSDATESUB = string.Empty;
        private string fsDLSTIMESUB = string.Empty;
        private string fsDLEDATESUB = string.Empty;
        private string fsDLETIMESUB = string.Empty;
        private string fsDSUMQTYSUB = string.Empty;

        public SiloBinSHipDoc()
        {
            this.CheckLogin = true;
            this.CheckAuth = false;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {
                UP_HangchaSelect(string.Format("{0:yyyy}", DateTime.Now), "T");

                //BIN번호
                stoBINNO.Data = GetBINNOData();
                stoBINNO.DataBind();
            }
        }

        #region Description : 항차 조회
        private void UP_HangchaSelect(string HANGCHA, string CORPGUBN)
        {
            this.DbConnector.CommandClear();
            if (CORPGUBN == "T")
            {
                this.DbConnector.Attach("TG_P_GS_B39FV857", HANGCHA);
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B39FW858", HANGCHA);
            }
            DataSet ds = this.DbConnector.ExecuteDataSet();

            this.stoHangcha.DataSource = ds.Tables[0];
            this.stoHangcha.DataBind();
        }
        #endregion

        #region Description : BIN번호 조회
        protected object GetBINNOData()
        {
            string sNowDate = string.Empty;
            sNowDate = System.DateTime.Now.ToString("yyyyMMdd");
            DataSet ds = null;
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B2HHE631", "2", sNowDate);
            ds = this.DbConnector.ExecuteDataSet();

            return ds.Tables[0];
        }
        #endregion  

        #region Description : 항차 리스트 그리드 클릭
        protected void grdHCList_CellClick(object sender, DirectEventArgs e)
        {
            string[] datas;
            string[] checkDatas = e.ExtraParams["DATAS"].Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);
            string sHCORPGUBN = string.Empty;

            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                UP_DataBinding(datas[0].ToString(), datas[2].ToString(), datas[5].ToString());

                txtHANGCHA2.Text = datas[0].ToString();
                txtHANGCHANM2.Text = datas[1].ToString();
                txtGOKJONG.Text = datas[2].ToString();
                txtGOKJONGNM.Text = datas[3].ToString();
                txtIBBEJNQTY.Text = datas[4].ToString();
                txtDHANGCHA.Text = datas[0].ToString();
                txtHCORPGUBN.Text = datas[5].ToString();
                if (datas[5].ToString() == "T")
                {
                    sHCORPGUBN = "그레인터미널";
                }
                else
                {
                    sHCORPGUBN = "평택싸이로";
                }
                txtHCORPGUBNNM.Text = sHCORPGUBN;
            }

            btnMAdd.Hidden = false;
            btnPrt.Hidden = false;
            btnExcel.Hidden = false;
            TSMAdd.Hidden = false;
        }
        #endregion

        #region Description : 하역작업 그리드 데이터 바인딩
        private void UP_DataBinding(string sHANGCHA, string sGOKJONG, string sCORPGUBN)
        {
            this.stoBinShipDoc.RemoveAll();
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BL4910", sCORPGUBN, sHANGCHA, sGOKJONG);

            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                this.stoBinShipDoc.DataSource = UP_DataTableChange(ds.Tables[0]);
            }
            else
            {
                this.stoBinShipDoc.DataSource = ds.Tables[0];
            }
            this.stoBinShipDoc.DataBind();

        }
        #endregion

        #region Description : 데이터셋 변환
        private DataTable UP_DataTableChange(DataTable dt)
        {
            DataTable rtnDt = new DataTable();
            DataTable dtD = new DataTable();
            DataTable dtHap = new DataTable();
            DataRow row;

            double dDLOADQTY = 0.000;
            double dDSUMQTY = 0.000;
            double dDLOADQTYTOTAL = 0.000;
            double dDSUMQTYTOTAL = 0.000;

            rtnDt.Columns.Add("DCORPGUBN", typeof(System.String));
            rtnDt.Columns.Add("DHANGCHA", typeof(System.String));
            rtnDt.Columns.Add("DGOKJONG", typeof(System.String));
            rtnDt.Columns.Add("DGOKJONGNM", typeof(System.String));
            rtnDt.Columns.Add("DLOADCODE", typeof(System.String));
            rtnDt.Columns.Add("DLOADCODENM", typeof(System.String));

            rtnDt.Columns.Add("DWKDATE", typeof(System.String));
            rtnDt.Columns.Add("DSEQ", typeof(System.String));
            rtnDt.Columns.Add("DSUNCHANG", typeof(System.String));
            rtnDt.Columns.Add("DWORKTEXT", typeof(System.String));
            rtnDt.Columns.Add("DBINNO", typeof(System.String));

            rtnDt.Columns.Add("DLSDATE", typeof(System.String));
            rtnDt.Columns.Add("DLSTIME", typeof(System.String));
            rtnDt.Columns.Add("DLEDATE", typeof(System.String));
            rtnDt.Columns.Add("DLETIME", typeof(System.String));
            rtnDt.Columns.Add("DSHSTIME", typeof(System.String));

            rtnDt.Columns.Add("DSHETIME", typeof(System.String));
            rtnDt.Columns.Add("DLOADQTY", typeof(System.String));
            rtnDt.Columns.Add("DSUMQTY", typeof(System.String));


            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (i > 0)
                {
                    if (dt.Rows[i]["DLOADCODE"].ToString() != dt.Rows[i - 1]["DLOADCODE"].ToString())
                    {
                        row = rtnDt.NewRow();

                        row["DCORPGUBN"] = DBNull.Value;
                        row["DHANGCHA"] = DBNull.Value;
                        row["DGOKJONG"] = DBNull.Value;
                        row["DGOKJONGNM"] = DBNull.Value;
                        row["DLOADCODE"] = DBNull.Value;
                        row["DLOADCODENM"] = "소 계";

                        row["DWKDATE"] =  DBNull.Value;
                        row["DSEQ"] = DBNull.Value;
                        row["DSUNCHANG"] = DBNull.Value;
                        row["DWORKTEXT"] = DBNull.Value;
                        row["DBINNO"] = DBNull.Value;

                        row["DLSDATE"] = DBNull.Value;
                        row["DLSTIME"] = DBNull.Value;
                        row["DLEDATE"] = DBNull.Value;
                        row["DLETIME"] = DBNull.Value;
                        row["DSHSTIME"] = DBNull.Value;

                        row["DSHETIME"] = DBNull.Value;
                        row["DLOADQTY"] = dDLOADQTY;
                        row["DSUMQTY"] = dDSUMQTY;

                        rtnDt.Rows.Add(row);

                        dDSUMQTYTOTAL += dDSUMQTY;

                        
                        dDLOADQTY = 0;
                        dDSUMQTY = 0;
                    }
                }

                row = rtnDt.NewRow();

                row["DCORPGUBN"] = dt.Rows[i]["DCORPGUBN"].ToString();
                row["DHANGCHA"] = dt.Rows[i]["DHANGCHA"].ToString();
                row["DGOKJONG"] = dt.Rows[i]["DGOKJONG"].ToString();
                row["DGOKJONGNM"] = dt.Rows[i]["DGOKJONGNM"].ToString();
                row["DLOADCODE"] = dt.Rows[i]["DLOADCODE"].ToString();
                row["DLOADCODENM"] = dt.Rows[i]["DLOADCODENM"].ToString();

                row["DWKDATE"] = dt.Rows[i]["DWKDATE"].ToString();
                row["DSEQ"] = dt.Rows[i]["DSEQ"].ToString();
                row["DSUNCHANG"] = dt.Rows[i]["DSUNCHANG"].ToString();
                row["DWORKTEXT"] = dt.Rows[i]["DWORKTEXT"].ToString();
                row["DBINNO"] = dt.Rows[i]["DBINNO"].ToString();

                row["DLSDATE"] = dt.Rows[i]["DLSDATE"].ToString();
                row["DLSTIME"] = dt.Rows[i]["DLSTIME"].ToString();
                row["DLEDATE"] = dt.Rows[i]["DLEDATE"].ToString();
                row["DLETIME"] = dt.Rows[i]["DLETIME"].ToString();
                row["DSHSTIME"] = dt.Rows[i]["DSHSTIME"].ToString();

                row["DSHETIME"] = dt.Rows[i]["DSHETIME"].ToString();
                row["DLOADQTY"] = dt.Rows[i]["DLOADQTY"].ToString();
                row["DSUMQTY"] = dt.Rows[i]["DSUMQTY"].ToString();

                rtnDt.Rows.Add(row);

                
                dDLOADQTY += Convert.ToDouble(dt.Rows[i]["DLOADQTY"].ToString());
                
                dDLOADQTYTOTAL += Convert.ToDouble(dt.Rows[i]["DLOADQTY"].ToString());

                if (dDSUMQTY < Convert.ToDouble(dt.Rows[i]["DSUMQTY"].ToString()))
                {
                    dDSUMQTY = Convert.ToDouble(dt.Rows[i]["DSUMQTY"].ToString());
                }
            }

            row = rtnDt.NewRow();

            row["DCORPGUBN"] = DBNull.Value;
            row["DHANGCHA"] = DBNull.Value;
            row["DGOKJONG"] = DBNull.Value;
            row["DGOKJONGNM"] = DBNull.Value;
            row["DLOADCODE"] = DBNull.Value;
            row["DLOADCODENM"] = "소 계";

            row["DWKDATE"] = DBNull.Value;
            row["DSEQ"] = DBNull.Value;
            row["DSUNCHANG"] = DBNull.Value;
            row["DWORKTEXT"] = DBNull.Value;
            row["DBINNO"] = DBNull.Value;

            row["DLSDATE"] = DBNull.Value;
            row["DLSTIME"] = DBNull.Value;
            row["DLEDATE"] = DBNull.Value;
            row["DLETIME"] = DBNull.Value;
            row["DSHSTIME"] = DBNull.Value;

            row["DSHETIME"] = DBNull.Value;
            row["DLOADQTY"] = dDLOADQTY;
            row["DSUMQTY"] = dDSUMQTY;

            rtnDt.Rows.Add(row);

            row = rtnDt.NewRow();

            row["DCORPGUBN"] = DBNull.Value;
            row["DHANGCHA"] = DBNull.Value;
            row["DGOKJONG"] = DBNull.Value;
            row["DGOKJONGNM"] = DBNull.Value;
            row["DLOADCODE"] = DBNull.Value;
            row["DLOADCODENM"] = "합 계";

            row["DWKDATE"] = DBNull.Value;
            row["DSEQ"] = DBNull.Value;
            row["DSUNCHANG"] = DBNull.Value;
            row["DWORKTEXT"] = DBNull.Value;
            row["DBINNO"] = DBNull.Value;

            row["DLSDATE"] = DBNull.Value;
            row["DLSTIME"] = DBNull.Value;
            row["DLEDATE"] = DBNull.Value;
            row["DLETIME"] = DBNull.Value;
            row["DSHSTIME"] = DBNull.Value;

            row["DSHETIME"] = DBNull.Value;
            row["DLOADQTY"] = dDLOADQTYTOTAL;
            row["DSUMQTY"] = dDSUMQTYTOTAL + dDSUMQTY;

            rtnDt.Rows.Add(row);

            
            dDLOADQTYTOTAL = 0;
            dDSUMQTY = 0;

            // 항차 곡종 조회
            this.DbConnector.CommandClear();

            if (dt.Rows[0]["DCORPGUBN"].ToString() == "T")
            {
                this.DbConnector.Attach("TG_P_GS_B39FV857", dt.Rows[0]["DHANGCHA"].ToString());
            }
            else
            {
                this.DbConnector.Attach("TG_P_GS_B39FW858", dt.Rows[0]["DHANGCHA"].ToString());
            }

            dtD = this.DbConnector.ExecuteDataTable();

            for (int i = 0; i < dtD.Rows.Count; i++)
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B3BLY911", dt.Rows[0]["DCORPGUBN"].ToString(), dtD.Rows[i]["HANGCHA"].ToString(), dtD.Rows[i]["GOKJONG"].ToString());

                dtHap = this.DbConnector.ExecuteDataTable();

                if (dtHap.Rows.Count > 0)
                {
                    
                    dDLOADQTYTOTAL += Convert.ToDouble(dtHap.Rows[0]["DLOADQTY"].ToString());
                    dDSUMQTY += Convert.ToDouble(dtHap.Rows[0]["DSUMQTY"].ToString());
                }
            }

            row = rtnDt.NewRow();

            row["DCORPGUBN"] = DBNull.Value;
            row["DHANGCHA"] = DBNull.Value;
            row["DGOKJONG"] = DBNull.Value;
            row["DGOKJONGNM"] = DBNull.Value;
            row["DLOADCODE"] = DBNull.Value;
            row["DLOADCODENM"] = "모선계";

            row["DWKDATE"] = DBNull.Value;
            row["DSEQ"] = DBNull.Value;
            row["DSUNCHANG"] = DBNull.Value;
            row["DWORKTEXT"] = DBNull.Value;
            row["DBINNO"] = DBNull.Value;

            row["DLSDATE"] = DBNull.Value;
            row["DLSTIME"] = DBNull.Value;
            row["DLEDATE"] = DBNull.Value;
            row["DLETIME"] = DBNull.Value;
            row["DSHSTIME"] = DBNull.Value;

            row["DSHETIME"] = DBNull.Value;
            row["DLOADQTY"] = dDLOADQTYTOTAL;
            row["DSUMQTY"] = dDSUMQTY;

            rtnDt.Rows.Add(row);

            return rtnDt;
        }
        #endregion

        #region Description : 마스타 그리드 클릭
        protected void grdList_CellClick(object sender, DirectEventArgs e)
        {
            string[] datas;
            string[] checkDatas = e.ExtraParams["DATAS"].Split(new string[] { "^/^" }, StringSplitOptions.RemoveEmptyEntries);

            foreach (string checkData in checkDatas)
            {
                //문자열 기준을 배열에 다시 담기
                datas = checkData.Split(new string[] { "^;^" }, StringSplitOptions.None);

                if (datas[3].ToString() != "소 계" && datas[3].ToString() != "합 계" && datas[3].ToString() != "모선계")
                {
                    UP_Select(datas[6].ToString(),
                              datas[0].ToString(),
                              datas[1].ToString(),
                              datas[2].ToString(),
                              datas[4].ToString().Replace(".", ""),
                              datas[5].ToString());

                    UP_grdDetail_Bind(datas[6].ToString(),
                                      datas[0].ToString(),
                                      datas[1].ToString(),
                                      datas[2].ToString(),
                                      datas[4].ToString(),
                                      datas[5].ToString());

                    ShipDocPop.Show();

                }
            }
        }
        #endregion

        #region Description : 마스타 조회
        private void UP_Select(string DCORPGUBN, string DHANGCHA, string DGOKJONG, string DLOADCODE, string DWKDATE, string DSEQ)
        {
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BMC914", DCORPGUBN,
                                                        DHANGCHA,
                                                        DGOKJONG,
                                                        DLOADCODE,
                                                        DWKDATE,
                                                        DSEQ);
            DataSet ds = this.DbConnector.ExecuteDataSet();

            if (ds.Tables[0].Rows.Count > 0)
            {
                cboDCORPGUBN.SetValueAndFireSelect(ds.Tables[0].Rows[0]["DCORPGUBN"].ToString());
                txtDHANGCHA.Text = ds.Tables[0].Rows[0]["DHANGCHA"].ToString();
                txtDHANGCHANM.Text = ds.Tables[0].Rows[0]["DHANGCHANM"].ToString();
                txtDGOKJONG.Text = ds.Tables[0].Rows[0]["DGOKJONG"].ToString();
                txtDGOKJONGNM.Text = ds.Tables[0].Rows[0]["DGOKJONGNM"].ToString();
                cboDLOADCODE.SetValueAndFireSelect(ds.Tables[0].Rows[0]["DLOADCODE"].ToString());
                if (ds.Tables[0].Rows[0]["DWKDATE"].ToString() == "")
                {
                    dtpDWKDATE.SetValue("");
                }
                else
                {
                    dtpDWKDATE.SetValue(ds.Tables[0].Rows[0]["DWKDATE"].ToString().Substring(0, 4) + "-" + ds.Tables[0].Rows[0]["DWKDATE"].ToString().Substring(4, 2) + "-" + ds.Tables[0].Rows[0]["DWKDATE"].ToString().Substring(6, 2));
                }
                txtDSEQ.Text = ds.Tables[0].Rows[0]["DSEQ"].ToString();
                txtDWORKTEXT.Text = ds.Tables[0].Rows[0]["DWORKTEXT"].ToString();
                txtDSUNCHANG.Text = ds.Tables[0].Rows[0]["DSUNCHANG"].ToString();
                txtDSUNCHANGPRE.Text = ds.Tables[0].Rows[0]["DSUNCHANG"].ToString();
                txtDBINNOPRE.Text = ds.Tables[0].Rows[0]["DBINNO"].ToString();
                if (ds.Tables[0].Rows[0]["DLSDATE"].ToString() == "")
                {
                    dtpDLSDATE.SetValue("");
                }
                else
                {
                    dtpDLSDATE.SetValue(ds.Tables[0].Rows[0]["DLSDATE"].ToString().Substring(0, 4) + "-" + ds.Tables[0].Rows[0]["DLSDATE"].ToString().Substring(4, 2) + "-" + ds.Tables[0].Rows[0]["DLSDATE"].ToString().Substring(6, 2));
                }
                txtDLSTIME.Text = ds.Tables[0].Rows[0]["DLSTIME"].ToString();
                if (ds.Tables[0].Rows[0]["DLEDATE"].ToString() == "")
                {
                    dtpDLEDATE.SetValue("");
                }
                else
                {
                    dtpDLEDATE.SetValue(ds.Tables[0].Rows[0]["DLEDATE"].ToString().Substring(0, 4) + "-" + ds.Tables[0].Rows[0]["DLEDATE"].ToString().Substring(4, 2) + "-" + ds.Tables[0].Rows[0]["DLEDATE"].ToString().Substring(6, 2));
                }
                txtDLETIME.Text = ds.Tables[0].Rows[0]["DLETIME"].ToString();
                txtDSHSTIME.Text = ds.Tables[0].Rows[0]["DSHSTIME"].ToString();
                txtDSHETIME.Text = ds.Tables[0].Rows[0]["DSHETIME"].ToString();
                txtDLOADQTY.Text = string.Format("{0:#,##0.000}", double.Parse(ds.Tables[0].Rows[0]["DLOADQTY"].ToString()));
                txtDSUMQTY.Text = string.Format("{0:#,##0.000}", double.Parse(ds.Tables[0].Rows[0]["DSUMQTY"].ToString()));

                txtDSUNCHANG.Focus();

            }
            cboDLOADCODE.ReadOnly = true;
            dtpDWKDATE.ReadOnly = true;

            cboDLOADCODE.FieldStyle = "background-color:#E5E5E5;";
            dtpDWKDATE.FieldStyle = "background-color:#E5E5E5;";

            btnDel.Hidden = false;
        }
        #endregion

        #region Description : 상세내역 데이터 바인드
        private void UP_grdDetail_Bind(string DCORPGUBN, string DSHANGCHA, string DSGOKJONG, 
                                       string DSLOADCODE, string DSWKDATE, string DSSEQ)
        {
            string sDSBINNOPRE = string.Empty;
            string sDLOADQTYPRE = string.Empty;

            DataTable rtnDt = new DataTable();

            DataRow row;

            rtnDt.Columns.Add("DSBINSEQ", typeof(System.String));
            rtnDt.Columns.Add("DSBINNO", typeof(System.String));
            rtnDt.Columns.Add("DSBINNOHD", typeof(System.String));
            rtnDt.Columns.Add("DSLOADQTY", typeof(System.String));

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3ABK862", DCORPGUBN,
                                                        DSHANGCHA,
                                                        DSGOKJONG,
                                                        DSLOADCODE,
                                                        DSWKDATE.Replace(".", ""),
                                                        Set_Fill3(DSSEQ));
            DataTable dt = this.DbConnector.ExecuteDataTable();

            if (dt.Rows.Count > 0)
            {
                for (int i = 0; i < 10; i++)
                {
                    row = rtnDt.NewRow();

                    if (i < dt.Rows.Count)
                    {   
                        row["DSBINSEQ"] = dt.Rows[i]["DSBINSEQ"].ToString();
                        row["DSBINNO"] = dt.Rows[i]["DSBINNO"].ToString();
                        row["DSBINNOHD"] = dt.Rows[i]["DSBINNO"].ToString();
                        row["DSLOADQTY"] = dt.Rows[i]["DSLOADQTY"].ToString();
                        if (i == 0)
                        {
                            sDSBINNOPRE = dt.Rows[i]["DSBINNO"].ToString();
                            sDLOADQTYPRE = dt.Rows[i]["DSLOADQTY"].ToString();
                        }
                        else
                        {
                            sDSBINNOPRE += "," + dt.Rows[i]["DSBINNO"].ToString();
                            sDLOADQTYPRE += "," + dt.Rows[i]["DSLOADQTY"].ToString();
                        }
                    }
                    else
                    {
                        row["DSBINSEQ"] = DBNull.Value;
                        row["DSBINNO"] = DBNull.Value;
                        row["DSBINNOHD"] = DBNull.Value;
                        row["DSLOADQTY"] = DBNull.Value;
                        if (i == 0)
                        {
                            sDSBINNOPRE = "";
                            sDLOADQTYPRE = "";
                        }
                        else
                        {
                            sDSBINNOPRE += ",";
                            sDLOADQTYPRE += ",";
                        }
                    }

                    rtnDt.Rows.Add(row);
                }
            }
            else
            {
                for (int i = 0; i < 10; i++)
                {
                    row = rtnDt.NewRow();
                    
                    row["DSBINSEQ"] = DBNull.Value;
                    row["DSBINNO"] = DBNull.Value;
                    row["DSBINNOHD"] = DBNull.Value;
                    row["DSLOADQTY"] = DBNull.Value;

                    if (i == 0)
                    {
                        sDSBINNOPRE = "";
                        sDLOADQTYPRE = "";
                    }
                    else
                    {
                        sDSBINNOPRE += ",";
                        sDLOADQTYPRE += ",";
                    }

                    rtnDt.Rows.Add(row);
                }
            }

            this.stoBinShipDocDetail.RemoveAll();
            this.stoBinShipDocDetail.DataSource = rtnDt;
            this.stoBinShipDocDetail.DataBind();

            this.txtDSBINNOPRE.Text = sDSBINNOPRE;
            this.txtDLOADQTYPRE.Text = sDLOADQTYPRE;
        }
        #endregion

        #region Description : 검색 버튼
        [DirectMethod]
        public void btnFind_Click(string sCORPGUBN, string sHANGCHA)
        {
            UP_HangchaSelect(sHANGCHA, sCORPGUBN);
        }
        #endregion

        #region Description : 신규 버튼
        protected void btnNew_Click(object sender, DirectEventArgs e)
        {
            btnSave.Hidden = false;
            btnDel.Hidden = true;

            cboDCORPGUBN.ReadOnly = false;
            cboDLOADCODE.ReadOnly = false;
            dtpDWKDATE.ReadOnly = false;


            cboDCORPGUBN.FieldStyle = "background-color:White;";
            cboDLOADCODE.FieldStyle = "background-color:White;";
            dtpDWKDATE.FieldStyle = "background-color:White;";

            txtDHANGCHA.Text = txtHANGCHA2.Text;
            txtDHANGCHANM.Text = txtHANGCHANM2.Text;
            txtDGOKJONG.Text = txtGOKJONG.Text;
            txtDGOKJONGNM.Text = txtGOKJONGNM.Text;
            if (txtHCORPGUBNNM.Text == "그레인터미널")
            {
                cboDCORPGUBN.SetValueAndFireSelect("T");
            }
            else
            {
                cboDCORPGUBN.SetValueAndFireSelect("P");
            }
            cboDLOADCODE.SetValueAndFireSelect("1");
            dtpDWKDATE.SetValue(string.Format("{0:yyyy-MM-dd}", DateTime.Now));
            txtDSEQ.Text = "";
            txtDWORKTEXT.Text = "";
            txtDSUNCHANG.Text = "";
            dtpDLSDATE.SetValue("");
            txtDLSTIME.Text = "";
            dtpDLEDATE.SetValue("");
            txtDLETIME.Text = "";
            txtDSHSTIME.Text = "";
            txtDSHETIME.Text = "";
            txtDLOADQTY.Text = "";
            txtDSUMQTY.Text = "";
            txtDSBINNOPRE.Text = "";
            txtDLOADQTYPRE.Text = "";
            txtDSBINNOPRE.Text = "";
            txtDLOADQTYPRE.Text = "";

            stoBinShipDocDetail.RemoveAll();

            UP_grdDetail_Bind("", "", "", "", "", "");

            ShipDocPop.Show();
        }
        #endregion

        #region Description : 저장 버튼
        [DirectMethod]
        public void btnSave_Click(string DCORPGUBN, string DHANGCHA, string DHANGCHANM, string DGOKJONG,
                                  string DLOADCODE, string DWKDATE, string DSEQ,
                                  string DWORKTEXT, string DSUNCHANG, string DLSDATE,
                                  string DLSTIME, string DLEDATE, string DLETIME,
                                  string DSHSTIME, string DSHETIME, string DLOADQTY, string DSUMQTY,
                                  string DSBINSEQ, string DSBINNO, string DSLOADQTY, string DSBINNOHD,
                                  string DSBINNOPRE, string DSLOADQTYPRE, string DSUNCHANGPRE)
        {
            fsDCORPGUBN = DCORPGUBN;
            fsDHANGCHA = DHANGCHA;
            fsDHANGCHANM = DHANGCHANM;
            fsDGOKJONG = DGOKJONG;
            
            fsDLOADCODE = DLOADCODE;
            fsDWKDATE = DWKDATE;
            fsDSEQ = DSEQ;
            fsDWORKTEXT = DWORKTEXT;
            fsDSUNCHANG = DSUNCHANG;
            fsDLSDATE = DLSDATE;
            fsDLSTIME = DLSTIME.Replace(":","");
            fsDLEDATE = DLEDATE;
            fsDLETIME = DLETIME.Replace(":", "");
            fsDSHSTIME = DSHSTIME.Replace(":", "");
            fsDSHETIME = DSHETIME.Replace(":", "");
            fsDLOADQTY = DLOADQTY.Replace(",", "");
            fsDSUMQTY = DSUMQTY.Replace(",", "");
            
            fsDSBINSEQ = DSBINSEQ;
            fsDSBINNO = DSBINNO;
            fsDSLOADQTY = DSLOADQTY;
            fsDSBINNOHD = DSBINNOHD;
            
            fsDSBINNOPRE = DSBINNOPRE;
            fsDSLOADQTYPRE = DSLOADQTYPRE;
            fsDSUNCHANGPRE = DSUNCHANGPRE;
            
            string[] sDSBINSEQ = fsDSBINSEQ.Split(',');
            string[] sDSBINNO = fsDSBINNO.Split(',');
            string[] sDSLOADQTY = fsDSLOADQTY.Split(',');

            string[] sDSBINNOHD = fsDSBINNOHD.Split(',');
            string[] sDSBINNOPRE = fsDSBINNOPRE.Split(',');
            string[] sDSLOADQTYPRE = fsDSLOADQTYPRE.Split(',');

            string sPREDSLOADQTY = string.Empty;
            
            // 마스타 키 체크
            bool result = UP_KeyCheck();

            if (result == false)
            {
                return;
            }

            for (int i = 0; i < sDSBINNO.Length; i++)
            {
                if (sDSBINNO[i] != "")
                {
                    result = UP_KeyCheckDetail(sDSBINNO[i], sDSBINNOHD[i]);
                    if (result == false)
                    {
                        return;
                    }
                }
            }

            #region Description : 마스타 저장
            if (DSEQ == "")
            {
                // 순번가져오기
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B3BJO900", fsDCORPGUBN,
                                                            fsDHANGCHA,
                                                            fsDGOKJONG,
                                                            fsDLOADCODE,
                                                            fsDWKDATE
                                                            );
                DataTable dt = this.DbConnector.ExecuteDataTable();
                fsDSEQ = dt.Rows[0]["SEQ"].ToString();

                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B3BJQ901", fsDCORPGUBN,
                                                            fsDHANGCHA,
                                                            fsDGOKJONG,
                                                            fsDLOADCODE,
                                                            fsDWKDATE,
                                                            fsDSEQ,
                                                            fsDWORKTEXT,
                                                            fsDSUNCHANG,
                                                            fsDLSDATE,
                                                            fsDLSTIME,
                                                            fsDLEDATE,
                                                            fsDLETIME,
                                                            fsDSHSTIME,
                                                            fsDSHETIME,
                                                            fsDLOADQTY,
                                                            fsDSUMQTY,
                                                            PSUserInfo.EmpNo
                                                            );
                this.DbConnector.ExecuteNonQuery();

                txtDSEQ.Text = Set_Fill3(fsDSEQ);
            }
            else
            {
                this.DbConnector.CommandClear();
                this.DbConnector.Attach("TG_P_GS_B3BJS902", fsDWORKTEXT,
                                                            fsDSUNCHANG,
                                                            fsDLSDATE,
                                                            fsDLSTIME,
                                                            fsDLEDATE,
                                                            fsDLETIME,
                                                            fsDSHSTIME,
                                                            fsDSHETIME,
                                                            fsDLOADQTY,
                                                            fsDSUMQTY,
                                                            PSUserInfo.EmpNo,
                                                            fsDCORPGUBN,
                                                            fsDHANGCHA,
                                                            fsDGOKJONG,
                                                            fsDLOADCODE,
                                                            fsDWKDATE,
                                                            fsDSEQ
                                                            );
                this.DbConnector.ExecuteNonQuery();


            }
            #endregion

            #region Description : 상세내역 Update

            for (int i = 0; i < sDSBINNO.Length; i++)
            {
                if (sDSBINNO[i] != "")
                {
                    // 하역작업일지 상세 내용 조회
                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B3BK5903", fsDCORPGUBN,
                                                                fsDHANGCHA,
                                                                fsDGOKJONG,
                                                                fsDLOADCODE,
                                                                fsDWKDATE,
                                                                fsDSEQ,
                                                                sDSBINSEQ[i],
                                                                sDSBINNO[i]);
                    DataTable dt = this.DbConnector.ExecuteDataTable();

                    sPREDSLOADQTY = "";

                    // 수정 
                    if (dt.Rows.Count > 0)
                    {
                        sPREDSLOADQTY = dt.Rows[0]["DSLOADQTY"].ToString();

                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B3BK8904", sDSLOADQTY[i],
                                                                    PSUserInfo.EmpNo,
                                                                    fsDCORPGUBN,
                                                                    fsDHANGCHA,
                                                                    fsDGOKJONG,
                                                                    fsDLOADCODE,
                                                                    fsDWKDATE,
                                                                    fsDSEQ,
                                                                    sDSBINSEQ[i],
                                                                    sDSBINNO[i]
                                                                    );
                        this.DbConnector.ExecuteNonQuery();

                        if(Convert.ToDouble(sPREDSLOADQTY) != Convert.ToDouble(Get_Numeric(sDSLOADQTY[i])))
                        {
                            // BIN 상태관리 입고량, 입고일자 업데이트
                            this.DbConnector.CommandClear();
                            this.DbConnector.Attach("TG_P_GS_B3QF5066", fsDWKDATE, sDSBINNO[i], fsDGOKJONG);

                            //BIN입고파일 그레인터미널, 평택싸이로
                            this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(fsDWKDATE.ToString()), sDSBINNO[i]);
                            this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(fsDWKDATE.ToString()), sDSBINNO[i]);
                            this.DbConnector.ExecuteNonQueryList();
                        }
                    }
                    else
                    {
                        // 순번가져오기
                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B3BK2905", fsDCORPGUBN,
                                                                    fsDHANGCHA,
                                                                    fsDGOKJONG,
                                                                    fsDLOADCODE,
                                                                    fsDWKDATE,
                                                                    fsDSEQ
                                                                    );
                        DataTable dt2 = this.DbConnector.ExecuteDataTable();
                        string sSEQ = dt2.Rows[0]["SEQ"].ToString();

                        this.DbConnector.CommandClear();
                        this.DbConnector.Attach("TG_P_GS_B3BK5906", fsDCORPGUBN,
                                                                    fsDHANGCHA,
                                                                    fsDGOKJONG,
                                                                    fsDLOADCODE,
                                                                    fsDWKDATE,
                                                                    fsDSEQ,
                                                                    sSEQ,
                                                                    sDSBINNO[i],
                                                                    sDSLOADQTY[i],
                                                                    PSUserInfo.EmpNo
                                                                    );
                        this.DbConnector.ExecuteNonQuery();

                        if (Convert.ToDouble(Get_Numeric(sDSLOADQTY[i])) > 0)
                        {
                            // BIN 상태관리 입고량, 이고일자 업데이트
                            this.DbConnector.CommandClear();
                            this.DbConnector.Attach("TG_P_GS_B3QF5066", fsDWKDATE, sDSBINNO[i], fsDGOKJONG);

                            //BIN입고파일 그레인터미널, 평택싸이로
                            this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(fsDWKDATE.ToString()), sDSBINNO[i]);
                            this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(fsDWKDATE.ToString()), sDSBINNO[i]);
                            this.DbConnector.ExecuteNonQueryList();
                        }
                    }
                }
                else if (sDSBINSEQ[i] != "")
                {
                    // 삭제
                    this.DbConnector.CommandClear();
                    this.DbConnector.Attach("TG_P_GS_B3BKE907", fsDCORPGUBN,
                                                                fsDHANGCHA,
                                                                fsDGOKJONG,
                                                                fsDLOADCODE,
                                                                fsDWKDATE,
                                                                fsDSEQ,
                                                                sDSBINSEQ[i],
                                                                sDSBINNOHD[i]
                                                                );

                    // BIN 상태관리 입고량 업데이트
                    this.DbConnector.Attach("TG_P_GS_B3QFN069", fsDWKDATE, sDSBINNOHD[i], fsDGOKJONG);

                    //BIN입고파일 그레인터미널, 평택싸이로
                    this.DbConnector.Attach("TG_P_GS_B2HJ4647", PSUserInfo.EmpNo, Get_Date(fsDWKDATE.ToString()), sDSBINNOHD[i]);
                    this.DbConnector.Attach("TG_P_GS_B3GGP985", PSUserInfo.EmpNo, Get_Date(fsDWKDATE.ToString()), sDSBINNOHD[i]);

                    this.DbConnector.ExecuteNonQueryList();
                }

                
            }

            #endregion

            this.UP_DataBinding(fsDHANGCHA, fsDGOKJONG, fsDCORPGUBN);

            X.Js.Call("SetOpenerCall");

            X.MessageBox.Alert("확인", "저장 되었습니다.").Show();
        }
        #endregion

        #region Description : 마스타 키 체크
        private bool UP_KeyCheck()
        {
            if (this.fsDHANGCHA == "")
            {
                X.MessageBox.Alert("확인", "항차를 입력하세요!", "SetTextFocus(1)").Show();
                return false;
            }

            if (this.fsDGOKJONG == "")
            {
                X.MessageBox.Alert("확인", "곡종을 입력하세요!", "SetTextFocus(2)").Show();
                return false;
            }

            if (this.fsDSUNCHANG == "")
            {
                X.MessageBox.Alert("확인", "선창을 입력하세요!", "SetTextFocus(4)").Show();
                return false;
            }

            if (string.Format("{0:yyyyMMdd}", fsDWKDATE) == "" || string.Format("{0:yyyyMMdd}", this.fsDWKDATE) == "00010101")
            {
                X.MessageBox.Alert("확인", "작업일자를 입력하세요!", "SetTextFocus(3)").Show();
                return false;
            }

            return true;
        }
        #endregion

        #region Descriptioin : 상세 키 체크
        private bool UP_KeyCheckDetail(string sDSBINNO, string sDSBINNOHD)
        {
            if (sDSBINNOHD != "")
            {
                if (sDSBINNO != sDSBINNOHD)
                {
                    if (sDSBINNO != "")
                    {
                        X.MessageBox.Alert("확인", "BIN 번호는 수정할 수 없습니다!\n" + sDSBINNO + " BIN").Show();
                        return false;
                    }
                }
            }

            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B35DL829", string.Format("{0:yyyyMMdd}", fsDWKDATE), sDSBINNO);
            DataTable dt = this.DbConnector.ExecuteDataTable();

            if (dt.Rows.Count == 0)
            {
                X.MessageBox.Alert("확인", "BIN 상태관리가 등록되지 않았습니다!\n" + sDSBINNO + " BIN").Show();
                return false;
            }
            else if (dt.Rows[0]["SGOKJONG"].ToString() != fsDGOKJONG)
            {
                X.MessageBox.Alert("확인", "BIN 상태관리의 곡종과 일치하지않습니다!\n" + sDSBINNO + " BIN").Show();
                return false;
            }

            return true;
        }
        #endregion

        #region Description : 삭제버튼
        protected void btnDel_Click(object sender, DirectEventArgs e)
        {
            string sHANGCHA = txtDHANGCHA.Text;
            string sGOKJONG = txtDGOKJONG.Text;
            string sCORPGUBN = cboDCORPGUBN.Value.ToString();

            // 마스타 삭제
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BKT908", cboDCORPGUBN.Value,
                                                        txtDHANGCHA.Text,
                                                        txtDGOKJONG.Text,
                                                        cboDLOADCODE.Value,
                                                        string.Format("{0:yyyyMMdd}", dtpDWKDATE.Value),
                                                        txtDSEQ.Text);
            this.DbConnector.ExecuteTranQuery();

            // 상세 삭제
            this.DbConnector.CommandClear();
            this.DbConnector.Attach("TG_P_GS_B3BKV909", cboDCORPGUBN.Value, 
                                                        txtDHANGCHA.Text,
                                                        txtDGOKJONG.Text,
                                                        cboDLOADCODE.Value,
                                                        string.Format("{0:yyyyMMdd}", dtpDWKDATE.Value),
                                                        txtDSEQ.Text);
            this.DbConnector.ExecuteTranQuery();

            this.UP_DataBinding(sHANGCHA, sGOKJONG, sCORPGUBN);
            btnNew_Click(null, null);

            X.Js.Call("SetOpenerCall");

            X.MessageBox.Alert("확인", "삭제 되었습니다.").Show();
        }
        #endregion

        #region Description : 엑셀버튼
        protected void btnExcel_Click(object sender, EventArgs e)
        {   
            double dDLOADQTYHap = 0;
            double dDLOADQTYTotal = 0;

            string json = Convert.ToString(hddGridData.Value);
            StoreSubmitDataEventArgs eSubmit = new StoreSubmitDataEventArgs(json, null);
            XmlNode xml = eSubmit.Xml;

            XmlNode xnDCORPGUBN, xnDHANGCHA, xnDGOKJONG, xnDGOKJONGNM, xnDLOADCODE, xnDLOADCODENM, xnDWKDATE, xnDSEQ, xnDSUNCHANG, xnDWORKTEXT, xnDBINNO, xnDLSDATE, xnDLSTIME, xnDLEDATE, xnDLETIME, xnDSHSTIME, xnDSHETIME, xnDLOADQTY, xnDSUMQTY;
            string sDCORPGUBN, sDHANGCHA, sDGOKJONG, sDGOKJONGNM, sDLOADCODE, sDLOADCODENM, sDWKDATE, sDSEQ, sDSUNCHANG, sDWORKTEXT, sDBINNO, sDLSDATE, sDLSTIME, sDLEDATE, sDLETIME, sDSHSTIME, sDSHETIME, sDLOADQTY, sDSUMQTY;
            foreach (XmlNode xnRecord in xml.SelectNodes("records/record"))
            {
                xnDHANGCHA = xnRecord.SelectSingleNode("DHANGCHA");
                xnDGOKJONG = xnRecord.SelectSingleNode("DGOKJONG");
                xnDGOKJONGNM = xnRecord.SelectSingleNode("DGOKJONGNM");
                
                xnDLOADCODE = xnRecord.SelectSingleNode("DLOADCODE");
                xnDLOADCODENM = xnRecord.SelectSingleNode("DLOADCODENM");
                xnDSUNCHANG = xnRecord.SelectSingleNode("DSUNCHANG");
                xnDWKDATE = xnRecord.SelectSingleNode("DWKDATE");
                xnDSEQ = xnRecord.SelectSingleNode("DSEQ");
                xnDWORKTEXT = xnRecord.SelectSingleNode("DWORKTEXT");
                xnDBINNO = xnRecord.SelectSingleNode("DBINNO");
                xnDLSDATE = xnRecord.SelectSingleNode("DLSDATE");
                xnDLSTIME = xnRecord.SelectSingleNode("DLSTIME");
                xnDLEDATE = xnRecord.SelectSingleNode("DLEDATE");
                xnDLETIME = xnRecord.SelectSingleNode("DLETIME");
                xnDSHSTIME = xnRecord.SelectSingleNode("DSHSTIME");
                xnDSHETIME = xnRecord.SelectSingleNode("DSHETIME");
                xnDLOADQTY = xnRecord.SelectSingleNode("DLOADQTY");
                xnDSUMQTY = xnRecord.SelectSingleNode("DSUMQTY");
                xnRecord.RemoveAll();

                sDHANGCHA = xnDHANGCHA.InnerText;
                sDGOKJONG = xnDGOKJONG.InnerText;
                sDGOKJONGNM = xnDGOKJONGNM.InnerText;
                sDLOADCODE = xnDLOADCODE.InnerText;
                sDLOADCODENM = xnDLOADCODENM.InnerText;
                sDSUNCHANG = xnDSUNCHANG.InnerText;
                sDWKDATE = xnDWKDATE.InnerText;
                sDSEQ = xnDSEQ.InnerText;
                sDWORKTEXT = xnDWORKTEXT.InnerText;
                sDBINNO = xnDBINNO.InnerText;

                sDLSDATE = xnDLSDATE.InnerText;
                sDLSTIME = xnDLSTIME.InnerText;
                sDLEDATE = xnDLEDATE.InnerText;
                sDLETIME = xnDLETIME.InnerText;

                sDSHSTIME = xnDSHSTIME.InnerText;
                sDSHETIME = xnDSHETIME.InnerText;
                sDLOADQTY = xnDLOADQTY.InnerText;
                sDSUMQTY = xnDSUMQTY.InnerText;

                if (sDLOADCODENM.Trim() != "소 계" && sDLOADCODENM.Trim() != "합 계")
                {
                    dDLOADQTYHap = dDLOADQTYHap + Convert.ToDouble(string.Format("{0:0.000}", Convert.ToDouble(sDLOADQTY)));

                    dDLOADQTYTotal = dDLOADQTYTotal + Convert.ToDouble(string.Format("{0:0.000}", Convert.ToDouble(sDLOADQTY)));
                }

                if (sDLOADCODENM.Trim() == "소 계")
                {   
                    sDLOADQTY = dDLOADQTYHap.ToString();

                    dDLOADQTYHap = 0;

                    sDLOADCODENM = "";
                    sDHANGCHA = "소 계";
                }

                if (sDLOADCODENM.Trim() == "합 계")
                {   
                    sDLOADQTY = dDLOADQTYTotal.ToString();

                    sDLOADCODENM = "";
                    sDHANGCHA = "합 계";
                }

                if (sDLOADCODENM.Trim() == "모선계")
                {
                    sDLOADCODENM = "";
                    sDHANGCHA = "모선계";
                }

                xnRecord.InnerXml = string.Format(
                    @"<항차>{0}</항차>
                    <곡종>{1}</곡종> 
                    <곡종명>{2}</곡종명> 
                    <하역기>{3}</하역기>
                    <일자>{4}</일자>
                    <순번>{5}</순번>
                    <선창>{6}</선창>
                    <작업내용>{7}</작업내용>
                    <BIN번호>{8}</BIN번호>
                    <시작일자>{9}</시작일자>
                    <시작시간>{10}</시작시간>
                    <종료일자>{11}</종료일자>
                    <종료시간>{12}</종료시간>
                    <하역시간>{13}</하역시간>
                    <중단시간>{14}</중단시간>
                    <하역량>{15}</하역량>
                    <누계량>{16}</누계량>",
                    sDHANGCHA,
                    sDGOKJONG,
                    sDGOKJONGNM,
                    sDLOADCODENM,
                    sDWKDATE,
                    sDSEQ,
                    sDSUNCHANG,
                    sDWORKTEXT,
                    sDBINNO,
                    sDLSDATE,
                    sDLSTIME,
                    sDLEDATE,
                    sDLETIME,
                    sDSHSTIME,
                    sDSHETIME,
                    sDLOADQTY,
                    sDSUMQTY);
            }

            this.Response.Clear();
            this.Response.ContentType = "application/vnd.ms-excel";
            this.Response.AddHeader("Content-Disposition", "attachment; filename=LoadDoc.xls");
            XslCompiledTransform xtExcel = new XslCompiledTransform();
            xtExcel.Load(Server.MapPath("~/Resources/Xslt/Excel.xslt"));
            xtExcel.Transform(xml, null, this.Response.OutputStream);
            this.Response.End();
        }
        #endregion
    }
}