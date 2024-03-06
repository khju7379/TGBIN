/********************************************************************************************
* 기본 공통 Function을 관리하는 Script JS
* 생성일 : 2012-01-04
* 생성자 : 진정보시스템(주) 장경환
********************************************************************************************/

/********************************************************************************************
* 변수 정의
********************************************************************************************/
// 탭패널의 최대 탭 갯수를 정의한다.
var _MAX_TABPANEL_LENGTH = 20;

// 할일의 수를 정의한다.
var _TODO_COUNT = 0;

/********************************************************************************************
*   작성목적    : 모바일기기 여부
********************************************************************************************/
function GetIsMobile() {
    var rtnValue = false;
    /*
    if (navigator.userAgent.match(/iPhone|iPad|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null
                || navigator.userAgent.match(/LG|SAMSUNG|Samsung/) != null) {
        rtnValue = true;
    } */

    if (navigator.userAgent.match(/iPhone|iPad|Mobile|UP.Browser|Android|BlackBerry|Windows CE|Nokia|webOS|Opera Mini|SonyEricsson|opera mobi|Windows Phone|IEMobile|POLARIS/) != null) {
        rtnValue = true;
    }

    return rtnValue;
}

/********************************************************************************************
*   작성목적    : url로 이동(IFRAME인 경우 부모창을 URL로 이동)
********************************************************************************************/
function GoPage(url) {
    if (parent != null) {
        parent.location.href = url;
    }
    else {
        location.href = url;
    }
}

/********************************************************************************************
*   함수명      : rowMerge(value, meta, record, rowIndex, colIndex, store, obj)
*   작성목적    : 그리드 RowMerge시 RowMerge할 컬럼의 Renderer에 사용된다.
*   작성자      : 장세현
*   최초작성일  : 2013-02-07
*   최종작성일  :
*   수정내역    :
********************************************************************************************/
function rowMerge(value, meta, record, rowIndex, colIndex, store, obj) {
    var first = !rowIndex || value !== store.getAt(rowIndex - 1).get(obj.columns[colIndex].dataIndex),
                    last = rowIndex >= store.getCount() - 1 || value !== store.getAt(rowIndex + 1).get(obj.columns[colIndex].dataIndex);
    meta.tdCls += 'row-span' + (first ? ' row-span-first' : '') + (last ? ' row-span-last' : '');
    if (first) {
        var i = rowIndex + 1;
        while (i < store.getCount() && value === store.getAt(i).get(obj.columns[colIndex].dataIndex)) {
            i++;
        }
        var rowHeight = 22,
                        height = (rowHeight * (i - rowIndex)) + 'px',
                        width = obj.columns[colIndex].getWidth() + 'px';
        //        meta.style = 'height:' + height + ';line-height:' + height + ';width:' + width + ';';
        //meta.style = 'height:' + height + '; width:' + width + '; offsetTop:0px;';
        meta.style = "height:" + height + "; width:" + width + "; top:" + (rowHeight * rowIndex) + "px;";
    }
    else {
        var i = rowIndex - 1;
        while (i > -1 && value === store.getAt(i).get(obj.columns[colIndex].dataIndex)) {
            i--;
        }
        if (i % 2 == 0) {
            meta.tdCls += ' row-span-during1';
        }
        else {
            meta.tdCls += ' row-span-during0';

        }
    }

    if (rowIndex == 0) {
        for (var i = 0; i < obj.columns.length; i++) {
            obj.columns[i].setHeight(22);
        }
    }

    return first ? value : '';
}

/********************************************************************************************
*   함수명      : rowMergeByFontColor(value, meta, record, rowIndex, colIndex, store, obj)
*   작성목적    : 
********************************************************************************************/
function rowMergeByFontColor(value, meta, record, rowIndex, colIndex, store, obj) {
    var first = !rowIndex || value !== store.getAt(rowIndex - 1).get(obj.columns[colIndex].dataIndex),
                    last = rowIndex >= store.getCount() - 1 || value !== store.getAt(rowIndex + 1).get(obj.columns[colIndex].dataIndex);
    if (first) {
    }
    else {
        meta.style = "color:#ffffff;";
    }

    return first ? value : '';
}

/********************************************************************************************
*   함수명      : winAttDown_Show(docno)
*   작성목적    : 첨부다운로드 창 오픈 시 문서번호 전달
*   작성자      : 장세현
*   최초작성일  : 2013-02-07
*   최종작성일  :
*   수정내역    :
********************************************************************************************/
function winAttDown_Show(docno) {
    var dowloadUrl = "";
    //    if (_ApplicationPath) {
    //        dowloadUrl = _ApplicationPath + "/Resources/Attach/Attach_Download.aspx";
    //    } else {
    dowloadUrl = "../Attach/Attach_Download.aspx";
    //}
    App.winAtt_Download.show();
    App.winAtt_Download.loader.url = dowloadUrl + "?docno=" + docno;
    App.winAtt_Download.reload();
}

/********************************************************************************************
*   함수명      : winAttDelete_Show(docno)
*   작성목적    : 첨부삭제 창 오픈 시 문서번호 전달
*   작성자      : 장세현
*   최초작성일  : 2013-02-07
*   최종작성일  :
*   수정내역    :
********************************************************************************************/
function winAttDelete_Show(docno) {
    var deleteUrl = "";
    if (_ApplicationPath) {
        dowloadUrl = _ApplicationPath + "/Resources/Attach/Attach_Download.aspx";
    } else {
        dowloadUrl = "../Attach/Attach_Download.aspx";
    }
    App.winAtt_Delete.show();
    App.winAtt_Delete.loader.url = deleteUrl + "?docno=" + docno;
    App.winAtt_Delete.reload();
}


/********************************************************************************************
*   작성목적    : 첨부파일 추가시 발생 이벤트
*   파라미터    : file : 추가한 파일경로
*   수정내역    :
********************************************************************************************/
var show_file;
function file_onchange(file, nfile, no) {
    var file_name = file.getValue();  //file.value.split("\\");
    var file_ext = file_name.split(".")[1];

    if (file_name.indexOf("^") > 0) {
        Ext.MessageBox.alert("확인", "파일명이나 경로에 '^' 문자가 있어 첨부할 수 없습니다.");
        file.reset();
        return;
    }

    document.getElementById("file_name").innerHTML += "<div id='file_name" + no + "' style='width:500px; padding-top:5px;'>" +
                                                                  "    <img src='/B2B/Resources/Images/Ext/" + file_ext + ".gif' style='vertical-align:middle;' />" +
                                                                  "    <span style='width:490px;'>" + file_name + "</span>" +
                                                                  "    <img src='/B2B/Resources/Images/Icons/" + "RemoveContact.gif' style='cursor:pointer; float:right; vertical-align:middle; padding-top:4px;' onclick='imgDel_Click(this.parentNode, " + no + ");' />" +
                                                                  "</div>";

    file.hide();

    if (App.bodyContents_fufAtt1.getRawValue() == "") {
        App.bodyContents_fufAtt1.show();
        show_file = 1;
    } else if (App.bodyContents_fufAtt2.getRawValue() == "") {
        App.bodyContents_fufAtt2.show();
        show_file = 2;
    } else if (App.bodyContents_fufAtt3.getRawValue() == "") {
        App.bodyContents_fufAtt3.show();
        show_file = 3;
    } else if (App.bodyContents_fufAtt4.getRawValue() == "") {
        App.bodyContents_fufAtt4.show();
        show_file = 4;
    } else if (App.bodyContents_fufAtt5.getRawValue() == "") {
        App.bodyContents_fufAtt5.show();
        show_file = 5;
    } else if (App.bodyContents_fufAtt6.getRawValue() == "") {
        App.bodyContents_fufAtt6.show();
        show_file = 6;
    } else if (App.bodyContents_fufAtt7.getRawValue() == "") {
        App.bodyContents_fufAtt7.show();
        show_file = 7;
    } else if (App.bodyContents_fufAtt8.getRawValue() == "") {
        App.bodyContents_fufAtt8.show();
        show_file = 8;
    } else if (App.bodyContents_fufAtt9.getRawValue() == "") {
        App.bodyContents_fufAtt9.show();
        show_file = 9;
    } else if (App.bodyContents_fufAtt10.getRawValue() == "") {
        App.bodyContents_fufAtt10.show();
        show_file = 10;
    } else {
        Ext.MessageBox.alert("확인", "파일첨부는 10개까지만 가능합니다.");
    }
}

/********************************************************************************************
*   작성목적    : 추가한 첨부파일 삭제 이벤트
*   파라미터    : file : 추가한 파일의 ID
*   수정내역    :
********************************************************************************************/
function imgDel_Click(fileName, no) {
    if (no == 1) {
        App.bodyContents_fufAtt1.show();
        App.bodyContents_fufAtt1.reset();
    } else if (no == 2) {
        App.bodyContents_fufAtt2.show();
        App.bodyContents_fufAtt2.reset();
    } else if (no == 3) {
        App.bodyContents_fufAtt3.show();
        App.bodyContents_fufAtt3.reset();
    } else if (no == 4) {
        App.bodyContents_fufAtt4.show();
        App.bodyContents_fufAtt4.reset();
    } else if (no == 5) {
        App.bodyContents_fufAtt5.show();
        App.bodyContents_fufAtt5.reset();
    } else if (no == 6) {
        App.bodyContents_fufAtt6.show();
        App.bodyContents_fufAtt6.reset();
    } else if (no == 7) {
        App.bodyContents_fufAtt7.show();
        App.bodyContents_fufAtt7.reset();
    } else if (no == 8) {
        App.bodyContents_fufAtt8.show();
        App.bodyContents_fufAtt8.reset();
    } else if (no == 9) {
        App.bodyContents_fufAtt9.show();
        App.bodyContents_fufAtt9.reset();
    } else if (no == 10) {
        App.bodyContents_fufAtt10.show();
        App.bodyContents_fufAtt10.reset();
    }

    if (show_file == 1) {
        App.bodyContents_fufAtt1.hide();
    } else if (show_file == 2) {
        App.bodyContents_fufAtt2.hide();
    } else if (show_file == 3) {
        App.bodyContents_fufAtt3.hide();
    } else if (show_file == 4) {
        App.bodyContents_fufAtt4.hide();
    } else if (show_file == 5) {
        App.bodyContents_fufAtt5.hide();
    } else if (show_file == 6) {
        App.bodyContents_fufAtt6.hide();
    } else if (show_file == 7) {
        App.bodyContents_fufAtt7.hide();
    } else if (show_file == 8) {
        App.bodyContents_fufAtt8.hide();
    } else if (show_file == 9) {
        App.bodyContents_fufAtt9.hide();
    } else if (show_file == 10) {
        App.bodyContents_fufAtt10.hide();
    }

    show_file = no;
    fileName.removeNode(fileName.id);
}

/********************************************************************************************
*   작성목적    : 파일선택 이벤트
*   파라미터    : file_path : 다운로드할 파일의 경로, file_name : 다운로드할 파일명, server : Web.Config에 정의된 FTP 서버 명(기본 "FTP11")
*   수정내역    :
********************************************************************************************/
function file_Download(file_path, file_name, server) {
    var MENU_NO = "L00";
    var url;
    if (window.location.search.split("MENU_NO=").length == 2) {
        MENU_NO = window.location.search.split("MENU_NO=")[1].split("&")[0];
    }
    url = "/B2B/Resources/Attach/FileDownload.aspx?filepath=" + escape(file_path) + "&filename=" + escape(file_name) + "&MENU_NO=" + MENU_NO;
    if (server != undefined && server != null) {
        url += "&server=" + server;
    }

    window.open(url, "download", "width=200, height=200");
}

/********************************************************************************************
*   작성목적    : 삭제버튼 클릭 이벤트
*   파라미터    : file_path : 삭제할 파일의 경로
*   수정내역    :
********************************************************************************************/
function file_Delete(file_path, seq_no, file_no) {
    Ext.MessageBox.confirm('확인', '첨부파일을 삭제하시겠습니까?',
        function (rtn) {
            if (rtn == "yes") {
                if (file_path != "") {
                    Ext.net.DirectMethod.request('btnDel_Click', { url: location.href, params: { file_path: file_path, seq_no: seq_no, file_no: file_no} });
                }
                else {
                    Ext.MessageBox.alert('확인', '파일명이 없습니다.');
                }
            }
        }
    );
}

function reload() {
    window.App.winAtt_Delete.reload();
}

function getPrint(html) {
    var winPrint = window.open("", "print", "toolbar=0, location=0, status=0, menubar=0, resizable=no, scrollbars=yes, width=700px,height=600px");
    winPrint.document.write('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
    winPrint.document.write('<html>');
    winPrint.document.write('<head>');
    winPrint.document.write('<link id="ext-theme" href="/B2B/extjs/resources/css/ext-all-embedded-css/ext.axd?v=6480" rel="stylesheet" type="text/css" _nodup="30804"/>');
    winPrint.document.write('<link href="/B2B/extnet/resources/css/extnet-all-embedded-css/ext.axd?v=6480" rel="stylesheet" type="text/css" _nodup="30804"/>');
    winPrint.document.write('<link rel="Stylesheet" href="/B2B/Resources/Styles/Common.css" />');
    winPrint.document.write('<script type="text/javascript" src="/B2B/Resources/Scripts/jquery.min.js"></script>');
    winPrint.document.write('<script type="text/javascript" src="/B2B/Resources/Scripts/jquery-ui.min.js"></script>');
    winPrint.document.write('<script type="text/javascript" src="/B2B/Resources/Scripts/Common.js"></script>');
    winPrint.document.write('</head><body>');
    winPrint.document.write(html);
    winPrint.document.write('</body></html>');
    winPrint.document.write('<script>window.print();</script>');
    winPrint.document.close();
}
