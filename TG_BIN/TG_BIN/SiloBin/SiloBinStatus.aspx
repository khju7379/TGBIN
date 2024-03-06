<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Resources/Master/Tab.Master" CodeBehind="SiloBinStatus.aspx.cs" Inherits="TG_BIN.SiloBin.SiloBinStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headScripts" runat="server">
    <style type="text/css">
                @font-face {
	                font-family: Daum_Regular;
	                font-style: normal;
                   font-weight: normal;
                   src: url('/Resources/Font/Daum_Regular.eot');
                   src: local('?'),
                        url('/Resources/Font/Daum_Regular.eot?#iefix') format('embedded-opentype'), 
                        url('/Resources/Font/Daum_Regular.ttf') format('truetype'),
                        url('/Resources/Font/Daum_Regular.otf') format('opentype'),
                        url('/Resources/Font/Daum_Regular.woff') format('woff'),
                        url('/Resources/Font/Daum_Regular.svg#DaumRegular') format('svg');
                }

                @font-face {
	                font-family: Daum_SemiBold;
	                font-style: normal;
                   font-weight: normal;
                   src: url('/Resources/Font/Daum_SemiBold.eot');
                   src: local('?'),
                        url('/Resources/Font/Daum_SemiBold.eot?#iefix') format('embedded-opentype'),  
                        url('/Resources/Font/Daum_SemiBold.ttf') format('truetype'),      
                        url('/Resources/Font/Daum_SemiBold.otf') format('opentype'),
                        url('/Resources/Font/Daum_SemiBold.woff') format('woff'),
                        url('/Resources/Font/Daum_SemiBold.svg#Daum_SemiBold') format('svg');
                }

                @font-face {
	                font-family: NanumGothic;
	                font-style: normal;
                   font-weight: normal;
                   src: url('/Resources/Font/NanumGothic.eot');
                   src: local('?'),
                        url('/Resources/Font/NanumGothic.eot?#iefix') format('embedded-opentype'), 
                        url('/Resources/Font/NanumGothic.ttf') format('truetype'),
                        url('/Resources/Font/NanumGothic.otf') format('opentype'),
                        url('/Resources/Font/NanumGothic.woff') format('woff'),
                        url('/Resources/Font/NanumGothic.svg#NanumGothic') format('svg');
                }

                @font-face {
	                font-family: NanumGothicBold;
	                font-style: normal;
                   font-weight: normal;
                   src: url('/Resources/Font/NanumGothicBold.eot');
                   src: local('?'),
                        url('/Resources/Font/NanumGothicBold.eot?#iefix') format('embedded-opentype'), 
                        url('/Resources/Font/NanumGothicBold.ttf') format('truetype'),
                        url('/Resources/Font/NanumGothicBold.otf') format('opentype'),
                        url('/Resources/Font/NanumGothicBold.woff') format('woff'),
                        url('/Resources/Font/NanumGothicBold.svg#NanumGothicBold') format('svg');
                }

                html {
	                scrollbar-face-color: #F0F0F0;
	                scrollbar-shadow-color: #E1DFDF;
	                scrollbar-highlight-color: #FFFFFF;
	                scrollbar-3dlight-color: #E1DFDF;
	                scrollbar-darkshadow-color: #D2D2C8;
	                scrollbar-track-color: #FFFFFF;
	                scrollbar-arrow-color: #D2D2C8;
                }

                html, body {wdith: 100%; min-width: 320px; height: 100%;}
                html {overflow-y: scroll;overflow-x: scroll;}
                
                #wrapper, #print_area {position: relative;}

                * {
	                margin: 0px; padding: 0px;
	                font-family: NanumGothicBold, 나눔고딕볼드, Dotum, 돋움, Gulim, 굴림, AppleGothic, Sans-serif; font-size: 15px; color: #505050; line-height: 28px;
	                word-break: keep-all;
                }
                .iljin {font-family: NanumGothicBold;}
                
                table {border-collapse: collapse;}
                img, button, fieldset, iframe {border: none;}
                img, input, select {vertical-align: middle;}
                hr, button img {display: none;}
                fieldset {_display: inline;}
                address {font-style: normal;}

                ul, ul li {list-style: none;}
                ul.vertical li {clear: both;}
                ul.horizontal li {float: left;}
                ul.list_01.size_11 li,
                ul.list_01.size_11 li span,
                ul.list_01.size_11 li strong,
                ul.list_02.size_11 li,
                ul.list_02.size_11 li span,
                ul.list_02.size_11 li strong,
                ul.list_03.size_11 li,
                ul.list_03.size_11 li span,
                ul.list_03.size_11 li strong,
                ul.list_04.size_11 li,
                ul.list_04.size_11 li span,
                ul.list_04.size_11 li strong,
                ul.list_05.size_11 li,
                ul.list_05.size_11 li span,
                ul.list_05.size_11 li strong {font-size: 11px;}
                ul.list_01 li {position: relative; padding-left: 8px; background: url(../Resources/Images/Monitoring/BIN/icon_list_01.gif); background-position: left 10px; background-repeat: no-repeat;}
                ul.list_02 li {position: relative; padding-left: 8px; background: url(../Resources/Images/Monitoring/BIN/icon_list_02.gif); background-position: left 10px; background-repeat: no-repeat;}
                ul.list_03 li {list-style: inside disc;}
                ul.list_04 li {list-style: inside circle;}
                ul.list_05 li {list-style: inside square;}

                ol, ol li {list-style: none;}
                ol.vertical li {clear: both;}
                ol.horizontal li {float: left;}
                ol.list_01.size_11 li,
                ol.list_01.size_11 li span,
                ol.list_01.size_11 li strong,
                ol.list_02.size_11 li,
                ol.list_02.size_11 li span,
                ol.list_02.size_11 li strong,
                ol.list_03.size_11 li,
                ol.list_03.size_11 li span,
                ol.list_03.size_11 li strong,
                ol.list_04.size_11 li,
                ol.list_04.size_11 li span,
                ol.list_04.size_11 li strong,
                ol.list_05.size_11 li,
                ol.list_05.size_11 li span,
                ol.list_05.size_11 li strong {font-size: 11px;}
                ol.list_01 li {list-style: inside decimal;}
                ol.list_02 li {list-style: inside decimal-leading-zero;}
                ol.list_03 li {list-style: inside lower-alpha;}
                ol.list_04 li {list-style: inside upper-alpha;}
                ol.list_05 li {list-style: inside lower-roman;}
                ol.list_06 li {list-style: inside upper-roman;}

                .group_horizontal {_float: left; overflow: hidden;}
                .para_group {margin-bottom: 50px;}
                .para {margin-bottom: 40px;}
                .para_s {margin-bottom: 30px;}
                .para_ss {margin-bottom: 10px;}
                .object {margin-bottom: 10px;}

                .inline {display: inline;}
                .none {display: none;}
                .clear {clear: both;}
                .cursor {cursor: pointer;}

                .left {float: left;}
                .center {margin: 0 auto; display: block;}
                .right {float: right;}
                .top {vertical-align: top;}
                .middle {position: relative; top: 50%;}
                .bottom {position: absolute; bottom: 0px;}

                .text_left {text-align: left;}
                .text_center {text-align: center;}
                .text_right {text-align: right;}
                .text_top {vertical-align: top;}
                .text_middle {vertical-align: middle;}
                .text_bottom {vertical-align: bottom;}

                .onmouse a img {display: inline;}
                .onmouse a img.over {display: none;}
                .onmouse a:hover {position: relative;}
                .onmouse a:hover img {display: none;}
                .onmouse a:hover img.over {display: inline;}

                a {text-decoration: none; cursor: pointer;}
                a:hover {color: #1658A0;}

                .png24 {tmp:expression(setPng24(this));} 

                #skip_navigation {display: none;}

                .hidden_text {position: absolute; left: 0px; top: 0px; width: 0px; height: 0px; font-size: 0px; line-height: 0px; visibility: hidden;}

                #main_body #container #content_bx #content #content_mode #content_mode_bx h4 {font-size: 15px; color: #323232; line-height: 15px; font-weight: normal;}
                #main_body #container #content_bx #content #content_mode #content_mode_bx #cm_02 h4 {position: absolute; z-index: 1; bottom: 10px; left: 15px;}
                #main_body #container #content_bx #content #content_mode #content_mode_bx #cm_03 h4,
                #main_body #container #content_bx #content #content_mode #content_mode_bx #cm_04 h4,
                #main_body #container #content_bx #content #content_mode #content_mode_bx #cm_05 h4,
                #main_body #container #content_bx #content #content_mode #content_mode_bx #cm_06 h4,
                #main_body #container #content_bx #content #content_mode #content_mode_bx #cm_07 h4,
                #main_body #container #content_bx #content #content_mode #content_mode_bx #cm_08 h4 {line-height: 38px;}
                #sub_body h4,
                #sub_body h4 span,
                #pop h4,
                #pop h4 span {font-size: 18px; color: #1E1E1E; line-height: 38px; font-weight: normal;}
                #sub_body h4,
                #pop h4 {background: url(../Resources/Images/Monitoring/BIN/icon_h4.gif); background-position: top left; background-repeat: no-repeat;}
                #sub_body h5,
                #sub_body h5 span {font-size: 16px; color: #505050; line-height: 35px; font-weight: normal;}
                #sub_body h5 {padding-left: 25px; background: url(../Resources/Images/Monitoring/BIN/icon_h5.gif); background-position: left 50%; background-repeat: no-repeat;}
                #sub_body h6,
                #sub_body h6 span {font-size: 16px; color: #505050; line-height: 35px; font-weight: normal;}
                #sub_body h6 {padding-left: 13px; background: url(../Resources/Images/Monitoring/BIN/icon_h6.gif); background-position: left 50%; background-repeat: no-repeat;}

                input {height: 23px; border: 1px solid #D2D2D2; background: #FFFFFF;}
                textarea {width: 100%; height: 20px; overflow: auto; border: 1px solid #D2D2D2; background: #FFFFFF;}
                select {height: 25px; border: 1px solid #D2D2D2; background: #FFFFFF;}
                span input {width: 13px; border: none; background: none;}

                html:first-child select {height: 20px; padding-right: 6px;} 
                option {padding-right: 6px;}
                legend {position: absolute; top: 0; left: 0; width: 0; height: 0; overflow: hidden; visibility: hidden; font-size: 0; line-height: 0;}

                table.table_01 {
	                border: 1px solid #A0A7B4;
                   background: #FFFFFF;
                }
                   table.table_01 tr.col {background: #F6F7FB;}
                   table.table_01 tr.total {background: #FFD86D;}
                   table.table_01 th {
   	                height: 25px;
   	                font-size: 13px;
                      color: #1E2D4B;
                      line-height: 25px;
                      padding: 1px;
                      border: 1px solid #A0A7B4;
                      
	                   background: #EEF0F7; 
	                   background: -moz-linear-gradient(top, #EEF0F7, #D7DCEB); 
	                   background: -webkit-gradient(linear, left top, left bottom, from(#EEF0F7), to(#D7DCEB)); 
                   }
                   table.table_01 td {
   	                height: 30px;
   	                font-size: 13px;
   	                line-height: 30px;
                      padding: 0px 1px 0px;
                      border: 1px solid #A0A7B4;
                   }
                   table.table_01 td.std {text-align: center;}
   
                table.table_02 {
	                border: 1px solid #A0A7B4;
                   background: #FFFFFF;
                }
                   table.table_02 th {
   	                height: 25px;
   	                font-size: 23px;
                      color: #1E2D4B;
                      line-height: 25px;
                      padding: 1px;
                      border: 1px solid #A0A7B4;
                      background: #D2DAEC; 
                   }
                   table.table_02 td {
   	                height: 30px;
   	                line-height: 30px;
                      padding: 0px 1px 0px;
                      border: 1px solid #A0A7B4;
                   }



                #wrapper {
                   position: relative;
                   margin : 0 auto;
                   width: 1650px;
                   height: 925px;
                }

                   #wrapper ul#title {
		                position: relative;
		                float: left;
		                width: 100%;
		                height: 110px;
		                background: url(../Resources/Images/Monitoring/BIN/title_bg.gif); background-position: top left; background-repeat: repeat-x;
		                overflow: hidden;
	                }
	                   #wrapper ul#title li {
	   	                float: left;
	                      height: 110px;
	                   }
	                   #wrapper ul#title li.logo img {
	                      position: relative;
	                      top: 50%;
	                      margin-top: -25px;
	                      padding-left: 20px;
	                   }
	                   #wrapper ul#title li.title {
	                      font-size: 70px;
	                      color: #FFFFFF;
	                      line-height: 110px;
	                   }
	                   #wrapper ul#title li.title_left {
	   	                float: right;
	   	                text-align: right;
	                   }
	                   #wrapper ul#title li.title_right {
	   	                float: left;
	   	                text-align: left;
	                   }
	                   #wrapper ul#title li.master {
	   	                float: right;
	   	                font-size: 30px;
	                      color: #FFFFFF;
	                      line-height: 110px;
	   	                text-align: right;
	   	                padding-right: 20px;
	                   }

                   #wrapper #container {
		                position: relative;
		                width: 1618px;
		                padding: 20px 10px 20px 20px;
		                margin-right: -10px;
		                background: #E9EEF4;
		                border: 1px solid #A7AFB9;
	                }
	                #wrapper #container.top_bx {height: 773px;}
	                
	                #wrapper #container.btm_bx {
		                width: 100%;
		                height: 100%;
	                   padding: 20px;
	                }
	                   #wrapper #container .bin_bx {
			                position: relative;
			                float: left;
			                width: 797px;
			                height: 771px;
			                margin-right: 10px;
			                background: #E9EBF0;
			                border: 1px solid #A0A7B4;
		                }
		                #wrapper #container .bin_bx_01 {
			                height: 400px;
			                margin-bottom: 10px;
		                }
		                #wrapper #container .bin_bx_02 {height: 359px;}
			                #wrapper #container .bin_title {
				                position: relative;
				                width: 100%;
		                      height: 70px;
				                font-size: 30px;
		                      color: #FFFFFF;
		                      line-height: 70px;
		                      text-align: center;
		                      background: url(../Resources/Images/Monitoring/BIN/bin_title_bg.gif); background-position: top left; background-repeat: repeat-x;
			                }
				                #wrapper #container .bin_title img.btn_left {
					                position: absolute;
			   	                top: 12px;
			   	                left: 10px;
				                }
				                #wrapper #container .bin_title img.btn_right {
					                position: absolute;
			   	                top: 12px;
			   	                right: 10px;
				                }
			                #wrapper #container .bin_bx .bin {
				                position: relative;
				                width: 100%;
		                      height: 701px;
			                }
			                #wrapper #container .bin_bx_01 .bin {
				                position: relative;
				                width: 100%;
		                      height: 330px;
			                }
			                #wrapper #container .bin_bx_02 .bin {
				                position: relative;
				                width: 100%;
		                      height: 289px;
			                }
			
                      #wrapper #container #tab_bx {
			                position: relative;
			                width: 100%;
		                }
			                #wrapper #container #tab_bx ul#tab {
				                position: relative;
				                float: left;
				                width: 1606px;
				                height: 75px;
				                border: 1px solid #A0A7B4;
				                border-top: 2px solid #782341;
				                filter:progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr='#F9F9FB', EndColorStr='#F3F4F8');
			                   background: #F3F4F8; 
			                   background: -moz-linear-gradient(top, #F9F9FB, #F3F4F8); 
			                   background: -webkit-gradient(linear, left top, left bottom, from(#F9F9FB), to(#F3F4F8)); 
				                overflow: hidden;
			                }
			                   #wrapper #container #tab_bx ul#tab li {float: left;}
			                   #wrapper #container #tab_bx ul#tab li a {
			                      width: 249px;
			                      height: 75px;
			                      font-size: 30px;
			                      color: #1E2D4B;
			                      line-height: 75px;
			                      text-align: center;
			                      border-right: 1px solid #A0A7B4;
			                      display: block;
			                   }
			                   #wrapper #container #tab_bx ul#tab li a:hover,
			                   #wrapper #container #tab_bx ul#tab li a.on {
			                      color: #FFFFFF;
			                      background: #C58787;
			                   }
			                   #wrapper #container #tab_bx a img.tab_btn {
					                position: absolute;
			   	                padding-top: 17px;
			   	                right: 10px;
				                }
			
		                #wrapper #container .info {
			                position: relative;
			                height: 78px;
			                font-size: 25px;
			                color: #1E2D4B;
			                text-align: right;
			                padding-right: 10px;
			                border: 1px solid #A0A7B4;
			                background: #D2DAEC;
		                }
		                #wrapper #container .info.info_01 {
			                width: 1596px;
		                   line-height: 80px;
		                }
		                #wrapper #container .info.info_02 {
			                width: auto;
		                   line-height: 39px;
		                }
			
		                #wrapper #container #bx_01 {
			                position: relative;
			                float: left;
			                width: 500px;
			                margin-right: 10px;
		                }
		
		                #wrapper #container #bx_02 {
			                position: relative;
			                float: left;
			                width: 280px;
			                margin-right: 10px;
		                }
		
		                #wrapper #container #bx_03 {
			                position: relative;
			                float: left;
			                width: 810px;
		                }
		
		                #wrapper #container ul#list_bx {
			                position: relative;
			                padding: 10px;
		                   border: 1px solid #A0A7B4;
			                background: #FFFFFF; 
		                }
		                   #wrapper #container ul#list_bx li {
		   	                height: 48px;
		   	                margin-bottom: 10px;
		                      border: 1px solid #C3C6CA;
			                   background: #DEE2E8; 
		                   }
		                      #wrapper #container ul#list_bx li a {
			                      height: 48px;
			                      font-size: 23px;
			                      color: #505050;
			                      line-height: 48px;
			                      padding: 0px 10px 0px;
			                      display: block;
			                   }
			                   #wrapper #container ul#list_bx li a:hover,
			                   #wrapper #container ul#list_bx li a.on {
			   	                color: #FFFFFF;
			                      background: #FF8533;
			                   }
			   
		                #wrapper #container ul#list_bx {
			                position: relative;
			                padding: 10px;
		                   border: 1px solid #A0A7B4;
			                background: #FFFFFF; 
		                }
		                   #wrapper #container ul#list_bx li {
		   	                height: 48px;
		   	                margin-bottom: 10px;
		                      border: 1px solid #C3C6CA;
			                   background: #DEE2E8; 
		                   }
		                      #wrapper #container ul#list_bx li a {
			                      height: 48px;
			                      font-size: 23px;
			                      color: #505050;
			                      line-height: 48px;
			                      padding: 0px 10px 0px;
			                      display: block;
			                   }
			                   #wrapper #container ul#list_bx li a:hover,
			                   #wrapper #container ul#list_bx li a.on {
			   	                color: #FFFFFF;
			                      background: #FF8533;
			                   }
			   
		                #wrapper #container #bx_03 .table_01 {float: left;}  
			                #wrapper #container #bx_03 .table_01 td {padding: 0px;}  
			                   #wrapper #container #bx_03 .table_01 td a {
			                      height: 53px;
			                      font-size: 23px;
			                      color: #505050;
			   	                line-height: 53px;
			                      padding: 5px;
			                      display: block;
			                   }
			                   #wrapper #container #bx_03 .table_01 td a:hover,
			                   #wrapper #container #bx_03 .table_01 td a.on {
			   	                color: #FFFFFF;
			                      background: #FF8533;
			                   }
          
            
            
    </style>
    <ext:XScript ID="XScript1" runat="server">
        <script type="text/javascript">

            var objitem;
            var codegubn;

           function UP_run()
           {
                Ext.net.DirectMethod.request('UP_run', {
                        url: location.href,
                        params: {sSDATE : Ext.util.Format.date(#{dtpDATE}.getValue(), 'Ymd'),
                                sCORPGUBN : #{cboGUBN}.getValue(),
                                sRTGUBN : #{chbRTGUBN}.getValue()
                                 },
                        eventMask: {
                            showMask: true,
                            msg: "BIN 상태관리 자료를 조회중입니다...",
                            target: "customtarget",
                            customTarget: #{grdBinMove}
                        }
                        });
                
           }

           function CellDbClick(SDATE, SBINNO)
           {
                Ext.net.DirectMethod.request('grdBinStatus_CellClick', {
                        url: location.href,
                        params: {SDATE : SDATE, 
                                 SBINNO : SBINNO
                                 }
                        });
           }

           function UP_CodeCheck(value ,id, nmid){
         
           var msg;
           var rObj = document.getElementById(id);

           rObj.value = rObj.value.toUpperCase();

           if(rObj.value == "0")
           {
                rObj.value = "00";
           }

           switch(value){
               case 'GK':
                  msg = '곡종코드를 확인하세요';
                 break;
               case 'WN':
                  msg = '원산지코드를 확인하세요';
                 break;
               case 'HJ':
                  msg = '화주코드를 확인하세요';
                 break;
               case 'SK':
                  msg = '협회코드를 확인하세요';
                 break;
           }

           if(rObj.value != ''){
                if((value == "HJ" && rObj.value.length == 6) || 
                    (value == "GK" && rObj.value.length == 2) ||
                    (value == "WN" && rObj.value.length == 2) ||
                    (value == "SK" && rObj.value.length == 1))
                    {
                       var store = #{stoCodeList}; 
                       var record = store.findRecord("CDCODE", rObj.value);
                       if(!record){
                          rObj.value = "";
                          rObj.focus();
                          alert(msg);
                          return;
                       }
                       else{
                           switch(value){
                               case 'WN':
                                  if(record.data.CDCODENM.length > 5)
                                  {
                                    document.getElementById(nmid).innerHTML = record.data.CDCODENM.substring(0,5);
                                  }
                                  else{
                                    document.getElementById(nmid).innerHTML = record.data.CDCODENM;
                                  }
                                 break;
                               default:
                                  document.getElementById(nmid).innerHTML = record.data.CDCODENM;
                                 break;
                           }
                    }
                }
           }
           else{
               var val = "";
               switch(value){
                   case 'GK':
                      //alert('곡종코드를 입력하세요');
                      val = "필수항목";
                     break;
                   case 'WN':
                      //alert('원산지코드를 입력하세요');
                      val = "필수항목";
                     break;
               }
               document.getElementById(nmid).innerHTML = val;
           }           
        }

        function UP_SKCodeCheck(id, nmid){
           
           var rObj = document.getElementById(id);

           rObj.value = rObj.value.toUpperCase();

           if(rObj.value != '')
           {
                if(rObj.value.length == 1)
                {
                    var store = #{stoSKCodeList}; 
                    var record = store.findRecord("CDCODE", rObj.value);

                    if(!record){
                        rObj.value = "";
                        rObj.focus();
                        alert('협회코드를 확인하세요');
                        return;
                    }
                    else{
                        document.getElementById(nmid).innerHTML = record.data.CDCODENM;
                    }
                }
            }
            else{
               var val = "";
               document.getElementById(nmid).innerHTML = val;
           }      
        }

        function UP_DateCheck(id){   
                   
           var rObj = document.getElementById(id);
	       var val = rObj.value;
           
           if (val != null &&  val.length == 8) {
                var yyyy = val.substring(0, 4);
                var mm = val.substring(4, 6);
                var dd = val.substring(6, 8);
                var date = yyyy + "-" + mm + "-" + dd;
                rObj.value = date;
           }
        }  

        var CheckCommand = function (id) {               
              var binno = id.split('-');
              var chkId = "txtSAVECHK-" + binno[1] + "-" + binno[2];
              document.getElementById(chkId).value = 'Y';
        }

        function UP_DataChange(value, id){
              
              var binno = id.split('-');
              var chkId = "txtSAVECHK-" + binno[1] + "-" + binno[2];
              var binId = "txtSBINNO-" + binno[1] + "-" + binno[2];

              var rObj = document.getElementById(binId);
              var obj = document.getElementById(id);
              
              var store = #{stoBinStatus}; 
              var record = store.findRecord("SBINNO", rObj.innerHTML);

              switch(value){
	           case 'GK':
		        if( obj.value != record.data.SGOKJONG ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	           case 'WN':
		        if( obj.value != record.data.SWONSAN ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
               case 'WG':
		        if( obj.value != record.data.SHWGCODE ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	           case 'HJ':
		        if( obj.value != record.data.STJHJ ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	           case 'SK':
		        if( obj.value != record.data.SSOSOK ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	           case 'VS':
		        if( obj.value != record.data.SHANGCHA ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	           case 'MO':
		        if( obj.value != record.data.SMEMO ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	           case 'IP':
		        if( obj.value != record.data.SIPDATE ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	           case 'CL':
		        if( obj.value != record.data.SCLDATE ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;
	          case 'QT':
		        if( obj.value != record.data.SSURQTY ){
		            document.getElementById(chkId).value = 'Y';
		        }
	             break;

               }               
         }

        function UP_HangchaCheck(id, nmid, binno, date){
          var rObj = document.getElementById(id);

          if( rObj.value.length == 7){
              Ext.net.DirectMethod.request('UP_HANGCHACHECK', {
                            url: location.href,
                            params: { HANGCHA: rObj.value,
                                      HANGHCANMID : nmid,
                                      SBINNO : binno,
                                      SDATE  : date
                                     },
                            eventMask: {
                                    showMask: true,
                                    msg: "BIN 상태관리 자료를 체크중입니다...",
                                    target: "customtarget",
                                    customTarget: #{grdBinMove}
                                }
                        }
                        );
           }
           else{
                document.getElementById(nmid).innerHTML = "";
           }
        }

        function trg_CODELIST_ClientTriggerClick(cdindex ,item) {          

            // IE 전용 시작
            //var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=" + cdindex + "&param2=" + "", null, "dialogWidth:500px; dialogHeight:400px;");

            //   if(result != null && result != undefined) {
            //      document.getElementById(item).setAttribute("value", result.CDCODE);
            //      UP_DataChange('WG',item);
            //}
            // IE 전용 종료

            // 크롬, 엣지 시작
            objitem = item;
            result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=" + cdindex + "&param2=" + "", null, "dialogWidth:500px; dialogHeight:400px;");
            // 크롬, 엣지 끝
        }

        function showModalDialogCallback(result) {
            
            if (result) {
                  document.getElementById(objitem).setAttribute("value", result.CDCODE);
                  UP_DataChange('WG', objitem);
            }

        }

        function settxtSHANGCHANM(ID, HANGCHA, GOKJONG, GOKJONGNM, WONSAN, WONSANNM)
        {
            var rObj = document.getElementById('txtSHANGCHANM-' + ID);
            rObj.innerHTML = HANGCHA.substring(0,10);

//            rObj = document.getElementById('txtSGOKJONG-' + ID);
//            rObj.value = GOKJONG;

//            rObj = document.getElementById('txtSGOKJONGNM-' + ID);
//            rObj.innerHTML = GOKJONGNM;

//            rObj = document.getElementById('txtSWONSAN-' + ID);
//            rObj.value = WONSAN;

//            rObj = document.getElementById('txtSWONSANNM-' + ID);
//            rObj.innerHTML = WONSANNM;
        }

           //하단 그리드 표현
           function tab_BoardHtmlRenter(){
                
                var store = #{stoBinStatus};           
                var div = document.getElementById("tab_SP_Board");
                var imgStr = "";                                                
                var count = store.getCount();
                var data = null;
                var id;
                var fontColor = "black";
                var chkvalue;

                //alert('start');
                                
                if(div)
                {
                    imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				    imgStr += "    <colgroup> ";
                    imgStr += "    <col style=\"width: 85px;\" /> ";
                    imgStr += "    <col style=\"width: 40px;\" /> ";
                    imgStr += "    <col style=\"width: 170px;\" /> ";
                    imgStr += "    <col style=\"width: 50px;\" /> ";
                    imgStr += "    <col style=\"width: 75px;\" /> ";
                    imgStr += "    <col style=\"width: 110px;\" /> ";
                    imgStr += "    <col style=\"width: 75px;\" /> ";
                    imgStr += "    <col style=\"width: 110px;\" /> ";
                    imgStr += "    <col style=\"width: 45px;\" /> ";
                    imgStr += "    <col style=\"width: 40px;\" /> ";
                    imgStr += "    <col style=\"width: 85px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"\" /> ";
                    imgStr += "    </colgroup> ";
				    imgStr += "     <tr>";
				    imgStr += "        <th rowspan='2'>BIN</th> ";
                    imgStr += "        <th colspan ='2'>곡종</th> ";
                    imgStr += "        <th colspan ='2'>원산지</th> ";
                    imgStr += "        <th rowspan='2'>곡종/원산지</th> ";
                    imgStr += "        <th colspan ='2'>항차</th> ";
                    imgStr += "        <th rowspan='2'>출고</th> ";
                    imgStr += "        <th colspan ='2'>협회</th> ";
                    imgStr += "        <th colspan ='7'>재고관리(M/T)</th> ";
                    imgStr += "        <th rowspan='2'>마감재고</th> ";
                    imgStr += "        <th rowspan='2'>입고일자</th> ";                              
                    imgStr += "        <th rowspan='2'>BIN청소일</th> ";                              
                    imgStr += "        <th rowspan='2'>특기사항</th> ";                
				    imgStr += "     </tr>";
                    imgStr += "     <tr>";
                    imgStr += "        <th>곡종</th> ";
                    imgStr += "        <th>곡종명</th> ";
                    imgStr += "        <th>원산지</th> ";
                    imgStr += "        <th>원산지명</th> ";
                    imgStr += "        <th>항차</th> ";
                    imgStr += "        <th>모선명</th> ";
                    imgStr += "        <th>협회</th> ";
                    imgStr += "        <th>협회명</th> ";
                    imgStr += "        <th>전일재고</th> ";
                    imgStr += "        <th>입고량</th> ";
                    imgStr += "        <th>이고入</th> ";
                    imgStr += "        <th>이고出</th> ";
                    imgStr += "        <th>출고량</th> ";
                    imgStr += "        <th>증감량</th> ";
                    imgStr += "        <th>재고량</th> ";
                    imgStr += "     </tr>";
                    imgStr += "   </table>";
                    imgStr += "<div id ='Scr_Move' style=\"height:800px;background: #FFFFFF; overflow-y: scroll;\">";
                    imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
				    imgStr += "    <colgroup> ";
                    imgStr += "    <col style=\"width: 85px;\" /> ";
                    imgStr += "    <col style=\"width: 40px;\" /> ";
                    imgStr += "    <col style=\"width: 170px;\" /> ";
                    imgStr += "    <col style=\"width: 50px;\" /> ";
                    imgStr += "    <col style=\"width: 75px;\" /> ";
                    imgStr += "    <col style=\"width: 110px;\" /> ";
                    imgStr += "    <col style=\"width: 75px;\" /> ";
                    imgStr += "    <col style=\"width: 110px;\" /> ";
                    imgStr += "    <col style=\"width: 45px;\" /> ";
                    imgStr += "    <col style=\"width: 40px;\" /> ";
                    imgStr += "    <col style=\"width: 85px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 80px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"width: 90px;\" /> ";
                    imgStr += "    <col style=\"\" /> ";
                    imgStr += "    </colgroup> ";
                           
                        //타이틀 
                        for (var i = 0; i < count; i++) {
                            data = store.getAt(i).data;  
                            
                            imgStr += "<tr ondblclick=\"javascript:CellDbClick('"+data.SDATE+"','"+data.SBINNO+"');\">";
                            imgStr += "<input type=\"hidden\" id=\"txtSAVECHK-" + data.SBINNO+ "\" Value=\"\"/> ";
                            imgStr += "<input type=\"hidden\" id=\"txtSDATE-" + data.SBINNO+ "\" Value=\"" + data.SDATE + "\"/> ";
                            if(#{cboGUBN}.getValue() == "T" || #{cboGUBN}.getValue() == "P")
                            {
                                if(#{cboGUBN}.getValue() == data.SCORPGUBN && #{cboGUBN}.getValue() != data.BRCORPGUBN)
                                {
                                    imgStr += "<td width=\"85px\" id=\"txtSBINNO-" + data.SBINNO+ "\" style=\"  text-align:center; color:green\">"+ data.SBINNO+ "</td>"; 
                                }
                                else if(#{cboGUBN}.getValue() != data.SCORPGUBN)
                                {
                                    imgStr += "<td width=\"85px\" id=\"txtSBINNO-" + data.SBINNO+ "\" style=\"  text-align:center; color:red\">"+ data.SBINNO+ "</td>"; 
                                }
                                else{
                                    imgStr += "<td width=\"85px\" id=\"txtSBINNO-" + data.SBINNO+ "\" style=\"  text-align:center; color:Blue\">"+ data.SBINNO+ "</td>"; 
                                }
                            }
                            else{ 
                                imgStr += "<td width=\"85px\" id=\"txtSBINNO-" + data.SBINNO+ "\" style=\"  text-align:center; color:Blue\">"+ data.SBINNO+ "</td>"; 
                            }

                            imgStr += "<td width=\"40px\">";
                            imgStr += "<input type=\"text\" onkeyup=\"javascript:UP_CodeCheck('GK','txtSGOKJONG-"+data.SBINNO+"','txtSGOKJONGNM-"+data.SBINNO+"');UP_DataChange('GK','txtSGOKJONG-"+data.SBINNO+"');\" id=\"txtSGOKJONG-" + data.SBINNO+ "\" Value=\"" + data.SGOKJONG + "\" maxlength=\"2\" style=\" font-size:13px; text-align:left; width: 100%;height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "</td>";  
                            
                            imgStr += "<td id=\"txtSGOKJONGNM-" + data.SBINNO+ "\" width=\"170px\" style=\"text-align:left; overflow:hidden; color:"+fontColor+"\">"+ data.SGOKJONGNM+ "</td>"; 

                            imgStr += "<td width=\"50px\" style=\"text-align:left; \">";
                            imgStr += "<input type=\"text\" onkeyup=\"javascript:UP_CodeCheck('WN','txtSWONSAN-"+data.SBINNO+"','txtSWONSANNM-"+data.SBINNO+"');UP_DataChange('WN','txtSWONSAN-"+data.SBINNO+"');\" id=\"txtSWONSAN-" + data.SBINNO+ "\" Value=\"" + data.SWONSAN + "\" maxlength=\"2\" style=\"font-size:13px; text-align:left; width: 100%;height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "</td>";  

                            imgStr += "<td id=\"txtSWONSANNM-" + data.SBINNO+ "\" width=\"75px\" style=\"text-align:left;  color:"+fontColor+"\">"+ data.SWONSANNM+ "</td>"; 

                            imgStr += "<td width=\"110px\">";
                            imgStr += "<input type=\"text\" onkeyup=\"UP_DataChange('WG','txtSHWGCODE-"+data.SBINNO+"');\" id=\"txtSHWGCODE-" + data.SBINNO+ "\" Value=\"" + data.SHWGCODE + "\" maxlength=\"14\" style=\"font-size:13px; text-align:left; width: 80px;height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "<input type=\"image\" onclick=\"trg_CODELIST_ClientTriggerClick('WG','txtSHWGCODE-"+data.SBINNO+"');\" src=\"../Resources/Images/Monitoring/SILOBIN/magnifier.gif\" style=\" text-align:left; width: 20px;height: 20px; border: 1px solid #D2D2D2; background-color:white;\"/>";
                            imgStr += "</td>";  

                            imgStr += "<td width=\"75px\" style=\"text-align:left; \">";
                            imgStr += "<input onkeyup=\"javascript:UP_HangchaCheck('txtSHANGCHA-"+data.SBINNO+"','txtSHANGCHANM-"+data.SBINNO+"','"+data.SBINNO+"','"+data.SDATE+ "');UP_DataChange('VS','txtSHANGCHA-"+data.SBINNO+"');\" type=\"text\" id=\"txtSHANGCHA-" + data.SBINNO+ "\" Value=\"" + data.SHANGCHA + "\" maxlength=\"7\" style=\"font-size:13px; text-align:left; width: 100%;height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "</td>";  

                            imgStr += "<td id=\"txtSHANGCHANM-" + data.SBINNO+ "\" width=\"110px\" style=\"text-align:left;  color:"+fontColor+"\">"+ data.SHANGCHANM+ "</td>"; 

                            imgStr += "<td width=\"45px\" style=\"text-align:center; \">";

                            chkvalue = data.SCHGN == true ? "checked": "";

                            imgStr += "<input type=\"checkbox\" onclick=\"javascript:CheckCommand(id);\" id=\"chkSCHGN-" + data.SBINNO+ "\" " + chkvalue + " style=\" text-align:center; width: 100%;height: 25px; background-color:white;\" onfocus=\"this.select();\" disabled=\"disabled\"/> ";
                            imgStr += "</td>";  

                            imgStr += "<td width=\"40px\" style=\"text-align:left; \">";
                            imgStr += "<input type=\"text\" onkeyup=\"javascript:UP_SKCodeCheck('txtSSOSOK-"+data.SBINNO+"','txtSSOSOKNM-"+data.SBINNO+"');UP_DataChange('SK','txtSSOSOK-"+data.SBINNO+"');\" id=\"txtSSOSOK-" + data.SBINNO+ "\" Value=\"" + data.SSOSOK + "\" maxlength=\"2\" style=\"font-size:13px; text-align:left; width: 100%;height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "</td>";  

                            imgStr += "<td id=\"txtSSOSOKNM-" + data.SBINNO+ "\" width=\"85px\" style=\"text-align:left; overflow:hidden; color:"+fontColor+"\">"+ data.SSOSOKNM+ "</td>"; 
                            imgStr += "<td width=\"90px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SJUNILQTY,'0,000.000') + "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SIPGOQTY,'0,000.000') + "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SEPGOQTY,'0,000.000') + "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SEPCHQTY,'0,000.000') + "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.SCHULQTY,'0,000.000') +"</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.SINCDECQTY,'0,000.000') +"</td>"; 
                            imgStr += "<td width=\"90px\" style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.SJEGOQTY,'0,000.000') +"</td>"; 

                            imgStr += "<td width=\"90px\" style=\"text-align:right; \">";
                            imgStr += "<input maxlength=\"9\" type=\"text\" onkeyup=\"javascript:UP_DataChange('QT','txtSSURQTY-"+data.SBINNO+"');\" id=\"txtSSURQTY-" + data.SBINNO+ "\" Value="+FormatZero(data.SSURQTY,'0,000.000')+" style=\"font-size:13px; text-align:right; width: 100%; height: 25px; border: 1px solid #D2D2D2; background-color:white; color:Red;\" onfocus=\"this.select();\" ReadOnly=\"true\"/> ";
                            imgStr += "</td>";  

                            imgStr += "<td width=\"90px\" style=\"text-align:left; \">";
                            imgStr += "<input type=\"text\" onkeyup=\"javascript:UP_DateCheck('txtSIPDATE-"+data.SBINNO+"');UP_DataChange('IP','txtSIPDATE-"+data.SBINNO+"');\" id=\"txtSIPDATE-" + data.SBINNO+ "\" Value=\"" + data.SIPDATE + "\" style=\"font-size:13px; text-align:left; width: 100%;height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "</td>";  

                            imgStr += "<td width=\"90px\" style=\"text-align:left; \">";
                            imgStr += "<input type=\"text\" onkeyup=\"javascript:UP_DateCheck('txtSCLDATE-"+data.SBINNO+"');UP_DataChange('CL','txtSCLDATE-"+data.SBINNO+"');\" id=\"txtSCLDATE-" + data.SBINNO+ "\" Value=\"" + data.SCLDATE + "\" maxlength=\"10\" style=\"font-size:13px; text-align:left; width: 100%;height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "</td>";  
                            
                            imgStr += "<td style=\"text-align:left; \">";
                            imgStr += "<input type=\"text\" onkeyup=\"javascript:UP_DataChange('MO','txtSMEMO-"+data.SBINNO+"');\" id=\"txtSMEMO-" + data.SBINNO+ "\" Value=\"" + data.SMEMO + "\" maxlength=\"10\" style=\"font-size:13px; text-align:left;width:100%; height: 25px; border: 1px solid #D2D2D2; background-color:white;\" onfocus=\"this.select();\" /> ";
                            imgStr += "</td>";  
                            imgStr += "</tr> "; 
  
                        }//for (var i = 0; i < count; i++) ..end
                        imgStr += "</table> </div> ";
                        
                        var aHTML = [];
                        aHTML.push(imgStr);
                        div.innerHTML = aHTML.join("");
                }       
           }
           // ----------특기사항, 하역,입합계획, bin클리닝, 하역작업일지  종료----------//         

           function tab_BoardHtmlRenter_Total(){
                
                var store = #{stoBinMoveTotal};           
                var div = document.getElementById("tab_SP_Total");
                var imgStr = "";                                                
                var count = store.getCount();
                var data = null;
                var id;
                var fontColor = "Red";
                var chkvalue;

                                
                if(div)
                {
                    
                    imgStr += "<div id ='Scr_Move' style=\"height:25px;background: #FFFFFF; \">";
                    imgStr += "   <table class=\"table_01\" style=\"width: 100%;\"> ";
                        
                        for (var i = 0; i < count; i++) {
                            data = store.getAt(i).data;  
                            
                            imgStr += "<tr>";
                            imgStr += "<td width=\"85px\" text-align:center; color:Red\">"+ data.SBINNO+ "</td>"; 
                            imgStr += "<td width=\"800px\" text-align:center; color:"+fontColor+"\"></td>";
                            imgStr += "<td width=\"90px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SJUNILQTY,'0,000.000')+ "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SIPGOQTY,'0,000.000')+ "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SEPGOQTY,'0,000.000') + "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right; color:"+fontColor+"\">"+ FormatZero(data.SEPCHQTY,'0,000.000')+ "</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.SCHULQTY,'0,000.000')+"</td>"; 
                            imgStr += "<td width=\"80px\" style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.SINCDECQTY,'0,000.000')+"</td>"; 
                            imgStr += "<td width=\"90px\" style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.SJEGOQTY,'0,000.000')+"</td>"; 
                            imgStr += "<td width=\"90px\" style=\"text-align:right;color:"+fontColor+"\">"+ FormatZero(data.SSURQTY,'0,000.000')+"</td>"; 
                            imgStr += "<td style=\"text-align:right;color:"+fontColor+"\">"+ data.SMEMO+"</td>"; 
                            imgStr += "</tr> "; 
                              
                        }//for (var i = 0; i < count; i++) ..end
                        imgStr += "</table> </div> ";
                        div.innerHTML = imgStr;     

                }       
           }

           function DateMove(value){

               //날짜 계산
               var valuedate;
               var NDate;
               var yyyy;
               var mm;
               var dd;
               
                valuedate = Ext.util.Format.date(#{dtpDATE}.getValue(), 'Ymd');
                                         
                yyyy = valuedate.substr(0,4);
                mm   = valuedate.substr(4,2);
                dd   = valuedate.substr(6,2);                  

                NDate = GetNDate(yyyy, mm, dd);

                if( value == '1' )
                {
                    NDate = GetPreDate(NDate);
                }
                else
                {
                    NDate = GetTomDate(NDate);
                }
              
               #{dtpDATE}.setValue(NDate);    
              
//               Ext.net.DirectMethod.request('UP_DateMove', {
//                    url: location.href,
//                    params: { sDate:Ext.util.Format.date(#{dtpDATE}.getValue(), 'Ymd')
//                             },
//                    eventMask: {
//                            showMask: true,
//                            msg: "BIN 상태관리 자료를 조회중입니다...",
//                            target: "customtarget",
//                            customTarget: #{grdBinMove}
//                        }
//                }
//                );
           }

           function CalendarSelect(item){

              var obj = null;
              obj = #{dtpDATE}.value;                  
              
               if( #{dtpDATE}.rawValue.length < 8 ){ return; }

               if (obj != null &&  obj.length == 8) {
                    var yyyy = obj.substring(0, 4);
                    var mm = obj.substring(4, 6);
                    var dd = obj.substring(6, 8);
                    var date = yyyy + "-" + mm + "-" + dd;
                    obj = date;
               }
               else{
                   if( obj == null || obj.length < 8 ){
                      obj = Current_Date();
                   }
                   else if( obj.length == undefined ){
                      obj = Ext.util.Format.date(item.value, "Y-m-d");
                   }
                   else
                   {
                      obj = Ext.util.Format.date(item.value, "Y-m-d");
                   }
               }

               item.setValue(obj);

               var valuedate = Ext.util.Format.date(#{dtpDATE}.getValue(), 'Ymd');

               if( valuedate.length == 8 ){
                    Ext.net.DirectMethod.request('UP_DateMove', {
                        url: location.href,
                        params: { sDate: valuedate,
                                  sCORPGUBN : #{cboGUBN}.getValue(),
                                  sRTGUBN : #{chbRTGUBN}.getValue()
                                 },
                        eventMask: {
                                showMask: true,
                                msg: "BIN 상태관리 자료를 조회중입니다...",
                                target: "customtarget",
                                customTarget: #{grdBinMove}
                            }
                    }
                    );
              }
           }

           function stoChul_FormatHandler(value) {              

                return ( value == "Y" ? true : false);
          }    

          function btnWinSav_Click(){
                var record = #{stoBinStatusEdit}.data.items;
                
                var SJUNILQTY = "";
                var SIPGOQTY = "";
                var SEPGOQTY = "";
                var SEPCHQTY = "";
                var SCHULQTY = "";
                var SINCDECQTY = "";
                var SJEGOQTY = "";
                var SSURQTY = "";
                

                for(var i = 0; i < record.length; i++)
                {   
                    SJUNILQTY  = record[i].data.SJUNILQTY;
                    SIPGOQTY   = record[i].data.SIPGOQTY;
                    SEPGOQTY   = record[i].data.SEPGOQTY;
                    SEPCHQTY   = record[i].data.SEPCHQTY;
                    SCHULQTY   = record[i].data.SCHULQTY;
                    SINCDECQTY = record[i].data.SINCDECQTY;
                    SJEGOQTY   = record[i].data.SJEGOQTY;
                    SSURQTY    = record[i].data.SSURQTY;
                }

                Ext.net.DirectMethod.request('btnWinSav_Click', {
                url: location.href,
                params: {sSDATE     : Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd'),
                            sSBINNO     : #{txtSBINNO}.getValue(), 
                            sSJUNILQTY  : SJUNILQTY, 
                            sSIPGOQTY   : SIPGOQTY, 
                            sSEPGOQTY   : SEPGOQTY, 
                            sSEPCHQTY   : SEPCHQTY, 
                            sSCHULQTY   : SCHULQTY,
                            sSINCDECQTY : SINCDECQTY,
                            sSJEGOQTY   : SJEGOQTY,
                            sSSURQTY    : SSURQTY,
                            sSGOKJONG   : #{txtSGOKJONG}.getValue(),
                            sSWONSAN    : #{txtSWONSAN}.getValue(),
                            sSHANGCHA   : #{txtSHANGCHA}.getValue(),
                            sSHANGCHANM : #{txtSHANGCHANM}.getValue(),
                            sSIPDATE    : Ext.util.Format.date(#{dtpSIPDATE}.getValue(), 'Ymd'),
                            sSCLDATE    : Ext.util.Format.date(#{dtpSCLDATE}.getValue(), 'Ymd'),
                            sSBINSTATUS : "0",
                            sSCHGN      : #{cboSCHGN}.getValue(),
                            sSSOSOK     : #{txtSSOSOK}.getValue(),
                            sSMEMO      : #{txtSMEMO}.getValue(),
                            sSHWGCODE   : #{txtSHWGCODE}.getValue(),
                            sCORPGUBN   : #{cboGUBN}.getValue(),
                            sRTGUBN     : #{chbRTGUBN}.getValue()
                            }
                });
            }

            function winBinStatushide(){
             Ext.net.DirectMethod.request('UP_WinBinStatushide', {
                    url: location.href,
                    params: { 
                              sDATE  : Ext.util.Format.date(#{dtpDATE}.getValue(), 'Ymd'),
                              sCORPGUBN : #{cboGUBN}.getValue(),
                              sRTGUBN : #{chbRTGUBN}.getValue()
                            }
                    }
                 );
             }    
            function trgP_CODE_ClientTriggerClick(gubn) {

                // IE 전용 시작
//                if(gubn == 1)
//                {
//                    var result = window.showModalDialog("../SiloBin/CodeHelpBinNo.aspx?param1=" + encodeURI(#{txtSBINNO}.getValue()), "FTAlink", " toolbar=0, location=0, status=0, menubar=0,resizable=no, location=no, menubar=no, toolbar=no, width=450px, height=400px");
            
//                    if(result != null && result != undefined) {
//                        #{txtSBINNO}.setValue(result.CBINNO);
//                    }
//                }                
//                else if(gubn == 2)
//                {
//                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=GK&param2=" + encodeURI(#{txtSGOKJONG}.getValue()), null, "dialogWidth=500px; dialogHeight=400px;");
            
//                    if(result != null && result != undefined) {
//                        #{txtSGOKJONG}.setValue(result.CDCODE);
//                        #{txtSGOKJONGNM}.setValue(result.CDDESC1);
//                    }
//                }
//		        else if(gubn == 3)
//                {
//                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=WN&param2=" + encodeURI(#{txtSWONSAN}.getValue()), null, "dialogWidth=500px; dialogHeight=400px;");
            
//                    if(result != null && result != undefined) {
//                        #{txtSWONSAN}.setValue(result.CDCODE);
//                        #{txtSWONSANNM}.setValue(result.CDDESC1);
//                    }
//                }
//                else if(gubn == 4)
//                {
//                    var result = window.showModalDialog("../SiloBin/CodeHelpHangcha.aspx?param1=" + encodeURI(#{txtSHANGCHA}.getValue()) + "&param2=" + encodeURI(Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd')) + "&param3=" + encodeURI(#{txtSBINNO}.getValue()) , "FTAlink", " toolbar=0, location=0, status=0, menubar=0,resizable=no, location=no, menubar=no, toolbar=no, width=450px, height=400px");

//                    if(result != null && result != undefined) {
    
//                        #{txtSHANGCHA}.setValue(result.CODE);
//                        #{txtSHANGCHANM}.setValue(result.CODENM);
////                        #{txtSGOKJONG}.setValue(result.GOKJONG);
////                        #{txtSGOKJONGNM}.setValue(result.GOKJONGNM);
////                        #{txtSWONSAN}.setValue(result.WONSAN);
////                        #{txtSWONSANNM}.setValue(result.WONSANNM);
//                    }
//                }
//		        else if(gubn == 5)
//                {
//                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=WG&param2=" + encodeURI(#{txtSHWGCODE}.getValue()), null, "dialogWidth=500px; dialogHeight=400px;");
            
//                    if(result != null && result != undefined) {
//                        #{txtSHWGCODE}.setValue(result.CDCODE);
//                    }
//                }
//		        else if(gubn == 6)
//                {
//                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=SK&param2=" + encodeURI(#{txtSSOSOK}.getValue()), null, "dialogWidth=500px; dialogHeight=400px;");
            
//                    if(result != null && result != undefined) {
//                        #{txtSSOSOK}.setValue(result.CDCODE);
//                        #{txtSSOSOKNM}.setValue(result.CDDESC1);
//                    }
//                }
                // IE 전용 끝

                codegubn = gubn;
                // 크롬, 엣지 시작
                if (gubn == 1) {
                    var result = window.showModalDialog("../SiloBin/CodeHelpBinNo.aspx?param1=" + encodeURI(#{txtSBINNO}.getValue()), null, "dialogWidth:450px; dialogHeight:400px;");
                }
                else if (gubn == 2) {
                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=GK&param2=" + encodeURI(#{txtSGOKJONG}.getValue()), null, "dialogWidth:500px; dialogHeight:400px;");
                }
                else if (gubn == 3) {
                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=WN&param2=" + encodeURI(#{txtSWONSAN}.getValue()), null, "dialogWidth:500px; dialogHeight:400px;");
                }
                else if (gubn == 4) {
                    var result = window.showModalDialog("../SiloBin/CodeHelpHangcha.aspx?param1=" + encodeURI(#{txtSHANGCHA}.getValue()) + "&param2=" + encodeURI(Ext.util.Format.date(#{dtpSDATE}.getValue(), 'Ymd')) + "&param3=" + encodeURI(#{txtSBINNO}.getValue()), null, "dialogWidth:450px; dialogHeight:400px;");
                }
                else if (gubn == 5) {
                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=WG&param2=" + encodeURI(#{txtSHWGCODE}.getValue()), null, "dialogWidth:500px; dialogHeight:400px;");
                }
                else if (gubn == 6) {
                    var result = window.showModalDialog("../SiloBin/BinCodeListPopup.aspx?param1=SK&param2=" + encodeURI(#{txtSSOSOK}.getValue()), null, "dialogWidth:500px; dialogHeight:400px;");
                }
                // 크롬, 엣지 끝
            }

            function showModalDialogCallback(result) {

                if (result) {

                    if (codegubn == 1) {
                        #{txtSBINNO}.setValue(result.CBINNO);
                    }
                    else if (codegubn == 2) {
                        #{txtSGOKJONG}.setValue(result.CDCODE);
                        #{txtSGOKJONGNM}.setValue(result.CDDESC1);
                    }
                    else if (codegubn == 3) {
                        #{txtSWONSAN}.setValue(result.CDCODE);
                        #{txtSWONSANNM}.setValue(result.CDDESC1);
                    }
                    else if (codegubn == 4) {
                        #{txtSHANGCHA}.setValue(result.CODE);
                        #{txtSHANGCHANM}.setValue(result.CODENM);
                    }
                    else if (codegubn == 5) {
                        #{txtSHWGCODE}.setValue(result.CDCODE);
                    }
                    else if (codegubn == 6) {
                        #{txtSSOSOK}.setValue(result.CDCODE);
                        #{txtSSOSOKNM}.setValue(result.CDDESC1);
                    }
                }

            }

            function btnClientSave_Click(){
                var record = #{stoBinStatus}.data.items;
                var rtnValue = "";
                var chkvalue = "";
		        var binno = "";
		        var gjid = "";
		        var wsid = "";
                var wgid = "";
		        var chkid = "";
		        var stdid = "";
		        var surqtyid = "";
		        var vsid = "";
		        var ipdtid = "";
		        var cldtid = "";
		        var skid = "";
		        var moid = "";
                var chgnid = "";

                for(var i = 0; i < record.length; i++)
                { 
		           binno = record[i].data.SBINNO;
		           gjid = "txtSGOKJONG-" + binno;
  		           wsid = "txtSWONSAN-" + binno;
  		           chkid = "txtSAVECHK-" + binno;

                   if( document.getElementById(chkid).value == 'Y' ){    

                      if( document.getElementById(gjid).value == '' ){
                          alert('BIN:'+binno+'의 곡종코드를 입력하세요!');
                              return;
                      }
                      if( document.getElementById(wsid).value == '' ){
                          alert('BIN:'+binno+'의 원산지코드를 입력하세요!');
                              return;
                      }
                   }
                } 

                for(var i = 0; i < record.length; i++)
                { 
		           binno = record[i].data.SBINNO;
   		           gjid = "txtSGOKJONG-" + binno;
 		           wsid = "txtSWONSAN-" + binno;
                   wgid = "txtSHWGCODE-" + binno;
  		           chkid = "txtSAVECHK-" + binno;
		           stdid = "txtSDATE-" + binno;
		           surqtyid = "txtSSURQTY-" + binno;
		           vsid = "txtSHANGCHA-" + binno;
		           ipdtid = "txtSIPDATE-" + binno;
		           cldtid = "txtSCLDATE-" + binno;
   		           skid = "txtSSOSOK-" + binno;
		           moid = "txtSMEMO-" + binno;
                   chgnid = "chkSCHGN-" + binno;
                   

                   
                   if( document.getElementById(chkid).value == 'Y' ){    

                      chkvalue = document.getElementById(chgnid).checked == true ? 'Y':'';
                      rtnValue +=  document.getElementById(stdid).value + "^;^" + binno + "^;^"+ document.getElementById(surqtyid).value.replace(/,/g,"") + "^;^";
                      rtnValue +=  document.getElementById(gjid).value + "^;^" + document.getElementById(wsid).value + "^;^";
                      rtnValue +=  document.getElementById(vsid).value + "^;^" + document.getElementById(ipdtid).value.replace(/-/g,"") + "^;^";
                      rtnValue +=  document.getElementById(cldtid).value.replace(/-/g,"") + "^;^" + chkvalue + "^;^";
                      rtnValue +=  document.getElementById(skid).value + "^;^" + document.getElementById(moid).value + "^;^" + document.getElementById(wgid).value + "^/^";
                   }
                }         
                //alert(rtnValue);
                if( rtnValue != ''){
                    Ext.net.DirectMethod.request('UP_BinStatusArrayValue', {
                        url: location.href,
                        params: { 
                                  sArrayValue  : rtnValue,
                                  sCORPGUBN : #{cboGUBN}.getValue(),
                                  sRTGUBN : #{chbRTGUBN}.getValue()
                                },
                        eventMask: {
                                showMask: true,
                                msg: "BIN 상태관리 자료를 저장중입니다...",
                                target: "customtarget",
                                customTarget: #{grdBinMove}
                            }
                      }
                    );
                }
         }
         
         function btnAccept_Click()
           {
                Ext.net.DirectMethod.request('btnAccept_Click', {
                        url: location.href,
                        params: {datStartDATE : Ext.util.Format.date(#{datStartDATE}.getValue(), 'Ymd'),
                                datCopyDATE : Ext.util.Format.date(#{datCopyDATE}.getValue(), 'Ymd')
                                 },
                        eventMask: {
                            showMask: true,
                            msg: "자료를 복사중입니다...",
                            target: "customtarget",
                            customTarget: #{grdBinMove}
                        }
                        });
                
           }
        </script>
    </ext:XScript>

    <ext:Store ID="stoCodeList" runat="server">
        <Model>
            <ext:Model ID="Model10" runat="server">
                <Fields>                    
                    <ext:ModelField Name="CDCODE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CDCODENM"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>

   <ext:Store ID="stoSKCodeList" runat="server">
        <Model>
            <ext:Model ID="Model1" runat="server">
                <Fields>                    
                    <ext:ModelField Name="CDCODE"  Type="String"></ext:ModelField>
                    <ext:ModelField Name="CDCODENM"  Type="String"></ext:ModelField>
                </Fields>
            </ext:Model>
        </Model>      
   </ext:Store>
    <!--BIN 상태 리스트-->
    <Store>
        <ext:Store ID="stoBinStatus" runat="server">
            <Model>
                <ext:Model ID="Model5" runat="server">
                    <Fields>
                        <ext:ModelField Name="SDATE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SBINNO"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SJUNILQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SIPGOQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SEPGOQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SEPCHQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SCHULQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SINCDECQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SJEGOQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SSURQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SGOKJONG"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SGOKJONGNM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SWONSAN"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SWONSANNM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SHANGCHA"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SHANGCHANM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SHWGCODE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SIPDATE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SCLDATE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SBINSTATUS"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SCHGN"  Type="Boolean">
                            <Convert FormatHandler="true" Handler="return stoChul_FormatHandler(value);"></Convert>
                        </ext:ModelField>
                        <ext:ModelField Name="SSOSOK"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SSOSOKNM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SMEMO"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SAVECHK"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SCORPGUBN"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="BRCORPGUBN"  Type="String"></ext:ModelField>
                    </Fields>
                </ext:Model>
            </Model>
        </ext:Store>
    </Store>
    <!--BIN 상태 합계-->
    <Store>
        <ext:Store ID="stoBinMoveTotal" runat="server">
            <Model>
                <ext:Model ID="Model2" runat="server">
                    <Fields>
                        <ext:ModelField Name="SDATE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SBINNO"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SJUNILQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SIPGOQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SEPGOQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SEPCHQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SCHULQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SINCDECQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SJEGOQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SSURQTY"  Type="Float"></ext:ModelField>
                        <ext:ModelField Name="SGOKJONG"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SGOKJONGNM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SWONSAN"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SWONSANNM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SHANGCHA"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SHANGCHANM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SHWGCODE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SIPDATE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SCLDATE"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SBINSTATUS"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SCHGN"  Type="Boolean"></ext:ModelField>
                        <ext:ModelField Name="SSOSOK"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SSOSOKNM"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SMEMO"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SAVECHK"  Type="String"></ext:ModelField>
                        <ext:ModelField Name="SCORPGUBN"  Type="String"></ext:ModelField>
                    </Fields>
                </ext:Model>
            </Model>
        </ext:Store>
    </Store>
    <ext:Viewport ID="vptBinMove" runat="server" Layout="BorderLayout">
        <Items>

            <ext:Panel ID="grdBinMove" runat="server" Height = "710" Region="Center">
                <TopBar>
                    <ext:Toolbar ID="Toolbar3" runat="server">
                        <Items>
                            <ext:ToolbarSpacer ID="ToolbarSpacer9" runat="server" Width="10"></ext:ToolbarSpacer>
                            <ext:Panel ID="Panel5" runat="server" Layout="HBoxLayout"   Border="false" Margin="5">
                               <LayoutConfig>
                                      <ext:HBoxLayoutConfig Align="Middle"></ext:HBoxLayoutConfig>
                               </LayoutConfig>
                            <Items> 
                                 <ext:Button ID="Button4" runat="server" Icon="ResultsetPrevious" >
                                        <Listeners>
                                            <Click Handler = "DateMove(1);" ></Click>
                                        </Listeners>
                                </ext:Button>
                                <ext:ToolbarSpacer ID="ToolbarSpacer1" runat="server" Width="2"></ext:ToolbarSpacer>
                                <ext:DateField ID="dtpDATE" runat="server" Width = "110" Format="yyyy-MM-dd">
                                   <Listeners>
                                       <Blur  Handler ="CalendarSelect(item);"></Blur>
                                       <Change Handler ="CalendarSelect(item);"></Change>
                                       <SpecialKey Handler="if (e.getKey() == e.ENTER) { CalendarSelect(item); } " />
                                   </Listeners>
                                </ext:DateField>
                                <ext:ToolbarSpacer ID="ToolbarSpacer2" runat="server" Width="2"></ext:ToolbarSpacer>
                                <ext:Button ID="Button5" runat="server" Icon="ResultsetNext">
                                        <Listeners>
                                            <Click Handler = "DateMove(2);" ></Click>
                                        </Listeners>
                                   </ext:Button>    
                             </Items>
                            </ext:Panel>

                            <ext:ToolbarSpacer ID="ToolbarSpacer8" runat="server" Width="3"></ext:ToolbarSpacer>

                            <ext:ComboBox ID="cboGUBN" NAME = "cboGUBN" runat="server" Editable="false" FieldLabel="회사구분" LabelWidth="60" width="180">
                                <Items>
                                    <ext:ListItem Text="전체" Value="A" AutoDataBind ="true" Index ="0" />
                                    <ext:ListItem Text="그레인터미널" Value="T" AutoDataBind ="true" Index ="1" />
                                    <ext:ListItem Text="평택싸이로" Value="P" AutoDataBind ="true" Index ="2" />
                                </Items>
                                <SelectedItems>
                                    <ext:ListItem Text="그레인터미널" Value="T"></ext:ListItem>
                                </SelectedItems>
                            </ext:ComboBox>

                            <ext:ToolbarSpacer ID="ToolbarSpacer12" runat="server" Width="3"></ext:ToolbarSpacer>

                            <ext:Checkbox ID="chbRTGUBN" runat="server" FieldLabel="임대BIN 포함" Checked="true" LabelWidth="90" width="120">
                            </ext:Checkbox>

                            <ext:ToolbarSpacer ID="ToolbarSpacer15" runat="server" Width="3"></ext:ToolbarSpacer>
                            <ext:ToolbarFill ID="ToolbarFill3" runat="server"></ext:ToolbarFill>
                            <ext:ToolbarSeparator ID="ToolbarSeparator6"  runat="server"></ext:ToolbarSeparator>

                            <ext:Button ID="Button3" runat="server" Icon="Find" Text="조회">
                                <Listeners>
                                    <Click Handler = "UP_run()">                                   
                                    </Click>
                                </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator8"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="Button2" runat="server" Text="저장" Icon="DatabaseSave" Margins = "0 0 0 0">
                                     <Listeners>
                                        <Click Handler = "btnClientSave_Click()">                                   
                                        </Click>
                                    </Listeners>
                            </ext:Button>
                            <ext:ToolbarSeparator ID="ToolbarSeparator2"  runat="server"></ext:ToolbarSeparator>
                            <ext:Button ID="Button1" runat="server" Text="복사" Icon="CdrGo" Margins = "0 0 0 0">
                                 <DirectEvents>
                                   <Click OnEvent="btnCopy_Click">                                   
                                   </Click>
                                 </DirectEvents>                            
                            </ext:Button>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                <Content>
                    <div id="wrapper1">      
                          <!--컨텐츠시작-->
                          <div id="container" class="btm_bx">
                          
                             
                             <%--그리드 표현 --%>
                             <div id="tab_SP_Board"></div>
                                      
                          </div>
                          <!--//컨텐츠끝-->                          

                        </div>   
                </Content>
            </ext:Panel>       

            <ext:Panel ID="grdBinMoveTotal" HideHeaders = "true" runat="server" Height = "35" Region= "South"  >                
                <Content>
                    <div id="Div1">      
                          <div id="Div2" class="btm_bx">
                             <%--그리드 표현 --%>
                             <div id="tab_SP_Total"></div>
                          </div>
                        </div>   
                </Content>
            </ext:Panel>       
        </Items>
    </ext:Viewport>        
    
    <ext:Window ID="winBinStatus" runat="server" CloseAction="Hide" Hidden="true" Width="1000" Height="320" Modal="true" AutoScroll="false" Constrain="true">
        <Items>
           <ext:Panel ID="Panel1" runat="server"  Region="North" Height="300"   BodyPadding="1" DefaultAnchor="100%" >
                    <TopBar>
                        <ext:Toolbar ID="Toolbar1" runat="server">
                            <Items>                                
                                <ext:DateField ID="dtpSDATE" runat="server" FieldLabel="기준일자"  LabelWidth ="60" Width = "160" Format="yyyy-MM-dd"></ext:DateField>
                                <ext:ToolbarFill ID="ToolbarFill1" runat="server"></ext:ToolbarFill>
                                <ext:ToolbarSeparator ID="ToolbarSeparator4"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnSave" runat="server" Text="저장" Icon="DatabaseSave"  >
                                    <Listeners>
                                        <Click Fn="btnWinSav_Click"></Click>
                                    </Listeners>
                                </ext:Button>
                                <ext:ToolbarSeparator ID="ToolbarSeparator7"  runat="server"></ext:ToolbarSeparator>
                                <ext:Button ID="btnClose" runat="server" Text="닫기" Icon="Decline"  >
                                    <Listeners>
                                        <Click Handler="#{winBinStatus}.hide();" />
                                    </Listeners>
                                </ext:Button>     
                                <ext:ToolbarSeparator ID="ToolbarSeparator5"  runat="server"></ext:ToolbarSeparator>
                        </Items>
                    </ext:Toolbar>
                </TopBar>
                    <Items>                        
                           <ext:Panel ID="Panel4"  runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:TriggerField ID="txtSBINNO" runat = "server" Margins="0 1 0 0" FieldLabel = "BIN" width = "140" LabelWidth ="40" MaxLength ="6" EnforceMaxLength ="true" TabIndex = "1" EnableKeyEvents ="true">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(1);"></TriggerClick>
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:ToolbarSpacer ID="ToolbarSpacer3" runat="server" Width="3"></ext:ToolbarSpacer>
                                    <ext:TriggerField ID="txtSGOKJONG" runat = "server" Margins="0 1 0 0" FieldLabel = "곡종" width = "120" LabelWidth ="40" MaxLength ="2" EnforceMaxLength ="true" TabIndex = "2" EnableKeyEvents ="true">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(2);"></TriggerClick>
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:TextField ID="txtSGOKJONGNM" runat="server" Width="100" Margins="0 1 0 0" > </ext:TextField>
                                    <ext:ToolbarSpacer ID="ToolbarSpacer4" runat="server" Width="3"></ext:ToolbarSpacer>
                                    <ext:TriggerField ID="txtSWONSAN" runat = "server" Margins="0 1 0 0" FieldLabel = "원산지" width = "120" LabelWidth ="50" MaxLength ="2" EnforceMaxLength ="true" TabIndex = "3" EnableKeyEvents ="true">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(3);"></TriggerClick>
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:TextField ID="txtSWONSANNM" runat="server" Width="100" Margins="0 1 0 0" > </ext:TextField>
                                    <ext:ToolbarSpacer ID="ToolbarSpacer5" runat="server" Width="3"></ext:ToolbarSpacer>
                                    <ext:TriggerField ID="txtSHANGCHA" runat = "server" Margins="0 1 0 0" FieldLabel = "항 차" width = "150" LabelWidth ="40" MaxLength ="7" EnforceMaxLength ="true" TabIndex = "4" EnableKeyEvents ="true">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(4);"></TriggerClick>
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:TextField ID="txtSHANGCHANM" runat="server" Width="100" Margins="0 1 0 0" > </ext:TextField>
                                 </Items>
                           </ext:Panel>      
                                                                                            
                           <ext:Panel ID="Panel10"  runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                   <ext:ComboBox ID="cboSCHGN" runat="server" Editable="false" FieldLabel="출고구분" LabelWidth="60" width="140" ReadOnly="true">
                                        <Items>
                                            <ext:ListItem Text="Y" Value="Y" />
                                            <ext:ListItem Text="" Value="" />
                                        </Items>
                                        <SelectedItems>
                                            <ext:ListItem Text="Y" Value="Y"></ext:ListItem>
                                        </SelectedItems>
                                    </ext:ComboBox>
                                    <ext:ToolbarSpacer ID="ToolbarSpacer10" runat="server" Width="3"></ext:ToolbarSpacer>
                                    <ext:TriggerField ID="txtSSOSOK" runat = "server" Margins="0 1 0 0" FieldLabel = "협 회" width = "120" LabelWidth ="50" MaxLength ="1" EnforceMaxLength ="true" TabIndex = "5" EnableKeyEvents ="true">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(6);"></TriggerClick>
                                        </Listeners>
                                    </ext:TriggerField>   
                                    <ext:TextField ID="txtSSOSOKNM" runat="server" Width="100" Margins="0 1 0 0" > </ext:TextField>
                                    <ext:ToolbarSpacer ID="ToolbarSpacer13" runat="server" Width="3"></ext:ToolbarSpacer>
                                    <ext:TriggerField ID="txtSHWGCODE" runat = "server" Margins="0 1 0 0" FieldLabel = "원산지/곡종" width = "180" LabelWidth ="80" MaxLength ="14" EnforceMaxLength ="true" TabIndex = "6" EnableKeyEvents ="true">
                                        <Triggers>
                                            <ext:FieldTrigger Icon="SimpleMagnify"></ext:FieldTrigger>
                                        </Triggers>
                                        <Listeners>
                                            <TriggerClick Handler="trgP_CODE_ClientTriggerClick(5);"></TriggerClick>
                                        </Listeners>
                                    </ext:TriggerField>   
                                 </Items>
                             </ext:Panel>

                             <ext:Panel ID="Panel20"  runat="server" Layout="HBoxLayout" Height="30" Padding="3" Border="false">
                                 <Items>
                                    <ext:DateField ID="dtpSIPDATE" runat="server" FieldLabel="입고일자"  LabelWidth ="60" Width = "170" Format="yyyy-MM-dd" TabIndex = "7"></ext:DateField>
                                    <ext:ToolbarSpacer ID="ToolbarSpacer17" runat="server" Width="10"></ext:ToolbarSpacer>
                                    <ext:DateField ID="dtpSCLDATE" runat="server" FieldLabel="BIN청소일"  LabelWidth ="80" Width = "180" Format="yyyy-MM-dd" TabIndex = "8"></ext:DateField>
                                    <ext:ToolbarSpacer ID="ToolbarSpacer11" runat="server" Width="3"></ext:ToolbarSpacer>
                                    <ext:TextField ID="txtSMEMO" runat="server" FieldLabel="특기사항" LabelWidth ="60" Width = "350" Margins="0 10 0 0" TabIndex = "9"></ext:TextField>
                                 </Items>
                           </ext:Panel>     

                           <ext:GridPanel ID="grdEdit" runat="server" Height = "170" Width = "870" >
                                <Store>
                                    <ext:Store ID="stoBinStatusEdit" runat="server">
                                        <Model>
                                            <ext:Model ID="Model3" runat="server">
                                                <Fields>
                                                    <ext:ModelField Name="SDATE"  Type="String"></ext:ModelField>
                                                    <ext:ModelField Name="SBINNO"  Type="String"></ext:ModelField>
                                                    <ext:ModelField Name="SJUNILQTY"  Type="Float"></ext:ModelField>
                                                    <ext:ModelField Name="SIPGOQTY"  Type="Float"></ext:ModelField>
                                                    <ext:ModelField Name="SEPGOQTY"  Type="Float"></ext:ModelField>
                                                    <ext:ModelField Name="SEPCHQTY"  Type="Float"></ext:ModelField>
                                                    <ext:ModelField Name="SCHULQTY"  Type="Float"></ext:ModelField>
                                                    <ext:ModelField Name="SINCDECQTY"  Type="Float"></ext:ModelField>
                                                    <ext:ModelField Name="SJEGOQTY"  Type="Float"></ext:ModelField>
                                                    <ext:ModelField Name="SSURQTY"  Type="Float"></ext:ModelField>
                                                </Fields>
                                            </ext:Model>
                                        </Model>
                                    </ext:Store>
                                </Store>
                                <ColumnModel>
                                    <Columns >
                                        <ext:Column ID="Column45" runat="server" Text="재고관리(M/T)">
                                            <Columns>
                                                <ext:Column ID="Column46" runat="server" DataIndex="SJUNILQTY" Text="전일재고" Align="Right" Width="100" Height="25">
                                                    <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>
                                                </ext:Column>                        
                                                <ext:Column ID="Column47" runat="server" DataIndex="SIPGOQTY" Text="입고량" Align="Right" Width="100">
                                                    <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>
                                                </ext:Column>                        
                                                <ext:Column ID="Column48" runat="server" DataIndex="SEPGOQTY" Text="이고入" Align="Right" Width="100">
                                                    <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>
                                                </ext:Column>                        
                                                <ext:Column ID="Column49" runat="server" DataIndex="SEPCHQTY" Text="이고出" Align="Right" Width="100">
                                                        <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>
                                                </ext:Column>                        
                                                <ext:Column ID="Column50" runat="server" DataIndex="SCHULQTY" Text="출고량" Align="Right" Width="100">
                                                        <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>
                                                </ext:Column>         
                                                <ext:ComponentColumn ID="ComponentColumn2" runat="server" DataIndex="SINCDECQTY" Text="증감량" Align="Right" Width="120"  Editor="true">
                                                        <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>                                
                                                        <Component>           
                                                                <ext:TextField ID="TextField2"  FieldStyle="text-align:right;font-size:15px;" runat ="server" >
                                                                    <Listeners>                                                                                        
                                                                        <Focus Handler ="this.selectText();"></Focus>
                                                                    </Listeners>                                           
                                                                </ext:TextField>
                                                        </Component>
                                                </ext:ComponentColumn>               
                                                <ext:Column ID="Column51" runat="server" DataIndex="SJEGOQTY" Text="재고량" Align="Right" Width="100">
                                                        <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>
                                                </ext:Column>                        
                                                <ext:ComponentColumn ID="ComponentColumn1" runat="server" DataIndex="SSURQTY" Text="마감재고량(M/T)" Align="Right" Width="150"  Editor="true">
                                                        <Renderer Handler="return FormatZero(value, '0,000.000');" ></Renderer>                                
                                                        <Component>           
                                                                <ext:TextField ID="TextField1"  FieldStyle="text-align:right;color:red;font-size:15px;" runat ="server" ReadOnly="true">
                                                                    <Listeners>                                                                                        
                                                                        <Focus Handler ="this.selectText();"></Focus>
                                                                    </Listeners>                                           
                                                                </ext:TextField>
                                                        </Component>
                                                </ext:ComponentColumn>
                                            </Columns>
                                        </ext:Column>
                                    </Columns>
                                </ColumnModel>
                            </ext:GridPanel> 
                    </Items>
           </ext:Panel>
        </Items>
        <Listeners>
           <Hide Handler = "winBinStatushide()" >
           </Hide>
        </Listeners>
    </ext:Window>


     <ext:Window ID="WinDateCopy" runat="server" CloseAction="Hide" Hidden="true" width="600" Height = "100" Padding ="5" modal ="true">
        <items>
            <ext:Panel ID="Panel2" runat="server" Layout = "HBoxLayout" Region ="North" Height = "38">
                <LayoutConfig>
                    <ext:HBoxLayoutConfig Align="Middle"></ext:HBoxLayoutConfig>
                </LayoutConfig>
                <Items>
                     <ext:DateField ID="datStartDATE" runat="server" FieldLabel="기준일자" Margins="0 0 0 5" Editable = "true" Width = "170" LabelWidth="60" MaxLength ="10" EnforceMaxLength ="true" TabIndex = "15" EnableKeyEvents = "true" Format="yyyy-MM-dd">
                        <Listeners>
                            <Blur Handler = "#{datStartDATE}.setValue(Get_Date(#{datStartDATE}));"></Blur>
                        </Listeners>
                        <Listeners>
                            <SpecialKey handler = "if (e.getKey() == e.ENTER) {#{datStartDATE}.setValue(DateCheck(#{datStartDATE}));}"></SpecialKey>
                        </Listeners>
                     </ext:DateField>
                     <ext:Label ID="Label3" runat="server" Icon = "BulletGo"  Margins="0 0 0 10" ></ext:Label>
                     <ext:DateField ID="datCopyDATE" runat="server" FieldLabel="복사일자" Margins="0 0 0 5" Editable = "true" Width = "170" LabelWidth="60" MaxLength ="10" EnforceMaxLength ="true" TabIndex = "15" EnableKeyEvents = "true" Format="yyyy-MM-dd">
                        <Listeners>
                            <Blur Handler = "#{datCopyDATE}.setValue(Get_Date(#{datCopyDATE}));"></Blur>
                        </Listeners>
                        <Listeners>
                            <SpecialKey handler = "if (e.getKey() == e.ENTER) {#{datCopyDATE}.setValue(DateCheck(#{datCopyDATE}));}"></SpecialKey>
                        </Listeners>
                    </ext:DateField>

                    <ext:ToolbarFill ID="ToolbarFill2"  runat="server"></ext:ToolbarFill>

                    <ext:Button ID="btnAccept" runat="server" Icon = "Accept" Text="확인" Margins = "0 0 0 0">
                        <Listeners>
                            <Click Handler = "btnAccept_Click();"></Click>
                        </Listeners>
                    </ext:Button>
                    <ext:ToolbarSpacer ID="ToolbarSpacer6"  runat="server" Width="5"></ext:ToolbarSpacer>

                    <ext:Button ID="btnAccept_Close" runat="server" Icon = "Decline" Text="닫기" Margins = "0 0 0 0">
                        <Listeners>
                           <Click Handler="#{WinDateCopy}.hide();" />
                        </Listeners>
                    </ext:Button>

                    <ext:ToolbarSpacer ID="ToolbarSpacer7"  runat="server" Width="5"></ext:ToolbarSpacer>
                </Items>
            </ext:Panel>
        </items>
    </ext:Window>

</asp:Content>