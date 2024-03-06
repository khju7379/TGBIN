<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinBoardSpc.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinBoardSpc" %>

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

            function command_ProcRenderer(command, record) {

                if (record.data.SPENDGUBN == 'N') {
                    command.hidden = false;
                }
                else {
                    command.hidden = true;
                }

            }

            function SetTextFocus(value) {             
             
             switch (value) {
                    case 1:
                        #{dtpSPDATE}.focus();
                        break;
                    case 2:
                        #{txtSPMEMO}.focus();
                        break;
                    case 3:
                        #{dtpSPUPDATE}.focus();
                        break;
                    case 4:
                        #{dtpSPDOWNDATE}.focus();
                        break;
                    case 5:
                        #{dtpSDATE}.focus();
                        break;
                    default:
                        #{dtpEDATE}.focus();
                        break;
                }
            }

            function GetSelectedDatas() {
                var rtnValue = "";
                var obj = #{grdSelect};
                if(obj.selected.items.length > 0) {
                    rtnValue +=  obj.selected.items[0].data.SPDATE + "^;^" + obj.selected.items[0].data.SPSEQ + "^/^";
                }                
                return rtnValue;
            } 

            function grdList_ProcCommand(item, command, record, recordIndex, cellIndex)
            {
                Ext.Msg.confirm('확인', '게시종료 하시겠습니까?', function(btn, text){
                    if(btn == 'yes'){
                        Ext.net.DirectMethod.request('btnProc_Click', {
                        url: location.href,
                        params: { SPDATE : record.data.SPDATE, SPSEQ : record.data.SPSEQ, SPMEMO: record.data.SPMEMO.replace(/<br>/g,"\n"), SPUPDATE: record.data.SPUPDATE,
                                  SDATE : Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd'), EDATE : Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd'), GUBN: #{cboGUBN}.getValue()}
                        });
                    }
                });
            }

            /********************************************************************************************
            *   작성목적    :  구분 선택 이벤트
            *   수정내역    :
            ********************************************************************************************/
            function GUBN_Select(){
                
                var GUBN = #{cboGUBN}.getValue().toString();
                var SDATE = Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd');
                var EDATE = Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd');

                if(GUBN == "N")
                {
                    #{dtpSDATE}.setValue("");
                    #{dtpEDATE}.setValue("");
                }
                else
                {   
                    if(SDATE == "" || EDATE == "")
                    {   
                        var dt = new Date();
                        
                        #{dtpSDATE}.setValue(dt.getFullYear() + "-" + Fill2(dt.getMonth() - 2) + "-" + dt.getDate());
                        
                        #{dtpEDATE}.setValue(dt.getFullYear() + "-" + Fill2(dt.getMonth() + 1) + "-" + dt.getDate());
                    }
                }                
            }

            function Fill2(month)
            {   
                var _month = month.toString();
                
                if(_month.length == 1)
                {
                    _month = "0" + _month;
                        
                }
                
                return _month;
            }

            function fontColor(value, record) {

                if (record.data.SPRANK == "2") {
                    return "<span style=\"color:red;\">" + value + "</span>";
                }
                else if (record.data.SPRANK == "1") {
                    return "<span style=\"color:blue;\">" + value + "</span>";
                }
                else {
                    return value;
                }
            }
           
        </script>
    </ext:XScript>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">
    <ext:Viewport ID="vptBinBoard" runat="server" Layout="BorderLayout">
        <Items>
            <ext:GridPanel ID="grdBinMove" runat="server" Region="Center">
                <TopBar>
                    <ext:Toolbar ID="Toolbar3" runat="server">
                        <Items>
                            <ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:ComboBox ID="cboGUBN" runat="server" Editable="false" FieldLabel="구분" LabelWidth="30" width="120">
                                <Items>
                                    <ext:ListItem Text="전체" Value="1" />
                                    <ext:ListItem Text="게시중" Value="N" />
                                    <ext:ListItem Text="게시종료" Value="Y" />
                                </Items>
                                <SelectedItems>
                                    <ext:ListItem Text="게시중" Value="N"></ext:ListItem>
                                </SelectedItems>
                                <Listeners>
                                    <Select Handler="GUBN_Select();" />
                                </Listeners>
                            </ext:ComboBox>
                            <ext:ToolbarSpacer ID="ToolbarSpacer9" runat="server" Width="15"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpSDATE" runat="server" FieldLabel="기준일자"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd"></ext:DateField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer15" runat="server" Width="3"></ext:ToolbarSpacer>
                            <ext:Label ID="Label5" runat="server" Text="~"></ext:Label>
                            <ext:ToolbarSpacer ID="ToolbarSpacer16" runat="server" Width="3"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpEDATE" runat="server" width="110" Format="yyyy-MM-dd"></ext:DateField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="15"></ext:ToolbarSpacer>
                            <ext:TextField ID="txtMEMO" runat="server" FieldLabel="내용" LabelWidth="30" Width="450"></ext:TextField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer20" runat="server" Width="60"></ext:ToolbarSpacer>
                            <ext:ToolbarFill ID="ToolbarFill3" runat="server"></ext:ToolbarFill>
                            <ext:ToolbarSeparator ID="ToolbarSeparator2"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="Button4" runat="server" Icon="Find" Text="조회">
                                <DirectEvents>
                                    <Click OnEvent="btnFind_Click">
                                        <EventMask ShowMask="true" Msg="조회중..." Target="CustomTarget" CustomTarget="#{vptBinBoard}"></EventMask>
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
                            <ext:ToolbarSeparator ID="ToolbarSeparator1"  runat="server"></ext:ToolbarSeparator>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Store>
                    <ext:Store ID="stoBinBoard" runat="server">
                        <Model>
                            <ext:Model ID="Model5" runat="server">
                                <Fields>
                                    <ext:ModelField Name="SPDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SPSEQ"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SPMEMO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SPUPDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SPDOWNDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SPENDGUBN"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SPRANK"  Type="String"></ext:ModelField>
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column ID="Column1" runat="server" DataIndex="SPDATE" Text="일자" Align="Left" Width="100">
                            <Renderer Handler = "return fontColor(value, record);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column2" runat="server" DataIndex="SPSEQ" Text="순번" Align="Left" Width="80">
                            <Renderer Handler = "return fontColor(value, record);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column3" runat="server" DataIndex="SPMEMO" Text="내용" Align="Left" Flex="1" >
                            <Renderer Handler = "return fontColor(value, record);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column4" runat="server" DataIndex="SPUPDATE" Text="게시시작일" Align="Center" Width="100">
                            <Renderer Handler = "return fontColor(value, record);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column5" runat="server" DataIndex="SPDOWNDATE" Text="게시종료일" Align="Center" Width="100">
                            <Renderer Handler = "return fontColor(value, record);"></Renderer>
                        </ext:Column>
                        <ext:ImageCommandColumn ID="ImageCommandColumn1" runat="server" Width="70">
                            <Commands>
                                <ext:ImageCommand Icon= "Cross" Text="게시종료" CommandName="PRINT"></ext:ImageCommand>
                            </Commands>
                            <PrepareCommand FormatHandler="true" Handler="command_ProcRenderer(command, record);" />
                            <Listeners>
                                <Command Handler="grdList_ProcCommand(item, command, record, recordIndex, cellIndex);"></Command>
                            </Listeners>
                        </ext:ImageCommandColumn>
                    </Columns>
                </ColumnModel>
                <DirectEvents>
                    <CellClick OnEvent="grdList_CellClick">
                        <ExtraParams>
                            <ext:Parameter Mode="Raw" Name="DATAS" Value="GetSelectedDatas()"></ext:Parameter>
                        </ExtraParams>
                    </CellClick>
                </DirectEvents>
                <SelectionModel>
                    <ext:RowSelectionModel ID="grdSelect" runat="server" Mode="Single"></ext:RowSelectionModel>
                </SelectionModel>
            </ext:GridPanel>         
        </Items>
    </ext:Viewport>    
    <%--팝업--%>
    <ext:Window ID="BoradSpcPop" runat="server" CloseAction="Hide" Hidden="true" width="630" Modal="true" AutoScroll="false" Constrain="true">
        <Items>
            <ext:Panel ID="Panel1" 
                    runat="server" 
                    Region="North"
                    Height="40" 
                    border="false"
                    >
                    <TopBar>
                        <ext:Toolbar ID="Toolbar2" runat="server">
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
                                <ext:ToolbarSeparator ID="ToolbarSeparator5"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnDel" runat="server" Text="삭제" Icon="Delete"  >
                                    <DirectEvents>
                                        <Click OnEvent="btnDel_Click">
                                            <Confirmation ConfirmRequest="true" Title="확인" Message="삭제하시겠습니까?"></Confirmation> 
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator7"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnClose" runat="server" Text="닫기" Icon="Decline"  >
                                    <Listeners>
                                        <Click Handler="#{BoradSpcPop}.hide();" />
                                    </Listeners>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator12"  runat="server"></ext:ToolbarSeparator>
                            </Items>
                        </ext:Toolbar>
                    </TopBar>
                </ext:Panel>                      
                <ext:Panel ID="Panel2"
                    runat="server" 
                    Region="Center"
                    Height="280" 
                    border="false"
                    DefaultAnchor = "100%" >
                    <Items>                        
                           <ext:Panel ID="Panel4"  runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                     <ext:DateField ID="dtpSPDATE" runat="server" FieldLabel="일자"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd" Margins="0 10 0 0"></ext:DateField>
                                 </Items>
                           </ext:Panel>                                                                       
                           <ext:Panel ID="Panel3" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                     <ext:TextField ID="txtSPSEQ" runat="server"   FieldLabel="순번" LabelWidth ="60" Width = "160" EnableKeyEvents="true" FieldStyle="background-color:#E5E5E5;" Margins="0 10 0 0" ReadOnly="true" EmptyText="자동부여" ></ext:TextField>
                                     <ext:ComboBox ID="cboSPRANK" runat="server" Editable="false" FieldLabel="중요도" LabelWidth="50" width="150">
                                        <Items>
                                            <ext:ListItem Text="매우높음" Value="2" />
                                            <ext:ListItem Text="높음" Value="1" />
                                            <ext:ListItem Text="보통" Value="0" />
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="보통" Value="0"></ext:ListItem>
                                        </SelectedItems>
                                    </ext:ComboBox>
                                 </Items>
                           </ext:Panel>
                           <ext:Panel ID="Panel7"  runat="server" Layout="HBoxLayout" Height="150" Width = "600"  Padding="3" Border="false">
                                 <Items>
                                     <ext:TextArea ID="txtSPMEMO" runat="server" FieldLabel="내용" Height="140" LabelWidth ="60" Flex="1" Margins="0 10 0 0"> </ext:TextArea>
                                 </Items>
                           </ext:Panel>
                           <ext:Panel ID="Panel5" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:DateField ID="dtpSPUPDATE" runat="server" FieldLabel="게시일자"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd" Margins="0 10 0 0"></ext:DateField>
                                    <ext:Label ID="Label1" runat="server" Text="~" Margins="0 10 0 0"></ext:Label>
                                    <ext:DateField ID="dtpSPDOWNDATE" runat="server" width="110" Format="yyyy-MM-dd" Margins="0 10 0 0" ReadOnly="true" FieldStyle="background-color:#E5E5E5;"></ext:DateField>
                                 </Items>
                           </ext:Panel> 
                           <ext:Panel ID="Panel6" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:Checkbox ID="ckbSPENDGUBN" runat="server" Width="90" FieldLabel="게시종료" LabelWidth="60">
                                    </ext:Checkbox>
                                 </Items>
                           </ext:Panel> 
                    </Items>
                </ext:Panel>
        </Items>
    </ext:Window>
</asp:Content>