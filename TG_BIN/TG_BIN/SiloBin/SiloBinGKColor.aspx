<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinGKColor.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinGKColor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">
    <ext:XScript ID="XScript2" runat="server">
        <script type="text/javascript">

            function SetTextFocus(value) {             
             
             switch (value) {
                    case 1:
                        #{txtCBINNO}.focus();
                        break;
                    case 2:
                        #{txtCCAPA}.focus();
                        break;
                }
            }

            function GetSelectedDatas() {
                var rtnValue = "";
                var obj = #{grdSelect};
                if(obj.selected.items.length > 0) {
                    rtnValue +=  obj.selected.items[0].data.GGOKJONG  + "^/^";
                }                
                return rtnValue;
            } 

            function btnMSave_Click(){              

                var record = #{stoBinGKColor}.data.items;
                var GGOKJONG = "";
                var GCOLOR = "";
                
                for(var i = 0; i < record.length; i++)
                {   
                    if(i == 0)
                    {   
                        GGOKJONG = record[i].data.GGOKJONG;
                        GCOLOR = record[i].data.GCOLOR;
                    }
                    else
                    {
                        GGOKJONG += "," + record[i].data.GGOKJONG;
                        GCOLOR += "," + record[i].data.GCOLOR;
                    }
                }
                Ext.Msg.confirm('확인', '저장 하시겠습니까?', function(btn, text){
                    if(btn == 'yes'){
                        Ext.net.DirectMethod.request('btnMSave_Click', {
                        url: location.href,
                        params: {GGOKJONG : GGOKJONG, 
                                 GCOLOR : GCOLOR
                                 }
                        });
                    }
                });

                
            }
            
            var colorRenderer = function(value, metadata) {
                metadata.style = 'background-color:#' + value + ';';
                return value;
            }    

            function trgP_CODE_ClientTriggerClick(gubn) {

                // IE 전용 시작
                //var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=GK&param2=" + encodeURI(#{txtGGOKJONG}.getValue()), null, "dialogWidth=500px; dialogHeight=400px;");
            
                //if(result != null && result != undefined) {
                //    #{txtGGOKJONG}.setValue(result.CDCODE);
                //    #{txtGGOKJONGNM}.setValue(result.CDDESC1);
                //}
                // IE 전용 끝

                // 크롬, 엣지 시작
                result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=GK&param2=" + encodeURI(#{txtGGOKJONG}.getValue()), null, "dialogWidth:500px; dialogHeight:400px;");
                // 크롬, 엣지 끝
            }

            function showModalDialogCallback(result) {

                if (result) {
                    #{txtGGOKJONG}.setValue(result.CDCODE);
                    #{txtGGOKJONGNM}.setValue(result.CDDESC1);
                }

            }

            function UP_GokjongCheck(item){           
                var obj = null;
                obj = item.value;
           
                if (obj != null &&  obj.length == 2) {
                    Ext.net.DirectMethod.request('UP_GOKJONGChange', {
                        url: location.href,
                        params: {GOKJONG : obj}
                        });
                }
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
                    <ext:Store ID="stoBinGKColor" runat="server">
                        <Model>
                            <ext:Model ID="Model5" runat="server">
                                <Fields>
                                    <ext:ModelField Name="GGOKJONG"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="GGOKJONGNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="GCOLOR"  Type="String"></ext:ModelField>
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column ID="Column1" runat="server" DataIndex="GGOKJONG" Text="곡종" Align="Left" Width="100">
                        </ext:Column>
                        <ext:Column ID="Column2" runat="server" DataIndex="GGOKJONGNM" Text="곡종명" Align="Left" Width="100">
                        </ext:Column>
                        <ext:ComponentColumn ID="ComponentColumn2" runat="server" DataIndex="GCOLOR" Text="색상" Width="110"  Editor="true" Sortable="false" >
                            <Renderer Fn="colorRenderer"/>
                            <Component>
                                <ext:DropDownField ID="DropDownField1" runat="server" Editable="false" MatchFieldWidth="False">
	                                <Component>
		                                <ext:Panel ID="Panel7" runat="server" Width="200" Height="120">
			                                <Items>
				                                <ext:ColorPicker ID="ColorPicker2" runat="server">
					                                <Listeners>
						                                <Select Handler="item.ownerCt.dropDownField.setValue(color);"/>
                                                        <Blur Handler="" />
					                                </Listeners>
				                                </ext:ColorPicker>
			                                </Items>
		                                </ext:Panel>
	                                </Component>
                                </ext:DropDownField>                                                                      
                            </Component>
                        </ext:ComponentColumn>
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
    <ext:Window ID="BoradColorPop" runat="server" CloseAction="Hide" Hidden="true" width="630" Modal="true" AutoScroll="false" Constrain="true">
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
                                <ext:ColorMenu ID="ColorMenu1" runat="server"></ext:ColorMenu>
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
                                        <Click Handler="#{BoradColorPop}.hide();" />
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
                    Height="40" 
                    border="false"
                    DefaultAnchor = "100%" >
                    <Items>
                           <ext:Panel ID="Panel3" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                     <ext:TriggerField ID="txtGGOKJONG" runat = "server" Margins="2 1 0 10" FieldLabel = "곡종" width = "90" LabelWidth ="35" MaxLength ="2" EnforceMaxLength ="true" TabIndex = "16" EnableKeyEvents ="true" >
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(2);"></TriggerClick>
                                            <Change  Handler = "UP_GokjongCheck(item);"></Change>
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:TextField ID="txtGGOKJONGNM" runat="server" Width="140" Margins="2 1 0 0" readonly="true" FieldStyle="background-color:#E5E5E5;"> </ext:TextField>
                                    <ext:DropDownField ID="txtGKCOLOR" runat="server" Editable="false" MatchFieldWidth="False" FieldLabel="색상" LabelWidth="35" Margins="2 1 0 10">
	                                <Component>
		                                <ext:Panel ID="Panel4" runat="server" Width="200" Height="120">
			                                <Items>
				                                <ext:ColorPicker ID="ColorPicker1" runat="server">
					                                <Listeners>
						                                <Select Handler="item.ownerCt.dropDownField.setValue(color);"/>
					                                </Listeners>
				                                </ext:ColorPicker>
			                                </Items>
		                                </ext:Panel>
	                                </Component>
                                </ext:DropDownField>                                                                      
                                 </Items>
                           </ext:Panel>
                    </Items>
                </ext:Panel>
        </Items>
    </ext:Window>

</asp:Content>

