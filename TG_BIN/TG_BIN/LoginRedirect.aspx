<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginRedirect.aspx.cs" Inherits="TG_BIN.SiloBin.LoginRedirect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script type="text/javascript">
        try {

            if (this.opener != null && this.opener.GoToLogin != undefined) {
                this.opener.GoToLogin();
                this.window.close();
            }
            else if (this.parent != null && this.parent.GoToLogin != undefined) {

                this.parent.GoToLogin();
            }
            else {
                alert("로그아웃되어 로그인 페이지로 이동합니다.");
                this.GoToLogin();
            }
        }
        catch (exc) {
            this.GoToLogin();
        }

        function GoToLogin() {

            location.replace("<%=System.Web.Security.FormsAuthentication.LoginUrl %>");

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
