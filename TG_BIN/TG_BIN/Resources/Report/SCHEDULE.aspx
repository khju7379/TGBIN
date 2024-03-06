<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SCHEDULE.aspx.cs" Inherits="TG_BIN.Resources.Report.SCHEDULE" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <ext:Panel 
                    runat="server" 
                    Region="North"
                    Margins="0 0 5 5"
                    Title="SCHEDULE 출력" 
                    Height="60" 
                    BodyPadding="1"
                    Frame="true"
                    Width="955">
        <Buttons>
                <ext:Button ID="btnCLO" runat="server" Text="닫기" Icon = "Decline" >
                    <Listeners>
                        <Click Handler="self.close();" />
                    </Listeners>
                </ext:Button>                         
        </Buttons>
    </ext:Panel>
    <ext:Panel  Width="955">
        <Items>
            <form id="form1" runat="server">
            <div>
                <ext:ResourceManager ID="rsmMain" runat="server" />
                <activereportsweb:WebViewer ID="arvMain" runat="server" Width="955" height="660" ViewerType="AcrobatReader"  >
                    <PdfExportOptions ExportBookmarks="True" HideMenubar="true" ConvertMetaToPng="False"
                        DisplayTitle="False" ImageResolution="0" Title="" Author="" Encrypt="False" OwnerPassword=""
                        NeverEmbedFonts="Arial;Courier New;Times New Roman" Keywords="" HideWindowUI="False"
                        CenterWindow="False" FitWindow="False" HideToolbar="False" DisplayMode="None"
                        Application="GrapeCity ActiveReports (tm) 6" Version="Pdf13" Use128Bit="True"
                        UserPassword="" ImageQuality="Medium" Permissions="AllowPrint, AllowModifyContents, AllowCopy, AllowModifyAnnotations, AllowFillIn, AllowAccessibleReaders, AllowAssembly"
                        Subject="" >
                    </PdfExportOptions>
                </activereportsweb:WebViewer>
                
            </div>
            </form>
        </Items>
    </ext:Panel>
</body>
</html>
