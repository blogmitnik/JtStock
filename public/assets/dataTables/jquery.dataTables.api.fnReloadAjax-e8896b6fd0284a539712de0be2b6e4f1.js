$.fn.dataTableExt.oApi.fnReloadAjax=function(A,t,e,i){"undefined"!=typeof t&&null!=t&&(A.sAjaxSource=t),this.oApi._fnProcessingDisplay(A,!0);var n=this,o=A._iDisplayStart,r=[];this.oApi._fnServerParams(A,r),A.fnServerData(A.sAjaxSource,r,function(t){n.oApi._fnClearTable(A);for(var r=""!==A.sAjaxDataProp?n.oApi._fnGetObjectDataFn(A.sAjaxDataProp)(t):t,s=0;s<r.length;s++)n.oApi._fnAddData(A,r[s]);A.aiDisplay=A.aiDisplayMaster.slice(),n.fnDraw(),"undefined"!=typeof i&&i===!0&&(A._iDisplayStart=o,n.fnDraw(!1)),n.oApi._fnProcessingDisplay(A,!1),"function"==typeof e&&null!=e&&e(A)},A)};