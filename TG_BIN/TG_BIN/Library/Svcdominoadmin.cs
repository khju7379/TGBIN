using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Data;
using System.Net;
using System.IO;
using System.Xml;
using PSM.Common.Library;

namespace TG_BIN.Library
{
    public class Svcdominoadmin : IDisposable
    {
        wsdominoadmin.wsDominoAdminElement svc;

        public Svcdominoadmin(string username, string password)
        {
            UserName = username;
            Password = EncryptionManager.DecryptString(System.Configuration.ConfigurationManager.AppSettings["PublicKey"].ToString(), password);
        }

        private byte[] iv = { 17, 29, 51, 112, 210, 78, 98, 186 };
        private byte[] key = { 57, 129, 125, 118, 233, 60, 13, 94, 153, 156, 188, 9, 109, 20, 138, 7, 31, 221, 215, 91, 241, 82, 254, 189 };

        public string UserName { get; set; }
        public string Password { get; set; }
        //public string SvcConnectionString { get; set; }

        public string DatabaseInjectionString(string str)
        {
            StringBuilder sb = new StringBuilder(str);

            sb = sb.Replace("'", "''");
            sb = sb.Replace("\\", "");
            sb = sb.Replace("--", "");
            sb = sb.Replace(";", "");

            return sb.ToString();
        }

        /// <summary>
        /// 양식목록 가져오기
        /// </summary>
        /// <returns></returns>
        public string GetDefaultDBPath(string empno)
        {
            svc = new wsdominoadmin.wsDominoAdminElement();

            CookieContainer cookies = new CookieContainer();
            // Prepare HTTP request
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create("http://gw.taeyoung.co.kr/names.nsf?login");
            request.Method = "POST";
            request.AllowAutoRedirect = false; request.ContentType = "application/x-www-form-urlencoded";
            request.CookieContainer = cookies;
            // Prepare POST body
            string post = "Username=" + UserName + "&Password=" + Password;
            byte[] bytes = Encoding.ASCII.GetBytes(post);
            // Write data to request
            request.ContentLength = bytes.Length;
            Stream streamOut = request.GetRequestStream();
            streamOut.Write(bytes, 0, bytes.Length); streamOut.Close();
            // Get response
            HttpWebResponse response = null;
            try
            {
                response = (HttpWebResponse)request.GetResponse();
                string retVal = string.Empty;

                // Check if we are authenticated properly
                if ((response.StatusCode == HttpStatusCode.Found) || (response.StatusCode == HttpStatusCode.Redirect) || (response.StatusCode == HttpStatusCode.Moved) || (response.StatusCode == HttpStatusCode.MovedPermanently))
                {
                    // Set up authentication cookie    
                    svc.CookieContainer = cookies;
                    // Perform Webservice call       
                    retVal = svc.GETUSERPASSWORD(empno);
                }
                response.Close();
                request = (HttpWebRequest)HttpWebRequest.Create("http://gw.taeyoung.co.kr/names.nsf?logout");
                request.KeepAlive = false;
                request.Method = "POST";
                request.AllowAutoRedirect = false;
                request.ContentType = "application/x-www-form-urlencoded";
                request.CookieContainer = cookies;
                response = (HttpWebResponse)request.GetResponse();
                response.Close();
                return retVal;
            }
            catch (Exception)
            {
                response.Close();
                return "";
            }
        }

        /// <summary>
        /// 사용자정보 가져오기
        /// </summary>
        /// <returns></returns>
        public DataTable GetUserInfo(string empno)
        {
            svc = new wsdominoadmin.wsDominoAdminElement();

            CookieContainer cookies = new CookieContainer();
            // Prepare HTTP request
            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create("http://gw.taeyoung.co.kr/names.nsf?login");
            request.Method = "POST";
            request.AllowAutoRedirect = false; request.ContentType = "application/x-www-form-urlencoded";
            request.CookieContainer = cookies;
            // Prepare POST body
            string post = "Username=" + UserName + "&Password=" + Password;
            byte[] bytes = Encoding.ASCII.GetBytes(post);
            // Write data to request
            request.ContentLength = bytes.Length;
            Stream streamOut = request.GetRequestStream();
            streamOut.Write(bytes, 0, bytes.Length); streamOut.Close();
            // Get response
            HttpWebResponse response = null;
            try
            {
                response = (HttpWebResponse)request.GetResponse();
                DataTable dt = new DataTable();

                // Check if we are authenticated properly
                if ((response.StatusCode == HttpStatusCode.Found) || (response.StatusCode == HttpStatusCode.Redirect) || (response.StatusCode == HttpStatusCode.Moved) || (response.StatusCode == HttpStatusCode.MovedPermanently))
                {
                    // Set up authentication cookie    
                    svc.CookieContainer = cookies;
                    // 생성할 테이블의 컬럼 정의
                    string[] columns = { "ERPMEMPNO", "COMPANYCODE", "COMPANYERPCODE" };
                    // Perform Webservice call       
                    dt = ConvertToXML(svc.GETUSERINFO(empno), columns);
                }
                response.Close();
                request = (HttpWebRequest)HttpWebRequest.Create("http://gw.taeyoung.co.kr/names.nsf?logout");
                request.KeepAlive = false;
                request.Method = "POST";
                request.AllowAutoRedirect = false;
                request.ContentType = "application/x-www-form-urlencoded";
                request.CookieContainer = cookies;
                response = (HttpWebResponse)request.GetResponse();
                response.Close();
                return dt;
            }
            catch (Exception)
            {
                response.Close();
                return null;
            }
        }

        private DataTable ConvertToXML(string xml, string[] columns)
        {
            DataSet ds = new DataSet();
            MemoryStream ms = new MemoryStream(System.Text.Encoding.UTF8.GetBytes(xml));

            ds.ReadXml(ms);

            ms.Close();
            ms.Dispose();

            return ds.Tables[0];
        }

        public void Dispose()
        {
            svc = null;
        }
    }
}