using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PSM.Common.Library
{
    internal class InternalCommon
    {
        public static string SystemCode
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings.Get("SystemCode");
            }
        }

        public static string LoginRedirectUrl
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings.Get("LoginRedirectUrl");
            }
        }

        public static string ErrorPageUrl
        {
            get
            {
                return System.Configuration.ConfigurationManager.AppSettings.Get("ErrorPageUrl");
            }
        }

        public static string UserInfoKey
        {
            get { return "UserInfo"; }
        }
    }
}
