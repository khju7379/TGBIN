using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PSM.Common.Library;
using System.Data;

namespace PSM.Common
{
    public class UserInfo
    {
        private string _empNo;
        private string _userID;
        private string _userPW;
        private string _userName;
        private string _deptCode;
        private string _deptName;
        public string EmpNo { get { return this._empNo; } }
        public string UserID { get { return this._userID; } set { this._userID = value; } }
        public string UserPW { get { return this._userPW; } }
        public string UserName { get { return this._userName; } }
        public string DeptCode { get { return this._deptCode; } }
        public string DeptName { get { return this._deptName; } }


        private UserInfo(string empNo, string userID, string userPW, string userName, string deptCode, string deptName)
        {
            this._empNo = empNo;
            this._userID = userID;
            this._userPW = userPW;
            this._userName = userName;
            this._deptCode = deptCode;
            this._deptName = deptName;

        }

        public static UserInfo GetUserInfo(string userID, string passWord)
        {
            UserInfo rtnValue = null;

            string empNo = null;
            string userName = null;
            string deptCode = null;
            string deptName = null;

            DataTable dt = null;

            DbConnector dbConnector = new DbConnector("", "S000000001");
            dbConnector.ProcedureDirectCall();
            dbConnector.LogStatus = false;

            dbConnector.CommandClear();
            dbConnector.Attach("TGQ0000003", userID, InternalCommon.SystemCode);
            dt = dbConnector.ExecuteDataTable();

            if (dt != null && dt.Rows.Count > 0)
            {
                empNo = Convert.ToString(dt.Rows[0]["EMP_NO"]);
                userName = Convert.ToString(dt.Rows[0]["USER_NAME"]);

                //사번 길이 OverFlow로 인한 오류 예외처리
                try
                {   
                    dbConnector.CommandClear();
                    dbConnector.Attach("TG_P_AC_43K2P876", empNo.Trim());
                    dt = dbConnector.ExecuteDataTable();
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        deptCode = Convert.ToString(dt.Rows[0]["KBBUSEO"]);
                        deptName = Convert.ToString(dt.Rows[0]["KBBUSEONM"]);
                    }
                }
                catch
                {
                    deptCode = "";
                    deptName = "";
                }

                rtnValue = new UserInfo(empNo, userID, passWord, userName, deptCode, deptName);
            }

            return rtnValue;
        }
    }
}
