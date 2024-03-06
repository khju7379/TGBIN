using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PSM.Common.Library;
using System.Web;
using System.Data;
using System.Security.Cryptography;
using System.IO;

namespace PSM.Common
{
    public class PageBase : System.Web.UI.Page
    {
        ///////////////////////////////////////////////////////////////////////
        // 1. 전역변수
        ///////////////////////////////////////////////////////////////////////
        private UserInfo _psUserInfo = null;
        private bool _checkAuth = true;
        private bool _checkLogin = true;
        private DbConnector _DbConnector = null;
        private bool _LogOccur_YN = false;

        public PageBase() : base() { }

        //public string ProgramNo
        //{
        //    get
        //    {
        //        return this.GetType().Name;
        //    }
        //}

        ///////////////////////////////////////////////////////////////////////
        // 2. 멤버변수
        ///////////////////////////////////////////////////////////////////////
        /// <summary>
        /// 페이지의 권한 체크 여부
        /// </summary>
        public bool CheckAuth
        {
            get
            {
                return this._checkAuth;
            }
            set
            {
                this._checkAuth = value;
            }
        }

        /// <summary>
        /// 페이지의 로그인 체크 여부
        /// </summary>
        public bool CheckLogin
        {
            get
            {
                return this._checkLogin;
            }
            set
            {
                this._checkLogin = value;
            }
        }

        /// <summary>
        /// 현재 로그인된 사용자 정보
        /// </summary>
        public UserInfo PSUserInfo
        {
            get
            {
                return this._psUserInfo;
            }
        }

        protected DbConnector DbConnector
        {
            get
            {
                if (this._DbConnector == null)
                {
                    this.SetDbConnector();
                }

                return _DbConnector;
            }
        }

        ///////////////////////////////////////////////////////////////////////
        // 4. Overriding Method
        ///////////////////////////////////////////////////////////////////////
        #region OnPreInit - Override System.Web.UI.Page.PreInit Event
        /// <summary>
        /// Override System.Web.UI.Page.PreInit Event
        /// </summary>
        /// <param name="e"></param>
        protected override void OnPreInit(EventArgs e)
        {
            base.OnPreInit(e);        

            if (!this._checkLogin)
                return;

            // 로그인 처리
            this._psUserInfo = HttpContext.Current.Session[InternalCommon.UserInfoKey] as UserInfo;
            if (this._psUserInfo == null)
            {

                HttpContext.Current.Response.Redirect(InternalCommon.LoginRedirectUrl, true);
                return;
            }
                        

            // 사용자 페이지 권한 처리
            if (this._checkAuth)
            {
                // 각 페이지 사용자 권한 체크
                DataTable dt = Util.GetMenuData(this._psUserInfo.EmpNo);
                if (dt != null && dt.Select(string.Format("[PROGRAM_FULL_NAME] LIKE '%{0}' AND [AUTH_YN] = 'Y'", this.Request.Path)).Length > 0)
                {
                    //아놔;; TV에서 걸스데이 SomeThing 나오니깐 코딩이 안되네;;ㅋ
                }
                else
                {
                    HttpContext.Current.Response.Redirect(InternalCommon.ErrorPageUrl + "?Type=2");
                    return;
                }
            }
        }
        #endregion

        #region Description : SetDbConnector()
        private void SetDbConnector()
        {
            this._DbConnector = new DbConnector("", (this.PSUserInfo == null ? "S000000001" : this.PSUserInfo.EmpNo));
            this._DbConnector.ProcedureDirectCall();
            this._DbConnector.LogStatus = this._LogOccur_YN;
        }
        #endregion

        #region Description : string 값을 입력받아서 4자리로 변형해서 Return 해준다
        protected string Set_Fill4(string sFirst)
        {
            if (sFirst.Length == 1)
            {
                sFirst = "000" + sFirst;
            }
            else if (sFirst.Length == 2)
            {
                sFirst = "00" + sFirst;
            }
            else if (sFirst.Length == 3)
            {
                sFirst = "0" + sFirst;
            }
            else if (sFirst.Length == 4)
            {
                sFirst = sFirst;
            }
            else sFirst = "0000";

            return sFirst;
        }
        #endregion

        #region Description : string 값을 입력받아서 3자리로 변형해서 Return 해준다
        protected string Set_Fill3(string sFirst)
        {
            if (sFirst.Length == 1)
            {
                sFirst = "00" + sFirst;
            }
            else if (sFirst.Length == 2)
            {
                sFirst = "0" + sFirst;
            }
            else if (sFirst.Length == 3)
            {
                sFirst = sFirst;
            }
            else sFirst = "000";

            return sFirst;
        }
        #endregion

        #region Description : string 값을 입력받아서 2자리로 변형해서 Return 해준다
        protected string Set_Fill2(string sFirst)
        {
            if (sFirst.Length == 1)
            {
                sFirst = "0" + sFirst;
            }
            else if (sFirst.Length == 2)
            {
                sFirst = sFirst;
            }
            else sFirst = "00";

            return sFirst;
        }
        #endregion

        //==================================================================================================
        // YYYY-MM-DD형식을 YYYYMMDD형태의 string 으로 바꿔주는 메서드,,
        //==================================================================================================
        protected string Get_Date(string sStr)
        {
            if (sStr == "") return "";
            else return sStr.Replace("-", "");
        }

        protected string Set_Date(string sStr)
        {
            if (sStr.Length == 8)
            {
                sStr = sStr.Substring(0, 4) + "-" + sStr.Substring(4, 2) + "-" + sStr.Substring(6, 2);
            }
            else
            {
                sStr = "";
            }
            return sStr;
        }

        protected string Set_Time(string sStr)
        {
            if (sStr.Length == 4)
            {
                sStr = sStr.Substring(0, 2) + ":" + sStr.Substring(2, 2);
            }
            else if (sStr.Length == 6)
            {
                sStr = sStr.Substring(0, 2) + ":" + sStr.Substring(2, 2) + ":" + sStr.Substring(4, 2);
            }
            else
            {
                sStr = "";
            }
            return sStr;
        }

        #region 숫자 입력 텍스트박스는  000,000,000 형식을 000000000형태의 decimal 로 바꿔주는 메서드
        protected string Get_Numeric(string sStr)
        {
            if (sStr == "") return "0";
            else return sStr.Replace(",", "");
        }
        #endregion

        #region 암호화 복호화 함수
        public string DesEncrypt(string str)
        {
            byte[] iv = { 16, 29, 51, 112, 210, 78, 98, 186 };
            byte[] key = { 57, 129, 125, 118, 233, 60, 13, 94, 153, 156, 188, 9, 109, 20, 138, 7, 31, 221, 215, 91, 241, 82, 254, 189 };

            string encryptStr = string.Empty;

            byte[] bytIn = null;
            byte[] bytOut = null;
            MemoryStream ms = null;
            TripleDESCryptoServiceProvider tcs = null;
            ICryptoTransform ct = null;
            CryptoStream cs = null;

            try
            {

                bytIn = System.Text.Encoding.UTF8.GetBytes(str);

                ms = new MemoryStream();

                tcs = new TripleDESCryptoServiceProvider();

                ct = tcs.CreateEncryptor(key, iv);

                cs = new CryptoStream(ms, ct, CryptoStreamMode.Write);

                cs.Write(bytIn, 0, bytIn.Length);

                cs.FlushFinalBlock();

                bytOut = ms.ToArray();

                encryptStr = System.Convert.ToBase64String(bytOut, 0, bytOut.Length);
            }
            catch (Exception ex)
            {
            }
            finally
            {
                if (cs != null) { cs.Clear(); cs = null; }
                if (ct != null) { ct.Dispose(); ct = null; }
                if (tcs != null) { tcs.Clear(); tcs = null; }
                if (ms != null) { ms = null; }
            }

            return encryptStr;

        }

        //복호화
        public string DesDecrypt(string str)
        {
            byte[] iv = { 16, 29, 51, 112, 210, 78, 98, 186 };
            byte[] key = { 57, 129, 125, 118, 233, 60, 13, 94, 153, 156, 188, 9, 109, 20, 138, 7, 31, 221, 215, 91, 241, 82, 254, 189 };

            string decryptStr = string.Empty;

            byte[] bytIn = null;
            MemoryStream ms = null;
            TripleDESCryptoServiceProvider tcs = null;
            CryptoStream cs = null;
            ICryptoTransform ct = null;
            StreamReader sr = null;

            try
            {

                bytIn = System.Convert.FromBase64String(str);
                ms = new MemoryStream(bytIn, 0, bytIn.Length);
                tcs = new TripleDESCryptoServiceProvider();
                ct = tcs.CreateDecryptor(key, iv);
                cs = new CryptoStream(ms, ct, CryptoStreamMode.Read);
                sr = new StreamReader(cs);

                decryptStr = sr.ReadToEnd();

            }
            catch (Exception ex)
            {
            }
            finally
            {
                if (sr != null) { sr.Close(); sr = null; }
                if (cs != null) { cs.Clear(); cs = null; }
                if (ct != null) { ct.Dispose(); ct = null; }
                if (tcs != null) { tcs.Clear(); tcs = null; }
                if (ms != null) { ms.Close(); ms = null; }
            }

            return decryptStr;
        }
        #endregion

    }

}
