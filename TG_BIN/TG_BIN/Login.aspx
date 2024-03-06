<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TG_BIN.Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="./LoginByDesigner/Css/Import.css" />

     <ext:XScript ID="XScript1" runat="server">
        <script type="text/javascript">
            /********************************************************************************************
            *   작성목적    : ibtLogin ClientClick 이벤트
            *   파라미터    : 
            *   수정내역    :
            ********************************************************************************************/
            function ibtLogin_ClientClick() {
                var rtnValue = true;
                if (!#{txtID}.validate() || !#{txtPWD}.validate()) {
                    Ext.Msg.alert('Error','아이디와 비밀번호를 입력하십시오.'); 
                    rtnValue = false; 
                }
                return rtnValue;
            }


            function LoginClick() {

                if (!#{txtID}.validate() || !#{txtPWD}.validate()) {
                    Ext.Msg.alert('Error','아이디와 비밀번호를 입력하십시오.'); 
                    return;
                }

                App.direct.UP_Login(#{txtID}.getValue().toString(),  #{txtPWD}.getValue().toString()  );
            }

            
          
        </script>
    </ext:XScript>

</head>
<body id="login_wrapper">
  <form id="form1" runat="server">
        <ext:ResourceManager ID="ResourceManager1" runat="server"></ext:ResourceManager>

	    <div id="login_top">
		    <img src="./Resources/Images/Login/login_logo.png" alt="" title="" />
	    </div>
	
	    <div id="login_bx">
		    <div id="login_title"><img src="./Resources/Images/Login/login_bx_title.png" alt="" title="MEMBER LOGIN" /></div>
		    <div id="login_bg" style="height:175px;">
			    <ul>
				    <li>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img src="./Resources/Images/Login/login_icon_01.png" alt="" title="id" /></td>
                                <td>
                                    <ext:TextField ID="txtID" runat="server" Width="242" Height = "35" AllowBlank="false" BlankText="아이디를 입력하세요" AutoFocus="true" >
                                        <Listeners>
                                            <SpecialKey Handler="if (e.getKey() == e.ENTER) { #{txtPWD}.focus(); }" />
                                        </Listeners>
                                    </ext:TextField>
                                </td>
                            </tr>
                        </table>
                    </li>
				    <li>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td><img src="./Resources/Images/Login/login_icon_02.png" alt="" title="password" /></td>
                                <td>
                                    <ext:TextField ID="txtPWD" runat="server" Width="242" Height = "35" InputType="Password" AllowBlank="false" BlankText="비밀번호를 입력하세요" >
                                        <Listeners>
                                            <SpecialKey Handler="if (e.getKey() == e.ENTER) { return ibtLogin_ClientClick(); } else { return false; }" />
                                        </Listeners>
                                        <DirectEvents>
                                            <SpecialKey OnEvent="txtPWD_SpecialKey">
                                                <EventMask ShowMask="true" Msg="확인중" />
                                            </SpecialKey>
                                        </DirectEvents>
                                    </ext:TextField>
                                </td>
                            </tr>
                        </table>
                    </li>
			    </ul>
			    <div><a href="#"><img src="./Resources/Images/Login/login_bt.png" alt="" title="LOGIN" onclick="LoginClick();" /></a></div>
		    </div>
	    </div>
	
	    <div id="login_bottom">
		    <img src="./Resources/Images/Login/login_copyright.gif" alt="" title="COPYRIGHT 2021 BY TAEYOUNG GRAIN TERMINAL MONITORING STSTEM" />
	    </div>
    </form>
</body>
</html>
