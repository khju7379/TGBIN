<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinCargill.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinCargill" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">
    <ext:XScript ID="XScript2" runat="server">
        <script type="text/javascript">                       

            var objitem;
            var codeindex;

            function trg_GOKJONG_ClientTriggerClick(item,trigger,index,tag,e) {          

                // IE 전용 시작
                //var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=GK&param2=" + "", null, "dialogWidth=500px; dialogHeight=400px;");

                //if(result != null && result != undefined) {
                //    item.setValue(result.CDCODE);
                //}
                // IE 전용 끝

                // 크롬, 엣지 시작
                codeindex = "GK";
                objitem = item;
                result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=GK&param2=" + "", null, "dialogWidth:500px; dialogHeight:400px;");
                // 크롬, 엣지 끝
            }        
          
            function trg_BINNO_ClientTriggerClick(item,trigger,index,tag,e) {          

                // IE 전용 시작
                //var result = window.showModalDialog("../SiloBin/CodeHelpBinNo.aspx?param1=", null, "dialogWidth=450px; dialogHeight=400px;");
   
                //if(result != null && result != undefined) {
                
                //    item.setValue(result.BCBINNO);
                //}
                // IE 전용 끝

                // 크롬, 엣지 시작
                codeindex = "BIN";
                objitem = item;
                result = window.showModalDialog("../SiloBin/CodeHelpBinNo.aspx?param1=", null, "dialogWidth:450px; dialogHeight:400px;");
                // 크롬, 엣지 끝
            }

            function showModalDialogCallback(result) {

                if (result) {

                    if (codeindex == "GK") {
                        objitem.setValue(result.CDCODE);
                    }
                    if (codeindex == "BIN") {
                        objitem.setValue(result.BCBINNO);
                    }
                }

            }
          

            function UP_recordLock(item, value){
          
              var data = item.record.data;          

         
                if( data.TRSTATUS != 'N' ){ 
                   if( value == 'TDATE' || value == 'GOKJONG' || value == 'TBINNO'){
                       item.setReadOnly(true);
                       item.setFieldStyle("background-color:#E5E5E5;");
                   }
                }
            }             

            function btnNew_Click(){
          
               var store = #{stoBinMove};
               var count = store.getCount();
               var data = null;
           
               if(store){
                   store.add
                     (
                         {
                                TDATE: Current_Date(), 
                                TSEQ: '자동부여',  
                                TGOKJONG:  '',
                                TGOKJONGNM: '',  
                                TBINNO: '', 
                                TSDATE: '', 
                                TSTIME:  '',
                                TEDATE: '', 
                                TETIME: '', 
                                THSTIME: '', 
                                TTRANSQTY: 0,
                                TBIGO   : '',
                                TRSTATUS:'N'
                         }
                     );                
               }
               RowSelectEvent();
            }
        
            var prepareCommand = function (grid, command, record, row) {

                if( record.data.TRSTATUS == 'N') {
                    if (command.command == 'Add' || command.command == 'Cancel' ){
                        command.hidden = false;
                        command.hideMode = 'visibility';
                    }   
                    else
                    {
                        command.hidden = true;
                        command.hideMode = 'visibility';                
                    }
                }
                else if( record.data.TRSTATUS == 'S') {
                    if (command.command == 'Add' || command.command == 'Cancel' ){
                        command.hidden = true;
                        command.hideMode = 'visibility';
                    }   
                    else
                    {
                        command.hidden = false;
                        command.hideMode = 'visibility';                
                    }                
                }
                else{
                        command.hidden = true;
                        command.hideMode = 'visibility';               
                }
            };

            function UP_DateCheck(item, value){           
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

               if( value == 'TDATE' ){
                  item.record.data.TDATE = Ext.util.Format.date(item.value, "Y-m-d");

                   if( item.record.data.TDATE != item.record.raw.TDATE ){
                       RowAutoCheck(item);
                   }
               }

               if( value == 'TSDATE' ){
                  item.record.data.TSDATE = Ext.util.Format.date(item.value, "Y-m-d");

                   if( item.record.data.TSDATE != item.record.raw.TSDATE ){
                       RowAutoCheck(item);
                   }
               }

               if( value == 'TEDATE' ){
                  item.record.data.TEDATE = Ext.util.Format.date(item.value, "Y-m-d");

                   if( item.record.data.TEDATE != item.record.raw.TEDATE ){
                       RowAutoCheck(item);
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

               if( value == 'TSTIME' ){
                  item.record.data.TSTIME = item.value;

                   if( item.record.data.TSTIME != item.record.raw.TSTIME ){
                       RowAutoCheck(item);
                   }
               }
               if( value == 'TETIME' ){
                  item.record.data.TETIME = item.value;

                   if( item.record.data.TETIME != item.record.raw.TETIME ){
                       RowAutoCheck(item);
                   }
               }           
            }      

            function UP_GOKJONGCheck(item){
               if(item.value != ''){
                   var store = #{stoGOKJONG}; 
                   var record = store.findRecord("GOKJONG", item.value);
                   if(!record){
                      item.focus();
                      alert('곡종코드를 확인하세요');
                      return;
                   }
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

            function btnClientSave_Click(){             

                  var obj = #{stoBinMove}.data.items;               
                  var rtnValue;

                  if(obj.length > 0) {

                      for(var i = 0; i < obj.length; i++)
                      {  
                           if(obj[i].get('TRCHECK') != undefined || obj[i].get('TRCHECK') == true)
                           {
                               if( obj[i].data.TGOKJONG == '' )
                               {
                                  alert('곡종을 입력하세요!');
                                  return;                             
                               }
                               if( obj[i].data.TBINNO == '' )
                               { 
                                  alert('이송BIN을  입력하세요!');
                                  return;                             
                               }
                           
                               if( Ext.util.Format.date(obj[i].data.TSDATE,'Ymd') != '' && obj[i].data.TSTIME == '' )
                               {
                                  alert('시작시간을 입력하세요!');
                                  return;
                               }
                               if( Ext.util.Format.date(obj[i].data.TEDATE,'Ymd') != '' && obj[i].data.TETIME == '' )
                               {
                                  alert('종료시간을 입력하세요!');
                                  return;
                               }
                               if( Ext.util.Format.date(obj[i].data.TSDATE,'Ymd') == '' && obj[i].data.TSTIME != '' )
                               {
                                  alert('시작일자를 입력하세요!');
                                  return;
                               }
                               if( Ext.util.Format.date(obj[i].data.TEDATE,'Ymd') == '' && obj[i].data.TETIME != '' )
                               {
                                  alert('종료일자를 입력하세요!');
                                  return;
                               }

                               if( Ext.util.Format.date(obj[i].data.TEDATE,'Ymd') != '' && obj[i].data.TETIME != '' &&
                                   parseFloat(obj[i].data.TTRANSQTY) <= 0 )
                               {
                                  alert('이송종료시에는 이고량을 입력하세요!');
                                  return;
                               }                       

                               if( parseFloat(obj[i].data.TTRANSQTY) > 0 )
                               {
                                  if( Ext.util.Format.date(obj[i].data.TSDATE,'Ymd') != '' && obj[i].data.TSTIME != '' && 
                                      Ext.util.Format.date(obj[i].data.TEDATE,'Ymd') == '' && obj[i].data.TETIME == '')
                                   {
                                      alert('이송시작시에는 이고량을 입력할수없습니다!');
                                      return;
                                   }

                                   if( Ext.util.Format.date(obj[i].data.TSDATE,'Ymd') == '' && obj[i].data.TSTIME == '')
                                   {
                                      alert('이송시작시에는 이고량을 입력할수없습니다!');
                                      return;
                                   }
                               }

                               if( Ext.util.Format.date(obj[i].data.TSDATE,'Ymd') != '' && Ext.util.Format.date(obj[i].data.TEDATE,'Ymd') != '' )
                               {
                                  if( Ext.util.Format.date(obj[i].data.TSDATE,'Ymd') > Ext.util.Format.date(obj[i].data.TEDATE,'Ymd') )
                                  {
                                     alert('시작일자가 종료일자보다 클수 없습니다!');
                                     return;                             
                                  }
                               }
                           }
                      }

                      rtnValue ='';

                      for(var i = 0; i < obj.length; i++)
                      {   
                         if(obj[i].get('TRCHECK') != undefined || obj[i].get('TRCHECK') == true){
                               rtnValue +=  obj[i].data.TRSTATUS + "^;^";
                               rtnValue +=  Ext.util.Format.date(obj[i].data.TDATE,'Ymd') + "^;^";
                               rtnValue +=  obj[i].data.TSEQ + "^;^";
                               rtnValue +=  obj[i].data.TGOKJONG + "^;^";
                               rtnValue +=  obj[i].data.TBINNO + "^;^";
                               rtnValue +=  Ext.util.Format.date(obj[i].data.TSDATE,'Ymd')  + "^;^";
                               rtnValue +=  obj[i].data.TSTIME + "^;^";
                               rtnValue +=  Ext.util.Format.date(obj[i].data.TEDATE,'Ymd')  + "^;^";
                               rtnValue +=  obj[i].data.TETIME + "^;^";
                               rtnValue +=  obj[i].data.THSTIME + "^;^";
                               rtnValue +=  comma_to_number(obj[i].data.TTRANSQTY) + "^;^";
                               rtnValue +=  obj[i].data.TBIGO + "^/^";
                           }
                      }         
                  }
              
                  if( rtnValue != ''){    
                      Ext.net.DirectMethod.request('UP_SetBinMoveArrayValue', {
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
                  else
                  {
                     alert('선택한 자료가 없습니다!');
                     return;
                  }
              
            }       
        
            function btnClientDel_Click(){

                  var obj = #{stoBinMove}.data.items;  
                  var rtnValue = "";
                  var cnt = 0;

                  if(obj.length > 0) {
                      for(var i = 0; i < obj.length; i++)
                      {                          
                           if(obj[i].get('TRCHECK') != undefined || obj[i].get('TRCHECK') == true){
                             if( obj[i].data.TRSTATUS != 'N' ){
                                rtnValue +=  Ext.util.Format.date(obj[i].data.TDATE,'Ymd') + "^;^";
                                rtnValue +=  obj[i].data.TSEQ + "^;^";                            
                                rtnValue +=  obj[i].data.TBINNO + "^;^";
                                rtnValue +=  Ext.util.Format.date(obj[i].data.TEDATE,'Ymd') + "^;^";
                                rtnValue +=  obj[i].data.TGOKJONG + "^/^";
                             }

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
                              Ext.net.DirectMethod.request('UP_SetBinMoveArrayDelValue', {
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
        
            function GUBN_Select(){
                
                    var GUBN = #{cboSearch}.getValue().toString();
                    var SDATE = Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd');
                    var EDATE = Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd');

                    if(GUBN == "P")
                    {
                        #{dtpSDATE}.setValue("");
                        #{dtpEDATE}.setValue("");
                    }
                    else
                    {   
                        if(SDATE == "" || EDATE == "")
                        {   
                            var dt = new Date();
                        
                            #{dtpSDATE}.setValue(dt.getFullYear() + "-" + PadLeft(dt.getMonth() - 2,2,'0') + "-" + dt.getDate());
                        
                            #{dtpEDATE}.setValue(dt.getFullYear() + "-" + PadLeft(dt.getMonth() + 1,2,'0') + "-" + dt.getDate());
                        }
                    } 
                
                    Ext.net.DirectMethod.request('UP_SetDataBinding', {
                            url: location.href,
                            params: { 
                                      sSDATE : Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd'),
                                      sEDATE : Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd'),
                                      sBIN   : #{txtBIN}.getValue(),
                                      sGubn  : #{cboSearch}.getValue().toString()
                                    }
                        }
                    );                             
            }

            function UP_DataCheck(item, value){          

               if( value == 'TTRANSQTY' ){
                   item.record.data.TTRANSQTY = item.value;

                   item.record.data.TTRANSQTY = Ext.util.Format.number(item.record.data.TTRANSQTY, '0,000.000');
                   item.setValue(item.record.data.TTRANSQTY);

                   if( Number(comma_to_number(item.record.data.TTRANSQTY)) != Number(item.record.raw.TTRANSQTY) ){
                       RowAutoCheck(item);
                   }
               }

               if( value == 'TBIGO' ){
                  item.record.data.TBIGO = item.value;

                   if( item.record.data.TBIGO != item.record.raw.TBIGO ){
                       RowAutoCheck(item);
                   }
               }           
            }   
        
            function RowAutoCheck(item){

               var newselindex;
               var datas = #{stoBinMove}.data.items;
               for(var i = 0; i< datas.length; i++) {
                    if( datas[i].data.TDATE == item.record.data.TDATE &&
                        datas[i].data.TSEQ == item.record.data.TSEQ ){
                        datas[i].set('TRCHECK',true);
                        return;
                     }    
               }
            }      
        
            function RowSelectEvent(){           

                var datas = #{stoBinMove}.data.items; 

                for(var i = 0; i< datas.length; i++) {
                    if( datas[i].data.TRSTATUS == 'N' ){
                      datas[i].set('TRCHECK',true);
                    }
                }
                #{grdBinMove}.getView().refresh();
            } 
        
            var CheckCommand = function (item,rowIndex,record,checked) {               

                var datas = #{stoBinMove}.data.items; 
                datas[rowIndex].set('TRCHECK',checked);              

            }    
         
             function stoCheck_FormatHandler(value) {              

                    return ( value == "Y" ? true : false);
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
      
           function UP_DataFormat(store) {

              var count = store.getCount();
              var data = null;
              for (var i = 0; i < count; i++) {
                 data = store.getAt(i).data;
                 data.TTRANSQTY = Ext.util.Format.number(data.TTRANSQTY, '0,000.000');
              }
            }

            function UP_SetFocus(obj){        
            
                var valueqty =  comma_to_number(obj.record.data.TTRANSQTY);
                obj.record.data.TTRANSQTY = valueqty;
            
                obj.setValue(valueqty);
                obj.selectText();
            }

            function btnPrinter_ClientClick(){
       
                OpenNamePopup("../Resources/Report/SiloBinCargill.aspx?val1=" + Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd') + "&val2=" + Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd') + "&val3=" + #{txtBIN}.getValue() + "&val4=" + #{cboSearch}.getValue().toString(),"SHipDoc", 952, 720);
            
                return false;
            }

        </script>
    </ext:XScript>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">

   <ext:Store ID="stoGOKJONG" runat="server">
        <Model>
            <ext:Model ID="Model10" runat="server">
                <Fields>                    
                    <ext:ModelField Name="GOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="GOKJONGNM"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>

   <ext:Store ID="stoBINNO" runat="server">
        <Model>
            <ext:Model ID="Model2" runat="server">
                <Fields>                    
                    <ext:ModelField Name="SBINNO"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>


    <ext:Viewport ID="vptBinMove" runat="server" Layout="BorderLayout">
        <Items>
            <ext:GridPanel ID="grdBinMove" runat="server" Region="Center">
                <TopBar>
                    <ext:Toolbar ID="Toolbar3" runat="server">
                        <Items>
                            <ext:ToolbarSpacer ID="ToolbarSpacer9" runat="server" Width="10"></ext:ToolbarSpacer>

                            <ext:ComboBox ID = "cboSearch" NAME ="cboSearch" runat="server"  FieldLabel ="구 분" LabelWidth="40" Editable="false" Width="140" Margin="0">
                                        <Items>
                                            <ext:ListItem Text ="전체"    Value ="A" AutoDataBind ="true" Index ="0"></ext:ListItem> 
                                            <ext:ListItem Text ="이송중"  Value ="P" AutoDataBind ="true" Index ="1"></ext:ListItem>
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="이송중" Value="P" />
                                        </SelectedItems> 
                                        <Listeners>
                                           <Select Handler="GUBN_Select();" />
                                        </Listeners>   
                            </ext:ComboBox>
                            <ext:ToolbarSpacer ID="ToolbarSpacer3" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpSDATE" runat="server" FieldLabel="이송일자"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd"></ext:DateField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer15" runat="server" Width="3"></ext:ToolbarSpacer>
                            <ext:Label ID="Label5" runat="server" Text="~"></ext:Label>
                            <ext:ToolbarSpacer ID="ToolbarSpacer16" runat="server" Width="3"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpEDATE" runat="server" width="110" Format="yyyy-MM-dd"></ext:DateField>                                                       
                            <ext:ToolbarSpacer ID="ToolbarSpacer20" runat="server" Width="40"></ext:ToolbarSpacer>
                            <ext:TextField ID="txtBIN" runat="server" FieldLabel="BIN번호:" LabelWidth ="60" Margins="0 5 0 0"> </ext:TextField>
                            <ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="10"></ext:ToolbarSpacer>                         

                            <ext:ToolbarFill ID="ToolbarFill3" runat="server"></ext:ToolbarFill>
                            <ext:ToolbarSeparator ID="ToolbarSeparator6"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="Button3" runat="server" Icon="Find" Text="조회">
                                <DirectEvents>
                                    <Click OnEvent="btnFind_Click">
                                        <EventMask ShowMask="true" Msg="조회중..." Target="CustomTarget" CustomTarget="#{vptBinMove}"></EventMask>
                                    </Click>
                                </DirectEvents>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator1"   runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="btnNew" runat="server" Text="신규" Icon="Add" Margins = "0 0 0 0">
                                   <Listeners>
                                        <Click Handler = "btnNew_Click()">                                   
                                        </Click>
                                  </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator5"   runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="btnPrt" runat="server" Icon="Printer" Text="출력" Hidden="true">
                                <Listeners>
                                    <Click Fn="btnPrinter_ClientClick"></Click>
                                </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator2"   runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="btnSave" runat="server" Text="저장" Icon="DatabaseSave" Margins = "0 0 0 0">
                                   <Listeners>
                                        <Click Handler = "btnClientSave_Click()">                                   
                                        </Click>
                                  </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator3"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="btnDel" runat="server" Text="삭제" Icon="Delete" Margins = "0 0 0 0">
                                   <Listeners>
                                        <Click Handler = "btnClientDel_Click()">                                   
                                        </Click>
                                  </Listeners>
                            </ext:Button>

                          
                            <ext:ToolbarSeparator ID="ToolbarSeparator4"  runat="server"></ext:ToolbarSeparator>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Store>
                    <ext:Store ID="stoBinMove" runat="server">
                        <Model>
                            <ext:Model ID="Model5" Name="Person" runat="server">
                                <Fields>
                                    <ext:ModelField Name="TDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TSEQ"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TGOKJONG"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TGOKJONGNM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TBINNO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TSDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TSTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TEDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TETIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="THSTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TTRANSQTY"  Type="Float"> </ext:ModelField>
                                    <ext:ModelField Name="TBIGO"    Type="String"></ext:ModelField>
                                    <ext:ModelField Name="TRSTATUS"  Type="String"></ext:ModelField>
                               </Fields>
                            </ext:Model>
                        </Model>
                        <Listeners>
                            <DataChanged Handler = "UP_DataFormat(#{stoBinMove})"></DataChanged>
                        </Listeners>
                    </ext:Store>
                </Store>
                <ColumnModel>
                    <Columns>     
                          
                          <ext:CheckColumn ID="TRCHECK" runat = "server" Text="선택"  DataIndex="TRCHECK" Align="Center" StopSelection = "false" Width="80" Sortable="false" Editable="true" >
                                    <Listeners>
                                         <CheckChange Fn ="CheckCommand"></CheckChange>
                                    </Listeners>
                           </ext:CheckColumn>   
                       <ext:ComponentColumn ID="ComponentColumn1" runat="server" DataIndex="TDATE" Text="이송일자" Align="Left" Width="110"  Editor="true">
                                <Component>    
                                    <ext:DateField ID="dtpTDATE"  Format ="yyyy-MM-dd" runat ="server" >                                               
                                        <Listeners>      
                                            <BeforeRender Handler = "UP_recordLock(item,'TDATE')"></BeforeRender>
                                            <Focus Handler ="this.selectText();"></Focus>
                                            <Blur  Handler = "UP_DateCheck(item,'TDATE');"></Blur>
                                        </Listeners>                                           
                                    </ext:DateField>
                                </Component>
                        </ext:ComponentColumn>
                        <ext:Column ID="Column2" runat="server" DataIndex="TSEQ" Text="이송순번" Align="Center" Width="80" >
                        </ext:Column>                        
                        <ext:ComponentColumn ID="ComponentColumn2" runat="server" DataIndex="TGOKJONG" Text="곡종" Align="Center" Width="70"  Editor="true" >                                
                                <Component>              
                                            <ext:TriggerField ID="txtTGOKJONG" MaxLength = "2" EnforceMaxLength = "true"  Width = "70" runat="server" Margins="0 0 0 0">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                                </Triggers>
                                                <Listeners>
                                                    <BeforeRender Handler = "UP_recordLock(item,'GOKJONG')"></BeforeRender>
                                                    <TriggerClick Handler="trg_GOKJONG_ClientTriggerClick(item,trigger,index,tag,e);"></TriggerClick>
                                                    <Blur  Handler = "UP_GOKJONGCheck(item);"></Blur>
                                                </Listeners>
                                            </ext:TriggerField>  
                                </Component>
                        </ext:ComponentColumn>                       
                        <ext:Column ID="Column5" runat="server" DataIndex="TGOKJONGNM" Text="곡종명" Align="Left" Width="120">
                        </ext:Column>                                    
                        <ext:ComponentColumn ID="ComponentColumn3" runat="server" DataIndex="TBINNO" Text="이송BIN" Align="Center" Width="100"  Editor="true" >                                
                                <Component>                                           
                                           <ext:TriggerField ID="trgTBINNO" MaxLength = "6" EnforceMaxLength = "true" runat="server" Margins="0 0 0 0">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                                </Triggers>
                                                <Listeners>
                                                    <BeforeRender Handler = "UP_recordLock(item,'TBINNO')"></BeforeRender>
                                                    <TriggerClick Handler="trg_BINNO_ClientTriggerClick(item,trigger,index,tag,e);"></TriggerClick>
                                                    <Blur  Handler = "UP_BINCheck(item);"></Blur>
                                                </Listeners>
                                            </ext:TriggerField>  
                                </Component>
                        </ext:ComponentColumn>
                        <ext:Column ID="Column1" runat="server" Text="작업시작" >
                          <Columns>
                                   <ext:ComponentColumn ID="ComponentColumn5" runat="server" DataIndex="TSDATE" Text="일자" Align="Left" Width="110"  Editor="true">
                                    <Component>           
                                        <ext:DateField ID="DateField1"  Format ="yyyy-MM-dd" runat ="server" >                                               
                                            <Listeners>      
                                                <BeforeRender Handler = "UP_recordLock(item,'STDATE')"></BeforeRender>                                                                                  
                                                <Focus Handler ="this.selectText(); "></Focus>
                                                <Blur  Handler = "UP_DateCheck(item,'TSDATE'); "></Blur>                                                                                                
                                            </Listeners>                                           
                                        </ext:DateField>
                                    </Component>
                                   </ext:ComponentColumn>
                                   <ext:ComponentColumn ID="ComponentColumn8" runat="server" DataIndex="TSTIME" Text="시간" Align="Left" Width="80"  Editor="true">
                                    <Component>           
                                         <ext:TextField ID="TextField11" MaxLength = "5" EnforceMaxLength = "true" FieldStyle="text-align:left;" runat ="server" >
                                               <Listeners>         
                                                 <BeforeRender Handler = "UP_recordLock(item,'STTIME')"></BeforeRender>                                                                               
                                                 <Focus Handler ="this.selectText();"></Focus>
                                                 <Blur  Handler = "UP_TimeCheck(item,'TSTIME'); "></Blur>
                                               </Listeners>                                           
                                         </ext:TextField>
                                    </Component>
                                   </ext:ComponentColumn>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="Column11" runat="server" Text="작업종료">
                          <Columns>
                                 <ext:ComponentColumn ID="ComponentColumn6" runat="server" DataIndex="TEDATE" Text="일자" Align="Left" Width="110"  Editor="true">
                                    <Component>           
                                        <ext:DateField ID="DateField2"  Format ="yyyy-MM-dd" runat ="server" >                                               
                                            <Listeners>              
                                                <BeforeRender Handler = "UP_recordLock(item,'ETDATE')"></BeforeRender>                                                                          
                                                <Focus Handler ="this.selectText();"></Focus>
                                                <Blur  Handler = "UP_DateCheck(item,'TEDATE'); "></Blur>
                                            </Listeners>                                           
                                        </ext:DateField>
                                    </Component>
                                   </ext:ComponentColumn>
                                   <ext:ComponentColumn ID="ComponentColumn9" runat="server" DataIndex="TETIME" Text="시간" Align="Left" Width="80"  Editor="true">
                                    <Component>           
                                         <ext:TextField ID="TextField3" MaxLength = "5" EnforceMaxLength = "true" FieldStyle="text-align:left;" runat ="server" >
                                               <Listeners>         
                                                 <BeforeRender Handler = "UP_recordLock(item,'ETTIME')"></BeforeRender>                                                                               
                                                 <Focus Handler ="this.selectText();"></Focus>
                                                 <Blur  Handler = "UP_TimeCheck(item,'TETIME'); "></Blur>                                                 
                                               </Listeners>                                  
                                         </ext:TextField>
                                    </Component>
                                   </ext:ComponentColumn>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="Column6" runat="server" DataIndex="THSTIME" Text="가동시간" Align="Center" Width="80">
                        </ext:Column>                        
                        <ext:ComponentColumn ID="colTTRANSQTY" runat="server" DataIndex="TTRANSQTY" Text="이송량(M/T)" Align="Right" Width="110" Editor="true">                               
                                <Component>           
                                     <ext:TextField ID="TextField2"  FieldStyle="text-align:right;" runat ="server" >
                                           <Listeners>         
                                             <BeforeRender Handler = "UP_recordLock(item, 'OVQTY')"></BeforeRender>                                                                               
                                             <Focus Handler ="UP_SetFocus(this);"></Focus>
                                             <Blur  Handler = "UP_DataCheck(item,'TTRANSQTY');"></Blur>
                                           </Listeners>                                           
                                     </ext:TextField>
                                </Component>
                        </ext:ComponentColumn>
                        <ext:ComponentColumn ID="ComponentColumn7" runat="server" DataIndex="TBIGO" Text="비   고" Align="left" Flex="1" Editor="true">
                                <Component>           
                                     <ext:TextField ID="TextField1" FieldStyle="text-align:left;" runat ="server" >
                                           <Listeners>         
                                             <BeforeRender Handler = "UP_recordLock(item,'BIGO')"></BeforeRender>                                                                               
                                             <Focus Handler ="this.selectText();"></Focus>
                                             <Blur  Handler = "UP_DataCheck(item,'TBIGO');"></Blur>
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