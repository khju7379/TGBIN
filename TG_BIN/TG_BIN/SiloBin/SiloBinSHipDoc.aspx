<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinSHipDoc.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinSHipDoc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">
    <ext:XScript ID="XScript2" runat="server">
        <script type="text/javascript">

            var objitem;
            
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
            function trgP_CODE_ClientTriggerClick(gubn) {
                
                if(gubn == 1)
                {
                    var result = window.showModalDialog("../SiloBin/CodeHelpHangcha.aspx?param1=" + encodeURI(#{txtDHANGCHA}.getValue()), "FTAlink", " toolbar=0, location=0, status=0, menubar=0,resizable=no, location=no, menubar=no, toolbar=no, width=450px, height=400px");

                    if(result != null && result != undefined) {
                        #{txtDHANGCHA}.setValue(result.CODE);
                        #{txtDHANGCHANM}.setValue(result.CODENM);
                    }
                }
                else if(gubn == 2)
                {
                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=GK&param2=" + encodeURI(#{txtDGOKJONG}.getValue()), null, "dialogWidth=500px; dialogHeight=400px;");
            
                    if(result != null && result != undefined) {
                        #{txtDGOKJONG}.setValue(result.CDCODE);
                        #{txtDGOKJONGNM}.setValue(result.CDDESC1);
                    }
                }
                else if(gubn == 3)
                {
                    var result = window.showModalDialog("../SiloBin/CodeHelpBinNo.aspx?param1=" + encodeURI(#{txtDBINNO}.getValue()), "FTAlink", " toolbar=0, location=0, status=0, menubar=0,resizable=no, location=no, menubar=no, toolbar=no, width=450px, height=400px");
            
                    if(result != null && result != undefined) {
                        #{txtDBINNO}.setValue(result.CBINNO);
                    }
                }
            }

            function GetSelectedDatas(Gubn) {
                var rtnValue = "";

                if(Gubn == 1)
                {
                    var obj = #{grdHCSelect};
                    if(obj.selected.items.length > 0) {
                        rtnValue +=  obj.selected.items[0].data.HANGCHA + "^;^" + obj.selected.items[0].data.HANGCHANM + "^;^" + 
                                     obj.selected.items[0].data.GOKJONG + "^;^" + obj.selected.items[0].data.GOKJONGNM + "^;^" + 
                                     obj.selected.items[0].data.PBLQTY + "^;^" + obj.selected.items[0].data.HCORPGUBN + "^/^";
                    }                
                }
                else if(Gubn == 2)
                {
                    var obj = #{grdSelect};
                    if(obj.selected.items.length > 0) {
                        rtnValue +=  obj.selected.items[0].data.DHANGCHA + "^;^" + obj.selected.items[0].data.DGOKJONG + "^;^" + obj.selected.items[0].data.DLOADCODE + "^;^" +
                        obj.selected.items[0].data.DLOADCODENM + "^;^" + obj.selected.items[0].data.DWKDATE + "^;^" + obj.selected.items[0].data.DSEQ+ "^;^" + obj.selected.items[0].data.DCORPGUBN + "^/^";
                    }                
                }
                return rtnValue;

            } 

            function SetTextFocus(value) {             
             
             switch (value) {
                    case 1:
                        #{txtDHANGCHA}.focus();
                        break;
                    case 2:
                        #{txtDGOKJONG}.focus();
                        break;
                    case 3:
                        #{dtpDWKDATE}.focus();
                        break;
                    default:
                        #{txtDSUNCHANG}.focus();
                        break;
                }
            }

            Number.prototype.to2 = function(){return this<10?'0'+this:this;};
            function displayDSHSTIME(record)
            {   
                var year = Ext.util.Format.date(record.data.DSLSDATE, 'Y') - Ext.util.Format.date(record.data.DSLEDATE, 'Y');

                var month;
                var day;
                var days = 0;

                if(Ext.util.Format.date(record.data.DSLSDATE, 'Ymd') != "00010101" && record.data.DSLEDATE != "")
                {
                    if(Ext.util.Format.date(record.data.DSLEDATE, 'm') > Ext.util.Format.date(record.data.DSLSDATE, 'm'))
                    {
                        month = Ext.util.Format.date(record.data.DSLEDATE, 'm') - Ext.util.Format.date(record.data.DSLSDATE, 'm');
                    }
                    else{
                        month = (Ext.util.Format.date(record.data.DSLEDATE, 'm') + 12) - (Ext.util.Format.date(record.data.DSLSDATE, 'm'));
                    }
                
                    if(Ext.util.Format.date(record.data.DSLEDATE, 'd') < Ext.util.Format.date(record.data.DSLSDATE, 'd') && month == 1)
                    {   
                        days = 1;
                    }
                    else
                    {
                        days = Ext.util.Format.date(record.data.DSLEDATE, 'd') - Ext.util.Format.date(record.data.DSLSDATE, 'd');
                    }

                    var vsTm = record.data.DSLSTIME;
                    var veTm = (Number(record.data.DSLETIME) + (days*2400)).toString();

                
                    if(vsTm.length<4 || isNaN(vsTm)) return; 
                    if(veTm.length<4 || isNaN(veTm)) return; 
                    var sTm = vsTm.match(/\d{2}/g);     // 2자리씩 추출 배열0->시 배열1->분 
                    var eTm = veTm.match(/\d{2}/g);     // 2자리씩 추출 배열0->시 배열1->분 
                    var sTime = parseInt(sTm[0],10)*60 + parseInt(sTm[1]); // 분 데이타로 변환 
                    var eTime = parseInt(eTm[0],10)*60 + parseInt(eTm[1]); // 분 데이타로 변환 
                    var rTime = eTime-sTime;            // 차이 계산 
                    var rH = Math.floor(rTime/60);      // 시 추출 
                    var rM = rTime%60;                  // 분 추출 
                    var rTm = '' + rH.to2() + rM.to2(); // 0000 포멧으로 변형 

                    record.data.DSSHSTIME.setValue(rTm);
                }

            }
            
            function STATUS_Renderer(value, record, gubn) {
                var rValue = "";
                var rtnValue = "";
                var color = "black";

                if (record.data.DLOADCODENM == "합 계") {
                   color = "red"; 
                }
                else if(record.data.DLOADCODENM == "소 계") {
                   color = "blue"; 
                }
                else if(record.data.DLOADCODENM == "모선계") {
                   color = "red"; 
                }

                if(gubn == "0")
                {
                    rtnValue = "<span style=\"color:"+color+"\">" + value + "</span>";
                }
                else{
                    if(value == "0.000" || value == "0")
                    {
                        rtnValue = "<span style=\"color:"+color+"\">0.000</span>";
                    }
                    else{
                        rtnValue = "<span style=\"color:"+color+"\">" + FormatNoZero(value, '0,000.000') + "</span>";
                    }
                }
                
                return rtnValue;
            }

            function btnFind_Click()
            {
                Ext.net.DirectMethod.request('btnFind_Click', {
                    url: location.href,
                    params: {sCORPGUBN : #{cboCORPGB}.getValue(),
                             sHANGCHA : #{txtHANGCHA}.getValue()
                             },
                    eventMask: {
                        showMask: true,
                        msg: "항차를 조회중입니다...",
                        target: "customtarget",
                        customTarget: #{vptBinShipDoc}
                    }
                });
            }

            function btnSave_Click(){
    
                var record = #{stoBinShipDocDetail}.data.items;
                
                var DSBINSEQ = "";
                var DSBINNO = "";
                var DSLOADQTY = "";
                var DSBINNOHD = "";

                for(var i = 0; i < record.length; i++)
                {   
                    if(i == 0)
                    {   
                        DSBINSEQ = record[i].data.DSBINSEQ;
                        DSBINNO = record[i].data.DSBINNO;
                        DSLOADQTY  = record[i].data.DSLOADQTY;                        
                        DSBINNOHD = record[i].data.DSBINNOHD;
                    }
                    else
                    {
                        DSBINSEQ += "," + record[i].data.DSBINSEQ;
                        DSBINNO += "," + record[i].data.DSBINNO;
                        DSLOADQTY += "," + record[i].data.DSLOADQTY;
                        DSBINNOHD += "," + record[i].data.DSBINNOHD;
                    }
                }
                
                Ext.Msg.confirm('확인', '저장 하시겠습니까?', function(btn, text){
                    if(btn == 'yes'){
                        Ext.net.DirectMethod.request('btnSave_Click', {
                        url: location.href,
                        params: {DCORPGUBN : #{cboDCORPGUBN}.getValue(), 
                                 DHANGCHA : #{txtDHANGCHA}.getValue(), 
                                 DHANGCHANM : #{txtDHANGCHANM}.getValue(), 
                                 DGOKJONG : #{txtDGOKJONG}.getValue(), 
                                 DLOADCODE : #{cboDLOADCODE}.getValue(), 
                                 DWKDATE: Ext.util.Format.date(#{dtpDWKDATE}.getValue(), 'Ymd'), 
                                 DSEQ: #{txtDSEQ}.getValue(),  
                                 DWORKTEXT : #{txtDWORKTEXT}.getValue(),  
                                 DSUNCHANG : #{txtDSUNCHANG}.getValue(),
                                 DLSDATE : Ext.util.Format.date(#{dtpDLSDATE}.getValue(), 'Ymd'), 
                                 DLSTIME : #{txtDLSTIME}.getValue(),
                                 DLEDATE : Ext.util.Format.date(#{dtpDLEDATE}.getValue(), 'Ymd'), 
                                 DLETIME : #{txtDLETIME}.getValue(),
                                 DSHSTIME : #{txtDSHSTIME}.getValue(),
                                 DSHETIME : #{txtDSHETIME}.getValue(),
                                 DLOADQTY : #{txtDLOADQTY}.getValue(),
                                 DSUMQTY : #{txtDSUMQTY}.getValue(),
                                 DSBINSEQ : DSBINSEQ,
                                 DSBINNO : DSBINNO,
                                 DSLOADQTY : DSLOADQTY,
                                 DSBINNOHD : DSBINNOHD,
                                 DSBINNOPRE : #{txtDSBINNOPRE}.getValue(),
                                 DSLOADQTYPRE : #{txtDLOADQTYPRE}.getValue(),
                                 DSUNCHANGPRE : #{txtDSUNCHANGPRE}.getValue()
                                 }
                        });
                    }
                });
            }

            function trg_BINNO_ClientTriggerClick(item,trigger,index,tag,e) {          

                // IE 전용 시작
                //var result = window.showModalDialog("../SiloBin/CodeHelpBinNo.aspx?param1=", null, "dialogWidth=450px; dialogHeight=400px;");

                //if(result != null && result != undefined) {
                //    item.setValue(result.BCBINNO);
                //}
                // IE 전용 끝

                // 크롬, 엣지 시작
                objitem = item;
                result = window.showModalDialog("../SiloBin/CodeHelpBinNo.aspx?param1=", null, "dialogWidth:450px; dialogHeight:400px;");
                // 크롬, 엣지 끝
            }

            function showModalDialogCallback(result) {

                if (result) {
                    objitem.setValue(result.BCBINNO);
                }

            }

            function UP_BINCheck(item){
               if(item.value != ''){
                   var store = #{stoBINNO}; 
                   var record = store.findRecord("SBINNO", item.value);
                   if(!record){
                      item.focus();
                      alert('BIN번호를 확인하세요');
                      return;
                   }
               }            
            }

            function UP_DateCheck(item){           
                var obj = null;

                obj = item.value;
           
                if (obj != null &&  obj.length == 8) {
                    var yyyy = obj.substring(0, 4);
                    var mm = obj.substring(4, 6);
                    var dd = obj.substring(6, 8);
                    var date = yyyy + "-" + mm + "-" + dd;
                    obj = date;
                }
                else{
                    obj = Ext.util.Format.date(item.value, "Y-m-d");
                }

                item.setValue(obj);
            }   

            function UP_TimeCheck(item){

               var charvalue = 0;
               var charstr = '';
               var obj = null;
               obj = item.value;
           
               obj = IsNumber(obj);

               if( obj != '' ){
                   obj = PadLeft(obj,4,'0');
                   if (obj.length > 2) {
                        var hh = obj.substring(0, 2);
                        var dd = obj.substring(2, 4);

                        if( parseInt(hh) > 24 )
                        {
                           item.focus();
                           alert('시간입력을 확인하세요');
                           return;
                        }

                        if( parseInt(dd) > 59 )
                        {
                           item.focus();
                           alert('시간입력을 확인하세요');
                           return;
                        }                

                        obj = hh+':'+dd;
                   }
                   else{
                        obj = '';
                   }            
               }
           
               item.setValue(obj);          
            }   

            function UP_recordLock(item, value){
          
                var data = item.record.data;          

                if( data.DSLOADQTY != '' ){                 
                    //item.setReadOnly(true);
                }
            }       

            function btnExcel_ClientClick() {
                #{hddGridData}.setValue(Ext.encode(#{grdBinMove}.getRowsValues({ selectedOnly: false })));
            }

            function btnPrinter_ClientClick(){

                if(#{txtDHANGCHA}.getValue() != "")
                {   
                    OpenNamePopup("../Resources/Report/SiloBinSHipDoc.aspx?val1=" + #{txtHANGCHA2}.getValue() + "&val2=" + #{txtGOKJONG}.getValue() + "&val3=" + #{txtHCORPGUBN}.getValue(),"SHipDoc", 952, 720);
                }
                return false;
            }
        </script>
    </ext:XScript>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">
    <ext:Store ID="stoBINNO" runat="server">
        <Model>
            <ext:Model ID="Model2" runat="server">
                <Fields>                    
                    <ext:ModelField Name="SBINNO"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
    </ext:Store>
    <ext:Viewport ID="vptBinShipDoc" runat="server" Layout="BorderLayout">
        <Items>
            <ext:TextField runat="server" ID="txtStat" Hidden="true"></ext:TextField>
            <ext:TextField runat="server" ID="txtDLOADQTYPRE" Hidden="true"></ext:TextField>
            <ext:TextField runat="server" ID="txtDSBINNOPRE" Hidden="true"></ext:TextField>
            <ext:TextField runat="server" ID="txtIBBEJNQTY" Hidden="true"></ext:TextField>
            <ext:TextField runat="server" ID="txtHCORPGUBN" Hidden="true"></ext:TextField>
            <ext:Panel ID="Panel1" runat="server" Region = "Center" Layout="BorderLayout" Border="false" >             
               <Items>    
            <ext:GridPanel ID="GridPanel1" runat="server" region="West" width="450" Collapsible="false" AniCollapsible="false" Border="true">
                    <Topbar>
                        <ext:Toolbar ID="Toolbar1" runat="server">
                            <Items>
                                <ext:ToolbarSpacer ID="ToolbarSpacer9" runat="server" Width="10"></ext:ToolbarSpacer>
                                <ext:ComboBox ID="cboCORPGB" runat="server" Margins="2 1 0 10" Editable="false" FieldLabel="회사" LabelWidth="40" width="160">
                                    <Items>
                                        <ext:ListItem Text="그레인터미널" Value="T" />
                                        <ext:ListItem Text="평택싸이로" Value="P" />
                                    </Items>
                                    <SelectedItems>
                                        <ext:ListItem Text="그레인터미널" Value="T"></ext:ListItem>
                                    </SelectedItems>
                                </ext:ComboBox>
                                <ext:ToolbarSpacer ID="ToolbarSpacer5" runat="server" Width="5"></ext:ToolbarSpacer>
                                <ext:TextField ID="txtHANGCHA" runat="server" FieldLabel="항차" LabelWidth="30" Width="120"></ext:TextField>                                
                                <ext:ToolbarFill ID="ToolbarFill1" runat="server"></ext:ToolbarFill>
                                <ext:ToolbarSeparator ID="ToolbarSeparator1" runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="Button4" runat="server" Icon="Find" Text="조회">
                                    <Listeners>
                                    <Click Handler = "btnFind_Click()">                                   
                                    </Click>
                                </Listeners>
                                </ext:Button>
                            </Items>
                        </ext:Toolbar>
                    </Topbar>
                    <Store>
                    <ext:Store ID="stoHangcha" runat="server">
                        <Model>
                            <ext:Model ID="Model1" runat="server">
                                <Fields>
                                    <ext:ModelField Name="HANGCHA"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="HANGCHANM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="GOKJONG"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="GOKJONGNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="PBLQTY"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="HCORPGUBN"  Type="String"></ext:ModelField>
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column ID="Column1" runat="server" DataIndex="HANGCHA" Text="항차" Align="Left" Width="80">
                        </ext:Column>
                        <ext:Column ID="Column2" runat="server" DataIndex="HANGCHANM" Text="모선명" Align="Left" Width="130">
                        </ext:Column>
                        <ext:Column ID="Column3" runat="server" DataIndex="GOKJONG" Text="곡종" Align="Left" Width="50">
                        </ext:Column>
                        <ext:Column ID="Column4" runat="server" DataIndex="GOKJONGNM" Text="곡종명" Align="Left" Flex="130">
                        </ext:Column>
                    </Columns>
                </ColumnModel>
                <DirectEvents>
                    <CellDblClick OnEvent="grdHCList_CellClick">
                        <ExtraParams>
                            <ext:Parameter Mode="Raw" Name="DATAS" Value="GetSelectedDatas(1)"></ext:Parameter>
                        </ExtraParams>
                    </CellDblClick>
                </DirectEvents>
                <SelectionModel>
                    <ext:RowSelectionModel ID="grdHCSelect" runat="server" Mode="Single"></ext:RowSelectionModel>
                </SelectionModel>
            </ext:GridPanel>   
            <ext:GridPanel ID="grdBinMove" runat="server" Flex="1" Region="Center" border="true">
                <TopBar>
                    <ext:Toolbar ID="Toolbar3" runat="server">
                        <Items>
                            <ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:TextField ID="txtHCORPGUBNNM" runat="server" FieldLabel="회사" LabelWidth="30" Width="160" readonly="true" FieldStyle="background-color:#E5E5E5;"></ext:TextField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer4" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:TextField ID="txtHANGCHA2" runat="server" FieldLabel="항차" LabelWidth="30" Width="120" readonly="true" FieldStyle="background-color:#E5E5E5;"></ext:TextField>
                            
                            <ext:TextField ID="txtHANGCHANM2" runat="server" Width="200" readonly="true" FieldStyle="background-color:#E5E5E5;"></ext:TextField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:TextField ID="txtGOKJONG" runat="server" FieldLabel="곡종" LabelWidth="30" Width="70" readonly="true" FieldStyle="background-color:#E5E5E5;"></ext:TextField>
                            
                            <ext:TextField ID="txtGOKJONGNM" runat="server" Width="150" readonly="true" FieldStyle="background-color:#E5E5E5;"></ext:TextField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer3" runat="server" Width="15"></ext:ToolbarSpacer>
                            <ext:ToolbarFill ID="ToolbarFill3" runat="server"></ext:ToolbarFill>
                            <ext:ToolbarSeparator ID="TSMAdd" runat="server" Hidden="true"></ext:ToolbarSeparator>
                            <ext:Button ID="btnMAdd" runat="server" Icon="Add" Text="신규" Hidden="true">
                                <DirectEvents>
                                    <Click OnEvent="btnNew_Click">                                   
                                    </Click>
                                </DirectEvents>
                            </ext:Button>
                            <ext:Button ID="btnPrt" runat="server" Icon="Printer" Text="출력" Hidden="true">
                                <Listeners>
                                    <Click Fn="btnPrinter_ClientClick"></Click>
                                </Listeners>
                            </ext:Button>
                            <ext:Hidden ID="hddGridData" runat="server"></ext:Hidden>
                            <ext:Button ID ="btnExcel" runat ="server" Icon ="PageExcel" Hidden="true" Text ="엑셀" AutoPostBack="true" OnClick="btnExcel_Click">
                                <Listeners>
                                    <Click Fn="btnExcel_ClientClick"></Click>
                                </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator2"  runat="server"></ext:ToolbarSeparator>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Store>
                    <ext:Store ID="stoBinShipDoc" runat="server">
                        <Model>
                            <ext:Model ID="Model5" runat="server">
                                <Fields>
                                    <ext:ModelField Name="DCORPGUBN"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DHANGCHA"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DGOKJONG"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DGOKJONGNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DLOADCODE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DLOADCODENM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DWKDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DSEQ"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DSUNCHANG"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DWORKTEXT"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DBINNO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DLSDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DLSTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DLEDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DLETIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DSHSTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DSHETIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DLOADQTY"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="DSUMQTY"  Type="String"></ext:ModelField>
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>
                        <ext:Column ID="Column9" runat="server" DataIndex="DLOADCODENM" Text="하역기" Align="Left" Width="70" Sortable="false">
                        </ext:Column>
                        <ext:Column ID="Column6" runat="server" DataIndex="DWKDATE" Text="일자" Align="Center" Width="100" Sortable="false">
                        </ext:Column>
                        <ext:Column ID="Column7" runat="server" DataIndex="DSEQ" Text="순번" Align="Center" Width="60" Sortable="false">
                        </ext:Column>
                        <ext:Column ID="Column8" runat="server" DataIndex="DSUNCHANG" Text="선창" Align="Center" Width="50" Sortable="false">
                        </ext:Column>
                        <ext:Column ID="Column19" runat="server" DataIndex="DWORKTEXT" Text="작업내용" Flex="1" Sortable="false">
                        </ext:Column>
                        <ext:Column ID="Column10" runat="server" DataIndex="DBINNO" Text="BIN" Align="Center" Width="200" Sortable="false">
                        </ext:Column>
                        <ext:Column ID="Column11" runat="server" Text="하역시작일시">
                            <Columns>
                                <ext:Column ID="Column12" runat="server" DataIndex="DLSDATE" Text="일자" Align="Center" Width="100" Sortable="false">
                                </ext:Column>
                                <ext:Column ID="Column13" runat="server" DataIndex="DLSTIME" Text="시간" Align="Center" Width="70" Sortable="false">
                                </ext:Column>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="Column14" runat="server" Text="하역종료일시">
                            <Columns>
                                <ext:Column ID="Column15" runat="server" DataIndex="DLEDATE" Text="일자" Align="Center" Width="100" Sortable="false">
                                </ext:Column>
                                <ext:Column ID="Column16" runat="server" DataIndex="DLETIME" Text="시간" Align="Center" Width="70" Sortable="false">
                                </ext:Column>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="Column17" runat="server" DataIndex="DSHSTIME" Text="하역시간" Align="Center" Width="80" Sortable="false">
                        </ext:Column>
                        <ext:Column ID="Column18" runat="server" DataIndex="DSHETIME" Text="중단시간" Align="Center" Width="80" Sortable="false">
                        </ext:Column>
                        <ext:NumberColumn ID="NumberColumn2" runat="server" DataIndex="DLOADQTY" Text="하역량" Align="Right" Width="110" Sortable="false">
                            <Renderer Handler="return STATUS_Renderer(value, record, '1');"></Renderer>  
                        </ext:NumberColumn>
                        <ext:NumberColumn ID="NumberColumn3" runat="server" DataIndex="DSUMQTY" Text="누계량" Align="Right" Width="110" Sortable="false">
                            <Renderer Handler="return STATUS_Renderer(value, record, '1');"></Renderer>  
                        </ext:NumberColumn>
                    </Columns>
                </ColumnModel>
                <DirectEvents>
                    <CellDblClick OnEvent="grdList_CellClick">
                        <ExtraParams>
                            <ext:Parameter Mode="Raw" Name="DATAS" Value="GetSelectedDatas(2)"></ext:Parameter>
                        </ExtraParams>
                    </CellDblClick>
                </DirectEvents>
                <SelectionModel>
                    <ext:RowSelectionModel ID="grdSelect" runat="server" Mode="Single"></ext:RowSelectionModel>
                </SelectionModel>
            </ext:GridPanel>   
            </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>    
    <ext:Window ID="ShipDocPop" runat="server" CloseAction="Hide" Hidden="true" Width="830" Modal="true" AutoScroll="false" Constrain="true">
        <Items>
            <ext:Panel ID="Panel2" 
                    runat="server" 
                    Region="North"
                    Height="40" 
                    border="false"
                     >
                     <TopBar>
                        <ext:Toolbar ID="Toolbar2" runat="server">
                            <Items>
                                <ext:ToolbarFill ID="ToolbarFill2" runat="server"></ext:ToolbarFill>
                                <ext:ToolbarSeparator ID="ToolbarSeparator6"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnAdd" runat="server" Text="신규" Icon="Add"  >
                                    <DirectEvents>
                                        <Click OnEvent="btnNew_Click"></Click>
                                    </DirectEvents>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator5"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnSave" runat="server" Text="저장" Icon="DatabaseSave"  >
                                    <Listeners>
                                        <Click Fn="btnSave_Click"></Click>
                                    </Listeners>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator4"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnDel" runat="server" Text="삭제" Icon="Delete"  >
                                    <DirectEvents>
                                        <Click OnEvent="btnDel_Click">
                                            <Confirmation ConfirmRequest="true" Title="확인" Message="해당자료 전체가 삭제됩니다.<br> 그래도 삭제 하시겠습니까?"></Confirmation> 
                                        </Click>
                                    </DirectEvents>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator13"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnClose" runat="server" Text="닫기" Icon="Decline"  >
                                    <Listeners>
                                        <Click Handler="#{ShipDocPop}.hide();" />
                                    </Listeners>
                                </ext:Button>   
                                <ext:ToolbarSeparator ID="ToolbarSeparator7"  runat="server"></ext:ToolbarSeparator>
                            </Items>
                        </ext:Toolbar>
                    </TopBar>
                    <Buttons>
                        
                    </Buttons>
                </ext:Panel>
                <ext:Panel ID="Panel3" runat="server"
                        Region="Center"
                        Height="470"
                        border="false"
                        DefaultAnchor="100%" >
                        <Items>
                            <ext:Panel ID="Panel41"  runat="server" Layout="HBoxLayout" Height="32" Padding="3" Border="false">
                                 <Items>
                                    <ext:ComboBox ID="cboDCORPGUBN" runat="server" Margins="2 1 0 10" Editable="false" FieldLabel="회사" LabelWidth="45" width="160" readonly="true">
                                        <Items>
                                            <ext:ListItem Text="그레인터미널" Value="T" />
                                            <ext:ListItem Text="평택싸이로" Value="P" />
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="그레인터미널" Value="T"></ext:ListItem>
                                        </SelectedItems>
                                    </ext:ComboBox>
                                    <ext:TriggerField ID="txtDHANGCHA" runat = "server" Margins="2 1 0 10" FieldLabel = "항차" width = "150" LabelWidth ="65" MaxLength ="7" EnforceMaxLength ="true" TabIndex = "16" EnableKeyEvents ="true" readonly="true" FieldStyle="background-color:#E5E5E5;">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(1);"></TriggerClick>
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:TextField ID="txtDHANGCHANM" runat="server" Width="140" Margins="2 1 0 0" readonly="true" FieldStyle="background-color:#E5E5E5;"> </ext:TextField>
                                    <ext:TriggerField ID="txtDGOKJONG" runat = "server" Margins="2 1 0 10" FieldLabel = "곡종" width = "120" LabelWidth ="65" MaxLength ="2" EnforceMaxLength ="true" TabIndex = "16" EnableKeyEvents ="true" readonly="true" FieldStyle="background-color:#E5E5E5;">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(2);"></TriggerClick>
                 
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:TextField ID="txtDGOKJONGNM" runat="server" Width="180" Margins="2 1 0 0" readonly="true" FieldStyle="background-color:#E5E5E5;"> </ext:TextField>
                                 </Items>
                           </ext:Panel>
                           <ext:Panel ID="Panel4"  runat="server" Layout="HBoxLayout" Height="32" Padding="3" Border="false">
                                 <Items>
                                    <ext:ComboBox ID="cboDLOADCODE" runat="server" Margins="2 1 0 10" Editable="false" FieldLabel="하역기" LabelWidth="45" width="160">
                                        <Items>
                                            <ext:ListItem Text="UL-1" Value="1" />
                                            <ext:ListItem Text="UL-2" Value="2" />
                                            <ext:ListItem Text="UL-3" Value="3" />
                                            <ext:ListItem Text="UL-4" Value="4" />
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="UL-1" Value="1"></ext:ListItem>
                                        </SelectedItems>
                                    </ext:ComboBox>
                                    <ext:DateField ID="dtpDWKDATE" runat="server" FieldLabel="작업일자"  LabelWidth ="65" Width = "190" Format="yyyy-MM-dd" Margins="2 1 0 10"></ext:DateField>
                                    <ext:TextField ID="txtDSEQ" runat="server" FieldLabel="작업순번" LabelWidth ="65" Width = "140" FieldStyle="background-color:#E5E5E5;" Margins="2 1 0 110" ReadOnly="true" EmptyText="자동부여" ></ext:TextField>
                                    <ext:TextField ID="txtDSUNCHANG" runat="server" FieldLabel="선창" LabelWidth ="35" Width = "80" Margins="2 1 0 10" MaxLength ="1" EnforceMaxLength ="true"></ext:TextField>
                                    <ext:TextField runat="server" ID="txtDSUNCHANGPRE" Hidden="true"></ext:TextField>
                                    <ext:TextField runat="server" ID="txtDBINNOPRE" Hidden="true"></ext:TextField>
                                 </Items>
                           </ext:Panel>
                           <ext:Panel ID="Panel55" runat="server" Flex="1" Height="1" border="false"></ext:Panel>
                           <ext:Panel ID="Panel54" runat="server" Layout="HBoxLayout" Height="32" Padding="3" Border="false" Hidden="false">
                                 <Items>
                                    <ext:TextField ID="txtDWORKTEXT" runat="server" FieldLabel="내용" LabelWidth ="45" Width = "775" Margins="1 1 0 10" ></ext:TextField>
                                 </Items>
                           </ext:Panel>
                           <ext:Panel ID="Panel65" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:DateField ID="dtpDLSDATE" runat="server" FieldLabel="하역시작일자"  LabelWidth ="90" Width = "210" Format="yyyy-MM-dd" Margins="2 1 0 10"  >
                                    </ext:DateField>
                                    <ext:TextField ID="txtDLSTIME" runat="server" FieldLabel="시작시간" LabelWidth ="65" Width = "130" Margins="2 1 0 10" MaxLength ="5" EnforceMaxLength ="true"  >
                                    </ext:TextField>
                                    <ext:TextField ID="txtDSHSTIME" runat="server" FieldLabel="하역시간" LabelWidth ="65" Width = "130" MaxLength ="5" EnforceMaxLength ="true" Margins="2 1 0 10"  ></ext:TextField>
                                    <ext:TextField ID="txtDSHETIME" runat="server" FieldLabel="중단시간" LabelWidth ="65" Width = "130" MaxLength ="5" EnforceMaxLength ="true" Margins="2 1 0 50"  ></ext:TextField>
                                    
                                 </Items>
                           </ext:Panel>
                           <ext:Panel ID="Panel6" runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:DateField ID="dtpDLEDATE" runat="server" FieldLabel="하역완료일자"  LabelWidth ="90" Width = "210" Format="yyyy-MM-dd" Margins="0 1 0 10"  >
                                    </ext:DateField>
                                    <ext:TextField ID="txtDLETIME" runat="server" FieldLabel="완료시간" LabelWidth ="65" Width = "130" Margins="0 1 0 10" MaxLength ="5" EnforceMaxLength ="true"  >
                                    </ext:TextField>
                                    <ext:TextField ID="txtDLOADQTY" runat="server" FieldLabel="하역량" LabelWidth ="65" Width = "170" FieldStyle="text-align:right;" Margins="0 1 0 10" ></ext:TextField>
                                    <ext:TextField ID="txtDSUMQTY" runat="server" FieldLabel="누계량" LabelWidth ="65" Width = "170" FieldStyle="text-align:right;" Margins="0 1 0 10" ></ext:TextField>
                                 </Items>
                           </ext:Panel>
                           <ext:GridPanel ID="grdShipDocDetail" runat="server" Height = "320" Region="North" Padding="3">
                            <Store>
                                <ext:Store ID="stoBinShipDocDetail" runat="server">
                                    <Model>
                                        <ext:Model ID="Model6" runat="server">
                                            <Fields>
                                                <ext:ModelField Name="DSBINSEQ"  Type="String"></ext:ModelField>
                                                <ext:ModelField Name="DSBINNO"  Type="String"></ext:ModelField>
                                                <ext:ModelField Name="DSBINNOHD"  Type="String"></ext:ModelField>
                                                <ext:ModelField Name="DSLOADQTY"  Type="String"></ext:ModelField>
                                            </Fields>
                                        </ext:Model>
                                    </Model>
                                </ext:Store>
                            </Store>
                            <ColumnModel>
                                <Columns>
                                    <ext:ComponentColumn ID="ComponentColumn8" runat="server" DataIndex="DSBINNO" Text="BIN번호" Width="130"  Editor="true" Sortable="false">
                                        <Component>           
                                            <ext:TriggerField ID="trgMIPBINNO" MaxLength = "6" EnforceMaxLength = "true" runat="server" Margins="0 0 0 0">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                                </Triggers>
                                                <Listeners>
                                                    <BeforeRender Handler = "UP_recordLock(item,'IPBIN')"></BeforeRender>
                                                    <TriggerClick Handler="trg_BINNO_ClientTriggerClick(item,trigger,index,tag,e);"></TriggerClick>
                                                    <Blur  Handler = "UP_BINCheck(item);"></Blur>
                                                </Listeners>
                                            </ext:TriggerField>  
                                        </Component>
                                    </ext:ComponentColumn>
                                    <ext:ComponentColumn ID="ComponentColumn1" runat="server" DataIndex="DSLOADQTY" Text="하역량" Align="Right" Width="110"  Editor="true" Sortable="false">
                                        <Renderer Handler="return FormatNoZero(value, '0,000.000');" ></Renderer>
                                        <Component>           
                                            <ext:TextField ID="TextField1" FieldStyle="text-align:right;" runat ="server">
                                                <Listeners>                                                                                        
                                                    <Focus Handler ="this.selectText();"></Focus>
                                                </Listeners>                                           
                                            </ext:TextField>
                                        </Component>
                                    </ext:ComponentColumn>
                                </Columns>
                            </ColumnModel>
                            <SelectionModel>
                                <ext:RowSelectionModel ID="grdSelectDetail" runat="server" Mode="Single"></ext:RowSelectionModel>
                            </SelectionModel>
                        </ext:GridPanel>  
                        </Items>
                </ext:Panel>
        </Items>
    </ext:Window>
</asp:Content>