<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="PlantsSiloBinMonitoring.aspx.cs" Inherits="TG_BIN.SiloBin.PlantsSiloBinMonitoring" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">   

  <link rel="Stylesheet" href="../Resources/Styles/SiloBin.css" />

  <ext:XScript ID="XScript1" runat="server">
    <script type="text/javascript">         
           
            var BoardDate = "";
            var BoardDateMonth = "";
            var ShipLoadDate = "";
            var dBinChTotalQty = 0;;
            var dBinEmpTotalQty = 0;;
            var dBinJegoTotalQty = 0;
            var ItemSelTempCodeClickCheck = "";
            var BinItemNumber = "";

            var selDcLoadGkCode = '';

            //하역작업일지 스크롤
            var scrleft_DCLOAD = 0;
            var scrtop_DCLOAD  = 0;
            //항차 
            var scrleft_Hangcha = 0;
            var scrtop_Hangcha = 0;
            //원산지
            var scrleft_Wonsan = 0;
            var scrtop_Wonsan = 0;
            //곡종
            var scrleft_Gokjong = 0;
            var scrtop_Gokjong = 0;
            //특기사항 
            var scrleft_Board = 0;
            var scrtop_Board = 0;
            //이고
            var scrleft_Move = 0;
            var scrtop_Move = 0;            

            ///////화면 사이즈 조정 시작//////////////////////////

            function setTransformStyle(obj, attrName, value) {
                var setFlags = ["", "ms", "webkit", "moz", "o"];
                for (var i = 0; i < setFlags.length; i++) {
                    obj.style[setFlags[i] + attrName] = value;
                }
            }
        
            // 창 화면에 따른 모니터링 화면 크기조정
            function MonitorBodyResize(winName) {
                var winSize = { Main: { x: 5760, y: 2160} };
                var wbody = document.getElementById("Monitor" + winName);
                
                var mbody = #{pnlMain}.body.dom;

                var factorX = mbody.offsetWidth / winSize[winName].x;
                var factorY = mbody.offsetHeight / winSize[winName].y;

                var factor = (factorX < factorY ? factorX : factorY);
                setTransformStyle(wbody, "Transform", "scaleX(" + factor + ") scaleY(" + factor + ")");
                setTransformStyle(wbody, "TransformOrigin", "top left");

                var fh = winSize[winName].y * factor;
                var m = parseInt((mbody.offsetHeight - fh) / 2, 10);

                wbody.parentNode.style.paddingTop = m + "px";

                var fw = winSize[winName].x * factor;
				m = parseInt((mbody.offsetWidth - fw) / 2, 10);
                wbody.parentNode.style.paddingLeft = m + "px";
            }
            ///////화면 사이즈 조정 종료//////////////////////////


            /////////빈 상세화면 팝업 시작//////////////////////////

            function OpenSubWin(id) {
               document.getElementById(id).style.display = "";
            }

            function CloseSubWin(id) {
                document.getElementById(id).style.display = "none";
            }

            //bin 상세화면 
            function OpenUnitInfoWin(recordKey, value) {

                var div = document.getElementById("BinStatus_bodyContent");
                div.innerHTML = '';

                var selBinNum;
                var sto = #{stoPlantUnits};
                var record = sto.findRecord("UNITCODE", recordKey);
                if (record) {                                    
                    
                    //bin 상태가 없으면 상세정보 팝업 아니면 작업내용 팝업
                    
                    if( record.data.BINSTATUSCODE == '' || value != 'BIN' ){
                        var div = document.getElementById("SelBinNum");
                        if( div.length > 0 )
                        {                         
                          for (var i = 0; i < div.length; i++) {
                             if(  div[i].selected == true)
                             {
                                selBinNum = div[i].value;
                             }
                          }
                        }

                        document.getElementById("winBinStatusInfos").style.display = "none";

                        if( document.getElementById("winUnitInfos").style.display != "none" &&  selBinNum == recordKey )
                        {
                           CloseSubWin("winUnitInfos");
                           return;
                        }

                        document.getElementById("winUnitInfos").style.display = "";                    
                        var rObj = document.getElementById("unit_" + recordKey);
                        var px = 610;
                        var py = 1090;

                        document.getElementById("winUnitInfos").style.left = px + "px";
                        document.getElementById("winUnitInfos").style.top = py + "px";

                        setBinChartInfo(record);            
                   }
                   else
                   {
                       
                        document.getElementById("winUnitInfos").style.display = "none";
                        if( document.getElementById("winBinStatusInfos").style.display != "none" && BinItemNumber == recordKey.substr(2,3) )
                        {
                           CloseSubWin("winBinStatusInfos");
                           return;
                        }

                        GetBinStatusWorkList(record);

                        document.getElementById("winBinStatusInfos").style.display = "";                                                 
                                          
                        var rObj = document.getElementById("unit_" + recordKey);
                        var px = 610;
                        var py = 1090;

                       document.getElementById("winBinStatusInfos").style.left = px + "px";
                       document.getElementById("winBinStatusInfos").style.top = py + "px";

                       BinItemNumber = recordKey.substr(2,3);
                   } 
                }
            }

            //BIN 작업상태 코드에 따라 상세정보 가져오기
            function GetBinStatusWorkList(record){                             

                    Ext.net.DirectMethod.request('UP_GetBinStatusInfoData', { 
                    url: location.href,
                    params: {BINNO: record.data.UNITCODE,
                             BINSTATUSCODE:record.data.BINSTATUSCODE,
                             BTCHULIL: record.data.BTCHULIL,
                             BTTKNO:  record.data.BTTKNO  ,
                             BCCORPGUBN : record.data.BCCORPGUBN
                            },
                    eventMask: {
                        showMask: true,
                        msg: "BIN 작업현황 조회중...",
                        target: "customtarget"
                        }
                      }
                   );
            }

            //bin이고 상세정보 표현
            function setBinStatusInfoPopList(Binvalue){
               
                var tableStr = null;
                var store = null;                
                var count = null;
                var data = null;
                var div = document.getElementById("BinStatus_bodyContent");
                div.innerHTML = '';

                //빈 클리닝
                tableStr = '';
                store =  null;
                store = #{stoBinStatusCleanInfos};
                count = store.getCount();
                data = null;
                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;

                        tableStr += "<table class=\"table_01\" style=\"width: 100%;\"> ";
                        tableStr += "	<colgroup>";
                        tableStr += "	<col style=\"width: 15%;\" />";
                        tableStr += "	<col style=\"width: 35%;\" />";
                        tableStr += "	<col style=\"width: 15%;\" />";
                        tableStr += "	<col style=\"width: 35%;\" />";
                        tableStr += "	</colgroup>";
                        tableStr += "	<tr>";
                        if( data.CLSSUTIME == '' && data.CLESUTIME == ''){
                           tableStr += " <th colspan=\"4\" class=\"color_05\">작&nbsp;&nbsp;&nbsp;업&nbsp;&nbsp;&nbsp;예&nbsp;&nbsp;&nbsp;정</th>";
                        }
                        else
                        {
                           tableStr += " <th colspan=\"4\" class=\"color_03\">작&nbsp;&nbsp;&nbsp;업&nbsp;&nbsp;&nbsp;중</th>";
                        }
                        tableStr += "	</tr>";
                        tableStr += "	<tr>";
                        tableStr += "		<th>작업내용</th>";
                        tableStr += "		<td colspan=\"3\">"+data.CLBIGO+"</td>";
                        tableStr += "	</tr> ";
                        tableStr += "	<tr>";
                        tableStr += "		<th>작업일시</th>";
                        tableStr += "		<td colspan=\"3\">"+data.CLDATE+ " " + data.CLSSUTIME + " ~ " + data.CLESUTIME+" </td>";
                        tableStr += "	</tr>			";
                        tableStr += " </table>";
                }
                if(div && count > 0){
                   div.innerHTML = tableStr;
                }

                //하역중
                tableStr = '';
                store =  null;
                store = #{stoBinStatusDOCLOADInfos};
                count = store.getCount();                               
                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;

                    tableStr += "<table class=\"table_01\" style=\"width: 100%;\">";
                        tableStr += "	<colgroup>";
                        tableStr += "	<col style=\"width: 15%;\" />";
                        tableStr += "	<col style=\"width: 35%;\" />";
                        tableStr += "	<col style=\"width: 15%;\" />";
                        tableStr += "	<col style=\"width: 35%;\" />";
                        tableStr += "	</colgroup>";
                        tableStr += "	<tr>";
                        tableStr += "		<th colspan=\"4\" class=\"color_04\">하&nbsp;&nbsp;&nbsp;역&nbsp;&nbsp;&nbsp;중</th>";
                        tableStr += "	</tr>";
                        tableStr += "	<tr>";
                        tableStr += "		<th>작업번호</th>";
                        tableStr += "		<td>"+data.DSWKDATE+"-"+data.DSSEQ+"</td>";
                        tableStr += "		<th>시작일시</th>";
                        tableStr += "		<td>"+data.DSLSDATE+" "+data.DSLSTIME+"</td>";
                        tableStr += "	</tr>   ";
                        tableStr += "	<tr>";
                        tableStr += "		<th>항 차</th>";
                        tableStr += "		<td>"+data.DSHANGCHA+"- "+data.DSHANGCHANM+"</td>";
                        tableStr += "		<th>곡 종</th>";
                        tableStr += "		<td>"+data.DSGOKJONG+"- "+data.DSGOKJONGNM+"</td>";
                        tableStr += "	</tr>   ";
                        tableStr += "	<tr>";
                        tableStr += "		<th>하역기</th>";
                        tableStr += "		<td>"+data.DSLOADCODENM+"</td>";
                        tableStr += "		<th>BIN번호</th>";
                        tableStr += "		<td>"+data.DSBINNO+"</td>";
                        tableStr += "	</tr>   ";
                        tableStr += "	<tr>";
                        tableStr += "		<th>작업내용</th>";
                        tableStr += "		<td>"+data.DWORKTEXT+"</td>";
                        tableStr += "		<th>선 창</th>";
                        tableStr += "		<td>"+data.DSUNCHANG+"</td>";
                        tableStr += "	</tr>   ";
                        tableStr += "	<tr>";
                        tableStr += "		<th>B/L량</th>";
                        tableStr += "		<td colspan=\"3\">"+Ext.util.Format.number(data.DBLQTY, '0,000.000') +" M/T"+"</td>";
                        tableStr += "	</tr>	";
                        tableStr += "</table>";
                          
                }
                if(div && count > 0){
                   div.innerHTML = div.innerHTML + tableStr;
                }              



                //이고
                tableStr = '';
                store =  null;
                store = #{stoBinStatusMoveInfos};
                count = store.getCount();                               
                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;

                            tableStr += " <table class=\"table_01\" style=\"width: 100%;\">  ";
                            tableStr += "	<colgroup>                                 "; 
                            tableStr += "	<col style=\"width: 15%;\" />                ";
                            tableStr += "	<col style=\"width: 35%;\" />                ";
                            tableStr += "	<col style=\"width: 15%;\" />                ";
                            tableStr += "	<col style=\"width: 35%;\" />                ";
                            tableStr += "	</colgroup>                ";
                            tableStr += "	<tr>                ";
                            if( Binvalue == data.MMVBINNO ){
                                tableStr += "<th colspan=\"4\" class=\"color_02\">이&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;出&nbsp;&nbsp;&nbsp; </th>  ";
                            }
                            else
                            { 
                               tableStr += "<th colspan=\"4\" class=\"color_02\">이&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;入&nbsp;&nbsp;&nbsp; </th>  "; 
                            }
                            tableStr += "	</tr> ";
                            tableStr += "	<tr> ";
                            tableStr += "		<th>작업번호</th> ";
                            tableStr += "		<td colspan=\"3\">"+data.MDATE+"-"+data.MSEQ+"</td>";
                            tableStr += "	</tr>                ";
                            tableStr += "	<tr>                ";
                            tableStr += "		<th>이고 BIN</th>       ";
                            if( Binvalue == data.MMVBINNO ){
                                tableStr += "		<td style=\"color:red\" >"+data.MMVBINNO+"</td> ";
                            }
                            else
                            {
                               tableStr += "		<td>"+data.MMVBINNO+"</td> ";
                            }
                            tableStr += "		<th>입고 BIN</th>       ";
                            if( Binvalue == data.MIPBINNO ){
                                tableStr += "		<td style=\"color:red\">"+data.MIPBINNO+"</td> ";
                            }
                            else{
                                tableStr += "		<td>"+data.MIPBINNO+"</td> ";
                            }
                            tableStr += "	</tr>                ";
                            tableStr += "	<tr>                ";
                            tableStr += "		<th>곡&nbsp;&nbsp;종</th> ";
                            tableStr += "		<td>"+data.SGOKJONG1NM+"</td> ";
                            tableStr += "		<th>이고량</th>                ";
                            tableStr += "		<td class=\"text_right\">"+ Ext.util.Format.number(data.MMOVEQTY,'0,000.000')+" M/T"+"</td> ";
                            tableStr += "	</tr>                ";
                            tableStr += "	<tr>                ";
                            tableStr += "		<th>시작일시</th>                ";
                            tableStr += "		<td colspan=\"3\">"+data.MMSDATE+"  "+data.MSTIME+" ~ "+" </td> ";
                            tableStr += "	</tr>                ";
                            tableStr += "  </table>                ";
                }
                if(div && count > 0){
                   div.innerHTML = div.innerHTML + tableStr;
                }       
                
                //카길이송
                tableStr = '';
                store =  null;
                store = #{stoBinStatusCargillInfos};
                count = store.getCount();                               
                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;

                            tableStr += " <table class=\"table_01\" style=\"width: 100%;\">  ";
                            tableStr += "	<colgroup>                                 "; 
                            tableStr += "	<col style=\"width: 15%;\" />                ";
                            tableStr += "	<col style=\"width: 35%;\" />                ";
                            tableStr += "	<col style=\"width: 15%;\" />                ";
                            tableStr += "	<col style=\"width: 35%;\" />                ";
                            tableStr += "	</colgroup>                ";
                            tableStr += "	<tr>";
                            tableStr += "		<th colspan=\"4\" class=\"color_06\">이&nbsp;&nbsp;&nbsp;송&nbsp;&nbsp;&nbsp;중</th>";
                            tableStr += "	</tr>";
                            tableStr += "	<tr> ";
                            tableStr += "		<th>작업번호</th> ";
                            tableStr += "		<td>"+data.TDATE+"-"+data.TSEQ+"</td>";
                            tableStr += "		<th>이송 BIN</th>       ";
                            tableStr += "		<td>"+data.TBINNO+"</td> ";
                            tableStr += "	</tr>                ";
                            tableStr += "	<tr>                ";
                            tableStr += "		<th>곡&nbsp;&nbsp;종</th> ";
                            tableStr += "		<td>"+data.TGOKJONGNM+"</td> ";
                            tableStr += "		<th>이송량</th>                ";
                            tableStr += "		<td class=\"text_right\">"+ Ext.util.Format.number(data.TTRANSQTY,'0,000.000')+" M/T"+"</td> ";
                            tableStr += "	</tr>                ";
                            tableStr += "	<tr>                ";
                            tableStr += "		<th>시작일시</th>                ";
                            tableStr += "		<td colspan=\"3\">"+data.TSDATE+"  "+data.TSTIME+" ~ "+" </td> ";
                            tableStr += "	</tr>                ";
                            tableStr += "  </table>                ";
                }
                if(div && count > 0){
                   div.innerHTML = div.innerHTML + tableStr;
                }        
                
                //출고중     
                tableStr = '';
                store =  null;
                store = #{stoBinStatusCHULInfos};
                count = store.getCount();                               
                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;
                    tableStr += "<table class=\"table_01\" style=\"width: 100%;\"> ";
                    tableStr += "<colgroup>";
                    tableStr += "<col style=\"width: 15%;\" />";
                    tableStr += "<col style=\"width: 35%;\" />";
                    tableStr += "<col style=\"width: 15%;\" />";
                    tableStr += "<col style=\"width: 35%;\" />";
                    tableStr += "</colgroup>";
                    tableStr += "<tr>";
                    tableStr += "		<th colspan=\"4\" class=\"color_01\">출&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;중</th>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>출고번호</th>";
                    tableStr += "	<td colspan=\"3\">"+data.CHCHULDAT+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>차량번호</th>";
                    tableStr += "	<td>"+data.CHNUMBER+"</td>";
                    tableStr += "	<th>BIN</th>";
                    tableStr += "	<td>"+data.CHBINNO+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>화&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;주</th>";
                    tableStr += "	<td colspan=\"3\">"+data.CHHWAJUNM+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;차</th>";
                    tableStr += "	<td colspan=\"3\">"+data.CHHANGCHA+" - "+data.CHHANGCHANM+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>곡&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;중</th>";
                    tableStr += "	<td colspan=\"3\">"+data.CHGOKJONG+" - "+data.CHGOKJONGNM+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>원&nbsp;&nbsp;&nbsp;산&nbsp;&nbsp;&nbsp;지</th>";
                    tableStr += "	<td colspan=\"3\">"+data.CHWONSAN+" - "+data.CHWONSANNM+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>B/L수량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.BEJNQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "	<th>확정량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.HWAKQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>양수량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.JBYSQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "	<th>양도량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.JBYDQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>통관량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.JBCSQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "	<th>출고량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.JBCHQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "</tr>";
                    tableStr += "<tr>";
                    tableStr += "	<th>통관재고량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.JBCSJANQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "	<th>재고량</th>";
                    tableStr += "	<td class=\"text_right\">"+Ext.util.Format.number(data.JBJEGOQTY,'0,000.000')+" M/T"+"</td>";
                    tableStr += "</tr>";
                    tableStr += "</table>";
                }
                if(div && count > 0){
                   div.innerHTML = div.innerHTML + tableStr;
                }         

            }            

            function setBinChartInfo(record){
                 //BIN 상세정보 처리
                   
                   var div = null;
                   var theadObj = null;
                   var tableStr = "";

                   var charcode = 'I';
                   var characii = charcode.charCodeAt(0);                 
                   var charconvertkey;

                   var binnum = record.data.UNITCODE;

                   var binstatus = "";

                   //bin 선택
                   div = document.getElementById("SelBinNum");
                   if( div.length > 0 )
                   {                         
                      for (var i = 0; i < div.length; i++) {
                         if(  div[i].value == binnum)
                         {
                             div[i].selected = true;
                         } 
                      }
                   }

                    //bin 작업상태 표시                  
                    var colorcls;

                    switch(record.data.BINSTATUSCODE){
                         case 'BST':
                            colorcls = "color_BST";
                            break;
                         case 'BPR':
                            colorcls = "color_BPR";
                            break;
                         case 'BCH':
                            colorcls = "color_BCH";
                            break;
                         case 'BMV':
                            colorcls = "color_BMV";
                            break;
                         case 'BCG':
                            colorcls = "color_BCG";
                            break;
                         case 'BSH':
                            colorcls = "color_BSH";
                            break;
                         default:
                            colorcls = "";
                            break;
                    }

                    switch(record.data.BINSTATUSNAME){
                         case 'BST':
                            binstatus = "작업예정";
                            break;
                         case 'BPR':
                            binstatus = "작업중";
                            break;
                         case 'BSB':
                            binstatus = "작업대기";
                            break;
                         case 'BRD':
                            binstatus = "작업준비";
                            break;
                         case 'BSH':
                            binstatus = "하역중";
                            break;
                         case 'BMVIN':
                            binstatus = "이고入";
                            break;
                         case 'BMVCH':
                            binstatus = "이고出";
                            break;
                         case 'BCG':
                            binstatus = "이송중";
                            break;
                         case 'BCH':
                            binstatus = "출고중";
                            break;
                         default:
                            binstatus = record.data.BINSTATUSNAME;
                            break;
                    }

                    if( colorcls != ""){
                       document.getElementById("spnBinChartStatus").style.display = "inline";
                       document.getElementById("spnBinChartStatus").className = colorcls;
                       //document.getElementById("spnBinChartStatus").innerHTML =  record.data.BINSTATUSNAME;
                       document.getElementById("spnBinChartStatus").innerHTML =  binstatus;
                    }
                    else
                    {
                       document.getElementById("spnBinChartStatus").style.display = "none";
                    } 
                   
                   //항목 표시
                   div = null;
                   tableStr = '';
                   div = document.getElementById("temperatureitem");
                   tableStr += "<table class=\"table_03 text_center\" style=\"width: 100%;\">";
                   tableStr += "<colgroup><col style=\"width: 15%;\" /><col style=\"width: 35%;\" /><col style=\"width: 50%;\" /></colgroup>";
                   tableStr += "<tr><th colspan=\"2\">항목</th><th>항목명</th></tr>";
                   //곡종
                   tableStr += "<tr>";
                   tableStr += "<td class=\"std\" colspan=\"2\">곡종</td>";
                   tableStr += "<td>"+record.data.SGOKJONGNM+"</td>";
                   tableStr += "</tr>";
                   //원산지
                   tableStr += "<tr>";
                   tableStr += "<td class=\"std\" colspan=\"2\">원산지</td>";
                   tableStr += "<td>"+record.data.SWONSANNM+"</td>";
                   tableStr += "</tr>";
                   //모선
                   tableStr += "<tr>";
                   tableStr += "<td class=\"std\" colspan=\"2\">모선</td>";
                   tableStr += "<td>"+record.data.SHANGCHANM+"</td>";
                   tableStr += "</tr>";
                   //화주/협회
                   tableStr += "<tr>";
                   tableStr += "<td class=\"std\" colspan=\"2\">화주/협회</td>";
                   tableStr += "<td></td>";
                   tableStr += "</tr>";
                   //입고일자
                   tableStr += "<tr>";
                   tableStr += "<td class=\"std\" colspan=\"2\">입고일자</td>";
                   tableStr += "<td>"+record.data.SIPDATE+"</td>";
                   tableStr += "</tr>";
                   //화물
                   //용량
                   tableStr += "<tr>";
                   tableStr += "<td class=\"std\" rowspan=\"4\">화<br/>물</td>";
                   tableStr += "<td>용 량</td>";
                   tableStr += "<td class=\"text_right\">"+commify(record.data.SCAPA)+" M/T"+"</td>";
                   tableStr += "</tr>";
                   //재고량
                   tableStr += "<tr>";
                   tableStr += "<td>재고량</td>";
                   tableStr += "<td class=\"text_right\">"+commify(record.data.SJEGOQTY)+" M/T"+"</td>";
                   tableStr += "</tr>";
                   //재고율
                   tableStr += "<tr>";
                   tableStr += "<td>재고율</td>";
                   tableStr += "<td class=\"text_right\">"+record.data.SJEGOQTYRATE+" %"+"</td>";
                   tableStr += "</tr>";
                   //출고량
                   tableStr += "<tr>";
                   tableStr += "<td>일 출고량</td>";
                   tableStr += "<td class=\"text_right\">"+commify(record.data.SCHULQTY)+" M/T"+"</td>";
                   tableStr += "</tr>";
                   //BIN 청소일
                   tableStr += "<tr style=\"height:110px;\">";
                   tableStr += "<td class=\"std\" colspan=\"2\">Cleaning</td>";
                   tableStr += "<td>"+record.data.SCLDATE+"</td>";
                   tableStr += "</tr>";       
                   tableStr += "</table>";

                   div.innerHTML = tableStr;     
                   
                   //차트 호출
                   Ext.net.DirectMethod.request('UP_GetBinRateChart', { 
                            url: location.href,
                            params: {sBINNO: binnum },
                            eventMask: {
                                showMask: true,
                                msg: "상세 내역 조회중...",
                                target: "customtarget"
                                }
                           }
                   );
            }

            function BinSelectCombo(value){

                var recordKey = value;
                var sto = #{stoPlantUnits};
                var record = sto.findRecord("UNITCODE", recordKey);
                if (record) {
                   setBinChartInfo(record);
                }                
            }
            /////////빈 상세화면 팝업 종료//////////////////////////

            	
            /////////빈 객체 생성 시작//////////////////////////
            function drowUnits(store) {

                dBinChTotalQty = 0;
                dBinEmpTotalQty = 0;
                dBinJegoTotalQty = 0;

                var count = store.getCount();
                var data = null;
                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;
                    dBinChTotalQty = dBinChTotalQty +  parseFloat(data.SCHULQTY);
                    dBinEmpTotalQty = dBinEmpTotalQty +  parseFloat(data.SEMPQTY);
                    dBinJegoTotalQty = dBinJegoTotalQty +  parseFloat(data.SJEGOQTY);
                    setUnit(data);
                    setUnitTitleLabel(data);
                }   
            }
            
            function setUnit(data) {
                // 상태별 개체생성
                if (data.UNITWINDOW == "") return;
                var div = document.getElementById("unit_" + data.UNITCODE);
                if (!div) {
                    div = document.createElement("div");
                    div.id = "unit_" + data.UNITCODE;
                    div.style.position = "absolute";
                    var imgStr = "";                    
                    var addStyle = "";                
                    var defaultimg = "";
                    var checkimgP = "";
                    var checkimgT = "";

                    defaultimg = "_01";
                    checkimgT = "_02";
                    checkimgP = "_04";


//                    var defaultimg = "_01";
//                    var checkimg = "_02";
                    
//                    if (data.BCCORPGUBN == "T")
//                    {
//                        var defaultimg = "_01";
//                        var checkimg = "_02";
//                    }
//                    else{
//                        var defaultimg = "_03";
//                        var checkimg = "_04";
//                    }
                    

                    //일반 정상 BIN
                    if (data.UNITTYPE == "tank100") {
                        imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:318.00px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + defaultimg + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st01\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:318.00px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgT + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_03' style=\"width:318.00px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgP + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st03\" />";
                    } else if (data.UNITTYPE == "tank101") { //좌측 END BIN
                        imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:139.50px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + defaultimg + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st01\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:139.50px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgT + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_03' style=\"width:139.50px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgP + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st03\" />";
                    } else if (data.UNITTYPE == "tank103") { //우측 END BIN
                        imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:139.50px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + defaultimg + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st01\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:139.50px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgT + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_03' style=\"width:139.50px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgP + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st03\" />";
                    } else if (data.UNITTYPE == "tank102" ) { //스타 BIN
                        imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:279.00px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + defaultimg + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st01\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:279.00px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgT + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_03' style=\"width:279.00px; height:210.33px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + checkimgP + ".png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st03\" />";
                    } else if (data.UNITTYPE == "tank500") { //상옥
                        if (data.UNITCODE.substring(0, 2) == "8A") {
                            imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:168px; height:250px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + "_01.png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st01\" />";
                        }
                        else {
                            imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:254px; height:250px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + "_01.png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st01\" />";
                        }
                        if (data.BCCORPGUBN == "T")
                        {
                            if (data.UNITCODE.substring(0, 2) == "8A") {
                                imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:168px; height:250px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + "_02.png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                            }
                            else {
                                imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:254px; height:250px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + "_02.png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                            }
                        }
                        else {
                            if (data.UNITCODE.substring(0, 2) == "8A") {
                                imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:168px; height:250px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + "_03.png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                            }
                            else {
                                imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:254px; height:250px\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITTYPE + "_03.png\" usemap=\"#unit_map_" + data.UNITCODE + "\" class=\"st02\" />";
                            }

                        }
                    
                    } else {
                        imgStr += "<a href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" >";

                        imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:20%; height:20%\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITCODE.substr(1, data.UNITCODE.length - 4) + "_01.png\" class=\"st01\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:20%; height:20%\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITCODE.substr(1, data.UNITCODE.length - 4) + "_02.png\" class=\"st02\" />";

                        imgStr += "</a>";

                    }

                    div.innerHTML = imgStr;

                    div.style.left = data.UNITPOINTX + "px";
                    div.style.top = data.UNITPOINTY + "px";

                    //if (data.UNITCODE == "8A-101") {
                    //    div.style.left = "10px";
                    //    div.style.top = "132px";
                    //}
                    //else if (data.UNITCODE == "8A-102") {
                    //    div.style.left = "182px";
                    //    div.style.top = "132px";
                    //}
                    //else if (data.UNITCODE == "8A-103") {
                    //    div.style.left = "354px";
                    //    div.style.top = "132px";
                    //}
                    //else {
                    //    div.style.left = data.UNITPOINTX + "px";
                    //    div.style.top = data.UNITPOINTY + "px";
                    //}
                }

                

                if (data.UNITSTATUS) {
                   div.className = "mUnit st"+data.UNITSTATUS;
                } else {
                   div.className = "mUnit st01";
                }
                var mBody = document.getElementById("Group" + data.UNITWINDOW);
                mBody.appendChild(div);
            }                     

         

            function setUnitTitleLabel(data) {
                // 상태별 개체생성
                if (data.UNITWINDOW == "") return;
                var div = document.getElementById("Labelunit_" + data.UNITCODE);
                if (!div) {
                    div = document.createElement("div");
                    div.id = "Labelunit_" + data.UNITCODE;
                    div.style.position = "absolute";
                    var imgStr = "";                    
                    var addStyle = "";         
                    var gateimg1 = "bl_white";                           
                    var gateimg2 = "bl_white";            
                    
                    if(data.BCGATE1 == "ON")
                    {
                        gateimg1 = "bl_red";
                    }
                    else if(data.BCGATE1 == "OFF")
                    {
                        gateimg1 = "bl_green";
                    }

                    if(data.BCGATE2 == "ON")
                    {
                        gateimg2 = "bl_red";
                    }
                    else if(data.BCGATE2 == "OFF")
                    {
                        gateimg2 = "bl_green";
                    }

                    //일반 정상 BIN
                    if (data.UNITTYPE == "tank100") {
                        addStyle = "left:1%; top:20%; width:100%; height:140%; padding-bottom:5px;";
                        imgStr += "<div class=\"unitTitle\" style=\"" + addStyle + "\">";
                        // 게이트 1, 게이트 2
                        
                        if(data.UNITCODE.substr(3,1) == "2")
                        {   
                            imgStr += "<img id='" + data.UNITCODE + "BCGATE1_01' style=\"width:42px; height:42px; position:absolute; top:-38px; left:95px;\" src=\"../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png\"/>"; 
                            imgStr += "<img id='" + data.UNITCODE + "BCGATE2_01' style=\"width:42px; height:42px; position:absolute; top:-38px; left:135px;\" src=\"../Resources/Images/Monitoring/SILOBIN/" + gateimg2 + ".png\"/>"; 
                        }
                        else{
                            imgStr += "<img id='" + data.UNITCODE + "BCGATE1_01' style=\"width:42px; height:42px; position:absolute; top:-38px; left:115px;\" src=\"../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png\"/>"; 
                        }
                        
                        imgStr += "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">";                        
                        imgStr += "<tr>"+GetBinStatus(data)+"</tr>";
                        imgStr += "<tr><td style=\"height:35px\" align=\"center\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + data.SGOKJONGNM + "</a></td></tr>";                        
                        imgStr += "<tr><td style=\"height:35px\" align=\"center\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + data.SWONSANNM + "</a></td></tr>";
                        imgStr += "</table> ";
                        imgStr += "</div>";                        
                    } else if (data.UNITTYPE == "tank101") { //좌측 END BIN
                        addStyle = "left:0%; top:18px;  width:80%; height:110%; padding-bottom:5px;";
                        imgStr += "<div class=\"unitTitle\" style=\"" + addStyle + "\">";
                        imgStr += "<img id='" + data.UNITCODE + "BCGATE1_01' style=\"width:42px; height:42px; position:absolute; top:-38px; left:-10px;\" src=\"../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png\"/>"; 
                        imgStr += "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">";
                        imgStr += "<tr>"+GetBinStatus(data)+"</tr>";
                        imgStr += "<tr><td style=\"height:35px\" align=\"left\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + StringTrim(data.SGOKJONGNM) + "</a></td></tr>";
                        imgStr += "<tr><td style=\"height:35px\" align=\"left\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + StringTrim(data.SWONSANNM) + "</a></td></tr>";
                        imgStr += "</table>";
                        imgStr += "</div>";
                    } else if (data.UNITTYPE == "tank103") { //우측 END BIN
                        addStyle = "left:1%; top:18px; width:80%; height:110%; padding-bottom:5px;";
                        imgStr += "<div class=\"unitTitle\" style=\"" + addStyle + "\">";
                        imgStr += "<img id='" + data.UNITCODE + "BCGATE1_01' style=\"width:42px; height:42px; position:absolute; top:-38px; left:183px;\" src=\"../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png\"/>"; 
                        imgStr += "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">";
                        imgStr += "<tr>"+GetBinStatus(data)+"</tr>";
                        imgStr += "<tr><td style=\"height:35px\" align=\"right\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + StringTrim(data.SGOKJONGNM) + "</a></td></tr>";
                        imgStr += "<tr><td style=\"height:35px\" align=\"right\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + StringTrim(data.SWONSANNM) + "</a></td></tr>";
                        imgStr += "</table>";
                        imgStr += "</div>";
                    } else if (data.UNITTYPE == "tank102" ) { //스타 BIN
                        addStyle = "left:1%; top:18px;  width:100%; height:110%; padding-bottom:5px;";
                        imgStr += "<div class=\"unitTitle\" style=\"" + addStyle + "\">";
                        imgStr += "<img id='" + data.UNITCODE + "BCGATE1_01' style=\"width:42px; height:42px; position:absolute; top:-38px; left:115px;\" src=\"../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png\"/>"; 
                        imgStr += "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">";
                        imgStr += "<tr>"+GetBinStatus(data)+"</tr>";
                        imgStr += "<tr><td style=\"height:35px\" align=\"center\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + StringTrim(data.SGOKJONGNM) + "</a></td></tr>";
                        imgStr += "<tr><td style=\"height:35px\" align=\"center\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + StringTrim(data.SWONSANNM) + "</a></td></tr>";
                        imgStr += "</table>";                        
                        imgStr += "</div>";
                    } else if (data.UNITTYPE == "tank500") { //상옥
                        addStyle = "left:15%; top:10%; width:100%; height:140%; padding-bottom:5px;";
                        imgStr += "<div class=\"unitTitle\" style=\"" + addStyle + "\">";
                        imgStr += "<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">";
                        imgStr += "<tr>"+GetBinStatus(data)+"</tr>";
                        imgStr += "<tr><td style=\"height:40px\" align=\"center\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + data.SGOKJONGNM + "</a></td></tr>";
                        imgStr += "<tr><td style=\"height:40px\" align=\"center\" valign=\"middle\"><a style=\"color:#"+ data.SGKCOLOR +";\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','ITEM');\" >" + data.SWONSANNM  + "</a></td></tr>";
                        imgStr += "</table>";
                        imgStr += "</div>";
                   } else {
                        imgStr += "<a href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\');\" >";
                        imgStr += "<img id='" + data.UNITCODE + "_01' style=\"width:20%; height:20%\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITCODE.substr(1, data.UNITCODE.length - 4) + "_01.png\" class=\"st01\" />";
                        imgStr += "<img id='" + data.UNITCODE + "_02' style=\"width:20%; height:20%\" src=\"../Resources/Images/Monitoring/SILOBIN/" + data.UNITCODE.substr(1, data.UNITCODE.length - 4) + "_02.png\" class=\"st02\" />";

                        imgStr += "</a>";

                    }

                    div.innerHTML = imgStr;
                    
                    div.style.width = "270px";
                    div.style.height = "100px";
                    
                    div.style.left = data.UNITPOINTLX + "px";
                    div.style.top = data.UNITPOINTLY + "px";
                }
                else
                {
                    var record = #{stoITEMSEL}.data.items;
                    var selVal1;
                    var selVal2;
                    
//                    if (data.UNITTYPE == "tank101" || data.UNITTYPE == "tank103" || data.UNITTYPE == "tank102")
//                    {
//                        selVal1 = record[1].data.ITEM.substr(0,2);             
//                    }
//                    else{
//                        selVal1 = record[0].data.ITEM.substr(0,2);             
//                    }

                    selVal1 = record[0].data.ITEM.substr(0,2);             
                    selVal2 = record[1].data.ITEM.substr(0,2);
                    var returnvalue;

                    var theadObj;
                    theadObj = div.querySelectorAll(".unitTitle > table > tbody > tr > td > a");
                    if( theadObj.length > 0 )
                    {                         
                        for (var j = 0; j < theadObj.length; j++) {
                           if( j == 1 ){
                             switch (selVal1){
                                 case 'GK':
                                    returnvalue = data.SGOKJONGNM;
                                    break;
                                 case 'WS':
                                    returnvalue = data.SWONSANNM;
                                    break;
                                 case 'WG':
                                    returnvalue = data.SHWGCODE;
                                    break;
                                 case 'HA':
                                    returnvalue = data.SHANGCHANM;
                                    break;
                                 case 'IP':
                                    returnvalue = data.SIPDATE;
                                    break;
                                 case 'BN':
                                    returnvalue = data.SCLDATE;
                                    break;
                                 case 'CH':
                                    returnvalue = commify(data.SCHULQTY);
                                    break;
                                 case 'JG':
                                    returnvalue = commify(data.SJEGOQTY);
                                    break;
                                 
                                 }
                             theadObj[j].style.color = "#"+data.SGKCOLOR;
                             theadObj[j].innerHTML = returnvalue;
                           }
                           if( j == 2 ){
                                switch (selVal2){
                                 case 'GK':
                                    returnvalue = data.SGOKJONGNM;
                                    break;
                                 case 'WS':
                                    returnvalue = data.SWONSANNM;
                                    break;
                                 case 'WG':
                                    returnvalue = data.SHWGCODE;
                                    break;
                                 case 'HA':
                                    returnvalue = data.SHANGCHANM;
                                    break;
                                 case 'IP':
                                    returnvalue = data.SIPDATE;
                                    break;
                                 case 'BN':
                                    returnvalue = data.SCLDATE;
                                    break;
                                 case 'CH':
                                    returnvalue = commify(data.SCHULQTY);
                                    break;
                                 case 'JG':
                                    returnvalue = commify(data.SJEGOQTY);
                                    break;
                                 }
                              theadObj[j].style.color = "#"+data.SGKCOLOR;
                              theadObj[j].innerHTML = returnvalue;
                           }
                        }
                    }         
                }

                var mBody = document.getElementById("Group" + data.UNITWINDOW);
                mBody.appendChild(div);
            }

            //bin번호자리에 bin번호가 올지 작업표시가 올지 체크 함수
            function GetBinStatus(data){
                var BinStr;
                var align;

                var binstatus;

                switch(data.BINSTATUSNAME){
                        case 'BST':
                        binstatus = "작업예정";
                        break;
                        case 'BPR':
                        binstatus = "작업중";
                        break;
                        case 'BSB':
                        binstatus = "작업대기";
                        break;
                        case 'BRD':
                        binstatus = "작업준비";
                        break;
                        case 'BSH':
                        binstatus = "하역중";
                        break;
                        case 'BMVIN':
                        binstatus = "이고入";
                        break;
                        case 'BMVCH':
                        binstatus = "이고出";
                        break;
                        case 'BCG':
                        binstatus = "이송중";
                        break;
                        case 'BCH':
                        binstatus = "출고중";
                        break;
                        default:
                        binstatus = data.BINSTATUSNAME;
                        break;
                }

                    align = "center";
                    if( data.UNITTYPE == "tank101")
                    {
                      align = "left";
                    }
                    else if(data.UNITTYPE == "tank103")
                    {
                      align = "right";
                    }

                    //bin번호자리에 bin번호가 올지 작업표시가 올지 체크
                    if( data.BINSTATUSCODE == "BST" || data.BINSTATUSCODE == "BSB" || data.BINSTATUSCODE == "BRD") //BIN 작업예정(BST), 작업대기(BSB), 작업준비(BRD)
                    {
                       BinStr = "<td align=\""+align+"\" valign=\"middle\"><a style=\"background-color:#FF0000;\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" >" + binstatus + "</a></td>";
                    }
                    else if(data.BINSTATUSCODE == "BPR")  //BIN 작업중
                    {
                      BinStr = "<td  align=\""+align+"\" valign=\"middle\"><a style=\"background-color:#ff0000;\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" >" + binstatus + "</a></td>";
                    }
                    else if(data.BINSTATUSCODE == "BCH")  //BIN 출고중
                    {
                      BinStr = "<td  align=\""+align+"\" valign=\"middle\"><a style=\"background-color:#0064ff;\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" >" + binstatus + "</a></td>";
                    }
                    else if(data.BINSTATUSCODE == "BMV")  //BIN 이고중
                    {
                      BinStr = "<td  align=\""+align+"\" valign=\"middle\"><a style=\"background-color:#28cd00;\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" >" + binstatus + "</a></td>";
                    }
                    else if(data.BINSTATUSCODE == "BCG")  //BIN 이송중
                    {
                      BinStr = "<td  align=\""+align+"\" valign=\"middle\"><a style=\"background-color:#FFBB00;\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" >" + binstatus + "</a></td>";
                    }
                    else if(data.BINSTATUSCODE == "BSH")  //BIN 하역중
                    {
                      BinStr = "<td  align=\""+align+"\" valign=\"middle\"><a style=\"background-color:#61C2F3;\" href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" >" + binstatus + "</a></td>";
                    }
                    else{
                        if (data.BCCORPGUBN == "T")
                        {
                            BinStr = "<td align=\""+align+"\" valign=\"middle\"><a href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" class=\"tgname\">" + data.UNITDESC + "</a></td>";
                        }
                        else{
                            BinStr = "<td align=\""+align+"\" valign=\"middle\"><a href=\"javascript:void(0);\" onclick=\"OpenUnitInfoWin(\'" + data.UNITCODE + "\','BIN');\" class=\"ptname\">" + data.UNITDESC + "</a></td>";
                        }
                    }

                return BinStr;
            }

            //bin번호자리에 bin번호 또느 작업표시를 리플쉬 될때 다시 표시
            function drowUnitsremark(store){
                
                var div;
                var theadObj;
                var record;
                var recordKey;
                var LoadGubn;
                var data;
                var count = 0;
                var unitStore = #{stoPlantUnits};
                
                count = unitStore.getCount();
                data = null;
                for (var i = 0; i < count; i++) {
                    data = unitStore.getAt(i).data;
                    LoadGubn = data.LOADGUBN;
                    recordKey = data.UNITCODE;
                    record = unitStore.findRecord("UNITCODE", recordKey)
                    if (record) {
                        div = document.getElementById("Labelunit_" + data.UNITCODE);
                        if(div){
                            theadObj = div.querySelectorAll(".unitTitle > table > tbody > tr > td");
                            if( theadObj.length > 0 )
                            {                         
                              for (var j = 0; j < theadObj.length; j++) {
                                 if (data.UNITTYPE == "tank100" || data.UNITTYPE == "tank101" || data.UNITTYPE == "tank102" ||     
                                     data.UNITTYPE == "tank103" || data.UNITTYPE == "tank500") 
                                  {
                                     //Bin번호 자리만 표시한다.
                                     if( j == 0 ){
                                        theadObj[j].innerHTML = GetBinStatus(data);
                                     }
                                  } 
                              }
                           }       
                           
                            // 게이트 표시
                            theadObj = div.querySelectorAll(".unitTitle > img");

                            var gateimg1 = "bl_white";                           
                            var gateimg2 = "bl_white";            
                    
                            if(data.BCGATE1 == "ON")
                            {
                                gateimg1 = "bl_red";
                            }
                            else if(data.BCGATE1 == "OFF")
                            {
                                gateimg1 = "bl_green";
                            }

                            if(data.BCGATE2 == "ON")
                            {
                                gateimg2 = "bl_red";
                            }
                            else if(data.BCGATE2 == "OFF")
                            {
                                gateimg2 = "bl_green";
                            }

                            if( theadObj.length > 0 )
                            {                         
                              for (var j = 0; j < theadObj.length; j++) {
                                 if (data.UNITTYPE == "tank100") 
                                 {
                                    if(data.UNITCODE.substr(3,1) == "2")
                                    {   
                                        //Bin번호 자리만 표시한다.
                                        if( j == 0 ){
                                            theadObj[j].setAttribute("src", "../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png");
                                        }
                                        if( j == 1 ){
                                            theadObj[j].setAttribute("src", "../Resources/Images/Monitoring/SILOBIN/" + gateimg2 + ".png");
                                        }
                                    }
                                    else{
                                        if( j == 0 ){
                                            theadObj[j].setAttribute("src", "../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png");
                                        }
                                    }
                                 }
                                 else 
                                 {
                                    if( j == 0 ){
                                        theadObj[j].setAttribute("src", "../Resources/Images/Monitoring/SILOBIN/" + gateimg1 + ".png");
                                    }
                                 } 
                              }
                           }     
                               
                        }  
                    }    
                }
                
                if( LoadGubn != '1'){
                    rdo_change(#{hidDisplayCheck}.getValue(),"refresh");
                    //if(#{hidGKCheck}.getValue() != "" || #{hidWNCheck}.getValue() != "" || #{hidVSCheck}.getValue() != "")
                    if(#{hidGKCnt}.getValue() == "0" && #{hidWNCnt}.getValue() == "0" && #{hidVSCnt}.getValue() == "0")
                    {  
                        rdo_change(#{hidDisplayCheck}.getValue(),"check");
                    }
                    else{
                        setBinDisplay();
                    }
                    setBinClearDayDisplay();
                }
            }

            //화면에서 bin출입일 선택 항목 찾기
            function setBinClearDayDisplay(){
                
                var div = document.getElementById("binClearbox");                                
                var theadObj = div.querySelectorAll("tr > td > a");
                if( theadObj.length > 0 )
                {                 
                  //선택 
                  for (var i = 0; i < theadObj.length; i++) {
                     if( theadObj[i].className == "on" )
                     {
                        BinClearDay(theadObj[i].id);
                     }
                  }
                }
            }


            //화면에서 표시선택(곡종,원산지,모선)으로 해당 항목 찾기
            function setBinDisplay(){

                var count;
                var dBinChQty = 0;
                var dBinEmpQty = 0;
                var dBinJegoQty = 0;

                var gkrowcnt = 0;
                var wnrowcnt = 0;
                var vsrowcnt = 0;

                var gkcnt = 0;
                var wncnt = 0;
                var vscnt = 0;
                
                var CheckColor;

                var data = null;
                var datads = null;
                var storeds = null;
                                
                var recordKey = "";
                var record = "";                             

                var unitStore = #{stoPlantUnits};         
                var DisplayCheck = #{hidDisplayCheck}.getValue();       
                
                count = unitStore.getCount();
                data = null;
                for (var i = 0; i < count; i++) {
                    data = unitStore.getAt(i).data;
                    recordKey = data.UNITCODE;
                    record = unitStore.findRecord("UNITCODE", recordKey)
                    if (record) {
                        setDataUnitClear(record.data);
                        setUnitTitleLabel(data);
                    }
                }

                for (var i = 0; i < count; i++) 
                {
                    data = unitStore.getAt(i).data;

                    gkcnt = 0;
                    wncnt = 0;
                    vscnt = 0;

                    gkrowcnt = 0;
                    wnrowcnt = 0;
                    vsrowcnt = 0;

                    //곡종    
                    storeds = #{stoGOKJONG};                
                    for(var j = 0 ; j < storeds.getCount(); j++ )
                    {
                        datads = storeds.getAt(j).data;
                        if( data.SGOKJONG == datads.GOKJONG && datads.CHECK == "Y" && DisplayCheck == data.GROUPCHECK)
                        {
                            gkcnt = gkcnt + 1;
                        }
                        if( datads.CHECK == "Y" )
                        {
                            gkrowcnt = gkrowcnt + 1;
                        }
                    }

                    //원산지 
                    storeds = null;
                    storeds = #{stoWonSan};                                                         
                    for(var j = 0 ; j < storeds.getCount(); j++ )
                    {
                        datads = storeds.getAt(j).data;
                        
                        if( data.SWONSAN == datads.IHWONSAN && datads.CHECK == "Y" && DisplayCheck == data.GROUPCHECK)
                        {
                            wncnt = wncnt + 1;
                        }                      
                        if( datads.CHECK == "Y" )
                        {
                            wnrowcnt = wnrowcnt + 1;
                        }
                    }

                    //항차
                    storeds = null;
                    storeds = #{stoHANGCHA};                                                         
                    for(var j = 0 ; j < storeds.getCount(); j++ )
                    {
                        datads = storeds.getAt(j).data;
                        
                        if( data.SHANGCHA == datads.IHHANGCHA && data.BCCORPGUBN == datads.CORPGUBN && datads.CHECK == "Y" && DisplayCheck == data.GROUPCHECK)
                        {   
                            vscnt = vscnt + 1;
                        }                      
                        if( datads.CHECK == "Y" )
                        {   
                            vsrowcnt = vsrowcnt + 1;
                        }
                    }                   

                    recordKey = data.UNITCODE;
                    record = unitStore.findRecord("UNITCODE", recordKey)

                    CheckColor = "N";
                
                    if( gkrowcnt > 0 )
                    {
                        if( gkrowcnt > 0 && wnrowcnt <= 0 && vsrowcnt <= 0)
                        {
                            if( gkcnt > 0 && wncnt <= 0 && vscnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }

                        if( gkrowcnt > 0 && wnrowcnt > 0 && vsrowcnt <= 0)
                        {
                            if( gkcnt > 0 && wncnt > 0 && vscnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }

                        if( gkrowcnt > 0 && wnrowcnt <= 0 && vsrowcnt > 0)
                        {
                            if( gkcnt > 0 && wncnt <= 0 && vscnt > 0 )
                            {
                            CheckColor = "Y";
                            }
                        }

                        if( gkrowcnt > 0 && wnrowcnt > 0 && vsrowcnt > 0)
                        {
                            if( gkcnt > 0 && wncnt > 0 && vscnt > 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                    }

                    if( wnrowcnt > 0 )
                    {
                        if( wnrowcnt > 0 && gkrowcnt <= 0 && vsrowcnt <= 0)
                        {
                            if( wncnt > 0 && gkcnt <= 0 && vscnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                        if( wnrowcnt > 0 && gkrowcnt > 0 && vsrowcnt <= 0)
                        {
                            if( wncnt > 0 && gkcnt > 0 && vscnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                        if( wnrowcnt > 0 && gkrowcnt <= 0 && vsrowcnt > 0)
                        {
                            if( wncnt > 0 && gkcnt <= 0 && vscnt > 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                    }

                    if( vsrowcnt > 0 )
                    {
                        if( vsrowcnt > 0 && gkrowcnt <= 0 && wnrowcnt <= 0)
                        {
                            if( vscnt > 0 && gkcnt <= 0 && wncnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                        if( vsrowcnt > 0 && gkrowcnt > 0 && wnrowcnt <= 0)
                        {
                            if( vscnt > 0 && gkcnt > 0 && wncnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                        if( vsrowcnt > 0 && gkrowcnt <= 0 && wnrowcnt > 0)
                        {
                            if( vscnt > 0 && gkcnt <= 0 && wncnt > 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                    }
                   
                    if (record) {
                        setWorkingData2Unit(record.data, CheckColor);
                        if( CheckColor == "Y" )
                        {
                          //bin출고량 합계
                          dBinChQty = dBinChQty + record.data.SCHULQTY;
                          //bin빈공간 합계
                          dBinEmpQty = dBinEmpQty + record.data.SEMPQTY;
                          //bin재고량 합계
                          dBinJegoQty = dBinJegoQty + record.data.SJEGOQTY;
                        }
                    }
                                
                    setUnit(data);
                  } // end for

                  if( gkrowcnt + wnrowcnt + vsrowcnt > 0 )
                  {
                     setBinQtyDisplay(dBinChQty, dBinEmpQty, dBinJegoQty);
                  }
                  else
                  {
                     setBinQtyDisplay(dBinChTotalQty,dBinEmpTotalQty, dBinJegoTotalQty);
                  }
            }

            function setGroupBinDisplay(){

                var count;
                var dBinChQty = 0;
                var dBinEmpQty = 0;
                var dBinJegoQty = 0;

                var gkrowcnt = 0;
                var wnrowcnt = 0;
                var vsrowcnt = 0;

                var gkcnt = 0;
                var wncnt = 0;
                var vscnt = 0;
                
                var CheckColor;

                var data = null;
                var datads = null;
                var storeds = null;
                                
                var recordKey = "";
                var record = "";                             

                var unitStore = #{stoPlantUnits};         
                var DisplayCheck = #{hidDisplayCheck}.getValue();       
                
                count = unitStore.getCount();
                data = null;

                for (var i = 0; i < count; i++) {
                    data = unitStore.getAt(i).data;
                    recordKey = data.UNITCODE;
                    record = unitStore.findRecord("UNITCODE", recordKey)
                    if (record) {
                        setDataUnitClear(record.data);
                        setUnitTitleLabel(data);
                    }
                }

                for (var i = 0; i < count; i++) 
                {
                    data = unitStore.getAt(i).data;

                    gkcnt = 0;
                    wncnt = 0;
                    vscnt = 0;

                    gkrowcnt = 0;
                    wnrowcnt = 0;
                    vsrowcnt = 0;

                    if(DisplayCheck != "chkALL" && DisplayCheck != "")
                    {   
		                if( DisplayCheck == data.GROUPCHECK)
		                {   
		                    gkcnt = gkcnt + 1;
		                    gkrowcnt = gkrowcnt + 1;
		                }
                    }                 

                    recordKey = data.UNITCODE;
                    record = unitStore.findRecord("UNITCODE", recordKey)

                    CheckColor = "N";
                
                    if( gkrowcnt > 0 )
                    {
                        if( gkrowcnt > 0 && wnrowcnt <= 0 && vsrowcnt <= 0)
                        {
                            if( gkcnt > 0 && wncnt <= 0 && vscnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }

                        if( gkrowcnt > 0 && wnrowcnt > 0 && vsrowcnt <= 0)
                        {
                            if( gkcnt > 0 && wncnt > 0 && vscnt <= 0 )
                            {
                            CheckColor = "Y";
                            }
                        }

                        if( gkrowcnt > 0 && wnrowcnt <= 0 && vsrowcnt > 0)
                        {
                            if( gkcnt > 0 && wncnt <= 0 && vscnt > 0 )
                            {
                            CheckColor = "Y";
                            }
                        }

                        if( gkrowcnt > 0 && wnrowcnt > 0 && vsrowcnt > 0)
                        {
                            if( gkcnt > 0 && wncnt > 0 && vscnt > 0 )
                            {
                            CheckColor = "Y";
                            }
                        }
                    }

                    
                   
                    if (record) {
                        setWorkingData2Unit(record.data, CheckColor);
                        if( CheckColor == "Y" && DisplayCheck == data.GROUPCHECK)
                        {   
                          //bin출고량 합계
                          dBinChQty = dBinChQty + record.data.SCHULQTY;
                          //bin빈공간 합계
                          dBinEmpQty = dBinEmpQty + record.data.SEMPQTY;
                          //bin재고량 합계
                          dBinJegoQty = dBinJegoQty + record.data.SJEGOQTY;
                        }
                    }
                                
                    setUnit(data);
                  } // end for

                  
                  if(DisplayCheck != "chkALL" && DisplayCheck != "")
                  { 
                     setBinQtyDisplay(dBinChQty, dBinEmpQty, dBinJegoQty);
                  }
                  else
                  {
                     setBinQtyDisplay(dBinChTotalQty,dBinEmpTotalQty, dBinJegoTotalQty);
                  }
            }

            function setWorkingData2Unit(uData, Color) {
               
                var tS = "01";

               if( Color == "Y" ){
                  // 임대 및 1,2,3 그룹 선택 체크 후 "03" 추가 필요
                  if (uData.BCCORPGUBN == "T")
                  {
                    tS = "02";
                  }
                  else{
                    tS = "03";
                  }
               }
               uData.UNITSTATUS = tS;
              
            }

            function setDataUnitClear(uData) {               
                uData.UNITSTATUS = "01";
            }
            /////////빈 객체 생성 종료//////////////////////////


            //우측 하단 bin 출고량, 재고량 표시
            function setBinQtyDisplay(BinChQty, BinEmpQty, BinJegoQty){

                BinChQty =  Number(BinChQty).toFixed(3);
                  BinEmpQty =  Number(BinEmpQty).toFixed(3);
                  BinJegoQty = Number(BinJegoQty).toFixed(3);

                  var div = document.getElementById("binClearbox");                                
                  var theadObj = div.querySelectorAll("tr > td");
                  if(div)
                  {
                      if( theadObj.length > 0 )
                      {
                         for (var i = 0; i < theadObj.length; i++)
                         {
                            if( i == 4 ){theadObj[i].innerHTML = commify(BinChQty)+"&nbsp;&nbsp;M/T&nbsp;";}
                            if( i == 5 ){theadObj[i].innerHTML = commify(BinEmpQty)+"&nbsp;&nbsp;M/T&nbsp;";}
                            if( i == 6 ){theadObj[i].innerHTML = commify(BinJegoQty)+"&nbsp;&nbsp;M/T&nbsp;";}
                         }
                      }
                  }
            }

            //화면에서 표시선택(bin청소)으로 해당 항목 찾기
            function setBinClearDisplay(id){

                var count;

                var bincnt = 0;

                var CheckColor;

                var data = null;
                                
                var recordKey = "";
                var record = "";

                var day = Number(id.substr(3,2));

                var unitStore = #{stoPlantUnits};
                
                count = unitStore.getCount();
                data = null;
                for (var i = 0; i < count; i++) {
                    data = unitStore.getAt(i).data;
                    recordKey = data.UNITCODE;
                    record = unitStore.findRecord("UNITCODE", recordKey)
                    if (record) {
                        setDataUnitClear(record.data);
                        setUnit(data);
                    }
                }                

                for (var i = 0; i < count; i++) 
                {
                    data = unitStore.getAt(i).data;     
                    
                    if(data.BINCLEDAY >= day) 
                    {
                      bincnt =  bincnt + 1;
                    }
                    CheckColor = "N";
                    if( bincnt > 0 ) { 
                      CheckColor = "Y"; 
                      recordKey = data.UNITCODE;
                      record = unitStore.findRecord("UNITCODE", recordKey)
                      if (record) {
                          setWorkingData2Unit(record.data, CheckColor);
                       }                    
                      setUnit(data); 
                    }

                    bincnt = 0;
                }
                                   
            }



           /* 사용자 정의 함수   */

            //내용항목 기본 설정
            function ItemSelCodeInz(){               
            
                var div = document.getElementById("list_bx");           
                     
                var theadObj = div.querySelectorAll("li > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                     if( i <= 1 )
                     {
                        theadObj[i].className == "on";
                        ItemSelTempImgbtn(theadObj[i].id,theadObj[i].className);
                     }
                  }
                }
         
            }

            function ItemSelClear(){               
                
               #{stoITEMSEL}.removeAll();

                var div = document.getElementById("list_bx");           
                     
                var theadObj = div.querySelectorAll("li > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                     if( i <= 1 )
                     {
                        theadObj[i].className = "on";
                        setITEMSEL(theadObj[i].id, 'A');
                        ItemSelTempImgbtn(theadObj[i].id,theadObj[i].className);
                     }
                     else
                     {
                        theadObj[i].className = "off";
                        ItemSelTempImgbtn(theadObj[i].id,theadObj[i].className);
                     }
                  }

                  SetUnitItemDisp('CLEAR');
                }
            }

            //내용항목 선택
            function ItemSelCode(id){
                
                var div = document.getElementById("list_bx");           
                     
                var theadObj = div.querySelectorAll("li > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                     if( theadObj[i].id == id) 
                     {
                        if( ItemSelTempCodeClickCheck != 'on' )
                        {
                            if( theadObj[i].className != "on" )
                            {
                               theadObj[i].className = "on"; 
                               setITEMSEL(theadObj[i].id, 'A');            
                            }
                        }
                        else{
                           if( id != 'TM_List'){ 
                                if( theadObj[i].className == "on" )
                                {
                                   theadObj[i].className = "off";
                                   setITEMSEL(theadObj[i].id, 'D');
                                }
                                else{ 
                                   theadObj[i].className = "on"; 
                                   setITEMSEL(theadObj[i].id, 'A');            
                                }                              
                           }
                        }
                        if( id == 'TM_List'){
                           ItemSelTempImgbtn(id,theadObj[i].className);
                        }
                        else
                        {                           
                           ItemSelTempCodeClickCheck = '';
                        }
                     }
                  }

                  if( id != 'TM_List' | ItemSelTempCodeClickCheck != 'on' ){
                     SetUnitItemDisp('');
                  }
                }  
                          
            }

            function ItemSelTempImgbtn(id, className){

               if( id == 'TM_List')
                {
                   document.getElementById("ImgTempPrev").style.display = className == 'on' ? 'inline' : 'none';
                   document.getElementById("ImgTempNext").style.display = className == 'on' ? 'inline' : 'none';
                }
            }

            //표시항목 선택된 자료 배열로 받기
            function GetSelectListCode(id){

                var CodeArray = new Array();
                var index;
                var div = document.getElementById(id);
                var theadObj = div.querySelectorAll("tr > td > a");
                if( theadObj.length > 0 )
                {
                  index = 0;

                  for (var i = 0; i < theadObj.length; i++) 
                  {
                      if( theadObj[i].className == "on" )
                      {
                          CodeArray[index] = theadObj[i].id;
                          index += 1;
                      }
                  }
                }

                div = null;
                theadObj = null;

                return CodeArray;
               
            }


            //곡종
            function setGokJongList(store){
                
                var div;
                //항차
                div = document.getElementById("Scr_Gokjong");
                if(div){
                  scrleft_Gokjong  = div.scrollLeft;
                  scrtop_Gokjong  = div.scrollTop;
                }
                div = null;

                var CodeArray = new Array();                
                CodeArray = GetSelectListCode('GokJong');

                div = document.getElementById('GokJong');
                var imgStr = "";                                                
                var count = store.getCount();
                var data = null;
                var id;
                var check = '';

                //타이틀 
                imgStr += "<div style=\"width: 25%; float: left;\">";
                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				imgStr += "    <colgroup> <col style=\"width: 100%;\" />  </colgroup> ";
				imgStr += "      <tr> ";
				imgStr += "	      <th>곡&nbsp;&nbsp;종&nbsp;&nbsp;&nbsp;&nbsp;<a><img onclick=\"setGkCodeClear()\" src=\"../Resources/Images/Monitoring/SILOBIN/btn_clr.gif\" class=\"btn_right\" alt=\"\" /></a></th> ";
				imgStr += "        </tr>";
                imgStr += "  </table> ";
			    imgStr += "   <div id='Scr_Gokjong' style=\"height: 460px; background: #FFFFFF; overflow-y: scroll; clear: both;\"> ";
                imgStr += "             <table class=\"table_01\" style=\"width: 100%;\"> ";
				imgStr += "              <colgroup> <col style=\"width: 100%;\" /> </colgroup> ";
                check ='';
                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;
                    id   = "GK_"+data.GOKJONG;
                    check = '';
                    for( var j=0; j < CodeArray.length;j++){
                       if( id == CodeArray[j] ){
                           check = "Y";
                           setStoreSel_GK(CodeArray[j], "Y");
                       }
                    }
                    imgStr += "<tr> "; 
                    if( check == 'Y' ){
                        imgStr += "<td><a id="+id+" class='on'style=\"overflow:hidden\" title=\"" + data.GOKJONGNM + "\"onclick=setGkCodeSelect(id)>"+data.GOKJONGNM+"</a></td>"; 
                    }
                    else{ 
                       imgStr += "<td><a id="+id+" style=\"overflow:hidden\" title=\"" + data.GOKJONGNM + "\"onclick=setGkCodeSelect(id)>"+data.GOKJONGNM+"</a></td>"; 
                    }
                    imgStr += "</tr> "; 

                    check ='';
                }
                imgStr += "</table> </div> </div> "; 				                                        

                div.innerHTML = imgStr;                      
                
                div = null;
                div = document.getElementById("Scr_Gokjong");
                if( div ){
                   div.scrollLeft  = scrleft_Gokjong;
                   div.scrollTop   = scrtop_Gokjong;
                }
                div = null;                      
            }

            //곡종 선택 이벤트
            function setGkCodeSelect(gokjongcode) {

                BinClearItemClear(); 
                
                var GKcount = #{hidGKCnt}.getValue();
                
                var count = 0;
                var div = document.getElementById("GokJong");                
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                     if( theadObj[i].id == gokjongcode )
                     {
                        if( theadObj[i].className == "on" )
                        {
                           theadObj[i].className = "off";
                           setStoreSel_GK(gokjongcode, "N");
                           GKcount--;
                        }
                        else{ 
                          theadObj[i].className = "on"; 
                          setStoreSel_GK(gokjongcode, "Y");
                          count++;
                          GKcount++;
                        }
                     }
                  }
                } 
                if(count > 0)
                {   
                    #{hidGKCheck}.setValue("Y");
                }

                #{hidGKCnt}.setValue(GKcount);
                
                if(#{hidGKCnt}.getValue() == "0" && #{hidWNCnt}.getValue() == "0" && #{hidVSCnt}.getValue() == "0")
                {
                    rdo_change(#{hidDisplayCheck}.getValue(),"check");
                }
                else{
                    setBinDisplay();
                }
            }

            //곡종 선택 클리어
            function setGkCodeClear(gubn) {
            
                var div = document.getElementById("GokJong");                
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                      theadObj[i].className = "off";
                      setStoreSel_GK(theadObj[i].id,"N");
                  }
                }     
                #{hidGKCheck}.setValue("");
                #{hidGKCnt}.setValue("0");

                if(gubn == "ALL")
                {
                    setBinDisplay();
                }
                else{
                    if(#{hidGKCnt}.getValue() == "0" && #{hidWNCnt}.getValue() == "0" && #{hidVSCnt}.getValue() == "0")
                    {
                        rdo_change(#{hidDisplayCheck}.getValue(),"check");
                    }
                    else{
                        setBinDisplay();
                    }     
                }             
            }

             //원산지
             function setWonSanList(store){
                
                var div;
                //항차
                div = document.getElementById("Scr_Wonsan");
                if(div){
                  scrleft_Wonsan  = div.scrollLeft;
                  scrtop_Wonsan  = div.scrollTop;
                }
                div = null;

                var CodeArray = new Array();                
                CodeArray = GetSelectListCode('WonSan');

                div = document.getElementById("WonSan");
                var imgStr = "";                                                
                var count = store.getCount();
                var data = null;
                var id;
                var check = '';
                
                //타이틀 
                imgStr += "<div style=\"width: 28%; float: left;\">";
                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				imgStr += "    <colgroup> <col style=\"width: 100%;\" />  </colgroup> ";
				imgStr += "     <tr>";
				imgStr += "	      <th>원&nbsp;산&nbsp;지&nbsp;&nbsp;&nbsp;&nbsp;<a><img onclick=\"setWnCodeClear()\" src=\"../Resources/Images/Monitoring/SILOBIN/btn_clr.gif\" class=\"btn_right\" alt=\"\" /></a></th> ";
				imgStr += "     </tr>";
                imgStr += "  </table> ";
			    imgStr += "   <div id ='Scr_Wonsan' style=\"height: 460px; background: #FFFFFF; overflow-y: scroll; clear: both;\"> ";
                imgStr += "             <table class=\"table_01\" style=\"width: 100%;\"> ";
				imgStr += "              <colgroup> <col style=\"width: 100%;\" /> </colgroup> ";               

                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;
                    id   = "GK_"+data.IHWONSAN;
                    check = '';
                    for( var j=0; j < CodeArray.length;j++){
                       if( id == CodeArray[j] ){
                           check = "Y";
                           setStoreSel_WN(CodeArray[j],"Y");
                       }
                    }

                    imgStr += "<tr> "; 
                    if( check == 'Y' ){
                        imgStr += "<td><a  id="+id+" class='on' onclick=setWnCodeSelect(id)>"+data.IHWONSANNM+"</a></td>"; 
                    }
                    else {
                       imgStr += "<td><a  id="+id+" onclick=setWnCodeSelect(id)>"+data.IHWONSANNM+"</a></td>"; 
                    }
                    imgStr += "</tr> "; 
                }
                imgStr += "</table> </div> </div> "; 				                                        

                div.innerHTML = imgStr;          
                
                div = null;
                div = document.getElementById("Scr_Wonsan");
                if( div ){
                   div.scrollLeft  = scrleft_Wonsan;
                   div.scrollTop   = scrtop_Wonsan;
                }
                div = null;
               
                                     
            }

             //원산지 선택 이벤트
            function setWnCodeSelect(wonsancode) {
                
                BinClearItemClear();

                var WNcount = #{hidWNCnt}.getValue();

                var count = 0;
                var div = document.getElementById("WonSan");                
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                     if( theadObj[i].id == wonsancode )
                     {
                        if( theadObj[i].className == "on" )
                        {
                           theadObj[i].className = "off";
                           setStoreSel_WN(wonsancode,"N");
                           WNcount--;
                        }
                        else{ 
                            theadObj[i].className = "on"; 
                            setStoreSel_WN(wonsancode,"Y");
                            count++;
                            WNcount++;
                        }
                     }
                  }
                }    
                if(count > 0)
                {
                    #{hidWNCheck}.setValue("Y");
                }    
                
                #{hidWNCnt}.setValue(WNcount);
                
                if(#{hidGKCnt}.getValue() == "0" && #{hidWNCnt}.getValue() == "0" && #{hidVSCnt}.getValue() == "0")
                {
                    rdo_change(#{hidDisplayCheck}.getValue(),"check");
                }
                else{
                    
                    setBinDisplay();
                }
                                         
            }

            //원산지 선택 클리어
            function setWnCodeClear(gubn) {
            
                var div = document.getElementById("WonSan");                
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                      theadObj[i].className = "off";
                      setStoreSel_WN(theadObj[i].id,"N");
                  }
                }  
                #{hidWNCheck}.setValue("");
                #{hidWNCnt}.setValue("0");
                
                if(gubn == "ALL")
                {
                    setBinDisplay();
                }
                else{
                    if(#{hidGKCnt}.getValue() == "0" && #{hidWNCnt}.getValue() == "0" && #{hidVSCnt}.getValue() == "0")
                    {
                        rdo_change(#{hidDisplayCheck}.getValue(),"check");
                    }
                    else{
                        setBinDisplay();
                    }     
                }                       
            }

            //항차 
            function setHANGCHAList(store){

                var div;
                //항차
                div = document.getElementById("Scr_Hangcha");
                if(div){
                  scrleft_Hangcha  = div.scrollLeft;
                  scrtop_Hangcha  = div.scrollTop;
                }
                div = null;
            
                var CodeArray = new Array();
                CodeArray = GetSelectListCode('HANGCHA');

                div = document.getElementById("HANGCHA");
                var imgStr = "";                                                
                var count = store.getCount();
                var data = null;
                var id;
                var check = '';
                
                //타이틀 
                imgStr += "<div style=\"width: 47%; float: left;\">";
                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				imgStr += "    <colgroup> <col style=\"width: 100%;\" />  </colgroup> ";
				imgStr += "     <tr>";
				imgStr += "	      <th>모&nbsp;&nbsp;선&nbsp;&nbsp;&nbsp;&nbsp;<a><img onclick=\"setVSCodeClear()\" src=\"../Resources/Images/Monitoring/SILOBIN/btn_clr.gif\" class=\"btn_right\" alt=\"\" /></a></th> ";
				imgStr += "     </tr>";
                imgStr += "  </table> ";
			    imgStr += "   <div id = 'Scr_Hangcha' style=\"height: 460px; background: #FFFFFF; overflow-y: scroll; clear: both;\"> ";
                imgStr += "             <table class=\"table_01\" style=\"width: 100%;\"> ";
				imgStr += "              <colgroup> <col style=\"width: 100%;\" /> </colgroup> ";               

                for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;     
                    id   = data.CORPGUBN + "_VS_"+data.IHHANGCHA;                         
                    check = '';
                    for( var j=0; j < CodeArray.length;j++){
                       if( id == CodeArray[j] ){
                           check = "Y";
                           setStoreSel_VS(CodeArray[j] ,"Y");
                       }
                    }                              
                    imgStr += "<tr> "; 
                    if( check == 'Y' ){
                       imgStr += "<td><a id="+id+" class='on' onclick=setVSCodeSelect(id)>"+ data.CORPGUBN + " " + data.IHHANGCHA +" "+data.IHHANGCHANM+"</a></td>"; 
                    }
                    else{
                       imgStr += "<td><a id="+id+" onclick=setVSCodeSelect(id)>"+ data.CORPGUBN + " "+ data.IHHANGCHA +" "+data.IHHANGCHANM+"</a></td>"; 
                    }
                    imgStr += "</tr> "; 
                }
                imgStr += "</table> </div> </div> "; 				                                        

                div.innerHTML = imgStr;          
                
                div = null;
                div = document.getElementById("Scr_Hangcha");
                if( div ){
                   div.scrollLeft  = scrleft_Hangcha;
                   div.scrollTop   = scrtop_Hangcha;
                }
                div = null;
                
                                     
            }

            //항차 선택 이벤트
            function setVSCodeSelect(VScode) {
                BinClearItemClear();
                
                var VScount = #{hidVSCnt}.getValue();

                var count = 0;
                var div = document.getElementById("HANGCHA");                
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                     if( theadObj[i].id == VScode )
                     {
                        if( theadObj[i].className == "on" )
                        {
                           theadObj[i].className = "off";
                           setStoreSel_VS(VScode,"N");
                           VScount--;
                        }
                        else{ 
                            theadObj[i].className = "on"; 
                            setStoreSel_VS(VScode,"Y");
                            count++;
                            VScount++;
                        }
                     }
                  }
                } 
                if(count > 0)
                {
                    #{hidVSCheck}.setValue("Y");
                }

                #{hidVSCnt}.setValue(VScount);
                
                if(#{hidGKCnt}.getValue() == "0" && #{hidWNCnt}.getValue() == "0" && #{hidVSCnt}.getValue() == "0")
                {
                    rdo_change(#{hidDisplayCheck}.getValue(),"check");
                }
                else{
                    
                    setBinDisplay();
                }          
            }

             //항차 선택 클리어
            function setVSCodeClear(gubn) {
            
                var div = document.getElementById("HANGCHA");                
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {
                  for (var i = 0; i < theadObj.length; i++) {
                      theadObj[i].className = "off";
                      setStoreSel_VS(theadObj[i].id,"N");
                  }
                }      
                
                #{hidVSCnt}.setValue("0");
                if(gubn == "ALL")
                {
                    setBinDisplay();
                }
                else{
                    if(#{hidGKCnt}.getValue() == "0" && #{hidWNCnt}.getValue() == "0" && #{hidVSCnt}.getValue() == "0")
                    {
                        rdo_change(#{hidDisplayCheck}.getValue(),"check");
                    }
                    else{
                        setBinDisplay();
                    }     
                }     

            }
            //표시 선태 전체 클리어
            function setCodeClearAll(gubun){

                setGkCodeClear("ALL");
                setWnCodeClear("ALL");
                setVSCodeClear("ALL"); 
                BinClearItemClear(); 
                setBinQtyDisplay(dBinChTotalQty,dBinEmpTotalQty, dBinJegoTotalQty);
            }

            function setClearAll()
            {
                document.getElementById("chkALL").checked = "checked";
                rdo_change("chkALL", "check");
            }

            //BIN 출입 표시
            function BinClearDay(id){
                setCodeClearAll();

                var div = document.getElementById("binClearbox");           
                     
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {                 
                  //선택 
                  for (var i = 0; i < theadObj.length; i++) {
                     if( theadObj[i].id == id )
                     {
                        if( theadObj[i].className == "on" )
                        {
                           theadObj[i].className = "off";                           
                        }
                        else{ 
                           theadObj[i].className = "on";                            
                       }
                     }
                     else
                     {
                        theadObj[i].className = "off";
                     }
                  }
                }                 

                setBinClearDisplay(id);
            }

            //bin 출입선택항목 클리어
            function BinClearItemClear(){
                
                var div = document.getElementById("binClearbox");           
                     
                var theadObj = div.querySelectorAll("tr > td > a");

                if( theadObj.length > 0 )
                {                 
                  //선택 
                  for (var i = 0; i < theadObj.length; i++) {
                     theadObj[i].className = "off";
                  }
                }          
            }

            //---------표시선택(곡종, 원산지, 항차) store 저장 시작-----------//
            function setStoreSel_GK(recordkey, gubn){               
                var record = null;
                var store  = #{stoGOKJONG};
                record = store.findRecord("GOKJONG", recordkey.substr(3,2));
                if (record) {
                    record.data.CHECK = gubn;
                }           
            }

            function setStoreSel_WN(recordkey, gubn){               
                var record = null;
                var store  = #{stoWonSan};
                record = store.findRecord("IHWONSAN", recordkey.substr(3,2));
                if (record) {
                    record.data.CHECK = gubn;
                }              
            }

            function setStoreSel_VS(recordkey, gubn){               
                var record = null;
                var store  = #{stoHANGCHA};              
                
                record = store.findRecord("IHCODE", recordkey.substr(0,1) + recordkey.substr(5,7));

                if (record) {
                    record.data.CHECK = gubn;                    
                }
            }
            //---------표시선택(곡종, 원산지, 항차) store 저장 종료-----------//

            //내용선택 store 저장
            function setITEMSEL(item, gubn){        
               var datas = null;

               if( gubn == "A" ){
                 #{stoITEMSEL}.add
                 (
                     {
                       ITEM: item
                     }
                 );
               }   
               else
               {
                 datas = #{stoITEMSEL}.data.items;
                 if( datas.length > 0 ){
                     #{stoITEMSEL}.remove(datas[0]); 
                 }
               }
               
               datas = #{stoITEMSEL}.data.items;

               //2개 이상 선택시 제일 먼저 선택한 것부터 지운다
               if( datas.length > 2 )
               {
                  var div = document.getElementById(datas[0].data.ITEM);  
                  div.className = "off";
                  ItemSelTempImgbtn(div.id,div.className);
                  if( div.id == 'TM_List' ){
                     document.getElementById("spnTemp").innerHTML = 'D';
                  }
                  #{stoITEMSEL}.remove(datas[0]); 
               }     
            }  

            function SetUnitItemDisp(value){

                //BIN 표시
                var div;
                var theadObj;
                var record;
                var recordKey;
                var data;
                var count = 0;
                var unitStore = #{stoPlantUnits};                
                var datas = #{stoITEMSEL}.data.items;

                count = unitStore.getCount();
                data = null;
                for (var i = 0; i < count; i++) {
                    data = unitStore.getAt(i).data;
                    recordKey = data.UNITCODE;
                    record = unitStore.findRecord("UNITCODE", recordKey)
                    if (record) {
                        div = document.getElementById("Labelunit_" + data.UNITCODE);
                        if(div){
                            theadObj = div.querySelectorAll("tr > td > a");
                            if( theadObj.length > 0 )
                            {                         
                              for (var j = 0; j < theadObj.length; j++) {
                                 if( j > 0 ){
                                    // 스타빈은 마지막 선택 항목을 표시한다.
//                                    if( data.UNITTYPE == "tank101" | data.UNITTYPE == "tank102" | data.UNITTYPE == "tank103" )
//                                    {
//                                        theadObj[j].innerHTML = value == 'CLEAR' ?  GetUnitItemValue(datas[0].data.ITEM, data) : GetUnitItemValue(datas[datas.length - 1].data.ITEM, data); 
//                                    }
//                                    else
//                                    {
                                       theadObj[j].innerHTML = GetUnitItemValue(datas[j-1].data.ITEM, data);
//                                    }
                                 }
                              }
                            }           
                        }  
                    }    
                }  
               
            }

            function GetUnitItemValue(id, data){
                
                var value = id.substr(0,2);
                  var returnvalue;
                
                  switch (value) {
                    case 'GK':
                        returnvalue = data.SGOKJONGNM;
                        break;
                    case 'WS':
                        returnvalue = data.SWONSANNM;
                        break;
                    case 'WG':
                        returnvalue = data.SHWGCODE;
                        break;
                    case 'HA':
                        returnvalue = data.SHANGCHANM;
                        break;
                    case 'IP':
                        returnvalue = data.SIPDATE;
                        break;
                    case 'BN':
                        returnvalue = data.SCLDATE;
                        break;
                    case 'CH':
                        returnvalue = commify(data.SCHULQTY);
                        break;
                    case 'JG':
                        returnvalue = commify(data.SJEGOQTY);
                        break;
                   }
                   return returnvalue;
              
            }

           // ----------특기사항, 하역,입합계획, bin클리닝, 하역작업일지  시작----------//
           //하단 날짜 표시
           function setBoardDate(){
                if(!BoardDate){                                            
                      BoardDate = Current_Date().split("-")[0]+Current_Date().split("-")[1]+Current_Date().split("-")[2];
                  }

                  if(!BoardDateMonth){                                            
                      BoardDateMonth = Current_Date().split("-")[0]+Current_Date().split("-")[1];
                  }
                  document.getElementById("BoardDate").innerHTML = BoardDate.substr(0,4) + "년" + BoardDate.substr(4,2) + "월" + BoardDate.substr(6,2) + "일";                                 
                  document.getElementById("BoardDateMonth").innerHTML = BoardDateMonth.substr(0,4) + "년" + BoardDateMonth.substr(4,2) + "월";
           }
           //특기사항 store 이벤트
           function setBoardSpcList(store){

                setBoardDate(); 
                tab_BoardHtmlRenter(store, 'SP_Board');

                var div = document.getElementById("Scr_Board");
                if( div ){
                   div.scrollLeft  = scrleft_Board;
                   div.scrollTop   = scrtop_Board;
                }
                div = null;
           }
            //입항하역 store 이벤트
           function setShipLoadList(store){
                setBoardDate();  
                tab_BoardHtmlRenter(store,'SH_Board');
           }        
            //bin클리닝 store 이벤트
           function setBinCleanList(store){
                setBoardDate();  
                tab_BoardHtmlRenter(store,'BN_Board');  
           }
            //BIN SPACE store 이벤트
           function setBoardBinSpaceList(store, GKstore){
                setBoardDate();  
                tab_BoardHtmlRenterBS(store, GKstore);
           }   
            //bin이고 store 이벤트
           function setBinMoveList(store){
                setBoardDate();  
                tab_BoardHtmlRenter(store,'MV_Board');              

                var div = document.getElementById("Scr_Move");
                if( div ){
                   div.scrollLeft  = scrleft_Move;
                   div.scrollTop   = scrtop_Move;
                }
                div = null;
           }
           //카길이송 store 이벤트
           function setBinCargillList(store){
                setBoardDate();  
                tab_BoardHtmlRenter(store,'CG_Board');              

                var div = document.getElementById("Scr_Cargill");
                if( div ){
                   div.scrollLeft  = scrleft_Move;
                   div.scrollTop   = scrtop_Move;
                }
                div = null;
           }
           //bin하역작업일지 이벤트
           function setBinSHipDocList(store){
                tab_BoardHtmlRenter(store,'DC_Board');

                var div = document.getElementById("ScrDC_Board");
                if( div ){
                   div.scrollLeft  = scrleft_DCLOAD;
                   div.scrollTop   = scrtop_DCLOAD;
                }
                div = null;
           }

           //BIN 하역작업일지 해당항차 곡종코드 select 박스에 넣기
           function setBinSHipDocGKList(store){
                var newOpt;
                var div = document.getElementById("SelectShipDoc");
                var count = store.getCount();
                var data;

                if( div )               
                {
                    //항목 삭제
                    if( div.length > 0 ){                         
                        for (var i = 0; i < div.length; i++) {
                            div.remove(div.selectedIndex); 
                        }
                    }

                    for (var i = 0; i < count; i++) {
                        data = store.getAt(i).data;
                        newOpt=document.createElement("OPTION");                   
                        newOpt.text = data.DGOKJONGNM;
                        newOpt.value = data.DGOKJONG;
                        div.options.add(newOpt);
                        if( div[i].value  == selDcLoadGkCode )
                        {
                            div[i].selected = true;
                        }
                    }
                }       
           }

           //BIN 하역작업일지 회사구분 select 선택 이벤트
           function BinSHipDocGORP_SelectCombo(value){
                
                var CorpGubn = value;

                Ext.net.DirectMethod.request('UP_GetShipDocData', { 
                            url: location.href,
                            params: {sCorpGubn: CorpGubn
                                    },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 하역작업일지 조회중...",
                                target: "customtarget"
                                }
                           }
                        );
              
           }

           function setDocHangCha(hangcha)
           { 
                document.getElementById("DocHangCha").innerHTML = hangcha;
           }


           //BIN 하역작업일지 곡종코드 select 선택 이벤트
           function BinSHipDocGK_SelectCombo(value){
                
              var GokJong = value;
                var hangcha = document.getElementById("DocHangCha").innerText;

                Ext.net.DirectMethod.request('UP_GetBinShipDocData', { 
                            url: location.href,
                            params: {sCorpGubn: GetBinShipDocSelectComboValue('SelectShipDocCORP'),
                                     sHangCha: hangcha,
                                     sGokJong: GokJong
                                    },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 하역작업일지 조회중...",
                                target: "customtarget"
                                }
                           }
                        );
           }

           //일자 이전, 다음 버튼 이벤트          
           function GetBoardMoveDate(value){
               var NDate;

               var yyyy;
               var mm;
               var dd;       

                  if(!BoardDate){                                            
                      NDate = Current_Date();
                  }
                  else
                  {                             
                      yyyy = BoardDate.substr(0,4);
                      mm   = BoardDate.substr(4,2);
                      dd   = BoardDate.substr(6,2);                  

                      NDate = GetNDate(yyyy, mm, dd);

                      if( value == 'Prev' )
                      {
                          NDate = GetPreDate(NDate);
                      }
                      else if( value == 'Next')
                      {
                          NDate = GetTomDate(NDate);
                      }
                      else{
                          NDate = Current_Date();
                      }
                  }
                  document.getElementById("BoardDate").innerHTML = NDate.split("-")[0] + "년" + NDate.split("-")[1] + "월" + NDate.split("-")[2] + "일";

                  BoardDate = NDate.split("-")[0]+NDate.split("-")[1]+NDate.split("-")[2];  
                  
                    var div = document.getElementById("tab_bx");                     
                    var theadObj = div.querySelectorAll("li > a");
                    var Tabid = null;
                    if( theadObj.length > 0 )
                    {
                        for (var i = 0; i < theadObj.length; i++) {
                            if( theadObj[i].className == "on")
                            {
                               Tabid = theadObj[i].id;
                            }
                        }
                    }                                           
                                     
                   GetDirectMethodData(Tabid, BoardDate);               
              
           }

           function GetScheduleMoveDate(value){
                              
              var NDate;

               var yyyy;
               var mm;
               var dd;       

                  if(!BoardDateMonth){                                            
                      NDate = Current_MonthDate();
                  }
                  else
                  {                             
                      yyyy = BoardDateMonth.substr(0,4);
                      mm   = BoardDateMonth.substr(4,2);
                      dd   = '02';

                      NDate = GetNDate(yyyy, mm, dd);

                      if( value == 'Prev' )
                      {
                          NDate = GetPreMonthDate(NDate);
                      }
                      else if( value == 'Next')
                      {
                          NDate = GetNextMonthDate(NDate);
                      }
                      else{
                          NDate = Current_MonthDate();
                      }
                  }
                  document.getElementById("BoardDateMonth").innerHTML = NDate.split("-")[0] + "년" + NDate.split("-")[1] + "월";

                  BoardDateMonth = NDate.split("-")[0]+NDate.split("-")[1];
                  
                    var div = document.getElementById("tab_bx");                     
                    var theadObj = div.querySelectorAll("li > a");
                    var Tabid = null;
                    if( theadObj.length > 0 )
                    {
                        for (var i = 0; i < theadObj.length; i++) {
                            if( theadObj[i].className == "on")
                            {
                               Tabid = theadObj[i].id;
                            }
                        }
                    }                                           
                                     
                   GetDirectMethodData(Tabid, BoardDate);
           }

           //항차선택 이전, 다음 이벤트
           function GetHangChaMove(value, Check){    
           
                var hangcha;
                var spanid; 
                var DirectMethodid; 
           
                spanid = Check == '1' ? "DocHangCha" : "spnShipTileHangcha";
                DirectMethodid = Check == '1' ? "DC_Board" : "LC_Board";
              
                var hangcha = document.getElementById(spanid).innerText; 

                if( value == 'Prev' )
                {
                    hangcha = parseInt(hangcha) - 1;
                    hangcha = hangcha < parseInt(#{hidMinHangCha}.getValue()) ? hangcha + 1: hangcha;
                }
                else if(value == 'Next' )
                {
                    hangcha = parseInt(hangcha) + 1;
                    hangcha = hangcha > parseInt(#{hidMaxHangCha}.getValue()) ? hangcha - 1: hangcha;
                }                     
                           
                document.getElementById(spanid).innerHTML = hangcha;
                
                //하역작업일지의 해당 항차 곡종코드 받아오기
                setDirectMethod_BinShipDocGKData(hangcha);

           }

           function SetShipDocList(){              

             var hangcha = document.getElementById('DocHangCha').innerText; 

              GetDirectMethodData('DC_Board', hangcha);
           }

           function GetLoadHangChaMove(value, Check){    
           
                var hangcha;
                var spanid; 
                var DirectMethodid; 
           
                spanid = Check == '1' ? "DocHangCha" : "spnShipTileHangcha";
                DirectMethodid = Check == '1' ? "DC_Board" : "LC_Board";
              
                var hangcha = document.getElementById(spanid).innerText; 

                if( value == 'Prev' )
                {
                    hangcha = parseInt(hangcha) - 1;
                    hangcha = hangcha < parseInt(#{hidLoadMinHangCha}.getValue()) ? hangcha + 1: hangcha;
                }
                else if(value == 'Next' )
                {
                    hangcha = parseInt(hangcha) + 1;
                    hangcha = hangcha > parseInt(#{hidLoadMaxHangCha}.getValue()) ? hangcha - 1: hangcha;
                }                     
                           
                document.getElementById(spanid).innerHTML = hangcha;
                
                GetDirectMethodData(DirectMethodid, hangcha);
                
           }

           function GetDirectMethodData(id, BoardDate){

              //시스템일자
              var sSysDate = Current_Date().split("-")[0]+Current_Date().split("-")[1]+Current_Date().split("-")[2];

              switch (id) {
                    case 'SP_Board':
                         Ext.net.DirectMethod.request('UP_GetBoardData', { 
                            url: location.href,
                            params: {sBoardDate: BoardDate },
                            eventMask: {
                                showMask: true,
                                msg: "특기사항 조회중...",
                                target: "customtarget"
                                }
                           }
                        );              
                        break;
                    case 'SH_Board':
                         Ext.net.DirectMethod.request('UP_GetShipLoadData', { 
                            url: location.href,
                            params: {sBoardDate: BoardDateMonth },
                            eventMask: {
                                showMask: true,
                                msg: "입항하역계획 조회중...",
                                target: "customtarget"
                                }
                           }
                        );         
                        break;
                    case 'BN_Board':
                         Ext.net.DirectMethod.request('UP_GetBinCleanData', { 
                            url: location.href,
                            params: {sBoardDate: sSysDate },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 클리닝 작업 조회중...",
                                target: "customtarget"
                                }
                           }
                        );         
                        break;
                   case 'MV_Board':
                         Ext.net.DirectMethod.request('UP_GetBinMoveData', { 
                            url: location.href,
                            params: {sBoardDate: sSysDate },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 이고 작업 조회중...",
                                target: "customtarget"
                                }
                           }
                        );         
                        break;
                  case 'CG_Board':
                         Ext.net.DirectMethod.request('UP_GetBinCargillData', { 
                            url: location.href,
                            params: {sBoardDate: sSysDate },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 이송 작업 조회중...",
                                target: "customtarget"
                                }
                           }
                        );         
                        break;
                  case 'DC_Board':
                         Ext.net.DirectMethod.request('UP_GetBinShipDocData', { 
                            url: location.href,
                            params: {sCorpGubn: GetBinShipDocSelectComboValue('SelectShipDocCORP'),
                                     sHangCha: BoardDate,
                                     sGokJong: GetBinShipDocSelectComboValue('SelectShipDoc')
                                    },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 하역작업일지 조회중...",
                                target: "customtarget"
                                }
                           }
                        );         
                        break;
                 case 'LC_Board':
                         Ext.net.DirectMethod.request('UP_GetShipDataListData', { 
                            url: location.href,
                            params: {sHangCha: BoardDate },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 하역현황 조회중...",
                                target: "customtarget"
                                }
                           }
                        );         
                        break;
                 case 'BS_Board':

                         Ext.net.DirectMethod.request('UP_GetBoardSpaceData', { 
                            url: location.href,
                            params: {sBoardDate: sSysDate ,
                                     sGROUP : #{BSRdoCheck}.getValue()},
                            eventMask: {
                                showMask: true,
                                msg: "BIN SPACE 조회중...",
                                target: "customtarget"
                                }
                           }
                        );         
                        break;
                   } 
           }

           //상단 Tab 선택
           function TabBoard(id) {
             
                var paramValue;
                var store = null;
                var div = null;

                div = document.getElementById("tab_bx");                     
                var theadObj = div.querySelectorAll("li > a");
                if( theadObj.length > 0 )
                {
                    for (var i = 0; i < theadObj.length; i++) {
                        theadObj[i].className = theadObj[i].id == id ? "on" : "off";
                    }
                }
                
                paramValue = id == 'DC_Board' ? document.getElementById("DocHangCha").innerText: BoardDate;
                
                GetDirectMethodData(id, paramValue);

                if(id != 'BS_Board')
                {
                    switch (id) {
                        case 'SP_Board':
                            store = #{stoBoardSpc};
                            break;
                        case 'SH_Board':
                            store = #{stoShipLoad};
                            break;
                        case 'BN_Board':
                            store = #{stoBinClean};
                            break;
                        case 'MV_Board':
                            store = #{stoBinMove};
                            break;
                        case 'CG_Board':
                            store = #{stoBinCargill};
                            break;
                        case 'DC_Board':
                            store = #{stoBinSHipDoc};
                            setDirectMethod_BinShipDocGKData(paramValue);
                            break;
                       }

                    tab_BoardHtmlRenter(store, id); 
                }
                else
                {
                    tab_BoardHtmlRenterBS(#{stoBinSpaceInfos}, #{stoBinGKSpaceInfos}); 
                }
                
           }
           //하단 그리드 표현
           function tab_BoardHtmlRenter(store, id){
                           
                var div = document.getElementById("tab_SP_Board");
                var imgStr = "";                                                
                var count = store.getCount();
                var data = null;
                var nextdata = null;
                var id;
                var fontColor;                
                                
                if(div)
                {
                      switch (id) {
                        case 'DC_Board':                            
                            OpenSubWin('BoardTopTitleShipDoc');
                            CloseSubWin('ShipScheduleBase');
                            CloseSubWin('BoardTopTitleBase');
                            CloseSubWin('BoardTopTitleBinSpace');
                            break;
                        case 'SP_Board':                       
                            CloseSubWin('BoardTopTitleShipDoc');
                            CloseSubWin('ShipScheduleBase');
                            OpenSubWin('BoardTopTitleBase');
                            CloseSubWin('BoardTopTitleBinSpace');
                            break;
                        case 'SH_Board':                       
                            CloseSubWin('BoardTopTitleShipDoc');
                            CloseSubWin('BoardTopTitleBase');
                            OpenSubWin('ShipScheduleBase');   
                            CloseSubWin('BoardTopTitleBinSpace');                         
                            break;
                        default:
                            CloseSubWin('BoardTopTitleBase');
                            CloseSubWin('ShipScheduleBase');
                            CloseSubWin('BoardTopTitleShipDoc');
                            CloseSubWin('BoardTopTitleBinSpace');
                            break;
                       }

                    switch(id){
                        case 'SP_Board':   
                              imgStr += "<table class=\"table_01\" style=\"width: 100%;\">";
   				              imgStr += "    <colgroup> ";                              
                              imgStr += "    <col style=\"width: 1750px;\" /> ";
                              imgStr += "    <col style=\"\" /> ";
                              imgStr += "    </colgroup> ";
				              imgStr += "     <tr>";
				              imgStr += "	      <th>내&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;용</th><th></th> ";
				              imgStr += "     </tr>";
                              imgStr += "     </table>";
                              imgStr += "<div id = 'Scr_Board' style=\"height:775px;background: #FFFFFF; overflow-y: scroll;\">";
                              imgStr += "       <table class=\"table_01\" style=\"width: 100%;\"> ";
                              imgStr += "        <colgroup><col style=\"width: 1750px;\" /> <col style=\"\" />  </colgroup> ";
                             break;
                        case 'SH_Board':
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 360px;\" /> ";
                                imgStr += "    <col style=\"width: 110px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 300px;\" /> ";
                                imgStr += "    <col style=\"width: 180px;\" /> ";
                                imgStr += "    <col style=\"width: 221px;\" /> ";
                                imgStr += "    <col style=\"width: 270px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
				                imgStr += "     <tr>";
				                imgStr += "	      <th>모선명</th><th>선석</th><th>입항일</th><th>곡종</th><th>원산지</th><th>선/후</th><th>B/L량</th><th>화주</th> ";
				                imgStr += "     </tr>";
                                imgStr += "   </table>";
                                imgStr += "<div style=\"height:775px;background: #FFFFFF; overflow-y: scroll;\">";
                                imgStr += "       <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "           <colgroup> ";
                                imgStr += "    <col style=\"width: 360px;\" /> ";
                                imgStr += "    <col style=\"width: 110px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 300px;\" /> ";
                                imgStr += "    <col style=\"width: 180px;\" /> ";
                                imgStr += "    <col style=\"width: 221px;\" /> ";
                                imgStr += "    <col style=\"width: 270px;\" /> ";
                                imgStr += "           <col style=\"\" /> ";                                
                                imgStr += "           </colgroup> ";
                             break;
                        case 'BN_Board':
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 400px;\" /> ";
                                imgStr += "    <col style=\"width: 750px;\" /> ";
                                imgStr += "    <col style=\"width: 250px;\" /> ";
                                imgStr += "    <col style=\"width: 250px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
				                imgStr += "     <tr>";
				                imgStr += "	      <th>BIN 번호</th><th>비고</th><th>작업시간</th><th>작업종료</th>";
				                imgStr += "     </tr>";
                                imgStr += "   </table>";
                                imgStr += "<div style=\"height:920px;background: #FFFFFF; overflow-y: scroll;\">";
                                imgStr += "     <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 400px;\" /> ";
                                imgStr += "    <col style=\"width: 750px;\" /> ";
                                imgStr += "    <col style=\"width: 250px;\" /> ";
                                imgStr += "    <col style=\"width: 250px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
                             break; 
                          case 'MV_Board':
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 150px;\" /> ";
                                imgStr += "    <col style=\"width: 150px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 140px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
				                imgStr += "     <tr>";
				                imgStr += "        <th rowspan='2'>일자</th> ";
                                imgStr += "        <th rowspan='2'>순번</th> ";
                                imgStr += "        <th rowspan='2'>곡종</th> ";
                                imgStr += "        <th rowspan ='2'>이고BIN</th> ";
                                imgStr += "        <th rowspan ='2'>입고BIN</th> ";
                                imgStr += "        <th colspan ='2'>작업시작</th> ";
                                imgStr += "        <th colspan ='2'>작업종료</th> ";
                                imgStr += "        <th rowspan='2'>가동시간</th> ";
                                imgStr += "        <th rowspan='2'>이고량</th> ";
                                imgStr += "        <th rowspan='2'>작 업</th> ";                              
				                imgStr += "     </tr>";
                                imgStr += "     <tr>";
                                imgStr += "        <th>일 자</th> ";
                                imgStr += "        <th>시 간</th> ";
                                imgStr += "        <th>일 자</th> ";
                                imgStr += "        <th>시 간</th> ";
                                imgStr += "     </tr>";
                                imgStr += "   </table>";
                                imgStr += "<div id ='Scr_Move' style=\"height:845px;background: #FFFFFF; overflow-y: scroll;\">";
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 150px;\" /> ";
                                imgStr += "    <col style=\"width: 150px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 140px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
                                break;  
                           case 'CG_Board':
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 350px;\" /> ";
                                imgStr += "    <col style=\"width: 150px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 140px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
				                imgStr += "     <tr>";
				                imgStr += "        <th rowspan='2'>일자</th> ";
                                imgStr += "        <th rowspan='2'>순번</th> ";
                                imgStr += "        <th rowspan='2'>곡종</th> ";
                                imgStr += "        <th rowspan ='2'>이송BIN</th> ";
                                imgStr += "        <th colspan ='2'>작업시작</th> ";
                                imgStr += "        <th colspan ='2'>작업종료</th> ";
                                imgStr += "        <th rowspan='2'>가동시간</th> ";
                                imgStr += "        <th rowspan='2'>이송량</th> ";
                                imgStr += "        <th rowspan='2'>작 업</th> ";                              
				                imgStr += "     </tr>";
                                imgStr += "     <tr>";
                                imgStr += "        <th>일 자</th> ";
                                imgStr += "        <th>시 간</th> ";
                                imgStr += "        <th>일 자</th> ";
                                imgStr += "        <th>시 간</th> ";
                                imgStr += "     </tr>";
                                imgStr += "   </table>";
                                imgStr += "<div id ='Scr_Cargill' style=\"height:845px;background: #FFFFFF; overflow-y: scroll;\">";
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 350px;\" /> ";
                                imgStr += "    <col style=\"width: 150px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 100px;\" /> ";
                                imgStr += "    <col style=\"width: 140px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
                                break;  
                           case 'DC_Board':
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 160px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 80px;\" /> ";
                                imgStr += "    <col style=\"width: 350px;\" /> ";
                                imgStr += "    <col style=\"width: 270px;\" /> ";
                                imgStr += "    <col style=\"width: 250px;\" /> ";
                                imgStr += "    <col style=\"width: 230px;\" /> ";
                                imgStr += "    <col style=\"width: 230px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
				                imgStr += "     <tr>";
				                imgStr += "        <th>하역기</th> ";
                                imgStr += "        <th>일 자</th> ";
                                imgStr += "        <th>선창</th> ";
                                imgStr += "        <th>작업내용</th> ";
                                imgStr += "        <th>BIN</th> ";
                                imgStr += "        <th>하역시간</th> ";
                                imgStr += "        <th>하역량</th> ";                              
                                imgStr += "        <th>누계량</th> ";                              
                                imgStr += "        <th>작  업</th> ";                              
				                imgStr += "     </tr>";
                                imgStr += "   </table>";
                                imgStr += "<div id='ScrDC_Board' style=\"height:790px;background: #FFFFFF; overflow-y: scroll; clear: both; \">";
                                imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				                imgStr += "    <colgroup> ";
                                imgStr += "    <col style=\"width: 160px;\" /> ";
                                imgStr += "    <col style=\"width: 200px;\" /> ";
                                imgStr += "    <col style=\"width: 80px;\" /> ";
                                imgStr += "    <col style=\"width: 350px;\" /> ";
                                imgStr += "    <col style=\"width: 270px;\" /> ";
                                imgStr += "    <col style=\"width: 250px;\" /> ";
                                imgStr += "    <col style=\"width: 230px;\" /> ";
                                imgStr += "    <col style=\"width: 230px;\" /> ";
                                imgStr += "    <col style=\"\" /> ";
                                imgStr += "    </colgroup> ";
                                break;
                      }
                        //타이틀 
                        for (var i = 0; i < count; i++) {
                            data = store.getAt(i).data;  
                            nextdata = null;
                            if (i+1 < count)
                            {
                                nextdata = store.getAt(i+1).data;  
                            }
                            
                            
                            switch(id){
                                case 'SP_Board':   
                                       if( data.SPRANK == "2")
                                       {
                                            fontColor = "red";
                                       }
                                       else if( data.SPRANK == "1")
                                       {
                                            fontColor = "blue";
                                       }
                                       else{
                                            fontColor = "#505050;";
                                       }

                                       imgStr += "<tr>";
                                       imgStr += "<td style=\"text-align:left;color:"+fontColor+"\">"+ data.SPMEMO + "</td>"; 
                                       if( #{hidAuthGubn}.getValue() == 'Y' ){
                                         imgStr += "<td onclick=\"javascript:setBinSPECIALWorkPreCess('"+data.SPDATE+"','"+data.SPSEQ+"');\" valign=\"middle\" style=\"text-align:center; background-color:#4346F2; color:white; cursor: pointer; \">";
                                         imgStr += "게시종료";
                                         imgStr += "</td>"; 
                                       }
                                       else
                                       {
                                         imgStr += "<td valign=\"middle\" style=\"text-align:center;\"></td>"; 
                                       }
                                       imgStr += "</tr> "; 
                                     break;
                                case 'SH_Board':
                                        fontColor = FontColor(data);
                                        imgStr += "<tr> "; 
                                        imgStr += "<td  class=\"std\" style=\"text-align:left;color:"+fontColor+";overflow:hidden\">"+ data.SHHANGCHANM + "</td>"; 
                                        imgStr += "<td style=\"text-align:left;color:"+fontColor+"\">"+ data.SHBERTH + "</td>";
                                        imgStr += "<td style=\"text-align:left;color:"+fontColor+"\">"+ data.SHETAPT + "</td>"; 
                                        imgStr += "<td style=\"text-align:left;color:"+fontColor+"\";overflow:hidden>"+ data.SHGOKJONGNM + "</td>"; 
                                        imgStr += "<td style=\"text-align:left;color:"+fontColor+"\";overflow:hidden>"+ data.SHWONSANNM + "</td>"; 
                                        imgStr += "<td style=\"text-align:left;color:"+fontColor+"\">"+ data.SHSUNHUGBNM + "</td>"; 
                                        imgStr += "<td style=\"text-align:right;color:"+fontColor+"\">"+ Ext.util.Format.number(data.SHPTQTY, '0,000.000')+ "</td>"; 
                                        imgStr += "<td style=\"text-align:left;color:"+fontColor+"\";overflow:hidden>"+ data.SHSOSOKNM + "</td>"; 
                                        imgStr += "</tr> "; 
                                     break;
                                case 'BN_Board':                                       
                                        //글자색 판단
                                        //작업예정이나 작업이 시작되지 않은 상태: 검정
                                        //작업시작(ccp확인) 하였고 종료되지 않은 상태: 레드
                                        //ccp작업종료: 파랑
                                        if( data.CLSSUTIME == "" && data.CLESUTIME == "")
                                        {
                                           fontColor = "#505050;";
                                        }
                                        else if(data.CLSSUTIME != "" && data.CLESUTIME == "")
                                        {
                                          fontColor = "red";
                                        }
                                        else if(data.CLSSUTIME != "" && data.CLESUTIME != "")
                                        {
                                           fontColor = "blue";
                                        }
                                        else
                                        {
                                           fontColor = "#505050;";
                                        }

                                        imgStr += "<tr>";
                                        imgStr += "<td style=\"text-align:center; color:"+fontColor+"\">"+ data.CLBINNO+ "</td>"; 
                                        imgStr += "<td style=\"text-align:left; color:"+fontColor+"\">"+ data.CLBIGO+ "</td>"; 
                                        if( #{hidAuthGubn}.getValue() == 'Y' && data.SAFEORDERSTATUS != 'Y' ){
                                            if( data.CLSSUTIME != "")
                                            {
                                                imgStr += "<td style=\"text-align:center;color:"+fontColor+"\">"+ data.CLSSUTIME+ "</td>";  
                                            }
                                            else
                                            {
                                               imgStr += "<td onclick=\"javascript:setBinCleanWorkPreCess('START','"+data.CLBINNO+"','"+data.CLSEQ+"');\" style=\"text-align:center; background-color:#ED2A37; color:white; cursor: pointer;\">시 작</td>";
                                            }

                                            if( data.CLESUTIME != "" )
                                            {
                                                imgStr += "<td onclick=\"javascript:setBinCleanWorkPreCess('RESTART','"+data.CLBINNO+"','"+data.CLSEQ+"');\" style=\"text-align:center; background-color:#ED2A37; color:white; cursor: pointer;\">"+ data.CLESUTIME+"</td>";
                                            }
                                            else
                                            {
                                               if( data.CLSSUTIME != "" )
                                               {
                                                  imgStr += "<td onclick=\"javascript:setBinCleanWorkPreCess('END','"+data.CLBINNO+"','"+data.CLSEQ+"');\" style=\"text-align:center; background-color:#4346F2; color:white; cursor: pointer;\">종 료</td>"; 
                                               }   
                                               else{
                                                  imgStr += "<td style=\"text-align:center;color:"+fontColor+"\"></td>"; 
                                               }
                                            }
                                        }
                                        else
                                        {
                                            imgStr += "<td style=\"text-align:center;color:"+fontColor+"\">"+ data.CLSSUTIME+ "</td>"; 
                                            imgStr += "<td style=\"text-align:center;color:"+fontColor+"\">"+ data.CLESUTIME+ "</td>"; 
                                        }
                                        imgStr += "</tr> "; 
                                     break; 
                                 case 'MV_Board':
                                        imgStr += "<tr> "; 
                                        imgStr += "<td  class=\"std\" style=\"text-align:left\">"+ data.MDATE + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.MSEQ + "</td>"; 
                                        imgStr += "<td style=\"text-align:left\">"+ data.SGOKJONG1NM + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.MMVBINNO + "</td>";                                         
                                        imgStr += "<td style=\"text-align:center\">"+ data.MIPBINNO + "</td>";                                         
                                        imgStr += "<td style=\"text-align:center\">"+ data.MMSDATE + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.MSTIME + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.MMEDATE + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.METIME + "</td>";                                         
                                        imgStr += "<td style=\"text-align:center\">"+ data.MHSTIME + "</td>";                                         
                                        if( #{hidAuthGubn}.getValue() == 'Y' ){
                                            if( data.MMSDATE == "" && data.MMEDATE == "" )
                                            {
                                               imgStr += "<td style=\"text-align:right\">"+ commify(data.MMOVEQTY)+ "</td>"; 
                                               imgStr += "<td onclick=\"javascript:setBinMoveWorkPreCess('START','"+data.MDATE+"','"+data.MSEQ+"','"+data.SGOKJONG1+"','"+data.MMVBINNO+"','"+data.MIPBINNO+"');\" style=\"text-align:center; background-color:#ED2A37; color:white; cursor: pointer;\">시 작</td>"; 
                                            }
                                            else if( data.MMSDATE != "" && data.MMEDATE == "" )
                                            {
                                               imgStr += "<td style=\"text-align:right\">";
                                               var txtid = "txtMV"+data.MDATE.split("/")[0]+data.MDATE.split("/")[1]+data.MDATE.split("/")[2]+data.MSEQ;
                                               imgStr += "<input maxlength=\"9\" type=\"text\" id="+txtid+" Value=\"0\" style=\"font-size:33px; text-align:right; width: 190px;height: 50px; border: 2px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                                               imgStr += "</td>"; 
                                               imgStr += "<td onclick=\"javascript:setBinMoveWorkPreCess('END','"+data.MDATE+"','"+data.MSEQ+"','"+data.SGOKJONG1+"','"+data.MMVBINNO+"','"+data.MIPBINNO+"');\" style=\"text-align:center; background-color:#4346F2; color:white; cursor: pointer;\">종 료</td>"; 
                                            }
                                            else
                                            {
                                               imgStr += "<td style=\"text-align:right\">"+ commify(data.MMOVEQTY)+ "</td>"; 
                                               imgStr += "<td style=\"text-align:center;  color:white; \"></td>"; 
                                            }
                                        }
                                        else
                                        {
                                            imgStr += "<td style=\"text-align:right\">"+ commify(data.MMOVEQTY)+ "</td>"; 
                                            imgStr += "<td style=\"text-align:center;  color:white; \"></td>"; 
                                        }
                                        imgStr += "</tr> ";                                      
                                     break;
                                 case 'CG_Board':
                                        imgStr += "<tr> "; 
                                        imgStr += "<td  class=\"std\" style=\"text-align:left\">"+ data.TDATE + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.TSEQ + "</td>"; 
                                        imgStr += "<td style=\"text-align:left\">"+ data.TGOKJONGNM + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.TBINNO + "</td>";                                         
                                        imgStr += "<td style=\"text-align:center\">"+ data.TSDATE + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.TSTIME + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.TEDATE + "</td>"; 
                                        imgStr += "<td style=\"text-align:center\">"+ data.TETIME + "</td>";                                         
                                        imgStr += "<td style=\"text-align:center\">"+ data.THSTIME + "</td>";                                         
                                        if( #{hidAuthGubn}.getValue() == 'Y' ){
                                            if( data.TSDATE == "" && data.TEDATE == "" )
                                            {
                                               imgStr += "<td style=\"text-align:right\">"+ commify(data.TTRANSQTY)+ "</td>"; 
                                               imgStr += "<td onclick=\"javascript:setBinCargillPreCess('START','"+data.TDATE+"','"+data.TSEQ+"','"+data.TGOKJONG+"','"+data.TBINNO+"');\" style=\"text-align:center; background-color:#ED2A37; color:white; cursor: pointer;\">시 작</td>"; 
                                            }
                                            else if( data.TSDATE != "" && data.TEDATE == "" )
                                            {
                                               imgStr += "<td style=\"text-align:right\">";
                                               var txtid = "txtCG"+data.TDATE.split("/")[0]+data.TDATE.split("/")[1]+data.TDATE.split("/")[2]+data.TSEQ;
                                               imgStr += "<input maxlength=\"9\" type=\"text\" id="+txtid+" Value=\"0\" style=\"font-size:33px; text-align:right; width: 190px;height: 50px; border: 2px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                                               imgStr += "</td>"; 
                                               imgStr += "<td onclick=\"javascript:setBinCargillPreCess('END','"+data.TDATE+"','"+data.TSEQ+"','"+data.TGOKJONG+"','"+data.TBINNO+"');\" style=\"text-align:center; background-color:#4346F2; color:white; cursor: pointer;\">종 료</td>"; 
                                            }
                                            else
                                            {
                                               imgStr += "<td style=\"text-align:right\">"+ commify(data.TTRANSQTY)+ "</td>"; 
                                               imgStr += "<td style=\"text-align:center;  color:white; \"></td>"; 
                                            }
                                        }
                                        else
                                        {
                                            imgStr += "<td style=\"text-align:right\">"+ commify(data.TTRANSQTY)+ "</td>"; 
                                            imgStr += "<td style=\"text-align:center;  color:white; \"></td>"; 
                                        }
                                        imgStr += "</tr> ";                                      
                                     break;
                                 case 'DC_Board':

                                        if( data.DHANGCHA == 'SUB' || data.DHANGCHA == 'TOT') 
                                        { 
                                            if( data.DHANGCHA == 'SUB')
                                            {
                                                imgStr += "<tr class='Shsub'> "; 
                                                fontColor = 'blue';
                                            } 
                                            else if(data.DHANGCHA == 'TOT')
                                            {
                                                imgStr += "<tr class='ShTotal'> "; 
                                                fontColor = 'red';
                                            }
                                            else
                                            {
                                                imgStr += "<tr> ";   
                                            }                                        
                                            imgStr += data.DHANGCHA == 'SUB'? "<td  class=\"std\" style=\"text-align:center;color:"+fontColor+"\">소 계</td>" : "<td  class=\"std\" style=\"text-align:center;color:"+fontColor+"\">합 계</td>";
                                            imgStr += "<td style=\"text-align:center\">"+ data.DLSDATE + "</td>"; 
                                            imgStr += "<td style=\"text-align:center\"></td>"; 
                                            imgStr += "<td style=\"text-align:left\">"+ data.DWORKTEXT + "</td>"; 
                                            imgStr += "<td style=\"text-align:center\">"+ data.DBINNO + "</td>"; 
                                            imgStr += "<td style=\"text-align:center\">"+ data.WORKTIME + "</td>"; 
                                            imgStr += "<td style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.DLOADQTY,'0,000.000') + "</td>"; 
                                            imgStr += "<td style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.DSUMQTY,'0,000.000') + "</td>"; 
                                            imgStr += "<td style=\"text-align:center\"></td>"; 
                                            imgStr += "</tr> ";    
                                        }
                                        else
                                        {
                                                imgStr += "<tr> ";   
                                                imgStr += "<td  class=\"std\" style=\"text-align:center\">"+ data.DLOADCODENM + "</td>"; 
                                                imgStr += "<td style=\"text-align:center\">"+ data.DLSDATE + "</td>"; 
                                                imgStr += "<td style=\"text-align:center\">"+ data.DSUNCHANG + "</td>"; 
                                                imgStr += "<td style=\"text-align:left\">"+ data.DWORKTEXT + "</td>"; 
                                                imgStr += "<td style=\"text-align:center\">"+ data.DBINNO + "</td>"; 
                                                imgStr += "<td style=\"text-align:center\">"+ data.WORKTIME + "</td>"; 
                                                                                           
                                                if( #{hidAuthGubn}.getValue() == 'Y' && data.BTNCNT == 0 ){
                                                   switch(data.BTNSTATUS){
                                                      case 'S':
                                                        imgStr += "<td style=\"text-align:right\">"+ FormatZero(data.DLOADQTY,'0,000.000') + "</td>";      
                                                        imgStr += "<td style=\"text-align:right\">"+ FormatZero(data.DSUMQTY,'0,000.000') + "</td>";  
                                                        imgStr += "<td onclick=\"javascript:setBinDCBoardWorkPreCess('START','"+data.DCORPGUBN+"','"+data.DHANGCHA+"','"+data.DGOKJONG+"','"+data.DLOADCODE+"','"+data.DWKDATE+"','"+data.DSEQ+"','"+data.DSBINSEQ+"','"+data.DBINNO+"','','','','','','','','');\" style=\"text-align:center; background-color:#ED2A37; color:white; cursor: pointer;\">시 작</td>";
                                                        break;
                                                      case 'E':
                                                        var txtid = "txtDC"+data.DCORPGUBN+data.DHANGCHA+data.DGOKJONG+data.DSEQ+data.DSBINSEQ+data.DBINNO;
                                                        var txtid2 = "txtDC2"+data.DCORPGUBN+data.DHANGCHA+data.DGOKJONG+data.DSEQ+data.DSBINSEQ+data.DBINNO;
                                                        imgStr += "<td style=\"text-align:right\">";
                                                        imgStr += "<input maxlength=\"9\" type=\"text\" id="+txtid2+" Value="+FormatZero(data.DLOADQTY,'0,000.000')+" style=\"font-size:33px; text-align:right; width: 190px;height: 50px; border: 2px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                                                        imgStr += "</td>";    
                                                        imgStr += "<td style=\"text-align:right\">";
                                                        imgStr += "<input maxlength=\"9\" type=\"text\" id="+txtid+" Value="+FormatZero(data.DSUMQTY,'0,000.000')+" style=\"font-size:33px; text-align:right; width: 190px;height: 50px; border: 2px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                                                        imgStr += "</td>";
                                                        if(nextdata == null)
                                                        {
                                                        imgStr += "<td onclick=\"javascript:setBinDCBoardWorkPreCess('END','"+data.DCORPGUBN+"','"+data.DHANGCHA+"','"+data.DGOKJONG+"','"+data.DLOADCODE+"','"+data.DWKDATE+"','"+data.DSEQ+"','"+data.DSBINSEQ+"','"+data.DBINNO+"','','','','','','','','');\" style=\"text-align:center; background-color:#4346F2; color:white; cursor: pointer;\">종 료</td>";
                                                        }
                                                        else{
                                                        imgStr += "<td onclick=\"javascript:setBinDCBoardWorkPreCess('END','"+data.DCORPGUBN+"','"+data.DHANGCHA+"','"+data.DGOKJONG+"','"+data.DLOADCODE+"','"+data.DWKDATE+"','"+data.DSEQ+"','"+data.DSBINSEQ+"','"+data.DBINNO+"','"
                                                                +nextdata.DCORPGUBN+"','"+nextdata.DHANGCHA+"','"+nextdata.DGOKJONG+"','"+nextdata.DLOADCODE+"','"+nextdata.DWKDATE+"','"+nextdata.DSEQ+"','"+nextdata.DSBINSEQ+"','"+nextdata.DBINNO+"');\" style=\"text-align:center; background-color:#4346F2; color:white; cursor: pointer;\">종 료</td>";
                                                        }
                                                        break;
                                                      default:
                                                        imgStr += "<td style=\"text-align:right\">"+ FormatZero(data.DLOADQTY,'0,000.000') + "</td>";      
                                                        imgStr += "<td style=\"text-align:right\">"+ FormatZero(data.DSUMQTY,'0,000.000') + "</td>";  
                                                        imgStr += "<td style=\"text-align:center\"></td>";  
                                                        break;
                                                   }
                                                }
                                                else{
                                                  imgStr += "<td style=\"text-align:right\">"+ FormatZero(data.DSUMQTY,'0,000.000') + "</td>";  
                                                  imgStr += "<td style=\"text-align:center\"></td>";  
                                                }
                                                imgStr += "</tr> ";   
                                        }
                                        
                                        //모선명
                                        if( i == 0 )
                                        {
                                           document.getElementById("spSHHANGCHANM").innerHTML = data.DHANGCHANM;
                                           //BL량
                                           document.getElementById("spSHBLQTY").innerHTML = commify(Number(data.DBLQTY).toFixed(3))+' M/T';
                                        }
                                        
                                        //하역량
                                        if( data.DHANGCHA == 'TOT' )
                                        {                                            
                                            document.getElementById("spSHLOADQTY").innerHTML = commify(Number(data.DLOADQTY).toFixed(3))+' M/T';
                                            //하역잔량
                                            document.getElementById("spSHLOADJANQTY").innerHTML = commify(Number(data.DSJANQTY).toFixed(3))+' M/T';
                                        }
                                     break;

                              }
                        }//for (var i = 0; i < count; i++) ..end
                        imgStr += "</table> </div> ";
                        div.innerHTML = imgStr;     

                }       
           }
           // ----------특기사항, 하역,입합계획, bin클리닝, 하역작업일지  종료----------//        
           
           // BIN SPACE 그리드 표현            
           function tab_BoardHtmlRenterBS(store, GKstore){
                var div = document.getElementById("tab_SP_Board");
	            var imgStr = "";                                                
	            var count = store.getCount();
                var GKcount = GKstore.getCount();
	            var data = null;
	            var id;
	            var fontColor;                
                
                var SBINNO = "";
                var CCAPA = 0;
                var rowCount = 0;

	            if(div)
	            {    
		            CloseSubWin('BoardTopTitleBase');
                    CloseSubWin('ShipScheduleBase');
                    CloseSubWin('BoardTopTitleShipDoc'); 
                    OpenSubWin('BoardTopTitleBinSpace');

		            imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
		            imgStr += "    <colgroup> ";
		            imgStr += "     <col style=\"width: 1301px;\" /> ";
		            imgStr += "     <col style=\"width: 250px;\" /> ";
		            imgStr += "     <col style=\"\" /> ";
		            imgStr += "    </colgroup> ";
		            imgStr += "     <tr>";
		            imgStr += "	      <th>하역대기 BIN</th><th>총 CAPA</th> ";
		            imgStr += "     </tr>";
		            imgStr += "   </table>";
		            imgStr += "<div style=\"height:210px;background: #FFFFFF; overflow-y: scroll;\">";
		            imgStr += "     <table class=\"table_01\" style=\"width: 100%;\"> ";
		            imgStr += "        <colgroup> ";
		            imgStr += "          <col style=\"width: 1301px;\" /> ";
		            imgStr += "          <col style=\"width: 250px;\" /> ";
		            imgStr += "          <col style=\"\" /> ";                                
		            imgStr += "        </colgroup> ";

		            //타이틀 
		            for (var i = 0; i < count; i++) {
			            data = store.getAt(i).data;  

                        if(i == 0 || rowCount == 0)
                        {
                            SBINNO += data.SBINNO;
                        }
                        else{
                            SBINNO += "," + data.SBINNO;
                        }
                        rowCount++;
                        if(rowCount == 22)
                        {
                            SBINNO += "<br>"
                            rowCount = 0;
                        }
			            CCAPA += parseFloat(data.CCAPA);

                        
		            }//for (var i = 0; i < count; i++) ..end

                    imgStr += "<tr> "; 
			            imgStr += "<td  class=\"std\" style=\"text-align:left;color:#505050;\">"+ SBINNO + "</td>";
			            imgStr += "<td style=\"text-align:right;color:blue;\">"+ FormatZero(CCAPA,'0,000') + "</td>";
			            imgStr += "</tr> "; 
		            imgStr += "</table> </div> ";

                    // 곡종별 SPACE
                    imgStr += "   <table class=\"table_01\" style=\"width: 1150px;\"> ";
		            imgStr += "    <colgroup> ";
		            imgStr += "     <col style=\"width: 500px;\" /> ";
                    imgStr += "     <col style=\"width: 350px;\" /> ";
		            imgStr += "     <col style=\"width: 300px;\" /> ";
		            imgStr += "     <col style=\"\" /> ";
		            imgStr += "    </colgroup> ";
		            imgStr += "     <tr>";
		            imgStr += "	      <th>곡종</th><th>원산지</th><th>CAPA</th> ";
		            imgStr += "     </tr>";
		            imgStr += "   </table>";
                    imgStr += "<div style=\"height:570px;background: #FFFFFF; overflow-y: scroll;\">";
		            imgStr += "     <table class=\"table_01\" style=\"width: 1150px;\"> ";
		            imgStr += "        <colgroup> ";
		            imgStr += "          <col style=\"width: 500px;\" /> ";
		            imgStr += "          <col style=\"width: 350px;\" /> ";
                    imgStr += "          <col style=\"width: 300px;\" /> ";
		            imgStr += "          <col style=\"\" /> ";                                
		            imgStr += "        </colgroup> ";

                    data= null;

                    for (var i = 0; i < GKcount; i++) {
			            data = GKstore.getAt(i).data;  

                        if(i == 0)
                        {
                            fontColor = "blue";
                        }
                        else{
                            fontColor = "#505050";
                        }
			            imgStr += "<tr> "; 
			            imgStr += "<td  class=\"std\" style=\"text-align:left;color:"+fontColor+"\">"+ data.SGOKJONGNM + "</td>"; 
			            imgStr += "<td style=\"text-align:left;color:"+fontColor+"\">"+ data.SWONSANNM + "</td>"; 			            
                        imgStr += "<td style=\"text-align:right;color:"+fontColor+"\">"+ Ext.util.Format.number(data.CAPA, '0,000')+ "</td>"; 
			            imgStr += "</tr> "; 

		            }//for (var i = 0; i < count; i++) ..end
		            imgStr += "</table> </div> ";

		            div.innerHTML = imgStr;     

	            } 
	              
            }
           //특기사항 게시종료 이벤트
           function setBinSPECIALWorkPreCess(sSPDATE, sSPSEQ){

                  Ext.MessageBox.confirm("확인", "특기사항 게시를 종료 하시겠습니까?", function (btn) {
                    if (btn == "yes") {

                         Ext.net.DirectMethod.request('UP_SetBinSPECIALWorkPreCess', {
                            url: location.href,
                            params: { SPDATE: sSPDATE,
                                      SPSEQ:  sSPSEQ,
                                      sBoardDate: BoardDate
                            },
                            eventMask: {
                                showMask: true,
                                msg: "특기사항을 저장하고 있습니다..",
                                target: "customtarget"
                            }
                        }
                        );
                    }
                });            
           }

           //bin 클리닝 작업 버튼 이벤트
           function setBinCleanWorkPreCess(value, sBinno, sSeq){

                var msg = null;

              switch(value){
                   case "START":
                     msg = "BIN 클리닝 작업을 시작 하시겠습니까?";
                     break;
                   case "END":
                     msg = "BIN 클리닝 작업을 종료 하시겠습니까?";
                     break;
                   case "RESTART":
                     msg = "BIN 클리닝 작업을 재시작하시겠습니까?";
                     break;
              }              

              Ext.MessageBox.confirm("확인", msg, function (btn) {
                    if (btn == "yes") {

                         Ext.net.DirectMethod.request('UP_SetBinCleanDataProcess', {
                            url: location.href,
                            params: { BINNO    : sBinno,
                                      TIMEGUBN : value,
                                      sDATE    : BoardDate,
                                      sSEQ     : sSeq,
                                      sGroupCheck : #{hidDisplayCheck}.getValue()
                            },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 클리닝을 저장하고 있습니다..",
                                target: "customtarget"
                            }
                        }
                        );
                    }
                });    
                            
           }

           //bin 이고 작업 버튼 이벤트
           function setBinMoveWorkPreCess(value, sMDATE, sMSEQ, sSGOKJONG, sMMVBINNO,  sMIPBINNO){

                var msg = null;
              var sMMOVEQTY;

              var sParamMDATE = sMDATE.split("/")[0]+sMDATE.split("/")[1]+sMDATE.split("/")[2];
              
              sMMOVEQTY = 0;
              
              if( value == "END")
              {
                 sMMOVEQTY = document.getElementById('txtMV'+sParamMDATE+sMSEQ).value;

                 if( parseFloat(sMMOVEQTY) <= 0 || sMMOVEQTY == "")
                 {
                    document.getElementById('txtMV'+sParamMDATE+sMSEQ).value = "0";
                    document.getElementById('txtMV'+sParamMDATE+sMSEQ).focus();
                    alert('BIN 이고 종료작업시에는 반드시 이고량을 입력해야 합니다');
                    return;
                 }

                 sMMOVEQTY = Ext.util.Format.number(parseFloat(sMMOVEQTY),'000.000');
              }              

              msg = value == 'START' ? "BIN 이고 작업 시작하시겠습니까?": "BIN 이고 작업을 종료하시겠습니까?";       

              Ext.MessageBox.confirm("확인", msg, function (btn) {
                    if (btn == "yes") {
                        Ext.net.DirectMethod.request('UP_SetBinMoveDataProcess', {
                            url: location.href,
                            params: { MDATE: sParamMDATE,
                                      MSEQ: sMSEQ,
                                      MGOKJONG: sSGOKJONG,
                                      MMVBINNO: sMMVBINNO,
                                      MIPBINNO: sMIPBINNO,
                                      MMOVEQTY: sMMOVEQTY,
                                      TIMEGUBN : value,
                                      sBoardDate: BoardDate,
                                      sGroupCheck : #{hidDisplayCheck}.getValue()
                            },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 이고작업을 저장하고 있습니다..",
                                target: "customtarget"
                            }
                        }
                        );                        
                    }
                });
           }

           //카길 이송 작업 버튼 이벤트
           function setBinCargillPreCess(value, sTDATE, sTSEQ, sTGOKJONG, sTBINNO){

              var msg = null;
              var sTTRANSQTY;

              var sParamTDATE = sTDATE.split("/")[0]+sTDATE.split("/")[1]+sTDATE.split("/")[2];
              
              sTTRANSQTY = 0;
              
              if( value == "END")
              {
                 sTTRANSQTY = document.getElementById('txtCG'+sParamTDATE+sTSEQ).value;

                 if( parseFloat(sTTRANSQTY) <= 0 || sTTRANSQTY == "")
                 {
                    document.getElementById('txtCG'+sParamTDATE+sTSEQ).value = "0";
                    document.getElementById('txtCG'+sParamTDATE+sTSEQ).focus();
                    alert('BIN 이송 종료작업시에는 반드시 이송량을 입력해야 합니다');
                    return;
                 }

                 sTTRANSQTY = Ext.util.Format.number(parseFloat(sTTRANSQTY),'000.000');
              }              

              msg = value == 'START' ? "BIN 이송 작업 시작하시겠습니까?": "BIN 이송 작업을 종료하시겠습니까?";       

              Ext.MessageBox.confirm("확인", msg, function (btn) {
                    if (btn == "yes") {
                        Ext.net.DirectMethod.request('UP_SetBinCargillDataProcess', {
                            url: location.href,
                            params: { TDATE: sParamTDATE,
                                      TSEQ: sTSEQ,
                                      TGOKJONG: sTGOKJONG,
                                      TBINNO: sTBINNO,
                                      TTRANSQTY: sTTRANSQTY,
                                      TIMEGUBN : value,
                                      sBoardDate: BoardDate,
                                      sGroupCheck : #{hidDisplayCheck}.getValue()
                            },
                            eventMask: {
                                showMask: true,
                                msg: "BIN 이송작업을 저장하고 있습니다..",
                                target: "customtarget"
                            }
                        }
                        );                        
                    }
                });
           }

           //하역작업일지 시작,종료 버튼 이벤트
           function setBinDCBoardWorkPreCess(value, DCORPGUBN, DHANGCHA, DGOKJONG, DLOADCODE, DWKDATE, DSEQ, DSBINSEQ, DBINNO,
                                                    N_DCORPGUBN, N_DHANGCHA, N_DGOKJONG, N_DLOADCODE, N_DWKDATE, N_DSEQ, N_DSBINSEQ, N_DBINNO){

              var msg = null;             
              var sDSSUMQTY;
              var sDLOADQTY;

              DWKDATE = DWKDATE.split("/")[0]+DWKDATE.split("/")[1]+DWKDATE.split("/")[2];
              if(N_DHANGCHA != "SUB" && N_DHANGCHA != "TOT")
              {
                N_DWKDATE = N_DWKDATE.split("/")[0]+N_DWKDATE.split("/")[1]+N_DWKDATE.split("/")[2];
              }

              var sParamid = "txtDC"+DCORPGUBN+DHANGCHA+DGOKJONG+DSEQ+DSBINSEQ+DBINNO;
              var sParamid2 = "txtDC2"+DCORPGUBN+DHANGCHA+DGOKJONG+DSEQ+DSBINSEQ+DBINNO;
              
              sDSSUMQTY = 0;
              sDLOADQTY = 0;
              
              if( value == "END")
              {
                 sDSSUMQTY = comma_to_number(document.getElementById(sParamid).value);
                 sDLOADQTY = comma_to_number(document.getElementById(sParamid2).value);

                 if( parseFloat(sDSSUMQTY) <= 0 || sDSSUMQTY == "" || parseFloat(sDLOADQTY) <= 0 || sDLOADQTY == "")
                 {
                    document.getElementById(sParamid).value = "0";
                    document.getElementById(sParamid).focus();
                    alert('BIN 하역종료시에는 반드시 하역량과 누계량을 입력해야 합니다');
                    return;
                 }

                 //직전 레코드의 누계량보다 작을수 없다.
                 var wkDWKDATE = '';
                 var drecordDSUMQTY = 0;
                 var drecordDLOADQTY = 0;
                 var store = #{stoBinSHipDoc};
                 var count = store.getCount();
                 var data = null;
                 for (var i = 0; i < count; i++) {
                    data = store.getAt(i).data;

                    wkDWKDATE = data.DWKDATE.split("/")[0]+data.DWKDATE.split("/")[1]+data.DWKDATE.split("/")[2];

                    if( data.DCORPGUBN == DCORPGUBN &&
                        data.DHANGCHA == DHANGCHA &&
                        data.DGOKJONG == DGOKJONG &&
                        data.DLOADCODE == DLOADCODE &&
                        wkDWKDATE == DWKDATE &&
                        data.DSEQ == DSEQ &&
                        count > 0 ){

                        if( parseFloat(sDSSUMQTY) < parseFloat(drecordDSUMQTY) ) // bobcat 작업, 수리등 내용입력으로 누계량이 이전누계량과 같은경우도 등록 허용(2021-01-06)
                        {
                           alert('누계량은 이전 누계량보다 작을수 없습니다');
                           return;                            
                        }
                   }

                   if( data.DCORPGUBN == DCORPGUBN &&
                        data.DHANGCHA == DHANGCHA &&
                        data.DGOKJONG == DGOKJONG &&
                        data.DLOADCODE == DLOADCODE ){
                    
                       drecordDSUMQTY = data.DSUMQTY;    
                       drecordDLOADQTY = data.DLOADQTY              
                   }
                   
                 }
                 sDSSUMQTY = Ext.util.Format.number(parseFloat(sDSSUMQTY),'000.000');
                 sDLOADQTY = Ext.util.Format.number(parseFloat(sDLOADQTY),'000.000');
              }
             
              msg = value == 'START' ? "BIN 하역작업을 시작하시겠습니까?": "BIN 하역작업을 종료하시겠습니까?";

              Ext.MessageBox.confirm("확인", msg, function (btn) {
                    if (btn == "yes") {
                        if(value == "START") {
                            Ext.net.DirectMethod.request('UP_SetBinDCBoardDataProcess', {
                                url: location.href,
                                params: { DCORPGUBN: DCORPGUBN,
                                          DHANGCHA: DHANGCHA,
                                          DGOKJONG: DGOKJONG,
                                          DLOADCODE:DLOADCODE,
                                          DWKDATE: DWKDATE,
                                          DSEQ: DSEQ,
                                          DLOADQTY : sDLOADQTY,
                                          DSUMQTY: sDSSUMQTY,

                                          N_DCORPGUBN: N_DCORPGUBN,
                                          N_DHANGCHA: N_DHANGCHA,
                                          N_DGOKJONG: N_DGOKJONG,
                                          N_DLOADCODE:N_DLOADCODE,
                                          N_DWKDATE: N_DWKDATE,
                                          N_DSEQ: N_DSEQ,
                                          N_DLOADQTY : 0,
                                          N_DSUMQTY: 0,

                                          TIMEGUBN : value,
                                          sGroupCheck : #{hidDisplayCheck}.getValue()
                                },
                                eventMask: {
                                    showMask: true,
                                    msg: "BIN 하역작업을 저장하고 있습니다..",
                                    target: "customtarget"
                                }
                            });                        
                        }
                        else{
                            if(N_DHANGCHA != "SUB" && N_DHANGCHA != "TOT" && N_DHANGCHA != "")
                            {
                                Ext.MessageBox.confirm("확인", "다음 작업을 이어서 하시겠습니까?", function (btn) {
                                    if (btn == "yes") {
                                        value = "ENDSTART";

                                        Ext.net.DirectMethod.request('UP_SetBinDCBoardDataProcess', {
                                            url: location.href,
                                            params: { DCORPGUBN: DCORPGUBN,
                                                    DHANGCHA: DHANGCHA,
                                                    DGOKJONG: DGOKJONG,
                                                    DLOADCODE:DLOADCODE,
                                                    DWKDATE: DWKDATE,
                                                    DSEQ: DSEQ,
                                                    DLOADQTY : sDLOADQTY,
                                                    DSUMQTY: sDSSUMQTY,

                                                    N_DCORPGUBN: N_DCORPGUBN,
                                                    N_DHANGCHA: N_DHANGCHA,
                                                    N_DGOKJONG: N_DGOKJONG,
                                                    N_DLOADCODE:N_DLOADCODE,
                                                    N_DWKDATE: N_DWKDATE,
                                                    N_DSEQ: N_DSEQ,
                                                    N_DLOADQTY : 0,
                                                    N_DSUMQTY: 0,

                                                    TIMEGUBN : value
                                            },
                                            eventMask: {
                                                showMask: true,
                                                msg: "BIN 하역작업을 저장하고 있습니다..",
                                                target: "customtarget"
                                            }
                                        });                   
                                    }
                                    else{
                                        Ext.net.DirectMethod.request('UP_SetBinDCBoardDataProcess', {
                                            url: location.href,
                                            params: { DCORPGUBN: DCORPGUBN,
                                                      DHANGCHA: DHANGCHA,
                                                      DGOKJONG: DGOKJONG,
                                                      DLOADCODE:DLOADCODE,
                                                      DWKDATE: DWKDATE,
                                                      DSEQ: DSEQ,
                                                      DLOADQTY : sDLOADQTY,
                                                      DSUMQTY: sDSSUMQTY,

                                                      N_DCORPGUBN: N_DCORPGUBN,
                                                      N_DHANGCHA: N_DHANGCHA,
                                                      N_DGOKJONG: N_DGOKJONG,
                                                      N_DLOADCODE:N_DLOADCODE,
                                                      N_DWKDATE: N_DWKDATE,
                                                      N_DSEQ: N_DSEQ,
                                                      N_DLOADQTY : 0,
                                                      N_DSUMQTY: 0,

                                                      TIMEGUBN : value
                                            },
                                            eventMask: {
                                                showMask: true,
                                                msg: "BIN 하역작업을 저장하고 있습니다..",
                                                target: "customtarget"
                                            }
                                        });       
                                    }
                                });
                            }
                            else{
                                Ext.net.DirectMethod.request('UP_SetBinDCBoardDataProcess', {
                                    url: location.href,
                                    params: { DCORPGUBN: DCORPGUBN,
                                                DHANGCHA: DHANGCHA,
                                                DGOKJONG: DGOKJONG,
                                                DLOADCODE:DLOADCODE,
                                                DWKDATE: DWKDATE,
                                                DSEQ: DSEQ,
                                                DLOADQTY : sDLOADQTY,
                                                DSUMQTY: sDSSUMQTY,

                                                N_DCORPGUBN: N_DCORPGUBN,
                                                N_DHANGCHA: N_DHANGCHA,
                                                N_DGOKJONG: N_DGOKJONG,
                                                N_DLOADCODE:N_DLOADCODE,
                                                N_DWKDATE: N_DWKDATE,
                                                N_DSEQ: N_DSEQ,
                                                N_DLOADQTY : 0,
                                                N_DSUMQTY: 0,

                                                TIMEGUBN : value
                                    },
                                    eventMask: {
                                        showMask: true,
                                        msg: "BIN 하역작업을 저장하고 있습니다..",
                                        target: "customtarget"
                                    }
                                });
                            }
                        }
                    }
                });                              
           }

            /********************************************************************************************
            *   작성목적    :  배너 시계 이벤트
            *   수정내역    :
            ********************************************************************************************/
            setInterval("dpTime()", 1000);
            
            function dpTime() {
                now = new Date();
                years = now.getYear() + 1900;
                month = now.getMonth() + 1;
                days = now.getDate();
                hours = now.getHours();
                minutes = now.getMinutes();
                seconds = now.getSeconds();

                if (years < 2000) {
                    years = years + 1900;
                }
                if (hours < 10) {
                    hours = "0" + hours;
                }
                if (minutes < 10) {
                    minutes = "0" + minutes;
                }
                if (seconds < 10) {
                    seconds = "0" + seconds;
                }
                document.getElementById("dpTime").innerHTML = years + "년" + month + "월" + days + "일" +"&nbsp;&nbsp;" + hours + ":" + minutes + ":" + seconds; 

                now = null;
                years = null;
                month = null;
                days = null;
                hours = null;
                minutes = null;
                seconds = null;
            }

            function Get_FormatDateTime(value, check){
               if( check == 1 ){
                 if (value.length == 8) {
                        var yyyy = value.substring(0, 4);
                        var mm = value.substring(4, 6);
                        var dd = value.substring(6, 8);

                        var date = yyyy + "." + mm + "." + dd;                        

                        return date;
                 }
                 else
                 {
                    return "";
                 }
               }
               else
               {
                 if (value.length == 4 && value != "" && value != "0000") {
                        var hh = value.substring(0, 2);
                        var mm = value.substring(2, 4);

                        var datetime = hh + ":" + mm;

                        return datetime;
                 }
                 else
                 {
                    return "";
                 }
               }
          }           
           
           //특기사항, 입항하역계획, bin 클리닝, bin이고, 하역작업일지,하역현황 타이머로 자료 조회
           function UpdateBoardData(){
                
                var paramValue; 
                var DirectMethodid;
                var store = null;
                var div = document.getElementById("tab_bx");                     
                var theadObj = div.querySelectorAll("li > a");
                if( theadObj.length > 0 )
                {
                    //선택한 tab 찾기
                    for (var i = 0; i < theadObj.length; i++) {
                        DirectMethodid = theadObj[i].className == "on" ? theadObj[i].id : "";
                        if(DirectMethodid)
                        {
                          break;
                        }
                    }
                }
                div = null;

                //하역작업일지 스크롤 좌표값 기억하기
                div = document.getElementById("ScrDC_Board");
                if(div){
                   scrleft_DCLOAD = div.scrollLeft;
                   scrtop_DCLOAD  = div.scrollTop;                
                }
                div = null;
                //특기사항
                div = document.getElementById("Scr_Board");
                if(div){
                   scrleft_Board  = div.scrollLeft;
                   scrtop_Board  = div.scrollTop;
                }
                div = null;
                //이고
                div = document.getElementById("Scr_Move");
                if(div){
                  scrleft_Move  = div.scrollLeft;
                  scrtop_Move  = div.scrollTop;
                }
                div = null;
                //특기사항, 입항하역계획, bin 클리닝, bin이고, 하역작업일지 중에 tab 활성화된건만 호출
                switch (DirectMethodid) {                   
                    case 'DC_Board':           
                        paramValue = document.getElementById("DocHangCha").innerText;
                        break;
                    default:
                        paramValue = BoardDate;
                        break; 
                }
                
                if(DirectMethodid){ 
                    GetDirectMethodData(DirectMethodid, paramValue);
                }

                 //하역작업일지 TAB이 선택되어 있으면 UPDATE
                if( DirectMethodid == 'DC_Board' ){
                   setDirectMethod_BinShipDocGKData(paramValue);
                }

                //하역현황은 추가 호출         
                paramValue = document.getElementById("spnShipTileHangcha").innerText;
                GetDirectMethodData('LC_Board', paramValue);
                
           }     

           function setDirectMethod_BinShipDocGKData(HangCha){

               Ext.net.DirectMethod.request('UP_GetBinShipDocGKData', { 
                                url: location.href,
                                params: {sCorpGubn : GetBinShipDocSelectComboValue('SelectShipDocCORP'),
                                         sHangCha: HangCha },
                                eventMask: {
                                    showMask: true,
                                    msg: "BIN 하역작업일지 조회중...",
                                    target: "customtarget"
                                    }
                               }
                    );
           }

           
           //현재 일자 가져오기
           function BoardDateCurrent_Date(id){      
                   
               BoardDate = Current_Date().split("-")[0]+Current_Date().split("-")[1]+Current_Date().split("-")[2];
               BoardDateMonth = Current_Date().split("-")[0]+Current_Date().split("-")[1];

               if( id == 'BoardDate' ){
                 
                  document.getElementById(id).innerHTML = BoardDate.substr(0,4) + "년" + BoardDate.substr(4,2) + "월" + BoardDate.substr(6,2) + "일";
                  GetBoardMoveDate('Now');
               }
               else
               {
                  document.getElementById(id).innerHTML = BoardDateMonth.substr(0,4) + "년" + BoardDateMonth.substr(4,2) + "월";
                  GetScheduleMoveDate('Now');
               }   
              
           }         

           //Max 항차
           function DocHangChaCurrent_Hang(id){

                document.getElementById(id).innerText = #{hidMaxHangCha}.getValue();

                if( id == 'DocHangCha' ){
                    GetHangChaMove('Now','1');
                }
                else
                {
                    GetHangChaMove('Now','2');
                }
           }

           function LoadDocHangChaCurrent_Hang(id){

                document.getElementById(id).innerText = #{hidLoadMaxHangCha}.getValue();

                if( id == 'DocHangCha' ){
                    GetLoadHangChaMove('Now','1');
                }
                else
                {
                    GetLoadHangChaMove('Now','2');
                }
           }

           //클라이언트 호출 최초 작업 설정
           function setClientCall(AuthGubn, AuthSABUN)
           { 
             
                //bin 출고량, 재고량 표시               
                 setBinQtyDisplay(dBinChTotalQty, dBinEmpTotalQty, dBinJegoTotalQty);

                 //하역작업일지 최초 항차 표시
                 var docStore = #{stoBinSHipDoc};
                 count = docStore.getCount();
                 data = null;
                 if( count >= 3 )
                 {
                    data = docStore.getAt(0).data;
                    document.getElementById("DocHangCha").innerHTML = data.DHANGCHA;
                 }

                 //권한체크
                 #{hidAuthGubn}.setValue(AuthGubn);
                 #{hidAuthSABUN}.setValue(AuthSABUN);

                 //항목체크 카운트 초기화
                 #{hidGKCnt}.setValue("0");
                 #{hidWNCnt}.setValue("0");
                 #{hidVSCnt}.setValue("0");

                 if( AuthGubn != 'Y' )
                 {                
                    document.getElementById("ImgManage").style.display = "none";
                    document.getElementById("ImgManage2").style.display = "none";
                 }

                 SetBinNoCombo();
           }

          function SetBinNoCombo() {
                
                var store = #{stoBinNo};
                var count = store.getCount();                               
                var data;
                var selectBox = document.getElementById("SelBinNum");
                var option;
                var i;

                for (var i = 0; i < count; i++) {

                    data = store.getAt(i).data;

                    option = document.createElement("option");
                    option.text = data.BCBINNO;
                    option.value = data.BCBINNO;
                    selectBox.add(option, null);
                }
          }

          function GetBinShipDocSelectComboValue(id){
              var value;
              
               value = '';

               var div = document.getElementById(id);
               if( div != null && div.length > 0 )
                {                         
                    for (var i = 0; i < div.length; i++) {
                        if(  div[i].selected == true)
                        {
                           value = div[i].value;
                        }
                    }
               }

               return value;
          }


          function FontColor(data){
                if( data.SHGKGUBN == "Y" )
                {               
                    return "blue";                
                }
                else
                {
                    return "#505050";
                }
//              if( data.SHIPCOME8 == "Y" )
//              {               
//                  return "red";                
//              }
//              else if( data.SHIPCOME9 == "Y" )
//              {
//                  return "blue";
//              }
//              else
//              {
//                  return "#505050";
//              }
           }

           //문자열내 모든 공백 제거
           function StringTrim(value){
                return value.replace(/\s/gi,'');               
           }           

           function UP_ManaGerFormOpen(value){    
                      
                var xWidth = window.screen.width;  
                var xHeight = window.screen.height; 

                //특기사항,입합계획,BIN 클리닝, BIN이고, 하역작업일지
                var div = document.getElementById("tab_bx");                     
                var theadObj = div.querySelectorAll("li > a");
                var Tabid = null;
                if( theadObj.length > 0 )
                {
                    for (var i = 0; i < theadObj.length; i++) {
                        if( theadObj[i].className == "on")
                        {
                            Tabid = theadObj[i].id;
                        }
                    }
                }
                var param1 = "param1="+value+"&param2="+Tabid;

               var popup = window.open(
                    "../SILOBIN/SiloBinManager.aspx?"+param1,
                    "SiloBinManager",
                    "toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width="+xWidth+",height="+xHeight
                    )
                popup.focus();
           } 

           function rdo_change(id, gubun)
           {
                var unitStore = #{stoPlantUnits};                
                var count = unitStore.getCount();
                var data = null;
                
                if(gubun != "refresh")
                {
                    //항목체크 카운트 초기화
                    #{hidGKCnt}.setValue("0");
                    #{hidWNCnt}.setValue("0");
                    #{hidVSCnt}.setValue("0");

                    BinClearItemClear();
                    setCodeClearAll();
                }

                #{hidDisplayCheck}.setValue(id);

                for (var i = 0; i < count; i++) {
                    
                    data = unitStore.getAt(i).data;
                    recordKey = data.UNITCODE;

                    if (id == "chkALL")
                    {
                        record = unitStore.findRecord("UNITCODE", recordKey)
                        if (record) {
                            record.data.GROUPCHECK = id;
                        }
                    }
                    else if (id == "chkTYGT")
                    {
                        if (data.BCCORPGUBN == "T")
                        {
                            record = unitStore.findRecord("UNITCODE", recordKey)
                            if (record) {
                                record.data.GROUPCHECK = id;
                            }
                        }
                    }
                    else if (id == "chkPTS")
                    {
                        if (data.BCCORPGUBN == "P")
                        {
                            record = unitStore.findRecord("UNITCODE", recordKey)
                            if (record) {
                                record.data.GROUPCHECK = id;
                            }
                        }
                    }
                    else if (id == "chkGP1")
                    {
                        if (data.UNITCODE.substring(0, 1) == "1")
                        {
                            record = unitStore.findRecord("UNITCODE", recordKey)
                            if (record) {
                                record.data.GROUPCHECK = id;
                            }
                        }
                    }
                    else if (id == "chkGP2")
                    {
                        if (data.UNITCODE.substring(0, 1) == "2")
                        {
                            record = unitStore.findRecord("UNITCODE", recordKey)
                            if (record) {
                                record.data.GROUPCHECK = id;
                            }
                        }
                    }
                    else if (id == "chkGP3")
                    {
                        if (data.UNITCODE.substring(0, 1) == "3")
                        {
                            record = unitStore.findRecord("UNITCODE", recordKey)
                            if (record) {
                                record.data.GROUPCHECK = id;
                            }
                        }
                    }
                    else if (id == "chkCH")
                    {
                        if (data.SCHGN == "Y")
                        {
                            record = unitStore.findRecord("UNITCODE", recordKey)
                            if (record) {
                                record.data.GROUPCHECK = id;
                            }
                        }
                    }
                }

                Ext.net.DirectMethod.request('UpdateItemCodeList', { 
                    url: location.href,
                    params: {sGroupCheck : #{hidDisplayCheck}.getValue() },
                    eventMask: {
                        showMask: false,
                        msg: "",
                        target: "customtarget"
                        }
                      }
                   );

                setGroupBinDisplay();
           }

           function BSrdo_change(id)
           {
                var sSysDate = Current_Date().split("-")[0]+Current_Date().split("-")[1]+Current_Date().split("-")[2];

                #{BSRdoCheck}.setValue("");

                if(id == "rdoBS1")
                {
                    #{BSRdoCheck}.setValue("1");
                }
                else if(id == "rdoBS2")
                {
                    #{BSRdoCheck}.setValue("2");
                }
                else if(id == "rdoBS3")
                {
                    #{BSRdoCheck}.setValue("3");
                }

                Ext.net.DirectMethod.request('UP_GetBoardSpaceData', { 
                        url: location.href,
                        params: {sBoardDate: sSysDate ,
                                 sGROUP : #{BSRdoCheck}.getValue()},
                        eventMask: {
                            showMask: true,
                            msg: "BIN SPACE 조회중...",
                            target: "customtarget"
                            }
                        }
                ); 
           }

           function UP_Refresh()
           {
                Ext.net.DirectMethod.request('UpdateMonitoringData', { 
                    url: location.href,
                    params: {sGroupCheck : #{hidDisplayCheck}.getValue() },
                    eventMask: {
                        showMask: true,
                        msg: "자료를 갱신중입니다...",
                        customtarget: #{vptMain}
                        }
                      }
                   );
           }

        </script>
  </ext:XScript>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="bodyContents" runat="server">
  
   <ext:Hidden ID="hidAuthGubn" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidAuthSABUN" runat="server"></ext:Hidden>

   <ext:Hidden ID="hidMaxHangCha" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidMinHangCha" runat="server"></ext:Hidden>

   <ext:Hidden ID="hidLoadMaxHangCha" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidLoadMinHangCha" runat="server"></ext:Hidden>

   <ext:Hidden ID="hidDisplayCheck" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidGKCheck" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidWNCheck" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidVSCheck" runat="server"></ext:Hidden>

   <ext:Hidden ID="hidGKCnt" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidWNCnt" runat="server"></ext:Hidden>
   <ext:Hidden ID="hidVSCnt" runat="server"></ext:Hidden>

   <ext:Hidden ID="BSRdoCheck" runat="server"></ext:Hidden>

   <input id = "check" type="hidden"  name="check" value="" />

       <ext:ChartTheme 
            ID="FancyTheme" 
            runat="server"
            ThemeName="Fancy" 
            Colors="url(#v-1),url(#v-2),url(#v-3),url(#v-4)">
            <Axis Stroke="#000"/>
            <AxisLabelLeft Fill="#000" />
            <AxisLabelBottom Fill="#000" />
            <AxisTitleLeft Fill="#000" />
            <AxisTitleBottom Fill="#000" />
        </ext:ChartTheme>
   
    <ext:TaskManager ID="TaskManager1" runat="server">
        <Tasks>
            <ext:Task 
                TaskID="servertime"
                Interval="60000">
                <DirectEvents>
                    <Update OnEvent="UpdateMonitoringData">
                        <EventMask ShowMask="true" Msg="자료를 갱신중입니다..." Target="CustomTarget" CustomTarget="#{vptMain}"></EventMask>
                    </Update>                    
                </DirectEvents>                                    
            </ext:Task>            
        </Tasks>
        
    </ext:TaskManager>

    <ext:TaskManager ID="TaskManager2" runat="server">
        <Tasks>
            <ext:Task 
                TaskID="servertime"
                Interval="60000">
                <Listeners>
                    <Update Handler = "UpdateBoardData()"></Update>
                </Listeners>
            </ext:Task>
        </Tasks>
    </ext:TaskManager>

   <!--설비코드 Store -->
   <ext:Store ID="stoPlantUnits" runat="server">
        <Model>
            <ext:Model ID="Model2" runat="server">
                <Fields>
                    <ext:ModelField Name="C2SAUP"       Mapping="C2SAUP"    Type="String"></ext:ModelField>
                    <%--<ext:ModelField Name="UNITCODE"     Mapping="C2KEYCODE" Type="String"></ext:ModelField>--%>
                    <ext:ModelField Name="UNITCODE"     Mapping="C2NAME" Type="String"></ext:ModelField>
                    <ext:ModelField Name="UNITDESC"     Mapping="C2NAME"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="UNITWINDOW"   Mapping="C2SCGUBN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="UNITPOINTX"   Mapping="C2XPOINT"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="UNITPOINTY"   Mapping="C2YPOINT"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="UNITPOINTLX"   Mapping="C2LXPOINT"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="UNITPOINTLY"   Mapping="C2LYPOINT"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="UNITTYPE"     Mapping="C2DSGUBN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="UNITSTATUS"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONGCHECK"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONGNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGKCOLOR"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SWONSANCHECK"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SWONSAN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SWONSANNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SHANGCHACHECK"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SHANGCHA"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SHANGCHANM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SCLDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="BINCLEDAY"  Type="Int"></ext:ModelField>
                    <ext:ModelField Name="SIPDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SCHULQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="SJEGOQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="SEMPQTY"    Type="Float"></ext:ModelField>
                    <ext:ModelField Name="STEMPA"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPB"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPC"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPD"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPE"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPF"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPG"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPH"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="STEMPI"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="SCAPA"     Type="String"></ext:ModelField>
                    <ext:ModelField Name="BTCHULIL"     Type="String"></ext:ModelField>
                    <ext:ModelField Name="BTTKNO"     Type="String"></ext:ModelField>
                    <ext:ModelField Name="SJEGOQTYRATE"    Type="String"></ext:ModelField>                    
                    <ext:ModelField Name="SCHULQTYTOTAL"    Type="Float"></ext:ModelField>
                    <ext:ModelField Name="SEMPQTYTOTAL"    Type="Float"></ext:ModelField>
                    <ext:ModelField Name="SJEGOQTYTOTAL"    Type="Float"></ext:ModelField>
                    <ext:ModelField Name="BINSTATUSCODE"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="BINSTATUSNAME"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="LOADGUBN"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="BCCORPGUBN"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="GROUPCHECK"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="BCGATE1"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="BCGATE2"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="SHWGCODE"    Type="String"></ext:ModelField>
                    <ext:ModelField Name="SCHGN"    Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>
        <Listeners>            
            <DataChanged Handler="drowUnits(#{stoPlantUnits});drowUnitsremark(#{stoPlantUnits});"></DataChanged>
        </Listeners>
    </ext:Store>

    <!--상세내용 BIN 번호 Store -->
   <ext:Store ID="stoBinNo" runat="server">
        <Model>
            <ext:Model ID="Model1" runat="server">
                <Fields>                    
                    <ext:ModelField Name="BCBINNO"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>

    <!--곡종 Store -->
    <ext:Store ID="stoGokJong" runat="server">
        <Model>
            <ext:Model ID="Model3" runat="server">
                <Fields>                    
                    <ext:ModelField Name="GOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="GOKJONGNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHECK"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>
        <Listeners>
            <DataChanged Handler="setGokJongList(#{stoGokJong});"></DataChanged>
        </Listeners>
    </ext:Store>

     <!--원산지 Store -->
    <ext:Store ID="stoWonSan" runat="server">
        <Model>
            <ext:Model ID="Model4" runat="server">
                <Fields>                    
                    <ext:ModelField Name="IHWONSAN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="IHWONSANNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHECK"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>
        <Listeners>
            <DataChanged Handler="setWonSanList(#{stoWonSan});"></DataChanged>
        </Listeners>
    </ext:Store>

     <!--항차 Store -->
    <ext:Store ID="stoHANGCHA" runat="server">
        <Model>
            <ext:Model ID="Model5" runat="server">
                <Fields>                    
                    <ext:ModelField Name="CORPGUBN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="IHHANGCHA"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="IHHANGCHANM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHECK"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="IHCODE"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>
        <Listeners>
            <DataChanged Handler="setHANGCHAList(#{stoHANGCHA});"></DataChanged>
        </Listeners>
    </ext:Store>

    <!--내용선택 Store -->
    <ext:Store ID="stoITEMSEL" runat="server">
        <Model>
            <ext:Model ID="Model6" runat="server">
                <Fields>                    
                    <ext:ModelField Name="ITEM"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>
        <Listeners>
            <DataChanged Handler="ItemSelCodeInz();"></DataChanged>
        </Listeners>
    </ext:Store>

    <!--BIN이고 Store -->
    <ext:Store ID="stoBinMove" runat="server">
        <Model>
            <ext:Model ID="Model10" runat="server">
                <Fields>                    
                    <ext:ModelField Name="MDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMVBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONG1"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONG1NM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MIPBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMSDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMEDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="METIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MHSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMOVEQTY"  Type="Float"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
         <Listeners>
            <DataChanged Handler="setBinMoveList(#{stoBinMove});"></DataChanged>
        </Listeners>
   </ext:Store>

   <!--카길이송 Store -->
    <ext:Store ID="stoBinCargill" runat="server">
        <Model>
            <ext:Model ID="Model19" runat="server">
                <Fields>                    
                    <ext:ModelField Name="TDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TGOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TGOKJONGNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TSDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TEDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TETIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="THSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TTRANSQTY"  Type="Float"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
         <Listeners>
            <DataChanged Handler="setBinCargillList(#{stoBinCargill});"></DataChanged>
        </Listeners>
   </ext:Store>

    <!--하역작업일지 Store -->
    <ext:Store ID="stoBinSHipDoc" runat="server">
        <Model>
            <ext:Model ID="Model11" runat="server">
                <Fields>                    
                    <ext:ModelField Name="DCORPGUBN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DHANGCHA"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DHANGCHANM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DGOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DLOADCODE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DLOADCODENM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DWKDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSBINSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DWORKTEXT"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSUNCHANG"  Type="String"></ext:ModelField>                    
                    <ext:ModelField Name="DLSDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DLSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DLEDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DLETIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="WORKTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSHSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSHETIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DLOADQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="DSUMQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="DBLQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="BTNSTATUS"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="BTNCNT"  Type="Int"></ext:ModelField>

                    <ext:ModelField Name="DSJANQTY"  Type="Float"></ext:ModelField>
                    
                </Fields>
            </ext:Model>
        </Model>      
         <Listeners>
            <DataChanged Handler="setBinSHipDocList(#{stoBinSHipDoc});"></DataChanged>
        </Listeners>
   </ext:Store>

   <!--하역작업일지사용 곡종코드 Store -->
   <ext:Store ID="stoBinSHipDocGK" runat="server">
        <Model>
            <ext:Model ID="Model16" runat="server">
                <Fields>                    
                    <ext:ModelField Name="DGOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DGOKJONGNM"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
         <Listeners>
            <DataChanged Handler="setBinSHipDocGKList(#{stoBinSHipDocGK});"></DataChanged>
        </Listeners>
   </ext:Store>

     <!--bin 클리닝 Store -->
    <ext:Store ID="stoBinClean" runat="server">
        <Model>
            <ext:Model ID="Model9" runat="server">
                <Fields>                    
                    <ext:ModelField Name="CLSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLBIGO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLSSUTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLESUTIME"  Type="String"></ext:ModelField>
                    
                </Fields>
            </ext:Model>
        </Model>      
         <Listeners>
            <DataChanged Handler="setBinCleanList(#{stoBinClean});"></DataChanged>
        </Listeners>
   </ext:Store>

    <!--입항하역계획 Store -->
    <ext:Store ID="stoShipLoad" runat="server">
        <Model>
            <ext:Model ID="Model8" runat="server">
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
                </Fields>
            </ext:Model>
        </Model>      
         <Listeners>
            <DataChanged Handler="setShipLoadList(#{stoShipLoad});"></DataChanged>
        </Listeners>
   </ext:Store>

   <!--특기사항 Store -->
    <ext:Store ID="stoBoardSpc" runat="server">
        <Model>
            <ext:Model ID="Model7" runat="server">
                <Fields>                    
                    <ext:ModelField Name="ROWNUM"  Type="String"></ext:ModelField>  
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
        <Listeners>
            <DataChanged Handler="setBoardSpcList(#{stoBoardSpc});"></DataChanged>
        </Listeners>
    </ext:Store>

     <!--BIN이고 상세정보 Store -->
    <ext:Store ID="stoBinStatusMoveInfos" runat="server">
        <Model>
            <ext:Model ID="Model12" runat="server">
                <Fields>                    
                    <ext:ModelField Name="MDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMVBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONG1"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONG1NM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MIPBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONG2"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SGOKJONG2NM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMSDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMEDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="METIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="MMOVEQTY"  Type="Float"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
    </ext:Store>

    <!--카길이송 상세정보 Store -->
    <ext:Store ID="stoBinStatusCargillInfos" runat="server">
        <Model>
            <ext:Model ID="Model20" runat="server">
                <Fields>                    
                    <ext:ModelField Name="TDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TGOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TGOKJONGNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TSDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TEDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TETIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="TTRANSQTY"  Type="Float"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
    </ext:Store>

    <!--BIN 클리닝 상세정보 Store -->
    <ext:Store ID="stoBinStatusCleanInfos" runat="server">
        <Model>
            <ext:Model ID="Model13" runat="server">
                <Fields>                    
                    <ext:ModelField Name="CLBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLBIGO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLSSUTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CLESUTIME"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>

   <!--BIN 하역작업일지 상세정보 Store -->
   <ext:Store ID="stoBinStatusDOCLOADInfos" runat="server">
        <Model>
            <ext:Model ID="Model14" runat="server">
                <Fields>                    
                    <ext:ModelField Name="DSHANGCHA"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSHANGCHANM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSGOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSGOKJONGNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLOADLINE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLOADCODE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLOADCODENM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSWKDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSSEQ"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DWORKTEXT"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSUNCHANG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLSDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLEDATE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLETIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSSHSTIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSSHETIME"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="DSLOADQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="DSSUMQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="DBLQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="DLOADQTYALINE"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="DLOADQTYBLINE"  Type="Float"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>
  
    <!--BIN 출고 상세정보 Store -->
   <ext:Store ID="stoBinStatusCHULInfos" runat="server">
        <Model>
            <ext:Model ID="Model15" runat="server">
                <Fields>                    
                    <ext:ModelField Name="CHCHULDAT"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHBINNO"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHHWAJU"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHHWAJUNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHHANGCHA"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHHANGCHANM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHGOKJONG"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHGOKJONGNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHWONSAN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CHWONSANNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="BEJNQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="HWAKQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="JBYSQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="JBYDQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="JBCSQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="JBCHQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="JBCSJANQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="JBJEGOQTY"  Type="Float"></ext:ModelField>
                    <ext:ModelField Name="CHNUMBER"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>    

   <!--BIN SPACE 상세정보 Store -->
   <ext:Store ID="stoBinSpaceInfos" runat="server">
        <Model>
            <ext:Model ID="Model18" runat="server">
                <Fields>                    
                    <ext:ModelField Name="SBINNO"  Type="String"></ext:ModelField>  
                    <ext:ModelField Name="CCAPA"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>
    </ext:Store>
   <ext:Store ID="stoBinGKSpaceInfos" runat="server">
        <Model>
            <ext:Model ID="Model17" runat="server">
                <Fields>                    
                    <ext:ModelField Name="SGOKJONG"  Type="String"></ext:ModelField>  
                    <ext:ModelField Name="SGOKJONGNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SWONSAN"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="SWONSANNM"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CAPA"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>
        <Listeners>
            <DataChanged Handler="setBoardBinSpaceList(#{stoBinSpaceInfos}, #{stoBinGKSpaceInfos});"></DataChanged>
        </Listeners>
    </ext:Store>


   <ext:Viewport ID="vptMain" runat="server" Layout="BorderLayout">
        <Items>
            <ext:Panel ID="pnlMain" runat="server" Border="true" Region = "Center"   >
            <Listeners>
               <Resize Handler="MonitorBodyResize('Main');"></Resize>                              
            </Listeners>
         <%--
            <TopBar>
                    <ext:Toolbar ID="Toolbar1" runat="server" Flat="true">
                        <Items>
                            <ext:Button ID="Button1" runat="server" Text="갱신" >
                                <Listeners>
                                   <Click Handler ="AreaDataReturn()"></Click>
                                </Listeners>
                            </ext:Button>
                        </Items>
                    </ext:Toolbar>
                </TopBar>--%>

             <Content>

                   <div id="MonitorMain" style="height:2160px; width:5760px; position:relative; /*border:2px dotted #666666;*/ ">

                        <!--A 그룹-->
                        <div id="wrapper">
                           <!--타이틀시작-->
                           <ul id="title">
                              <li class="logo"><img src="../Resources/Images/Monitoring/SILOBIN/logo.png" alt="" /></li>
                              
                           </ul>
                           <!--//타이틀끝-->    
                           <!--컨텐츠시작-->
                              <div id="container" class="top_bx">
      	                        <!--타이틀시작-->
                                    <div class="bin_title">
                                        A GROUP
                                    </div>
                                <!--//타이틀끝-->
      	                        <!--bin박스시작-->
                                 <div class="bin_bx">
                                    
                                    <!--bin시작 1A 그룹-->
                                    <div id = "GroupMain1A" class="bin">                                   
                                    </div>
                                    <!--//bin시작-->
                                 </div>
                                 <!--//bin박스끝-->

                                 <!--bin박스시작-->
                                 <div class="bin_bx">
                                    <div id = "GroupMain2A" class="bin">                                   
                                    </div>
                                 </div>
                                 <!--//bin박스끝-->
      	
      	                        <!--bin박스시작-->
                                 <div class="bin_bx">
                                    <div id = "GroupMain3A" class="bin">                                   
                                    </div>
                                 </div>
                                 <!--//bin박스끝-->
         
                              </div>
                              <!--//컨텐츠끝-->
                        </div>

                        <!--B 그룹-->

                        <div id="wrapper">  
                                  <!--타이틀시작-->
                                  <ul id="title">
                                     <li class="title title_center">&nbsp;SILO BIN 장치현황</li> 
                                  </ul>
                                  <!--//타이틀끝-->
                                  <!--컨텐츠시작-->
                                  <div id="container" class="top_bx">
      	                            <!--타이틀시작-->
                                        <div class="bin_title">
                                           B GROUP
                                        </div>
                                    <!--//타이틀끝-->
      	                            <!--bin박스시작-->
                                     <div class="bin_bx">
                                        
                                        <!--bin시작-->
                                        <div id = "GroupMain1B" class="bin">
                                           
                                        </div>
                                        <!--//bin시작-->
                                        
                                     </div>
                                     <!--//bin박스끝-->
      	
      	                            
                                     <!--bin박스시작-->
                                 <div class="bin_bx">
                                    <div id = "GroupMain2B" class="bin">                                   
                                    </div>
                                 </div>
                                 <!--//bin박스끝-->
      	
      	                        <!--bin박스시작-->
                                 <div class="bin_bx">
                                    <div id = "GroupMain3B" class="bin">                                   
                                    </div>
                                 </div>
                                 <!--//bin박스끝-->
         
      	                            
         
                                  </div>
                                  <!--//컨텐츠끝-->
                         </div>

                        <!--특기사항-->
                        <div id="wrapper">      
                            <!--타이틀시작-->
                                  <ul id="title">
                                    <li id = "dpTime" class="master"></li>     
                                     <li class="title title_right"></li> 
                                     <li id = "Li1" class="master"></li>     
                                  </ul>
                                  <!--//타이틀끝-->
                          <!--컨텐츠시작-->
                              <div id="container" class="btm_bx_01">
      	
                                  <!--박스_01시작-->
                                   <div id="bx_01">
	                                 <!--타이틀시작-->
                                    <div class="bin_title">
                                       평창고/야적장
                                    </div>
                                    <!--//타이틀끝-->
                                    <div id="GroupMain0">
                                    </div>
	                              </div>
	                              <!--//박스_01끝-->	      
	      
	                              <!--박스_02시작-->
                                   <div id="bx_02">
	                                 <!--타이틀시작-->
                                    <div class="bin_title">
                                       내용선택&nbsp;
                                       <a><img  onclick ="ItemSelClear()" style="width:60px; height:45px" src="../Resources/Images/Monitoring/SILOBIN/btn_clr2.gif" class="btn_right" alt="" /></a>
                                    </div>
                                    <!--//타이틀끝-->
	         
	                                 <!--테이블시작-->
	                                 <ul id="list_bx">
                                        <li><a  id="WG_List" class="on" onclick ="ItemSelCode(id)" >원산지/곡종</a></li>
                                        <li><a  id="JG_List" class="on" onclick ="ItemSelCode(id)" >재&nbsp;&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;량</a></li>
                                        <li><a  id="HA_List" onclick ="ItemSelCode(id)" >모&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;선</a></li>
                                        <li><a  id="BN_List" onclick ="ItemSelCode(id)" >BIN&nbsp;출&nbsp;입&nbsp;일</a></li>
	                                    <li><a  id="IP_List" onclick ="ItemSelCode(id)" >입&nbsp;&nbsp;고&nbsp;일&nbsp;&nbsp;자</a></li>
                                        <li><a  id="CH_List" onclick ="ItemSelCode(id)" >출&nbsp;&nbsp;&nbsp;&nbsp;고&nbsp;&nbsp;&nbsp;&nbsp;량</a></li>
                                            <li><a  id="GK_List" onclick ="ItemSelCode(id)" >곡&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;종</a></li>
	                                    <li><a  id="WS_List" onclick ="ItemSelCode(id)" >원&nbsp;&nbsp;&nbsp;&nbsp;산&nbsp;&nbsp;&nbsp;&nbsp;지</a></li>
	                                    <li></li>
	                                    <li></li>
	                                    <li></li>
	                                    <li></li>
	                                    <li></li>
                                        <li></li>
	                                 </ul>
	                                 <!--//테이블끝-->
	                              </div>
	                              <!--//박스_02끝-->     
	      
	                               <!--박스_03시작-->
                                   <div id="bx_03">
	                                 <!--타이틀시작-->
                                    <div class="bin_title">
                                       표시선택
                                        <a><img id = "ImgManage2" onclick="UP_ManaGerFormOpen('COL')" src="../Resources/Images/Monitoring/SILOBIN/btn_manage_01.gif" class="btn_left" alt="" /></a>
                                       <a><img onclick="setClearAll()" src="../Resources/Images/Monitoring/SILOBIN/btn_clrall.gif" class="btn_right" alt="" /></a>
                                    </div>
                                    <!--//타이틀끝-->
                                    <div id="rdo_group">
                                        <div style="margin-top:10px"></div>
                                        <input type="radio" style="width:35px;height:35px; margin-left:27px;" id="chkALL" name="rdogroup" checked="checked" onclick="rdo_change(id, 'check')">
                                        <label for="chkALL" style="font-size:38px;color:White;" >전체</label>
                                        <input type="radio" style="width:35px;height:35px; margin-left:27px;" id="chkTYGT" name="rdogroup" onclick="rdo_change(id, 'check')">
                                        <label for="chkTYGT" style="font-size:38px;color:White;">TYGT</label>
                                        <input type="radio" style="width:35px;height:35px; margin-left:27px;" id="chkPTS" name="rdogroup" onclick="rdo_change(id, 'check')">
                                        <label for="chkPTS" style="font-size:38px;color:White;">PTS</label>
                                        <input type="radio" style="width:35px;height:35px; margin-left:27px;" id="chkGP1" name="rdogroup" onclick="rdo_change(id, 'check')">
                                        <label for="chkGP1" style="font-size:38px;color:White;">1G</label>
                                        <input type="radio" style="width:35px;height:35px; margin-left:27px;" id="chkGP2" name="rdogroup" onclick="rdo_change(id, 'check')">
                                        <label for="chkGP2" style="font-size:38px;color:White;">2G</label>
                                        <input type="radio" style="width:35px;height:35px; margin-left:27px;" id="chkGP3" name="rdogroup" onclick="rdo_change(id, 'check')">
                                        <label for="chkGP3" style="font-size:38px;color:White;">3G</label>
                                        <input type="radio" style="width:35px;height:35px; margin-left:27px;" id="chkCH" name="rdogroup" onclick="rdo_change(id, 'check')">
                                        <label for="chkCH" style="font-size:38px;color:White;">출고</label>
                                    </div>
	         
	                                <!--테이블시작-->
			   
                                      <div id = "GokJong">			                                
                                      </div>
                                      <div id = "WonSan">			                               
                                      </div>
			   
                                       <div id = "HANGCHA">			                                 
			                           </div>                                      
                                        
			                           <table id="binClearbox" class="table_01" style="height:250px; width: 100%;">
				                        <colgroup>
				                        <col style="width: 20%;" />
				                        <col style="width: 20%;" />
				                        <col style="width: 20%;" />
				                        <col style="width: 20%;" />
				                        <col style="width: 20%;" />
				                        </colgroup>
				                        <tr>
					                        <th>BIN출입</th>
					                        <td class="text_center"><a  id="BIN03_List" onclick ="BinClearDay(id)" >3개월</a></td>
					                        <td class="text_center"><a  id="BIN06_List" onclick ="BinClearDay(id)" >6개월</a></td>
					                        <td class="text_center"><a  id="BIN09_List" onclick ="BinClearDay(id)" >9개월</a></td>
					                        <td class="text_center"><a  id="BIN12_List" onclick ="BinClearDay(id)" >12개월</a></td>
				                        </tr>
				                        <tr>
					                        <th colspan="2">BIN 출고량</th>
					                        <td style="text-align:right; font-size:40px; color:Blue; " colspan="3">0 M/T</td>
				                        </tr>
                                        <tr>
					                        <th colspan="2">BIN 빈공간</th>
					                        <td style="text-align:right; font-size:40px; color:Blue; " colspan="3">0 M/T</td>
				                        </tr>
				                        <tr>
					                        <th colspan="2">BIN 재고량</th>
					                        <td style="text-align:right; font-size:40px;color:red;" colspan="3">0 M/T</td>
				                        </tr>
			                           </table>
	                                 <!--//테이블끝-->
	                              </div>
	                               <!--//박스_03끝-->
         
                              </div>
                              <!--//컨텐츠끝-->   
                          <!--컨텐츠시작-->
                          <div id="container" class="btm_bx">
      	
                             <!--탭시작-->	
                             <div id="tab_bx">
	                             <ul id="tab">
	                                <li><a id = "SP_Board" onclick = "TabBoard(id)" class="on">특기사항</a></li>
	                                <li><a id = "SH_Board" onclick = "TabBoard(id)" >입항/하역계획</a></li>
                                    <li><a id = "DC_Board" onclick = "TabBoard(id)" >하역작업일지</a></li>
                                    <li><a id = "MV_Board" onclick = "TabBoard(id)" >BIN 이고</a></li>
                                    <li><a id = "CG_Board" onclick = "TabBoard(id)" >카길이송일지</a></li>
	                                <li><a id = "BN_Board" onclick = "TabBoard(id)" >BIN CLEANING</a></li>                                    
                                    <li><a id = "BS_Board" onclick = "TabBoard(id)" >BIN SPACE</a></li>
	                             </ul>
                                 <a><img id = "ImgRefresh" onclick="UP_Refresh()"   src="../Resources/Images/Monitoring/SILOBIN/btn_refresh.gif" class="tab_btn_re" alt="" /></a>
	                             <a><img id = "ImgManage" onclick="UP_ManaGerFormOpen('BOR')"   src="../Resources/Images/Monitoring/SILOBIN/btn_manage_01.gif" class="tab_btn" alt="" /></a>
	                          </div>
                             <!--//탭끝-->      
                             <div id="BoardTopTitleBase" style="display:block">
                                 <div class="info info_01">
         	                            <ul class="info_bx">
                                            <li>
                                                <ext:ImageButton ID="ImageButton1" runat="server" ImageUrl="../Resources/Images/Monitoring/SILOBIN/btn_pre.gif">
                                                <Listeners>
                                                    <Click Handler= "GetBoardMoveDate('Prev');">                                                           
                                                    </Click>
                                                </Listeners>
                                                </ext:ImageButton>
                                            </li>
                                            <li><a href="javascript:BoardDateCurrent_Date('BoardDate');"><span style="font-size:33px;" id="BoardDate"></span></a></li>
                                            <li>
                                                <ext:ImageButton ID="ImageButton2" runat="server" ImageUrl="../Resources/Images/Monitoring/SILOBIN/btn_next.gif">
                                                <Listeners>
                                                    <Click Handler= "GetBoardMoveDate('Next');">                                                           
                                                    </Click>
                                                </Listeners>
                                                </ext:ImageButton>
                                            </li>
                                        </ul>
                                 </div> 
                             </div>

                             <div id="ShipScheduleBase" style="display:none">
                                 <div class="info info_01">
         	                            <ul class="info_bx">
                                            <li>
                                                <ext:ImageButton ID="ImageButton3" runat="server" ImageUrl="../Resources/Images/Monitoring/SILOBIN/btn_pre.gif">
                                                <Listeners>
                                                    <Click Handler= "GetScheduleMoveDate('Prev');">                                                           
                                                    </Click>
                                                </Listeners>
                                                </ext:ImageButton>
                                            </li>
                                            <li><a href="javascript:BoardDateCurrent_Date('BoardDateMonth');"><span style="font-size:33px;" id="BoardDateMonth"></span></a></li>
                                            <li>
                                                <ext:ImageButton ID="ImageButton4" runat="server" ImageUrl="../Resources/Images/Monitoring/SILOBIN/btn_next.gif">
                                                <Listeners>
                                                    <Click Handler= "GetScheduleMoveDate('Next');">                                                           
                                                    </Click>
                                                </Listeners>
                                                </ext:ImageButton>
                                            </li>
                                        </ul>
                                 </div> 
                             </div>

                             <%-- 하역작업일지 tab 전용 top --%>
                             <div id="BoardTopTitleShipDoc" style="display:none;">
                                   <table class="table_01" style="color: #1E2D4B;background: #D2DAEC; width: 100%;">
			                        <tr>
                                        <td class="std" style="width:100px" >회사</td>
                                        <td class="std"  style="width:150px;" align="center" valign="middle" >
                                           <select id="SelectShipDocCORP" class="ShipDocselectCORP" onchange="BinSHipDocGORP_SelectCombo(this.value)" >   
                                                <option value="T">TYGT</option>
                                                <option value="P">PTS</option>	                                                 
                                           </select>
                                        </td>
				                        <td class="std" style="width:100px" >항차</td>
					                    <td style="width:300px" align="center" valign="middle">
					                         <ul style="width: 250px; margin:0 auto;">
                                                <li class="leftmarginR" ><ext:ImageButton ID="ImageButton5" runat="server" ImageUrl="../Resources/Images/Monitoring/SILOBIN/btn_pre.gif">
                                                    <Listeners>
                                                        <Click Handler= "GetHangChaMove('Prev','1');">                                                           
                                                        </Click>
                                                    </Listeners>
                                                </ext:ImageButton>
                                                </li>
                                                <li class="left"><a href="javascript:DocHangChaCurrent_Hang('DocHangCha');"><span class="std" id="DocHangCha">2015015</span></a></li>
                                                <li class="leftmarginL" ><ext:ImageButton ID="ImageButton6" runat="server" ImageUrl="../Resources/Images/Monitoring/SILOBIN/btn_next.gif">
                                                    <Listeners>
                                                        <Click Handler= "GetHangChaMove('Next','1');">                                                           
                                                        </Click>
                                                    </Listeners>
                                                    </ext:ImageButton>
                                                </li>
                                             </ul>                                            
					                    </td>
					                    <td class="std" style="width:200px">모선명</td>
				                        <td class="text_center"><span class="std" id="spSHHANGCHANM"></span></td>
					                    <td class="std" style="width:200px">B/L량</td>
					                    <td class="text_right"><span class="std" id="spSHBLQTY"></span></td>
				                    </tr>
			                        <tr>
                                        
                                        <td class="std" style="width:100px"  >곡 종</td>
                                        <td class="std"  style="width:650px;" align="center" valign="middle" colspan="3">
                                           <select id="SelectShipDoc" class="ShipDocselect" onchange="BinSHipDocGK_SelectCombo(this.value)" >                                                    
                                           </select>
                                        </td>
					                    <td class="std" style="width:200px">하역량</td>
				                        <td class="text_right"><span class="std" id="spSHLOADQTY"></span></td>
					                    <td class="std" style="width:200px">하역잔량</td>
					                    <td class="text_right"><span class="std" id="spSHLOADJANQTY"></span></td>
				                    </tr>
			                    </table>
                             </div>

                             <%-- BIN SPACE tab 전용 top --%>
                             <div id="BoardTopTitleBinSpace" style="display:none">
                                 <table class="table_01" style="color: #1E2D4B;background: #D2DAEC; width: 100%;">
			                        <tr>
                                        <td class="std" style="width:200px" >구  분</td>
                                        <td class="left" style="flex:1">
                                            <input type="radio" style="width:35px;height:35px; margin-left:30px;" id="rdoBSAll" name="BSgroup" checked="checked" onclick="BSrdo_change(id)">
                                            <label for="rdoBSAll" style="font-size:38px;color:Black;" >전체</label>
                                            <input type="radio" style="width:35px;height:35px; margin-left:30px;" id="rdoBS1" name="BSgroup" onclick="BSrdo_change(id)">
                                            <label for="rdoBS1" style="font-size:38px;color:Black;">1그룹</label>
                                            <input type="radio" style="width:35px;height:35px; margin-left:30px;" id="rdoBS2" name="BSgroup" onclick="BSrdo_change(id)">
                                            <label for="rdoBS2" style="font-size:38px;color:Black;">2그룹</label>
                                            <input type="radio" style="width:35px;height:35px; margin-left:30px;" id="rdoBS3" name="BSgroup" onclick="BSrdo_change(id)">
                                            <label for="rdoBS3" style="font-size:38px;color:Black;">3그룹</label>
                                        </td>
                                    </tr>
			                    </table>
                             </div>
                             <%--그리드 표현 --%>
                             <div id="tab_SP_Board"></div>
                                      
                          </div>
                          <!--//컨텐츠끝-->                          

                        </div>      
                        
                        
                        

                        

                        <!-- 빈 작업상태 상세화면 -->
                        <div id="winBinStatusInfos" class="MonitorSubWin" style="position:absolute; top:100px; left:10px; width:1305px; height:1060px;  z-index:9999; display:none;">
                              <div id="wrapperBinStatus">           
                                      <!--팝업시작-->
                                      <div id="popup_bx">
      	                                <!--타이틀시작-->
                                         <div class="detail_title">BIN 작업현황 상세
                                           <a href="javascript:CloseSubWin('winBinStatusInfos');" ><img style="width:35px; height:35px;position: relative; top: -10%; " src="../Resources/Images/Monitoring/SILOBIN/btn_close.png"  /></a>                                                 
                                         </div>
                                         <!--//타이틀끝-->      	
      	                                <!--테이블시작-->  
                                         <div id="BinStatus_bodyContent">
                                         </div>
                                         <!--//테이블끝-->                 	
                                      </div>
                                      <!--//팝업끝-->               
                              </div>	
                        </div> <!-- 빈 작업상태 상세화면 -->
		
                        <!--빈 상세정보 화면-->
                        <div id="winUnitInfos" class="MonitorSubWin" style="position:absolute; top:100px; left:0px; width:1305px; height:1060px;  z-index:9999; display:none; ">
                                <div id="wrapperdetail">      	
                                      <div id="detail_bx">
                                           <!--타이틀시작-->
                                            <div class="detail_title">
                                                 BIN 상세정보
                                                 <a href="javascript:CloseSubWin('winUnitInfos');" ><img style="width:35px; height:35px;position: relative; top: -10%; " src="../Resources/Images/Monitoring/SILOBIN/btn_close.png"  /></a>                                                 
                                            </div>
                                            <!--//타이틀끝-->                                 

                                            <div id="sel">
      	                                        <select id="SelBinNum" onchange="BinSelectCombo(this.value)" >
                                                    
                                                </select>
                                                <span id="spnBinChartStatus" style ="padding-top:15px;" class="color_BST" ></span>
      	                                    </div>      

                                            <div id="temperatureitem"></div>

                                            <div id="temperature_graph"> 
                                              <table class="table_03 text_center" style="width: 100%;">
                                                <colgroup>
				                                <col style="width: 100%;" />
				                                </colgroup>
				                                <tr>
					                                <th>재고량</th>
				                                </tr>
                                                <tr><td>
                                                 <ext:Panel ID="pnlBinChart" runat="server" Width="270" Height="600" border="true" bodystyle="border-color:black;" >
                                                    <Items>
                                                        <ext:Chart ID="BinChart" runat="server" Animate="true" Width="270" Height="600" Theme="Fancy">
                                                            <Store>
                                                                <ext:Store ID="stoBinChart" runat="server">
                                                                    <Model>
                                                                        <ext:Model ID="T01_Model" runat="server">
                                                                            <Fields>
                                                                                <ext:ModelField Name="SBINNO" Type="String"></ext:ModelField>
                                                                                <ext:ModelField Name="SCAPA" Type="Float"></ext:ModelField>
                                                                                <ext:ModelField Name="BLANK" Type="String"></ext:ModelField>
                                                                                <ext:ModelField Name="SRATE" Type="String"></ext:ModelField>
                                                                                <ext:ModelField Name="SRATEL" Type="Float"></ext:ModelField>
                                                                                <ext:ModelField Name="SRATEM" Type="Float"></ext:ModelField>
                                                                            </Fields>
                                                                        </ext:Model>
                                                                    </Model>
                                                                </ext:Store>
                                                            </Store>
                                                            <Series>
                                                                <ext:BarSeries Column="true" XField="SBINNO" YField="SRATEL, SRATEM" Stacked="true">
                                                                   <Label Field="BLANK,SRATE" Display="InsideStart" contrast="true" font="14px Arial Black"></Label>
                                                                </ext:BarSeries>
                                                            </Series>     
                                                            <Gradients>
                                                                <ext:Gradient GradientID="v-1" Angle="0">
                                                                    <Stops>
                                                                        <ext:GradientStop Offset="0" Color="#1e81c0" />
                                                                        <ext:GradientStop Offset="100" Color="#2d95d6" />
                                                                    </Stops>
                                                                </ext:Gradient>
                                                                <ext:Gradient GradientID="v-2" Angle="0">
                                                                    <Stops>
                                                                        <ext:GradientStop Offset="0" Color="rgb(255, 255, 255)" />
                                                                        <ext:GradientStop Offset="100" Color="rgb(220, 220, 220)" />
                                                                    </Stops>
                                                                </ext:Gradient>
                                                                <ext:Gradient GradientID="v-3" Angle="0">
                                                                    <Stops>
                                                                        <ext:GradientStop Offset="0" Color="#FFCD12" />
                                                                        <ext:GradientStop Offset="100" Color="#FFDF24" />
                                                                    </Stops>
                                                                </ext:Gradient>
                                                                <ext:Gradient GradientID="v-4" Angle="0">
                                                                    <Stops>
                                                                        <ext:GradientStop Offset="0" Color="#DB0000" />
                                                                        <ext:GradientStop Offset="100" Color="#ED0000" />
                                                                    </Stops>
                                                                </ext:Gradient>
                                                            </Gradients>
                                                            <Axes>
                                                                <ext:NumericAxis Fields="SRATEL"  Minimum="0" Maximum="100" MajorTickSteps="5" Hidden="false" ></ext:NumericAxis>
                                                            </Axes>                                                                                                                   
                                                        </ext:Chart>
                                                    </Items>
                                                </ext:Panel>
                                                </td>
                                                </tr>
                                            </div>
            	                      </div>  
                                 </div>
                        </div>  <!-- <div id="winUnitInfos"..end -->

                        <!--빈 상세정보 화면-->
                        
                        
                   </div>  <%-- <div id="MonitorMain" style="height:2100px; width:3360px; position:relative; "> --%>
                
             </Content>  
              

            </ext:Panel>
        </Items>      
   </ext:Viewport>                        
</asp:Content>

