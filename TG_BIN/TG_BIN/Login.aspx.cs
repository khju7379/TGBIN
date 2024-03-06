using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices;
using Ext.Net;
using PSM.Common;
using PSM.Common.Library;
using System.Web.Security;
using System.Data;

namespace TG_BIN
{
    public partial class Login : System.Web.UI.Page
    {
        private string fsSABUN, fsACTION, fsPWD;

        private string userid = "", password = "";

        private string strDomain;

        private string sNew_ACTION = "";
        private string sNew_pwd = "";

        TypeReturnBool returnBool = new TypeReturnBool();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!X.IsAjaxRequest)
            {

                if (UserChk() != true)
                {
                    this.CheckLogin(txtID.Text, txtPWD.Text);
                }
            }
        }

        protected void txtPWD_SpecialKey(object sender, DirectEventArgs e)
        {
            this.CheckLogin(txtID.Text, txtPWD.Text);

            //신 그룹웨어용
            //this.CheckLogin_New(txtID.Text, txtPWD.Text);  
        }

        [DirectMethod]
        public void UP_Login(string sID, string sPass)
        {
            this.CheckLogin(sID, sPass);

            //신 그룹웨어용
            //this.CheckLogin_New(sID, sPass);
        }

        private void CheckLogin(string sID, string sPass)
        {
            userid = sID;
            password = sPass;

            //그룹웨어 로그인 체크
            TypeReturnBool rValue = GetMessage_New(userid, password);

            //사번 받아오기
            if (rValue.Return == true)
            {
                if (userid != "")
                {
                    UP_UserCheck(userid, "", "6", "");
                }
            }

            UserInfo userInfo = UserInfo.GetUserInfo(this.txtID.Text, EncryptionManager.EncryptString(System.Configuration.ConfigurationManager.AppSettings["PublicKey"].ToString(), this.txtPWD.Text));
            if (userInfo != null)
            {
                this.Response.Cookies["TYPSM_EMPNO"].Value = userInfo.EmpNo;
                this.Response.Cookies["TYPSM_EMPNO"].Expires = DateTime.Now.AddYears(10);

                this.Session.Add("UserInfo", userInfo);

                System.Web.Security.FormsAuthentication.SetAuthCookie(userInfo.EmpNo, true);
                System.Web.Security.FormsAuthentication.RedirectFromLoginPage(userInfo.EmpNo, true, System.Web.Security.FormsAuthentication.FormsCookiePath);
                Response.Redirect("./SiloBin/PlantsSiloBinMonitoring.aspx");
            }

        }

        public class TypeReturnBool
        {
            public bool Return;
            public string Code;
            public string Message;
        }

        private AuthenticationTypes atAuthentType;
        private TypeReturnBool GetMessage_New(string UserId, string Passwd)
        {
            try
            {
                string Domain = "LDAP://gw.taeyoung.co.kr";
                strDomain = Domain + ":389";

                atAuthentType = AuthenticationTypes.None;

                using (DirectoryEntry deDirEntry = new DirectoryEntry(this.strDomain, UserId, Passwd, this.atAuthentType))
                {
                    // 사번나올수도있다.
                    if (deDirEntry.Name.Length > 0)
                    {
                        returnBool.Return = true;
                        returnBool.Message = "인증 성공";
                        returnBool.Code = "SUCCESS";
                    }
                    else
                    {
                        returnBool.Return = false;
                        returnBool.Message = "인증 실패";
                        returnBool.Code = "FAIL";
                    }
                }

                return returnBool;
            }
            catch (SystemException ex)
            {
                returnBool.Return = false;
                returnBool.Message = "인증 실패";
                returnBool.Code = "FAIL";
                return returnBool;
            }
        }

        private void UP_UserCheck(string sKBMAILID, string sKBSABUN, string sGate, string sLinkUrl)
        {
            string sERR = string.Empty;
            string sCOMPANY = string.Empty;

            DataSet ds = null;
            DataSet ds_New = null;

            DbConnector dbConnector = new DbConnector("", "S000000001");
            dbConnector.ProcedureDirectCall();
            dbConnector.LogStatus = false;

            if (sGate != "3" && sGate != "5") //일반, 그룹웨어
            {   
                // 그레인터미널 체크
                dbConnector.CommandClear();
                dbConnector.Attach("TG_P_GS_B2HBW597", sKBMAILID, sKBSABUN);
                ds = dbConnector.ExecuteDataSet();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    sCOMPANY = "TYGT";
                    sKBMAILID = ds.Tables[0].Rows[0]["KBMAILID"].ToString();
                    sKBSABUN = ds.Tables[0].Rows[0]["KBSABUN"].ToString();
                }
                else
                {
                    // 평택싸이로 체크
                    // DB2 인사 체크 후 오라클 권한 체크
                    dbConnector.CommandClear();
                    dbConnector.Attach("TG_P_GS_B47AZ145", sKBMAILID, sKBSABUN);
                    ds = dbConnector.ExecuteDataSet();

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        sCOMPANY = "PTS";
                        sKBMAILID = ds.Tables[0].Rows[0]["KBMAILID"].ToString();
                        sKBSABUN = ds.Tables[0].Rows[0]["KBSABUN"].ToString();

                        dbConnector.CommandClear();
                        dbConnector.Attach("TG_P_GS_B47B6147", sKBSABUN);
                        ds = dbConnector.ExecuteDataSet();
                    }
                    else
                    {
                        // 태영인더스트리 체크
                        // DB2 인사 체크 후 오라클 권한 체크
                        dbConnector.CommandClear();
                        dbConnector.Attach("TG_P_GS_B47B0146", sKBMAILID, sKBSABUN);
                        ds = dbConnector.ExecuteDataSet();

                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            sCOMPANY = "TYI";
                            sKBMAILID = ds.Tables[0].Rows[0]["KBMAILID"].ToString();
                            sKBSABUN = ds.Tables[0].Rows[0]["KBSABUN"].ToString();

                            dbConnector.CommandClear();
                            dbConnector.Attach("TG_P_GS_B47B6147", sKBSABUN);
                            ds = dbConnector.ExecuteDataSet();
                        }
                    }
                }
            }
            
            if (ds != null && ds.Tables[0].Rows.Count > 0)
            {
                //사번이면 그룹웨어 영문이니셜로 그룹웨어에서 비번을 받아온다.
                if (sKBMAILID == "" && sGate != "3" && sGate != "5")
                {
                    //sKBMAILID = ds.Tables[0].Rows[0]["KBMAILID"].ToString();

                    if (sKBMAILID != "")
                    {
                        if (sNew_ACTION.ToString() == "NEW_GW")
                        {
                            // 사번으로 메뉴권한 체크
                            dbConnector.CommandClear();
                            dbConnector.Attach("TG_P_GB_CBFEW201", sCOMPANY, sKBSABUN, sNew_pwd.ToString());

                            ds_New = dbConnector.ExecuteDataSet();

                            if (ds_New != null && ds_New.Tables[0].Rows.Count > 0)
                            {
                                this.txtID.Text = sKBMAILID;
                                this.txtPWD.Text = sNew_pwd.ToString();
                            }
                            else
                            {
                                this.txtID.Text = "";
                                this.txtPWD.Text = "";
                                sERR = "ERROR";

                                //X.MessageBox.Alert("경고", fsSABUN + "/" + fsACTION + "/" + fsPWD).Show();
                                X.MessageBox.Alert("경고", "BIN 장치현황 사용권한이 없습니다.").Show();
                            }
                        }
                        else { 
                            //우선 webmaster 로그인
                            TG_BIN.Library.Svcdominoadmin Svc = new TG_BIN.Library.Svcdominoadmin("webmaster", EncryptionManager.EncryptString(System.Configuration.ConfigurationManager.AppSettings["PublicKey"].ToString(), "tyc3362"));
                            //웹서비스에서 비번 받아오기
                            this.txtPWD.Text = Svc.GetDefaultDBPath(sKBMAILID);
                            this.txtID.Text = sKBMAILID;
                        }
                    }
                }

                string sEncry_Pwd = "";

                if (sNew_ACTION.ToString() == "NEW_GW")
                {
                    sEncry_Pwd = sNew_pwd.ToString();
                }
                else
                {
                    sEncry_Pwd = EncryptionManager.EncryptString(System.Configuration.ConfigurationManager.AppSettings["PublicKey"].ToString(), this.txtPWD.Text);
                }

                if (sERR.ToString() == "")
                {
                    //UserInfo userInfo = UserInfo.GetUserInfo(sKBSABUN, EncryptionManager.EncryptString(System.Configuration.ConfigurationManager.AppSettings["PublicKey"].ToString(), this.txtPWD.Text));
                    UserInfo userInfo = UserInfo.GetUserInfo(sKBSABUN, sEncry_Pwd);
                    userInfo.UserID = this.txtID.Text;

                    this.Response.Cookies["TYPSM_EMPNO"].Value = userInfo.EmpNo;
                    this.Response.Cookies["TYPSM_EMPNO"].Expires = DateTime.Now.AddYears(10);

                    this.Session.Add("UserInfo", userInfo);

                    System.Web.Security.FormsAuthentication.SetAuthCookie(userInfo.EmpNo, true);
                    System.Web.Security.FormsAuthentication.RedirectFromLoginPage(userInfo.EmpNo, true, System.Web.Security.FormsAuthentication.FormsCookiePath);


                    TYCookie.setSABUN(userInfo.EmpNo);
                    this.Response.Cookies["SABUN"].Value = userInfo.EmpNo;
                    this.Response.Cookies["SABUN"].Expires = DateTime.Now.AddDays(2);
                    this.Response.Cookies["Gubn"].Value = "";
                    this.Response.Cookies["Gubn"].Expires = DateTime.Now.AddDays(2);
                    this.Response.Cookies["btnPage"].Value = "0";
                    this.Response.Cookies["btnPage"].Expires = DateTime.Now.AddDays(2);
                    this.Response.Cookies["BTankStat"].Value = "Hidden";
                    this.Response.Cookies["BTankStat"].Expires = DateTime.Now.AddDays(2);
                    this.Response.Cookies["TrandStat"].Value = "Hidden";
                    this.Response.Cookies["TrandStat"].Expires = DateTime.Now.AddDays(2);

                    if (sGate == "3")
                    {
                        Response.Redirect(sLinkUrl);
                    }
                    else if (sGate == "6")
                    {
                        Response.Redirect("./SiloBin/PlantsSiloBinMonitoring.aspx");
                    }
                    else
                    {
                        Response.Redirect(FormsAuthentication.DefaultUrl);
                    }
                }
                else
                {
                    X.MessageBox.Alert("경고", "BIN 장치현황 사용권한이 없습니다.").Show();
                }
            }
            else
            {
                X.MessageBox.Alert("경고", "BIN 장치현황 사용권한이 없습니다.").Show();
            }
        }

        private bool UserChk()
        {
            bool UserOk = false;

            string USERID = "", ACTION = "";

            USERID = Request.Form["SABUN"];
            ACTION = Request.Form["ACTION"];

            sNew_ACTION = Request.Form["ACTION"];
            sNew_pwd = Request.Form["PWD"];

            //USERID = "TG2018001";
            //ACTION = "NEW_GW";

            //sNew_ACTION = "NEW_GW";
            //sNew_pwd = "SnflSjIhcrTDhVF58Pnw8A==";

            fsSABUN = USERID;
            fsACTION = sNew_ACTION;
            fsPWD = sNew_pwd;

            if (ACTION == "NEW_GW")
            {
                UP_UserCheck("", USERID, "2", "");
                UserOk = true;
            }
            if (ACTION == "GROUPWARE")
            {
                UP_UserCheck("", USERID, "2", "");
                UserOk = true;
            }

            if (ACTION == "SILOBIN")
            {
                UP_UserCheck("", USERID, "6", "");
                UserOk = true;
            }

            return UserOk;
        }


        protected string GetIPAddress()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }

            return context.Request.ServerVariables["REMOTE_ADDR"];
        }

        #region CheckLogin_New - 신 그룹웨어 로그인 체크
        private void CheckLogin_New(string sID, string sPass)
        {

            password = EncryptionManager.EncryptBase64(System.Configuration.ConfigurationManager.AppSettings["PassKey"].ToString(), sPass);

            DbConnector dbConnector = new DbConnector("", "S000000001");
            dbConnector.ProcedureDirectCall();
            dbConnector.LogStatus = false;
            dbConnector.CommandClear();

            //신 그룹웨어 로그인 체크
            dbConnector.CommandClear();
            dbConnector.Attach("TG_P_GB_CBGJW212", "TYGT", sID, password.ToString());

            DataSet ds_New = dbConnector.ExecuteDataSet();

            if (ds_New != null && ds_New.Tables[0].Rows.Count > 0)
            {
                
                UP_UserCheck(sID, "", "6", "");

                UserInfo userInfo = UserInfo.GetUserInfo(sID, password);
                if (userInfo != null)
                {
                    this.Response.Cookies["TYPSM_EMPNO"].Value = userInfo.EmpNo;
                    this.Response.Cookies["TYPSM_EMPNO"].Expires = DateTime.Now.AddYears(10);

                    this.Session.Add("UserInfo", userInfo);

                    System.Web.Security.FormsAuthentication.SetAuthCookie(userInfo.EmpNo, true);
                    System.Web.Security.FormsAuthentication.RedirectFromLoginPage(userInfo.EmpNo, true, System.Web.Security.FormsAuthentication.FormsCookiePath);
                    Response.Redirect(FormsAuthentication.DefaultUrl);
                }
            }
            else
            {
                X.MessageBox.Alert("경고", "BIN장치현황 사용권한이 없습니다.").Show();
            }

        }
        #endregion
    }
}