<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinManager.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">

   <link rel="Stylesheet" href="../Resources/Styles/SiloBin.css" />
    
    <ext:XScript ID="XScript1" runat="server">
        <script type="text/javascript">

            function fn_OpenPop(url, id, w, h) {
                if (url == "" || url == null || url == undefined) return;

                w = (w == undefined || w == null) ? 600 : w;
                h = (h == undefined || h == null) ? 400 : h;

                var strLeft = (window.screen.width - w) / 2;
                var strTop = (window.screen.height - h) / 2;

                var feat = "toolbar=0,location=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=" + w + ",height=" + h + ",top=" + strTop + ",left=" + strLeft;

                var win = window.open(url, id, feat);
                win.focus();
            }

        </script>
    </ext:XScript>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">
    <ext:Viewport ID="vptMain" runat="server" Layout= "BorderLayout" >
        <Items>
            <ext:TabPanel ID="tpnPage" runat="server" Region="Center" Border="true" Padding="3" >
                <Items>
                   <ext:Panel ID="pnlMain" runat="server" Title="특기사항" Border="true" Padding="2"  AutoScroll="true">
                       <Loader ID="Loader2" runat="server" Url="../SiloBin/SiloBinBoardSpc.aspx" Mode="Frame">
                         <LoadMask ShowMask="true"></LoadMask>
                       </Loader>
                   </ext:Panel>
                </Items>

                <Items>
                    <ext:Panel ID="pnlSchedule" runat="server" Region="Center" Title="입항/하역계획" Border="true" Padding="2"  AutoScroll="true">
                          <Loader ID="Loader8" runat="server" Url="../SiloBin/SiloBinSchedule.aspx" Mode="Frame">
                             <LoadMask ShowMask="true"></LoadMask>
                         </Loader>
                    </ext:Panel>
                </Items>

                <Items>
                    <ext:Panel ID="Panel5" runat="server" Region="Center" Title="하역작업일지 " Border="true" Padding="2"  AutoScroll="true">
                                <Loader ID="Loader4" runat="server" Url="../SiloBin/SiloBinSHipDoc.aspx" Mode="Frame">
                                  <LoadMask ShowMask="true"></LoadMask>
                                </Loader>
                    </ext:Panel>
                </Items>

                <Items>
                    <ext:Panel ID="Panel3" runat="server" Region="Center" Title="BIN 이고관리 " Border="true" Padding="2"  AutoScroll="true">
                                <Loader ID="Loader3" runat="server" Url="../SiloBin/SiloBinMove.aspx" Mode="Frame">
                                  <LoadMask ShowMask="true"></LoadMask>
                                </Loader>
                    </ext:Panel>
                </Items>

                <Items>
                    <ext:Panel ID="Panel2" runat="server" Region="Center" Title="카길이송일지 " Border="true" Padding="2"  AutoScroll="true">
                                <Loader ID="Loader5" runat="server" Url="../SiloBin/SiloBinCargill.aspx" Mode="Frame">
                                  <LoadMask ShowMask="true"></LoadMask>
                                </Loader>
                    </ext:Panel>
                </Items>

                <Items>
                    <ext:Panel ID="Panel1" runat="server" Region="Center" Title="BIN 클리닝" Border="true" Padding="2"  AutoScroll="true">
                                <Loader ID="Loader1" runat="server" Url="../SiloBin/SiloBinClean.aspx" Mode="Frame">
                                  <LoadMask ShowMask="true"></LoadMask>
                                </Loader>
                    </ext:Panel>
                </Items>
                           
                <Items>
                    <ext:Panel ID="Panel9" runat="server" Region="Center" Title="BIN 상태관리 " Border="true" Padding="2" AutoScroll="true">
                                <Loader ID="Loader6" runat="server" Url="../SiloBin/SiloBinStatus.aspx" Mode="Frame">
                                <LoadMask ShowMask="true"></LoadMask>
                                </Loader>
                    </ext:Panel>
                </Items>

                <Items>
                    <ext:Panel ID="Panel11" runat="server" Region="Center" Title="BIN 용량관리 " Border="true" Padding="2"  AutoScroll="true">
                                <Loader ID="Loader7" runat="server" Url="../SiloBin/SiloBinCapa.aspx" Mode="Frame">
                                  <LoadMask ShowMask="true"></LoadMask>
                                </Loader>
                    </ext:Panel>
                </Items>

                <Items>
                    <ext:Panel ID="Panel13" runat="server" Region="Center" Title="곡종별 색상관리 " Border="true" Padding="2"  AutoScroll="true">
                                <Loader ID="Loader9" runat="server" Url="../SiloBin/SiloBinGKColor.aspx" Mode="Frame">
                                  <LoadMask ShowMask="true"></LoadMask>
                                </Loader>
                    </ext:Panel>
                </Items>

                <Plugins>
                    <ext:TabCloseMenu ID="tcmTabClose" runat="server"></ext:TabCloseMenu>
                </Plugins>
            </ext:TabPanel>
        </Items>
    </ext:Viewport>

</asp:Content>