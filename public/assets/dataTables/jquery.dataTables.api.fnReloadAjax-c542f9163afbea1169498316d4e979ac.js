$.fn.dataTableExt.oApi.fnReloadAjax=function(A,t,e,i){"undefined"!=typeof t&&null!=t&&(A.sAjaxSource=t),this.oApi._fnProcessingDisplay(A,!0);var n=this,r=A._iDisplayStart,s=[];this.oApi._fnServerParams(A,s),A.fnServerData(A.sAjaxSource,s,function(t){n.oApi._fnClearTable(A);for(var s=""!==A.sAjaxDataProp?n.oApi._fnGetObjectDataFn(A.sAjaxDataProp)(t):t,o=0;o<s.length;o++)n.oApi._fnAddData(A,s[o]);A.aiDisplay=A.aiDisplayMaster.slice(),n.fnDraw(),"undefined"!=typeof i&&i===!0&&(A._iDisplayStart=r,n.fnDraw(!1)),n.oApi._fnProcessingDisplay(A,!1),"function"==typeof e&&null!=e&&e(A)},A)};