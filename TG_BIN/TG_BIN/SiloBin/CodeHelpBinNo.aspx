<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="CodeHelpBinNo.aspx.cs" Inherits="TG_BIN.SiloBin.CodeHelpBinNo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">
    <ext:XScript ID="XScript1" runat="server">
        <script type="text/javascript">

            function grdCode_CellClick(item, td, cellIndex, record, tr, rowIndex, e) {
                // IE 전용 시작
                //window.returnValue = record.data;
                //window.close();
                // IE 전용 끝

                // 크롬, 엣지 시작
                window.opener.showModalDialogCallback(record.data);
                window.close();
                // 크롬, 엣지 끝
            }

        </script>
    </ext:XScript>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">
    <ext:Hidden ID="hidCDINDEX" runat="server"></ext:Hidden>
    <ext:Hidden ID="hidCDCODE" runat="server"></ext:Hidden>
    <ext:Viewport ID="vptMain" runat="server" Layout="BorderLayout">
        <Items>
             <ext:GridPanel ID="grdCodeList" runat="server" Title="BIN 번호 조회" Icon="Money" Region="Center">
                    <TopBar>
                        <ext:Toolbar ID="Toolbar1" runat="server">
                            <Items>
                                <ext:TextField ID="txtCDCODE" runat="server" FieldLabel="BIN 번호" LabelWidth="55"  Width = "200" LabelAlign="Left"></ext:TextField>
                                <ext:ToolbarSpacer Flex = "1" ></ext:ToolbarSpacer>
                                <ext:ToolbarSeparator ID="ToolbarSeparator1" runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnSearch" runat="server" Text="조회" Icon="Find">
                                    <DirectEvents>
                                        <Click OnEvent="btnSearch_Click">                                            
                                            <EventMask ShowMask="true" Target="CustomTarget" Msg="데이터를 불러오고 있습니다" CustomTarget="#{grdCodeList}" />
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator2"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnClose" runat="server" Icon="Decline" Text="닫기">
                                   <Listeners>
                                       <Click Handler="self.close();" />
                                   </Listeners>
                                </ext:Button>
                            </Items>
                        </ext:Toolbar>                        
                    </TopBar>                                        
                    <Store>
                        <ext:Store ID="stoGrid" runat="server">
                            <Model>
                                <ext:Model ID="Model1" runat="server">
                                    <Fields>
                                        <ext:ModelField Name="BCBINNO" Type="String"></ext:ModelField>
                                        <ext:ModelField Name="BCGROUP" Type="String"></ext:ModelField>
                                        <ext:ModelField Name="BCCAPA" Type="String"></ext:ModelField>
                                    </Fields>
                                </ext:Model>
                            </Model>
                        </ext:Store>
                    </Store>
                    <ColumnModel>
                        <Columns>
                            <ext:Column ID="Column1"  runat="server" DataIndex="BCBINNO" Width="100" Text="BIN 번호"></ext:Column>
                            <ext:Column ID="Column2"  runat="server" DataIndex="BCGROUP" Width="100" Text="그룹"></ext:Column>
                            <ext:Column ID="Column3"  runat="server" DataIndex="BCCAPA" Flex= "1" Text="저장량"></ext:Column>
                        </Columns>
                    </ColumnModel>
                    <Listeners>
                        <CellClick Handler="grdCode_CellClick(item, td, cellIndex, record, tr, rowIndex, e);"></CellClick>
                    </Listeners>
                    <SelectionModel>
                        <ext:RowSelectionModel ID="rselCode" runat="server"></ext:RowSelectionModel>
                    </SelectionModel>         
                    <BottomBar>
                         <ext:Toolbar ID="Toolbar2" runat="server">
                              <Items>
                                  <ext:ToolbarTextItem ID="TbarText" runat="server" Text="" />
                              </Items>
                         </ext:Toolbar>                    
                    </BottomBar>                               
                </ext:GridPanel>
        </Items>
    </ext:Viewport>
</asp:Content>

