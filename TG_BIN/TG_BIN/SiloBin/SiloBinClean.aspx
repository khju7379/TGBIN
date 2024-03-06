<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinClean.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinClean" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">

   <%--  <link rel="Stylesheet" href="../Resources/Styles/FontStyle.css" />
--%>
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

            function command_Renderer(command, record, btnGubn) {

                if (btnGubn == 'S') {
                    if (record.data.CLSSUTIME == "" && record.data.CLESUTIME == "") {
                        command.hidden = false;
                    }
                    else if (record.data.CLSSUTIME != "" && record.data.CLESUTIME == "") {
                        command.hidden = true;
                    }
                    else {
                        command.hidden = true;
                    }
                }
                else {
                    if (record.data.CLSSUTIME == "" && record.data.CLESUTIME == "") {
                        command.hidden = true;
                    }
                    else if (record.data.CLSSUTIME != "" && record.data.CLESUTIME == "") {
                        command.hidden = false;
                    }                  
                    else {
                        command.hidden = true;
                    }
                }
            }
            
          function UP_TimeCheck(item, value){

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
           
           if( value == 'CLSSUTIME' ){
              item.record.data.CLSSUTIME = item.value;

               if( item.record.data.CLSSUTIME != item.record.raw.CLSSUTIME ){
                   RowAutoCheck(item);
               }
           }
           if( value == 'CLESUTIME' ){
              item.record.data.CLESUTIME = item.value;

               if( item.record.data.CLESUTIME != item.record.raw.CLESUTIME ){
                   RowAutoCheck(item);
               }
           }                 
        }
        
        function btnNew_Click(){
          
           var store = #{stoBinClean};
           var count = store.getCount();
           var data = null;
           
           if(store){
               store.add
                 (
                     {
                            CLDATE: Current_Date(), 
                            CLSEQ: '자동부여',  
                            CLBINNO:  '',
                            CLBIGO: '', 
                            CLSSUTIME:  '',
                            CLESUTIME: '',
                            CLSTATUS:'N'
                     }
                 );                
           }
           RowSelectEvent();
       }       
       
       function RowSelectEvent(){           

           var datas = #{stoBinClean}.data.items; 

           for(var i = 0; i< datas.length; i++) {
               if( datas[i].data.CLSTATUS == 'N' ){
                   datas[i].set('CLCHECK',true);
               }
           }
           #{grdBinClean}.getView().refresh();
        }           
        
        function btnClientSave_Click(){
              var obj = #{stoBinClean}.data.items;
              var rtnValue = "";

              if(obj.length > 0)
              {
                  for(var i = 0; i < obj.length; i++)
                  {   
                       if(obj[i].get('CLCHECK') != undefined || obj[i].get('CLCHECK') == true){
                            rtnValue +=  Ext.util.Format.date(obj[i].data.CLDATE,'Ymd') + "^;^";
                            rtnValue += obj[i].data.CLSEQ + "^;^";
                            rtnValue += obj[i].data.CLBINNO + "^;^";
                            rtnValue += obj[i].data.CLSSUTIME + "^;^";
                            rtnValue += obj[i].data.CLESUTIME + "^;^";
                            rtnValue += obj[i].data.CLBIGO + "^;^";
                            rtnValue += obj[i].data.CLSTATUS + "^/^";
                       }
                  }         
                
                  Ext.net.DirectMethod.request('UP_BinCleanArrayValue', {
                        url: location.href,
                        params: { 
                                  sArrayValue  : rtnValue,
                                  SDATE : Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd'),
                                  EDATE : Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd'),
                                  BIN   : #{txtBIN}.getValue(),
                                  GUBN  : #{cboSearch}.getValue().toString()
                                }
                    }
                  );
              }
              else{
                    alert('선택한 자료가 없습니다!');
                    return;
              }
        }          
        
        function btnClientDel_Click(){

              var obj = #{stoBinClean}.data.items;  
              var rtnValue = "";
              var cnt = 0;

              if(obj.length > 0) {
                  for(var i = 0; i < obj.length; i++)
                  {                          
                       if(obj[i].get('CLCHECK') != undefined || obj[i].get('CLCHECK') == true){
                         
                            rtnValue +=  Ext.util.Format.date(obj[i].data.CLDATE,'Ymd') + "^;^";
                            rtnValue +=  obj[i].data.CLSEQ + "^;^";                            
                            rtnValue +=  obj[i].data.CLBINNO + "^;^";

                            cnt = cnt + 1;
                       }                      
                  }         
              }

              if( rtnValue == '' && cnt == 0)
              {
                 alert('선택한 자료가 없습니다!');
                 return;
              }

               Ext.MessageBox.confirm("확인", "삭제 하시겠습니까?", function (btn) {
                    if (btn == "yes") {                       
                          Ext.net.DirectMethod.request('UP_SetBinCleanArrayDelValue', {
                                    url: location.href,
                                    params: { 
                                                sArrayValue  : rtnValue,
                                                SDATE : Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd'),
                                                EDATE : Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd'),
                                                BIN   : #{txtBIN}.getValue(),
                                                GUBN  : #{cboSearch}.getValue().toString()
                                            }
                                }
                                );              
                    }
                });
        }    
        
        var CheckCommand = function (item,rowIndex,record,checked) {    
        
            var datas = #{stoBinClean}.data.items; 
       
            if( datas[rowIndex].data.CLSTATUS != 'E'){
                datas[rowIndex].set('CLCHECK',checked);    
            }
            else
            {   
                datas[rowIndex].set('CLCHECK',false);
                return;
            }
         }    

        function SetTextFocus(value) {             
             
             switch (value) {
                    case 1:
                        #{dtpSDATE}.focus();
                        break;
                    case 2:
                        #{dtpEDATE}.focus();
                        break;
                }
            }  

        function UP_recordLock(item, value){
          
            var data = item.record.data;          
          
            if( data.CLSTATUS != 'N'){ 
                
                item.setReadOnly(true);
                item.setFieldStyle("background-color:#E5E5E5;");
                
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
           
           item.record.data.CLDATE = Ext.util.Format.date(item.value, "Y-m-d");

           if( item.record.data.CLDATE != item.record.raw.CLDATE ){
               RowAutoCheck(item);
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

        function UP_DataCheck(item, value){          
   
            item.record.data.CLBIGO = item.value;

            if( item.record.data.CLBIGO != item.record.raw.CLBIGO ){
                RowAutoCheck(item);
            }
        }  

        function RowAutoCheck(item){

           var newselindex;
           var datas = #{stoBinClean}.data.items;

           for(var i = 0; i< datas.length; i++) {
                if( datas[i].data.CLDATE == item.record.data.CLDATE &&
                    datas[i].data.CLSEQ == item.record.data.CLSEQ && 
                    datas[i].data.CLBINNO == item.record.data.CLBINNO)
                 {
                    datas[i].set('CLCHECK',true);
                    return;
                 }    
           }
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
 
    <ext:Hidden ID="hidAuthSABUN" runat="server"></ext:Hidden>
 
    <ext:Viewport ID="vptBinClean" runat="server" Layout="BorderLayout">
        <Items>
            <ext:GridPanel ID="grdBinClean" runat="server" Region="Center" >
                <TopBar>
                    <ext:Toolbar ID="Toolbar3" runat="server">
                        <Items>
                            <ext:ToolbarSpacer ID="ToolbarSpacer9" runat="server" Width="10"></ext:ToolbarSpacer>

                            <ext:ComboBox ID = "cboSearch" NAME ="cboSearch" runat="server"  FieldLabel ="구 분" LabelWidth="40" Editable="false" Width="140" Margin="0">
                                        <Items>
                                            <ext:ListItem Text ="작업중"    Value ="P" AutoDataBind ="true" Index ="0"></ext:ListItem> 
                                            <ext:ListItem Text ="작업종료"  Value ="E" AutoDataBind ="true" Index ="1"></ext:ListItem>
                                            <ext:ListItem Text ="전체"  Value ="A" AutoDataBind ="true" Index ="2"></ext:ListItem>
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="작업중" Value="P" />
                                        </SelectedItems> 
                            </ext:ComboBox>
                            <ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpSDATE" runat="server" FieldLabel="기준일자"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd"></ext:DateField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer15" runat="server" Width="3"></ext:ToolbarSpacer>
                            <ext:Label ID="Label5" runat="server" Text="~"></ext:Label>
                            <ext:ToolbarSpacer ID="ToolbarSpacer16" runat="server" Width="3"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpEDATE" runat="server" width="110" Format="yyyy-MM-dd"></ext:DateField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer20" runat="server" Width="60"></ext:ToolbarSpacer>
                            <ext:TextField ID="txtBIN" runat="server" FieldLabel="BIN번호:" LabelWidth ="60" Margins="0 5 0 0"> </ext:TextField>
                            <ext:ToolbarFill ID="ToolbarFill3" runat="server"></ext:ToolbarFill>
                            <ext:ToolbarSeparator ID="ToolbarSeparator6"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="Button3" runat="server" Icon="Find" Text="조회">
                                <DirectEvents>
                                    <Click OnEvent="btnFind_Click">
                                        <EventMask ShowMask="true" Msg="조회중..." Target="CustomTarget" CustomTarget="#{vptBinClean}"></EventMask>
                                    </Click>
                                </DirectEvents>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator3"   runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="btnNew" runat="server" Text="신규" Icon="Add" Margins = "0 0 0 0">
                                   <Listeners>
                                        <Click Handler = "btnNew_Click()">                                   
                                        </Click>
                                  </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator2"  runat="server"></ext:ToolbarSeparator>
                             <ext:Button ID="btnSave" runat="server" Text="저장" Icon="DatabaseSave" Margins = "0 0 0 0">
                                   <Listeners>
                                        <Click Handler = "btnClientSave_Click()">                                   
                                        </Click>
                                  </Listeners>
                            </ext:Button>
                             <ext:ToolbarSeparator ID="ToolbarSeparator4"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="btnDel" runat="server" Text="삭제" Icon="Delete" Margins = "0 0 0 0">
                                   <Listeners>
                                        <Click Handler = "btnClientDel_Click()">                                   
                                        </Click>
                                  </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator1"  runat="server"></ext:ToolbarSeparator>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Store>
                    <ext:Store ID="stoBinClean" runat="server">
                        <Model>
                            <ext:Model ID="Model5" runat="server">
                                <Fields>
                                    <ext:ModelField Name="CLDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="CLSEQ"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="CLBINNO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="CLBIGO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="CLSSUTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="CLESUTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="CLSTATUS"  Type="String"></ext:ModelField>
                                </Fields>
                            </ext:Model>
                        </Model>
                    </ext:Store>
                </Store>
                <SelectionModel>
                    <ext:RowSelectionModel ID="RowSelectionModel2" runat="server" Mode="Single"></ext:RowSelectionModel>
                </SelectionModel>
                <ColumnModel>
                    <Columns>
                        <ext:CheckColumn ID="CLCHECK" runat = "server" Text="선택"  DataIndex="CLCHECK" Align="Center" StopSelection = "false" Width="80" Sortable="false" Editable="true" >
                                <Listeners>
                                     <CheckChange Fn ="CheckCommand"></CheckChange>
                                </Listeners>
                        </ext:CheckColumn>   
                        <ext:ComponentColumn ID="ComponentColumn2" runat="server" DataIndex="CLDATE" Text="작업일자" Align="Left" Width="160"  Editor="true">
                                <Component>    
                                    <ext:DateField ID="dtpCLDATE"  Format ="yyyy-MM-dd" runat ="server" >                                               
                                        <Listeners>      
                                            <BeforeRender Handler = "UP_recordLock(item)"></BeforeRender>
                                            <Focus Handler ="this.selectText();"></Focus>
                                            <Blur  Handler = "UP_DateCheck(item);"></Blur>
                                        </Listeners>                                           
                                    </ext:DateField>
                                </Component>
                        </ext:ComponentColumn>
                        <ext:Column ID="Column31" runat="server" DataIndex="CLSEQ" Text="순번" Align="Left" Width="130">
                        </ext:Column>
                        <ext:ComponentColumn ID="ComponentColumn3" runat="server" DataIndex="CLBINNO" Text="BIN" Align="Center" Width="140"  Editor="true" >                                
                                <Component>                                           
                                           <ext:TriggerField ID="trgCLBINNO" MaxLength = "6" EnforceMaxLength = "true" runat="server" Margins="0 0 0 0">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                                </Triggers>
                                                <Listeners>
                                                    <BeforeRender Handler = "UP_recordLock(item)"></BeforeRender>
                                                    <TriggerClick Handler="trg_BINNO_ClientTriggerClick(item,trigger,index,tag,e);"></TriggerClick>
                                                    <Blur  Handler = "UP_BINCheck(item);"></Blur>
                                                </Listeners>
                                            </ext:TriggerField>  
                                </Component>
                        </ext:ComponentColumn>
                        <ext:ComponentColumn ID="ComponentColumn5" runat="server" DataIndex="CLSSUTIME" Text="작업시작" Align="Left" Width="100" Editor="true">
                                <Component>           
                                         <ext:TextField ID="TextField1" MaxLength = "5" EnforceMaxLength = "true" FieldStyle="text-align:left;" runat ="server" >
                                               <Listeners>         
                                                 <Focus Handler ="this.selectText();"></Focus>
                                                 <Blur  Handler = "UP_TimeCheck(item, 'CLSSUTIME');"></Blur>
                                               </Listeners>                                  
                                         </ext:TextField>
                                </Component>
                        </ext:ComponentColumn>                                   
                        <ext:ComponentColumn ID="ComponentColumn4" runat="server" DataIndex="CLESUTIME" Text="작업종료" Align="Left" Width="100" Editor="true">
                                <Component>           
                                         <ext:TextField ID="TextField5" MaxLength = "5" EnforceMaxLength = "true" FieldStyle="text-align:left;" runat ="server" >
                                               <Listeners>         
                                                 <Focus Handler ="this.selectText();"></Focus>
                                                 <Blur  Handler = "UP_TimeCheck(item, 'CLESUTIME');"></Blur>
                                               </Listeners>                                  
                                         </ext:TextField>
                                </Component>
                        </ext:ComponentColumn>
                        <ext:ComponentColumn ID="ComponentColumn1" runat="server" DataIndex="CLBIGO" Text="비고" Align="Left" Flex = "1" Editor="true">
                                <Component>           
                                         <ext:TextField ID="TextField2" EnforceMaxLength = "true" FieldStyle="text-align:left;" runat ="server" >
                                               <Listeners>         
                                                 <Focus Handler ="this.selectText();"></Focus>
                                                 <Blur  Handler = "UP_DataCheck(item);"></Blur>
                                               </Listeners>                                  
                                         </ext:TextField>
                                </Component>
                        </ext:ComponentColumn>
                    </Columns>
                </ColumnModel>
            </ext:GridPanel>         
        </Items>
    </ext:Viewport>    

</asp:Content>
