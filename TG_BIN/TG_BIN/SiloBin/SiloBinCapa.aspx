<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinCapa.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinCapa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">
    <ext:XScript ID="XScript2" runat="server">
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

            function SetTextFocus(value) {             
             
             switch (value) {
                    case 1:
                        #{txtBCBINNO}.focus();
                        break;
                    case 2:
                        #{txtBCCAPA}.focus();
                        break;
                }
            }

            function GetSelectedDatas() {
                var rtnValue = "";
                var obj = #{grdSelect};
                if(obj.selected.items.length > 0) {
                    rtnValue +=  obj.selected.items[0].data.BCBINNO  + "^/^";
                }                
                return rtnValue;
            } 

            function btnMSave_Click(){              

                var record = #{stoBinCapa}.data.items;
                var BCBINNO = "";
                var BCCAPA = "";
                var BCYONGJUCK = "";
                
                for(var i = 0; i < record.length; i++)
                {   
                    if(i == 0)
                    {   
                        BCBINNO = record[i].data.BCBINNO;
                        BCCAPA = record[i].data.BCCAPA;
                        BCYONGJUCK = record[i].data.BCYONGJUCK;
                    }
                    else
                    {
                        BCBINNO += "," + record[i].data.BCBINNO;
                        BCCAPA += "," + record[i].data.BCCAPA;
                        BCYONGJUCK += "," + record[i].data.BCYONGJUCK;
                    }
                }
                Ext.Msg.confirm('확인', '저장 하시겠습니까?', function(btn, text){
                    if(btn == 'yes'){
                        Ext.net.DirectMethod.request('btnMSave_Click', {
                        url: location.href,
                        params: {BCBINNO : BCBINNO, 
                                 BCCAPA : BCCAPA,
                                 BCYONGJUCK : BCYONGJUCK
                                 }
                        });
                    }
                });

                
            }

          

        </script>
    </ext:XScript>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">
    <ext:Viewport ID="vptBinCapa" runat="server" Layout="BorderLayout">
        <Items>
            <ext:GridPanel ID="grdBinMove" runat="server" Region="Center" >
                <TopBar>
                    <ext:Toolbar ID="Toolbar3" runat="server">
                        <Items>
                            <ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:ComboBox ID="cboGROUP" runat="server" Editable="false" FieldLabel="그룹" LabelWidth="30" width="120">
                                <Items>
                                    <ext:ListItem Text="전체" Value="A" />
                                    <ext:ListItem Text="1" Value="1" />
                                    <ext:ListItem Text="2" Value="2" />
                                    <ext:ListItem Text="3" Value="3" />
                                    <ext:ListItem Text="0" Value="0" />
                                </Items>
                                <SelectedItems>
                                    <ext:ListItem Text="전체" Value="A"></ext:ListItem>
                                </SelectedItems>
                            </ext:ComboBox>
                            <ext:ToolbarSpacer ID="ToolbarSpacer9" runat="server" Width="15"></ext:ToolbarSpacer>
                            <ext:TextField ID="txtBINNO" runat="server" FieldLabel="BIN번호" LabelWidth="60" Width="150"></ext:TextField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="15"></ext:ToolbarSpacer>
                            <ext:ComboBox ID="cboCORPGB" runat="server" Editable="false" FieldLabel="회사구분" LabelWidth="60" width="180">
                                <Items>
                                    <ext:ListItem Text="전체" Value="A" />
                                    <ext:ListItem Text="그레인터미널" Value="T" />
                                    <ext:ListItem Text="평택싸이로" Value="P" />
                                </Items>
                                <SelectedItems>
                                    <ext:ListItem Text="전체" Value="A"></ext:ListItem>
                                </SelectedItems>
                            </ext:ComboBox>
                            <ext:ToolbarFill ID="ToolbarFill3" runat="server"></ext:ToolbarFill>
                            <ext:ToolbarSeparator ID="ToolbarSeparator2"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="Button4" runat="server" Icon="Find" Text="조회">
                                <DirectEvents>
                                    <Click OnEvent="btnFind_Click">
                                        <EventMask ShowMask="true" Msg="조회중..." Target="CustomTarget" CustomTarget="#{vptBinCapa}"></EventMask>
                                    </Click>
                                </DirectEvents>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator6"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="Button3" runat="server" Icon="Add" Text="신규">
                                <DirectEvents>
                                    <Click OnEvent="btnNew_Click">                                   
                                    </Click>
                                </DirectEvents>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="tsMSave"  runat="server" hidden="true"></ext:ToolbarSeparator>
                            <ext:Button ID="btnMSave" runat="server" Text="저장" Icon="DatabaseSave" hidden="true" >
                                <Listeners>
                                    <Click Fn="btnMSave_Click"></Click>
                                </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator1"  runat="server"></ext:ToolbarSeparator>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Store>
                    <ext:Store ID="stoBinCapa" runat="server">
                        <Model>
                            <ext:Model ID="Model5" runat="server">
                                <Fields>
                                    <ext:ModelField Name="BCBINNO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="BCGROUP"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="BCLCGUBN"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="BCCAPA"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="BCYONGJUCK"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="BCCORPGUBN"  Type="String"></ext:ModelField>
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column ID="Column1" runat="server" DataIndex="BCBINNO" Text="BIN번호" Align="Left" Width="100">
                        </ext:Column>
                        <ext:Column ID="Column2" runat="server" DataIndex="BCGROUP" Text="그룹" Align="Left" Width="100">
                        </ext:Column>
                        <ext:Column ID="Column3" runat="server" DataIndex="BCLCGUBN" Text="위치구분" Align="Left" Width="100" >
                        </ext:Column>
                        <ext:ComponentColumn ID="ComponentColumn1" runat="server" DataIndex="BCCAPA" Text="저장량" Align="Right" Width="130"  Editor="true" Sortable="false">
                            <Renderer Handler="return FormatNoZero(value, '0,000.000');" ></Renderer>
                            <Component>           
                                    <ext:TextField ID="TextField1"  FieldStyle="text-align:right;" runat ="server" >
                                        <Listeners>                                                                                        
                                            <Focus Handler ="this.selectText();"></Focus>
                                        </Listeners>                                           
                                    </ext:TextField>
                            </Component>
                        </ext:ComponentColumn>
                        <ext:ComponentColumn ID="ComponentColumn2" runat="server" DataIndex="BCYONGJUCK" Text="용적(㎥)" Align="Right" Editor="true" Width="130" Sortable="false">
                            <Renderer Handler="return FormatNoZero(value, '0,000.00');" ></Renderer>
                            <Component>           
                                    <ext:TextField ID="TextField2"  FieldStyle="text-align:right;" runat ="server" >
                                        <Listeners>                                                                                        
                                            <Focus Handler ="this.selectText();"></Focus>
                                        </Listeners>                                           
                                    </ext:TextField>
                            </Component>
                        </ext:ComponentColumn>
                        <ext:Column ID="Column4" runat="server" DataIndex="BCCORPGUBN" Text="회사구분" Align="Left" Width="100" >
                        </ext:Column>
                    </Columns>
                </ColumnModel>
                <DirectEvents>
                    <CellDblClick OnEvent="grdList_CellClick">
                        <ExtraParams>
                            <ext:Parameter Mode="Raw" Name="DATAS" Value="GetSelectedDatas()"></ext:Parameter>
                        </ExtraParams>
                    </CellDblClick>
                </DirectEvents>
                <SelectionModel>
                    <ext:RowSelectionModel ID="grdSelect" runat="server" Mode="Single"></ext:RowSelectionModel>
                </SelectionModel>
            </ext:GridPanel>         
        </Items>
    </ext:Viewport>    
    <%--팝업--%>
    <ext:Window ID="BoradCapaPop" runat="server" CloseAction="Hide" Hidden="true" width="630" Modal="true" AutoScroll="false" Constrain="true">
        <Items>
            <ext:Panel ID="Panel1" 
                    runat="server" 
                    Region="North"
                    Height="40" 
                    border="false">
                    <TopBar>
                        <ext:Toolbar ID="Toolbar1" runat="server">
                            <Items>
                                <ext:ToolbarFill ID="ToolbarFill1" runat="server"></ext:ToolbarFill>
                                <ext:ToolbarSeparator ID="ToolbarSeparator3"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnAdd" runat="server" Text="신규" Icon="Add"  >
                                    <DirectEvents>
                                        <Click OnEvent="btnWinNew_Click"></Click>
                                    </DirectEvents>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator4"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnSave" runat="server" Text="저장" Icon="DatabaseSave"  >
                                    <DirectEvents>
                                        <Click OnEvent="btnSave_Click"></Click>
                                    </DirectEvents>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator7"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnDel" runat="server" Text="삭제" Icon="Delete"  >
                                        <DirectEvents>
                                            <Click OnEvent="btnDel_Click">
                                                <Confirmation ConfirmRequest="true" Title="확인" Message="삭제하시겠습니까?"></Confirmation> 
                                            </Click>
                                        </DirectEvents>
                                    </ext:Button>
                                    <ext:ToolbarSeparator ID="ToolbarSeparator8"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnClose" runat="server" Text="닫기" Icon="Decline"  >
                                    <Listeners>
                                        <Click Handler="#{BoradCapaPop}.hide();" />
                                    </Listeners>
                                </ext:Button>         
                                <ext:ToolbarSeparator ID="ToolbarSeparator5"  runat="server"></ext:ToolbarSeparator>
                            </Items>
                        </ext:Toolbar>
                    </TopBar>
                    <Buttons>
                                         
                    </Buttons>
                </ext:Panel>                      
                <ext:Panel ID="Panel2"
                    runat="server" 
                    Region="Center"
                    Height="200" 
                    border="false"
                    DefaultAnchor = "100%" >
                    <Items>                        
                           <ext:Panel ID="Panel4"  runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                     <ext:TextField ID="txtBCBINNO" runat="server" FieldLabel="BIN번호"  LabelWidth ="60" Width = "160" Margins="0 10 0 0"></ext:TextField>
                                 </Items>
                           </ext:Panel>                                                                       
                           <ext:Panel ID="Panel3" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                     <ext:ComboBox ID="cboBCGROUP" runat="server" Editable="false" FieldLabel="그룹" LabelWidth="60" width="160" Margins="0 10 0 0">
                                        <Items>
                                            <ext:ListItem Text="1" Value="1" />
                                            <ext:ListItem Text="2" Value="2" />
                                            <ext:ListItem Text="3" Value="3" />
                                            <ext:ListItem Text="0" Value="0" />
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="1" Value="1"></ext:ListItem>
                                        </SelectedItems>
                                    </ext:ComboBox>
                                    <ext:ComboBox ID="cboBCLCGUBN" runat="server" Editable="false" FieldLabel="위치구분" LabelWidth="60" width="160" Margins="0 10 0 0">
                                        <Items>
                                            <ext:ListItem Text="R" Value="R" />
                                            <ext:ListItem Text="S" Value="S" />
                                            <ext:ListItem Text="E" Value="E" />
                                            <ext:ListItem Text="없음" Value="A" />
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="R" Value="R"></ext:ListItem>
                                        </SelectedItems>
                                    </ext:ComboBox>
                                 </Items>
                           </ext:Panel>
                           <ext:Panel ID="Panel5" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:TextField ID="txtBCCAPA" runat="server" FieldLabel="저장량" FieldStyle="text-align:right;" LabelWidth ="60" Width = "160" Margins="0 10 0 0" ></ext:TextField>
                                    <ext:TextField ID="txtBCYONGJUCK" runat="server" FieldLabel="용적(㎥)" FieldStyle="text-align:right;" LabelWidth ="60" Width = "160" Margins="0 10 0 0" ></ext:TextField>
                                 </Items>
                           </ext:Panel> 
                           <ext:Panel ID="Panel6" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:TextField ID="txtBCCORPGUBN" runat="server" FieldLabel="회사구분" FieldStyle="text-align:right;" LabelWidth ="60" Width = "160" ReadOnly = "true" Margins="0 10 0 0" ></ext:TextField>
                                 </Items>
                           </ext:Panel> 
                    </Items>
                </ext:Panel>
        </Items>
    </ext:Window>
</asp:Content>