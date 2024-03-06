<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinSchedule.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinSchedule" %>

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

            function fontColor(value, record, check) {
                var Rvalue;

                if (check == 0)
                {
                    Rvalue = FormatNoZero(value, '0,000.000');
                }
                else if (check == 1) {
                    if (value.length == 8) {
                        var yyyy = value.substring(0, 4);
                        var mm = value.substring(4, 6);
                        var dd = value.substring(6, 8);

                        var date = yyyy + "." + mm + "." + dd;

                        Rvalue = date;
                    }
                    else {
                        Rvalue = "";
                    }
                }
                else if (check == 2) {
                    if (value.length == 4 && value != "" && value != "0000") {
                        var hh = value.substring(0, 2);
                        var mm = value.substring(2, 4);

                        var datetime = hh + ":" + mm;

                        Rvalue = datetime;
                    }
                    else {
                        Rvalue = "";
                    }
                }
                else
                {
                    Rvalue = value;
                }
                //

                if (record.data.SHGKGUBN == "Y") {
                    return "<span style=\"color:blue;\">" + Rvalue + "</span>";
                }
                else {
                    return Rvalue;
                }

//                if (record.data.SHIPCOME8 == "Y") {
//                    return "<span style=\"color:red;\">" + Rvalue + "</span>";
//                }
//                else if (record.data.SHIPCOME9 == "Y") {
//                    return "<span style=\"color:blue;\">" + Rvalue + "</span>";
//                }
//                else {
//                    return Rvalue;
//                }
            }

          function DateMove(value){
               Ext.net.DirectMethod.request('UP_DateMove', {
                    url: location.href,
                    params: { sDate:Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Y-m-d'),
                              sGubn:value  },
                    eventMask: {
                            showMask: true,
                            msg: "선박스케줄을 조회중입니다...",
                            target: "customtarget",
                            customTarget: #{grdBinSchedule}
                        }
                }
                );
           }

           function Next_Focus()
           {                
                var keyCode = window.event.keyCode;

                if (keyCode == 0)
                {
                    #{Button2}.focus();
	            }
                else
                {
                    window.event.returnValue = true;
                }
           };
           
        </script>
    </ext:XScript>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">
    <ext:Viewport ID="vptBinSchedule" runat="server" Layout="BorderLayout">
        <Items>
            <ext:GridPanel ID="grdBinSchedule" runat="server" Height = "600" Region="Center">
                <TopBar>
                    <ext:Toolbar ID="Toolbar3" runat="server">
                        <Items>
                            <ext:ToolbarSpacer ID="ToolbarSpacer9" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:Panel ID="Panel1" runat="server" Layout="HBoxLayout"   Border="false" Margin="5">
                                <LayoutConfig>
                                        <ext:HBoxLayoutConfig Align="Middle"></ext:HBoxLayoutConfig>
                                </LayoutConfig>
                            <Items> 
                                <ext:Button ID="Button1" runat="server" Icon="ResultsetPrevious" >
                                    <Listeners>
                                        <Click Handler = "DateMove(1);" ></Click>
                                    </Listeners>
                                </ext:Button>
                                <ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="3"></ext:ToolbarSpacer>
                                <ext:DateField ID="dtpSDATE" runat="server" ReadOnly = "true" Width = "80" Enabled = "false" Format="yyyy-MM" TabIndex = "24" EnableKeyEvents = "true">
                                    <Listeners>
                                        <Focus Handler = "DateMove(3);Next_Focus();" ></Focus>
                                    </Listeners>
                                </ext:DateField>
                                <ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="3"></ext:ToolbarSpacer>
                                <ext:Button ID="Button2" runat="server" Icon="ResultsetNext">
                                    <Listeners>
                                        <Click Handler = "DateMove(2);" ></Click>
                                    </Listeners>
                                </ext:Button>    
                            </Items>
                            </ext:Panel>
                            <ext:ToolbarSpacer ID="ToolbarSpacer15" runat="server" Width="50"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpCurrentDate" runat="server" FieldLabel="현재일자" ReadOnly="true"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd"></ext:DateField>
                            <ext:ToolbarFill ID="ToolbarFill3" runat="server"></ext:ToolbarFill>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Store>
                    <ext:Store ID="stoShipList" runat="server">
                        <Model>
                            <ext:Model ID="Model1" runat="server">
                                <Fields>
                                    <ext:ModelField Name="SHDATE"    Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHSEQ"    Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHBERTH"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHCORPGB"    Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHCORPGBNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHHANGCHA"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHHANGCHANM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHSOSOK"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHSOSOKNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHGOKJONG"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHGOKJONGNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHWONSAN"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHWONSANNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHAGENT"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHAGENTNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHSURVEY"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHSURVEYNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHHJSURVEY"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHHJSURVEYNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHSUNHUGB"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHSUNHUGBNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHETCD_S"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHETCD_E"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHETCD"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHETAPT"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHETAPTTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHPTQTY"  Type="Float"></ext:ModelField>
                                    <ext:ModelField Name="SHREMARK"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHWORKGB"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHIPCOME8"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHIPCOME9"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHGKGUBN"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SHETBDATE"  Type="String"></ext:ModelField>
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column ID="Column2"   runat="server" DataIndex="SHHANGCHA" Text="항차" Width="90" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column6"   runat="server" DataIndex="SHHANGCHANM" Text="선 명" Width="190" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column1"   runat="server" DataIndex="SHBERTH" Text="선석" Width="70" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column7"  runat="server" Text="검정사" >
                            <Columns>
                                <ext:Column ID="Column8"   runat="server" DataIndex="SHSURVEYNM" Text="태영" Width="130"  Align="Left" Sortable ="false">
                                    <Renderer Handler = "return fontColor(value, record, 3);" ></Renderer>
                                </ext:Column>
                                <ext:Column ID="Column9"   runat="server" DataIndex="SHHJSURVEYNM" Text="화주" Width="130" Align="Left" Sortable ="false">
                                    <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                                </ext:Column>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="Column19"   runat="server" DataIndex="SHAGENTNM" Text="대리점" Width="160" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column3"   runat="server" DataIndex="SHETAPT" Text="ETA" Width="100" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 1);"></Renderer> 
                        </ext:Column>
                        <ext:Column ID="Column17"   runat="server" DataIndex="SHGOKJONGNM" Text="곡종" Width="170" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column18"   runat="server" DataIndex="SHWONSANNM" Text="원산지" Width="80" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                        <ext:NumberColumn ID="NumberColumn1" runat ="server" DataIndex ="SHPTQTY" Text ="B/L량" Align ="Right" Width ="100" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 0);"></Renderer>
                        </ext:NumberColumn>
                        <ext:Column ID="Column10"   runat="server" DataIndex="SHSUNHUGBNM" Text="선/후" Width="100" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer> 
                        </ext:Column>
                        <ext:Column ID="Column16"   runat="server" DataIndex="SHSOSOKNM" Text="협회" Width="120" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column4"   runat="server" DataIndex="SHETBDATE" Text="ETB" Width="100" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 1);"></Renderer> 
                        </ext:Column>
                        <ext:Column ID="Column20" runat="server" DataIndex="SHETCD_E" Text="ETCD" Width="100" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 1);"></Renderer>
                        </ext:Column>
                        <ext:Column ID="Column21" runat="server" DataIndex="SHREMARK" Text="REMARK" Flex="1" Align="Left" Sortable ="false">
                            <Renderer Handler = "return fontColor(value, record, 3);"></Renderer>
                        </ext:Column>
                    </Columns>
                </ColumnModel>
            </ext:GridPanel>
        </Items>
    </ext:Viewport>
</asp:Content>