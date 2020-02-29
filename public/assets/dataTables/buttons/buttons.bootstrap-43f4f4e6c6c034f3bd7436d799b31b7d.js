/*! Bootstrap integration for DataTables' Buttons
 * ©2016 SpryMedia Ltd - datatables.net/license
 */
!function(t){"function"==typeof define&&define.amd?define(["jquery","datatables.net-bs","datatables.net-buttons"],function(e){return t(e,window,document)}):"object"==typeof exports?module.exports=function(e,i){return e||(e=window),i&&i.fn.dataTable||(i=require("datatables.net-bs")(e,i).$),i.fn.dataTable.Buttons||require("datatables.net-buttons")(e,i),t(i,e,e.document)}:t(jQuery,window,document)}(function(t){"use strict";var e=t.fn.dataTable;return t.extend(!0,e.Buttons.defaults,{dom:{container:{className:"dt-buttons btn-group"},button:{className:"btn btn-default"},collection:{tag:"ul",className:"dt-button-collection dropdown-menu",button:{tag:"li",className:"dt-button"},buttonLiner:{tag:"a",className:""}}}}),e.ext.buttons.collection.text=function(t){return t.i18n("buttons.collection",'Collection <span class="caret"/>')},e.Buttons});