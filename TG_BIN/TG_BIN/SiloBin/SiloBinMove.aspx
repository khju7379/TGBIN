<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinMove.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinMove" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">
    <ext:XScript ID="XScript2" runat="server">
        <script type="text/javascript">                       

            var objitem;
            var codeindex;

            function command_Renderer(command, record) {

                var rtnValue = "";

                if (record.data.MVSTATUS != 'E' && record.data.MVSTATUS != 'N' ) {
                    command.hidden = false;
                    if (record.data.MVSTATUS == "S") {
                        color = "blue";
                        text = "시 작"; ;
                    }
                    else if (record.data.MVSTATUS == "P") {
                        color = "red";
                        text = "종 료"; ;
                    }

                    rtnValue = "<span style=\"color:" + color + ";\">" + text + "</span>";

                    command.text = rtnValue;

                }
                else
                {
                    command.hidden = true;
                }

            }

            function grdBinMove_ClientCommand(item, command, record, recordIndex, cellIndex) {

                var msg;
                var WkGubn;              
               
                var MDate;
                var MTime;                

                msg = record.data.MVSTATUS == "S" ? "BIN  이고작업을 시작하시겠습니까?": "BIN 이고작업을 종료하시겠습니까?";
                WkGubn = record.data.MVSTATUS == "S" ? "S": "E";

                if( record.data.MVSTATUS == "S" ){
                    if(  record.data.MMOVEQTY > 0 ){
                        Ext.MessageBox.alert("확인", "이고작업 시작시에는 이고량을 입력할수 없습니다.");   
                        return;
                    }
                    MDate = Ext.util.Format.date(record.data.MMEDATE, 'Ymd');
                    MTime = record.data.METIME;

                    if( MDate != '' || MTime != '')
                    {
                        if( MDate == '' ){
                            Ext.MessageBox.alert("확인", "이고작업 시작일자를 확인하세요.");   
                            return;           
                        }  
                        if( MTime == '' ){
                            Ext.MessageBox.alert("확인", "이고작업 시작시간을 확인하세요.");   
                            return;           
                        }                                  
                    }
                }

                if( record.data.MVSTATUS == "P" ){
                    if(  record.data.MMOVEQTY <= 0 ){
                        Ext.MessageBox.alert("확인", "이고작업 종료시에 반드시 이고량을 입력해야합니다.");   
                        return;
                    }
                    //종료일자, 종료시간 입력시 둘다 있어야 한다.
                    MDate = Ext.util.Format.date(record.data.MMEDATE, 'Ymd');
                    MTime = record.data.METIME;

                    if( MDate != '' || MTime != '')
                    {
                        if( MDate == '' ){
                            Ext.MessageBox.alert("확인", "이고작업 종료일자를 확인하세요.");   
                            return;           
                        }  
                        if( MTime == '' ){
                            Ext.MessageBox.alert("확인", "이고작업 종료시간을 확인하세요.");   
                            return;           
                        }                                  
                    }
                }              


                Ext.MessageBox.confirm("확인", msg, function (btn) {
                    if (btn == "yes") {                       
                        Ext.net.DirectMethod.request('UP_SetBinMoveDataProcess', {
                            url: location.href,
                            params: { MDATE: Ext.util.Format.date(record.data.MDATE, 'Ymd'),
                                      MSEQ: record.data.MSEQ,
                                      MMVDATE: MDate,
                                      MMVTIME: MTime,
                                      MMOVEQTY: Ext.util.Format.number(record.data.MMOVEQTY, "0000.000"),
                                      sBin : #{txtBIN}.getValue(),
                                      TIMEGUBN:WkGubn,
                                      SDATE : Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd'),
                                      EDATE : Ext.util.Format.date(#{dtpEDATE}.getValue(), 'Ymd'),
                                      GUBN: #{cboSearch}.getValue().toString()
                            },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 이고작업을 처리중입니다..",
                                target: "customtarget",
                                customTarget: #{vptBinMove}
                            }
                        }
                        );
                    }
                });
               
            }

            function FormatNoZero(value, format) {
                var rtnValue = Ext.util.Format.number(value, format);

                if (value == 0 || value == "0") {
                    rtnValue = " ";
                }

                return rtnValue;
            }

           function GetSelectedDatas() {
                var rtnValue = "";
                var obj = #{rselBinMove};
                if(obj.selected.items.length > 0) {
                    rtnValue +=  obj.selected.items[0].data.MDATE + "^;^" + obj.selected.items[0].data.MSEQ + "^/^";
                }                
                return rtnValue;
            }            

          function grdBinStatus_CellClick(item, td, cellIndex, record, tr, rowIndex, e) {
              if( record.data.SCALLGUBN == '1' ){
                #{txtMMVBINNO}.setValue(record.data.SBINNO);  
                #{txtMMVBINNOGOKJONG}.setValue(record.data.SGOKJONG);  
                #{txtMMVBINNOGOKJONGNM}.setValue(record.data.SGOKJONGNM);  
              }
              else{
                #{txtMIPBINNO}.setValue(record.data.SBINNO);  
                #{txtMIPBINNOGOKJONG}.setValue(record.data.SGOKJONG);  
                #{txtMIPBINNOGOKJONGNM}.setValue(record.data.SGOKJONGNM);  
             }

             #{winBinPopup}.hide();
          }

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

         
                if( data.MVSTATUS != 'N' ){ 
                    if( value == 'MVDATE' || value == 'GOKJONG' || value == 'MVBIN' || value == 'IPBIN' ){
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
                                MDATE: Current_Date(), 
                                MSEQ: '자동부여',  
                                SGOKJONG1:  '',
                                SGOKJONG1NM: '',  
                                MMVBINNO: '', 
                                MIPBINNO: '', 
                                MMSDATE: '', 
                                MSTIME:  '',
                                MMEDATE: '', 
                                METIME: '', 
                                MHSTIME: '', 
                                MMOVEQTY: 0,
                                MBIGO   : '',
                                MVSTATUS:'N'
                            }
                        );                
                }
                RowSelectEvent();
            }

            function grdBinMove_SaveCommand(item, command, record, recordIndex, cellIndex) {

                if( command == 'Cancel'){
                    var datas = #{stoBinMove}.data.items;
                    #{stoBinMove}.remove(datas[recordIndex]);
                    #{grdBinMove}.getView().refresh();
                    return;
                }

                if( record.data.MDATE == '' ){
                    Ext.Msg.alert('Error', '이고일자를 확인하십시오.'); 
                    return;
                }

                if( record.data.SGOKJONG1 == '' ){
                    Ext.Msg.alert('Error', '곡종을 확인하십시오.'); 
                    return;
                }

                if( record.data.MMVBINNO == '' ){
                    Ext.Msg.alert('Error', '출고BIN번호를 확인하십시오.'); 
                    return;
                }

                if( record.data.MIPBINNO == '' ){
                    Ext.Msg.alert('Error', '입고BIN번호를 확인하십시오.'); 
                    return;
                }

                if( record.data.MMVBINNO == record.data.MIPBINNO ){
                    Ext.Msg.alert('Error', '출고BIN번호 와 입고BIN번호는 같을수 없습니다.'); 
                    return;
                }

                if( record.data.MVSTATUS != 'S' ){
                    if( parseFloat(record.data.MMOVEQTY) > 0 ){
                        Ext.Msg.alert('Error', '이고작업 시작이후 이고량을 입력할수있습니다.'); 
                        return;
                    }
                }

                Ext.net.DirectMethod.request('UP_SetBinMoveDataSave', {
                    url: location.href,
                    params: {   MDATE: Ext.util.Format.date(record.data.MDATE, 'Ymd'),
                                MSEQ: record.data.MSEQ,     
                                MGOKJONG: record.data.SGOKJONG1,      
                                MMVBINNO: record.data.MMVBINNO,      
                                MIPBINNO: record.data.MIPBINNO,      
                                MMSDATE: Ext.util.Format.date(record.data.MMSDATE,"Ymd"),       
                                MSTIME:  record.data.MSTIME.replace(':',''),        
                                MMEDATE: Ext.util.Format.date(record.data.MMEDATE,"Ymd"),
                                METIME:  record.data.METIME.replace(':',''),       
                                MHSTIME: record.data.MHSTIME.replace(':',''),       
                                MMOVEQTY: record.data.MMOVEQTY,      
                                MSTCHECK1: '',      
                                MSTCHECK2: '',      
                                MSTCHECK3: '',      
                                MBIGO:    record.data.MBIGO,     
                                TIMEGUBN:command,
                                SDATE: Ext.util.Format.date(#{dtpSDATE}.getValue(),"Ymd"),
                                EDATE: Ext.util.Format.date(#{dtpEDATE}.getValue(),"Ymd"),
                                BIN: #{txtBIN}.getValue(),
                                GUBN: #{cboSearch}.getValue().toString()
                    },
                    eventMask: {
                        showMask: true,
                        msg: "BIN 이고자료를 처리중입니다..",
                        target: "customtarget",
                        customTarget: #{vptBinMove}
                    }
                });
           
            }     

        
            var prepareCommand = function (grid, command, record, row) {

                if( record.data.MVSTATUS == 'N') {
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
                else if( record.data.MVSTATUS == 'S') {
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

                if( value == 'MDATE' ){
                    item.record.data.MDATE = Ext.util.Format.date(item.value, "Y-m-d");

                    if( item.record.data.MDATE != item.record.raw.MDATE ){
                        RowAutoCheck(item);
                    }
                }

                if( value == 'MMSDATE' ){
                    item.record.data.MMSDATE = Ext.util.Format.date(item.value, "Y-m-d");

                    if( item.record.data.MMSDATE != item.record.raw.MMSDATE ){
                        RowAutoCheck(item);
                    }
                }

                if( value == 'MMEDATE' ){
                    item.record.data.MMEDATE = Ext.util.Format.date(item.value, "Y-m-d");

                    if( item.record.data.MMEDATE != item.record.raw.MMEDATE ){
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

                if( value == 'MSTIME' ){
                    item.record.data.MSTIME = item.value;

                    if( item.record.data.MSTIME != item.record.raw.MSTIME ){
                        RowAutoCheck(item);
                    }
                }
                if( value == 'METIME' ){
                    item.record.data.METIME = item.value;

                    if( item.record.data.METIME != item.record.raw.METIME ){
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
                            if(obj[i].get('MVCHEK') != undefined || obj[i].get('MVCHEK') == true)
                            {
                                if( obj[i].data.SGOKJONG1 == '' )
                                {
                                    alert('곡종을 입력하세요!');
                                    return;                             
                                }
                                if( obj[i].data.MMVBINNO == '' )
                                { 
                                    alert('이고BIN을  입력하세요!');
                                    return;                             
                                }
                                if( obj[i].data.MIPBINNO == '' )
                                {
                                    alert('입고BIN을  입력하세요!');
                                    return;                             
                                }

                                if( obj[i].data.MIPBINNO == '' )
                                {
                                    alert('입고BIN을  입력하세요!');
                                    return;                             
                                }
                                if( Ext.util.Format.date(obj[i].data.MMSDATE,'Ymd') != '' && obj[i].data.MSTIME == '' )
                                {
                                    alert('시작시간을 입력하세요!');
                                    return;
                                }
                                if( Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd') != '' && obj[i].data.METIME == '' )
                                {
                                    alert('종료시간을 입력하세요!');
                                    return;
                                }
                                if( Ext.util.Format.date(obj[i].data.MMSDATE,'Ymd') == '' && obj[i].data.MSTIME != '' )
                                {
                                    alert('시작일자를 입력하세요!');
                                    return;
                                }
                                if( Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd') == '' && obj[i].data.METIME != '' )
                                {
                                    alert('종료일자를 입력하세요!');
                                    return;
                                }

                                if( Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd') != '' && obj[i].data.METIME != '' &&
                                    parseFloat(obj[i].data.MMOVEQTY) <= 0 )
                                {
                                    alert('이고종료시에는 이고량을 입력하세요!');
                                    return;
                                }                       

                                if( parseFloat(obj[i].data.MMOVEQTY) > 0 )
                                {
                                    if( Ext.util.Format.date(obj[i].data.MMSDATE,'Ymd') != '' && obj[i].data.MSTIME != '' && 
                                        Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd') == '' && obj[i].data.METIME == '')
                                    {
                                        alert('이고시작시에는 이고량을 입력할수없습니다!');
                                        return;
                                    }

                                    if( Ext.util.Format.date(obj[i].data.MMSDATE,'Ymd') == '' && obj[i].data.MSTIME == '')
                                    {
                                        alert('이고시작시에는 이고량을 입력할수없습니다!');
                                        return;
                                    }
                                }

                                if( Ext.util.Format.date(obj[i].data.MMSDATE,'Ymd') != '' && Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd') != '' )
                                {
                                    if( Ext.util.Format.date(obj[i].data.MMSDATE,'Ymd') > Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd') )
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
                            if(obj[i].get('MVCHEK') != undefined || obj[i].get('MVCHEK') == true){
                                rtnValue +=  obj[i].data.MVSTATUS + "^;^";
                                rtnValue +=  Ext.util.Format.date(obj[i].data.MDATE,'Ymd') + "^;^";
                                rtnValue +=  obj[i].data.MSEQ + "^;^";
                                rtnValue +=  obj[i].data.SGOKJONG1 + "^;^";
                                rtnValue +=  obj[i].data.MMVBINNO + "^;^";
                                rtnValue +=  obj[i].data.MIPBINNO + "^;^";
                                rtnValue +=  Ext.util.Format.date(obj[i].data.MMSDATE,'Ymd')  + "^;^";
                                rtnValue +=  obj[i].data.MSTIME + "^;^";
                                rtnValue +=  Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd')  + "^;^";
                                rtnValue +=  obj[i].data.METIME + "^;^";
                                rtnValue +=  obj[i].data.MHSTIME + "^;^";
                                rtnValue +=  comma_to_number(obj[i].data.MMOVEQTY) + "^;^";
                                rtnValue +=  obj[i].data.MBIGO + "^/^";
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
                            if(obj[i].get('MVCHEK') != undefined || obj[i].get('MVCHEK') == true){
                                if( obj[i].data.MVSTATUS != 'N' ){
                                rtnValue +=  Ext.util.Format.date(obj[i].data.MDATE,'Ymd') + "^;^";
                                rtnValue +=  obj[i].data.MSEQ + "^;^";                            
                                rtnValue +=  obj[i].data.MMVBINNO + "^;^";
                                rtnValue +=  obj[i].data.MIPBINNO + "^;^";
                                rtnValue +=  Ext.util.Format.date(obj[i].data.MMEDATE,'Ymd') + "^/^";
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

                if( value == 'MMOVEQTY' ){
                    item.record.data.MMOVEQTY = item.value;

                    item.record.data.MMOVEQTY = Ext.util.Format.number(item.record.data.MMOVEQTY, '0,000.000');
                    item.setValue(item.record.data.MMOVEQTY);

                    if( Number(comma_to_number(item.record.data.MMOVEQTY)) != Number(item.record.raw.MMOVEQTY) ){
                        RowAutoCheck(item);
                    }
                }

                if( value == 'MBIGO' ){
                    item.record.data.MBIGO = item.value;

                    if( item.record.data.MBIGO != item.record.raw.MBIGO ){
                        RowAutoCheck(item);
                    }
                }           
            }   
        
            function RowAutoCheck(item){

                var newselindex;
                var datas = #{stoBinMove}.data.items;
                for(var i = 0; i< datas.length; i++) {
                    if( datas[i].data.MDATE == item.record.data.MDATE &&
                        datas[i].data.MSEQ == item.record.data.MSEQ ){
                        datas[i].set('MVCHEK',true);
                        return;
                        }    
                }
            }      
        
            function RowSelectEvent(){           

                var datas = #{stoBinMove}.data.items; 

                for(var i = 0; i< datas.length; i++) {
                    if( datas[i].data.MVSTATUS == 'N' ){
                        datas[i].set('MVCHEK',true);
                    }
                }
                #{grdBinMove}.getView().refresh();
            } 
        
            var CheckCommand = function (item,rowIndex,record,checked) {               

                    var datas = #{stoBinMove}.data.items; 
                    datas[rowIndex].set('MVCHEK',checked);              

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
                    data.MMOVEQTY = Ext.util.Format.number(data.MMOVEQTY, '0,000.000');
                }
            }

            function UP_SetFocus(obj){        
            
                var valueqty =  comma_to_number(obj.record.data.MMOVEQTY);
                obj.record.data.MMOVEQTY = valueqty;
            
                obj.setValue(valueqty);
                obj.selectText();
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
                                            <ext:ListItem Text ="이고중"  Value ="P" AutoDataBind ="true" Index ="1"></ext:ListItem>
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="이고중" Value="P" />
                                        </SelectedItems> 
                                        <Listeners>
                                           <Select Handler="GUBN_Select();" />
                                        </Listeners>   
                            </ext:ComboBox>
                            <ext:ToolbarSpacer ID="ToolbarSpacer3" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:DateField ID="dtpSDATE" runat="server" FieldLabel="이고일자"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd"></ext:DateField>
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
                                    <ext:ModelField Name="MDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MSEQ"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SGOKJONG1"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="SGOKJONG1NM"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MMVBINNO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MIPBINNO"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MMSDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MSTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MMEDATE"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="METIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MHSTIME"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MMOVEQTY"  Type="Float"> </ext:ModelField>
                                    <ext:ModelField Name="MBIGO"    Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MVSTATUS"  Type="String"></ext:ModelField>
                                    <ext:ModelField Name="MVSAVE"  Type="String"></ext:ModelField>
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
                          
                          <ext:CheckColumn ID="MVCHEK" runat = "server" Text="선택"  DataIndex="MVCHEK" Align="Center" StopSelection = "false" Width="80" Sortable="false" Editable="true" >
                                    <Listeners>
                                         <CheckChange Fn ="CheckCommand"></CheckChange>
                                    </Listeners>
                           </ext:CheckColumn>   
                       <ext:ComponentColumn ID="ComponentColumn1" runat="server" DataIndex="MDATE" Text="이고일자" Align="Left" Width="110"  Editor="true">
                                <Component>    
                                    <ext:DateField ID="dtpMDATE"  Format ="yyyy-MM-dd" runat ="server" >                                               
                                        <Listeners>      
                                            <BeforeRender Handler = "UP_recordLock(item,'MVDATE')"></BeforeRender>
                                            <Focus Handler ="this.selectText();"></Focus>
                                            <Blur  Handler = "UP_DateCheck(item,'MDATE');"></Blur>
                                        </Listeners>                                           
                                    </ext:DateField>
                                </Component>
                        </ext:ComponentColumn>
                        <ext:Column ID="Column2" runat="server" DataIndex="MSEQ" Text="이고순번" Align="Center" Width="80" >
                        </ext:Column>                        
                        <ext:ComponentColumn ID="ComponentColumn2" runat="server" DataIndex="SGOKJONG1" Text="곡종" Align="Center" Width="70"  Editor="true" >                                
                                <Component>              
                                            <ext:TriggerField ID="txtSGOKJONG1" MaxLength = "2" EnforceMaxLength = "true"  Width = "70" runat="server" Margins="0 0 0 0">
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
                        <ext:Column ID="Column5" runat="server" DataIndex="SGOKJONG1NM" Text="곡종명" Align="Left" Width="120">
                        </ext:Column>                                    
                        <ext:ComponentColumn ID="ComponentColumn3" runat="server" DataIndex="MMVBINNO" Text="이고BIN" Align="Center" Width="100"  Editor="true" >                                
                                <Component>                                           
                                           <ext:TriggerField ID="trgMMVBINNO" MaxLength = "6" EnforceMaxLength = "true" runat="server" Margins="0 0 0 0">
                                                <Triggers>
                                                    <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                                </Triggers>
                                                <Listeners>
                                                    <BeforeRender Handler = "UP_recordLock(item,'MVBIN')"></BeforeRender>
                                                    <TriggerClick Handler="trg_BINNO_ClientTriggerClick(item,trigger,index,tag,e);"></TriggerClick>
                                                    <Blur  Handler = "UP_BINCheck(item);"></Blur>
                                                </Listeners>
                                            </ext:TriggerField>  
                                </Component>
                        </ext:ComponentColumn>
                        <ext:ComponentColumn ID="ComponentColumn4" runat="server" DataIndex="MIPBINNO" Text="입고BIN" Align="Center" Width="100"  Editor="true" >                                
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
                        <ext:Column ID="Column1" runat="server" Text="작업시작" >
                          <Columns>
                                   <ext:ComponentColumn ID="ComponentColumn5" runat="server" DataIndex="MMSDATE" Text="일자" Align="Left" Width="110"  Editor="true">
                                    <Component>           
                                        <ext:DateField ID="DateField1"  Format ="yyyy-MM-dd" runat ="server" >                                               
                                            <Listeners>      
                                                <BeforeRender Handler = "UP_recordLock(item,'STDATE')"></BeforeRender>                                                                                  
                                                <Focus Handler ="this.selectText(); "></Focus>
                                                <Blur  Handler = "UP_DateCheck(item,'MMSDATE'); "></Blur>                                                                                                
                                            </Listeners>                                           
                                        </ext:DateField>
                                    </Component>
                                   </ext:ComponentColumn>
                                   <ext:ComponentColumn ID="ComponentColumn8" runat="server" DataIndex="MSTIME" Text="시간" Align="Left" Width="80"  Editor="true">
                                    <Component>           
                                         <ext:TextField ID="TextField11" MaxLength = "5" EnforceMaxLength = "true" FieldStyle="text-align:left;" runat ="server" >
                                               <Listeners>         
                                                 <BeforeRender Handler = "UP_recordLock(item,'STTIME')"></BeforeRender>                                                                               
                                                 <Focus Handler ="this.selectText();"></Focus>
                                                 <Blur  Handler = "UP_TimeCheck(item,'MSTIME'); "></Blur>
                                               </Listeners>                                           
                                         </ext:TextField>
                                    </Component>
                                   </ext:ComponentColumn>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="Column11" runat="server" Text="작업종료">
                          <Columns>
                                 <ext:ComponentColumn ID="ComponentColumn6" runat="server" DataIndex="MMEDATE" Text="일자" Align="Left" Width="110"  Editor="true">
                                    <Component>           
                                        <ext:DateField ID="DateField2"  Format ="yyyy-MM-dd" runat ="server" >                                               
                                            <Listeners>              
                                                <BeforeRender Handler = "UP_recordLock(item,'ETDATE')"></BeforeRender>                                                                          
                                                <Focus Handler ="this.selectText();"></Focus>
                                                <Blur  Handler = "UP_DateCheck(item,'MMEDATE'); "></Blur>
                                            </Listeners>                                           
                                        </ext:DateField>
                                    </Component>
                                   </ext:ComponentColumn>
                                   <ext:ComponentColumn ID="ComponentColumn9" runat="server" DataIndex="METIME" Text="시간" Align="Left" Width="80"  Editor="true">
                                    <Component>           
                                         <ext:TextField ID="TextField3" MaxLength = "5" EnforceMaxLength = "true" FieldStyle="text-align:left;" runat ="server" >
                                               <Listeners>         
                                                 <BeforeRender Handler = "UP_recordLock(item,'ETTIME')"></BeforeRender>                                                                               
                                                 <Focus Handler ="this.selectText();"></Focus>
                                                 <Blur  Handler = "UP_TimeCheck(item,'METIME'); "></Blur>                                                 
                                               </Listeners>                                  
                                         </ext:TextField>
                                    </Component>
                                   </ext:ComponentColumn>
                            </Columns>
                        </ext:Column>
                        <ext:Column ID="Column6" runat="server" DataIndex="MHSTIME" Text="가동시간" Align="Center" Width="80">
                        </ext:Column>                        
                        <ext:ComponentColumn ID="colMMOVEQTY" runat="server" DataIndex="MMOVEQTY" Text="이고량(M/T)" Align="Right" Width="110" Editor="true">                               
                                <Component>           
                                     <ext:TextField ID="TextField2"  FieldStyle="text-align:right;" runat ="server" >
                                           <Listeners>         
                                             <BeforeRender Handler = "UP_recordLock(item, 'OVQTY')"></BeforeRender>                                                                               
                                             <Focus Handler ="UP_SetFocus(this);"></Focus>
                                             <Blur  Handler = "UP_DataCheck(item,'MMOVEQTY');"></Blur>
                                           </Listeners>                                           
                                     </ext:TextField>
                                </Component>
                        </ext:ComponentColumn>
                        <ext:ComponentColumn ID="ComponentColumn7" runat="server" DataIndex="MBIGO" Text="비   고" Align="left" Flex="1" Editor="true">
                                <Component>           
                                     <ext:TextField ID="TextField1" FieldStyle="text-align:left;" runat ="server" >
                                           <Listeners>         
                                             <BeforeRender Handler = "UP_recordLock(item,'BIGO')"></BeforeRender>                                                                               
                                             <Focus Handler ="this.selectText();"></Focus>
                                             <Blur  Handler = "UP_DataCheck(item,'MBIGO');"></Blur>
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

