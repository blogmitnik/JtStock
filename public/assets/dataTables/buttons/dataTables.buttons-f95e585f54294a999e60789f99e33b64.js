/*! Buttons for DataTables 1.2.2
 * ©2016 SpryMedia Ltd - datatables.net/license
 */
!function(t){"function"==typeof define&&define.amd?define(["jquery","datatables.net"],function(e){return t(e,window,document)}):"object"==typeof exports?module.exports=function(e,i){return e||(e=window),i&&i.fn.dataTable||(i=require("datatables.net")(e,i).$),t(i,e,e.document)}:t(jQuery,window,document)}(function(t,e,i,A){"use strict";var n=t.fn.dataTable,s=0,o=0,r=n.ext.buttons,a=function(e,i){i===!0&&(i={}),t.isArray(i)&&(i={buttons:i}),this.c=t.extend(!0,{},a.defaults,i),i.buttons&&(this.c.buttons=i.buttons),this.s={dt:new n.Api(e),buttons:[],listenKeys:"",namespace:"dtb"+s++},this.dom={container:t("<"+this.c.dom.container.tag+"/>").addClass(this.c.dom.container.className)},this._constructor()};t.extend(a.prototype,{action:function(t,e){var i=this._nodeToButton(t);return e===A?i.conf.action:(i.conf.action=e,this)},active:function(e,i){var n=this._nodeToButton(e),s=this.c.dom.button.active,o=t(n.node);return i===A?o.hasClass(s):(o.toggleClass(s,i===A?!0:i),this)},add:function(t,e){var i=this.s.buttons;if("string"==typeof e){for(var A=e.split("-"),n=this.s,s=0,o=A.length-1;o>s;s++)n=n.buttons[1*A[s]];i=n.buttons,e=1*A[A.length-1]}return this._expandButton(i,t,!1,e),this._draw(),this},container:function(){return this.dom.container},disable:function(e){var i=this._nodeToButton(e);return t(i.node).addClass(this.c.dom.button.disabled),this},destroy:function(){t("body").off("keyup."+this.s.namespace);var e,i,A=this.s.buttons.slice();for(e=0,i=A.length;i>e;e++)this.remove(A[e].node);this.dom.container.remove();var n=this.s.dt.settings()[0];for(e=0,i=n.length;i>e;e++)if(n.inst===this){n.splice(e,1);break}return this},enable:function(e,i){if(i===!1)return this.disable(e);var A=this._nodeToButton(e);return t(A.node).removeClass(this.c.dom.button.disabled),this},name:function(){return this.c.name},node:function(e){var i=this._nodeToButton(e);return t(i.node)},remove:function(e){var i=this._nodeToButton(e),A=this._nodeToHost(e),n=this.s.dt;if(i.buttons.length)for(var s=i.buttons.length-1;s>=0;s--)this.remove(i.buttons[s].node);i.conf.destroy&&i.conf.destroy.call(n.button(e),n,t(e),i.conf),this._removeKey(i.conf),t(i.node).remove();var o=t.inArray(i,A);return A.splice(o,1),this},text:function(e,i){var n=this._nodeToButton(e),s=this.c.dom.collection.buttonLiner,o=n.inCollection&&s&&s.tag?s.tag:this.c.dom.buttonLiner.tag,r=this.s.dt,a=t(n.node),l=function(t){return"function"==typeof t?t(r,a,n.conf):t};return i===A?l(n.conf.text):(n.conf.text=i,o?a.children(o).html(l(i)):a.html(l(i)),this)},_constructor:function(){var e=this,A=this.s.dt,n=A.settings()[0],s=this.c.buttons;n._buttons||(n._buttons=[]),n._buttons.push({inst:this,name:this.c.name});for(var o=0,r=s.length;r>o;o++)this.add(s[o]);A.on("destroy",function(){e.destroy()}),t("body").on("keyup."+this.s.namespace,function(t){if(!i.activeElement||i.activeElement===i.body){var A=String.fromCharCode(t.keyCode).toLowerCase();-1!==e.s.listenKeys.toLowerCase().indexOf(A)&&e._keypress(A,t)}})},_addKey:function(e){e.key&&(this.s.listenKeys+=t.isPlainObject(e.key)?e.key.key:e.key)},_draw:function(t,e){t||(t=this.dom.container,e=this.s.buttons),t.children().detach();for(var i=0,A=e.length;A>i;i++)t.append(e[i].inserter),e[i].buttons&&e[i].buttons.length&&this._draw(e[i].collection,e[i].buttons)},_expandButton:function(e,i,n,s){for(var o=this.s.dt,r=0,a=t.isArray(i)?i:[i],l=0,h=a.length;h>l;l++){var c=this._resolveExtends(a[l]);if(c)if(t.isArray(c))this._expandButton(e,c,n,s);else{var u=this._buildButton(c,n);if(u){if(s!==A?(e.splice(s,0,u),s++):e.push(u),u.conf.buttons){var d=this.c.dom.collection;u.collection=t("<"+d.tag+"/>").addClass(d.className),u.conf._collection=u.collection,this._expandButton(u.buttons,u.conf.buttons,!0,s)}c.init&&c.init.call(o.button(u.node),o,t(u.node),c),r++}}}},_buildButton:function(e,i){var A=this.c.dom.button,n=this.c.dom.buttonLiner,s=this.c.dom.collection,r=this.s.dt,a=function(t){return"function"==typeof t?t(r,h,e):t};if(i&&s.button&&(A=s.button),i&&s.buttonLiner&&(n=s.buttonLiner),e.available&&!e.available(r,e))return!1;var l=function(e,i,A,n){n.action.call(i.button(A),e,i,A,n),t(i.table().node()).triggerHandler("buttons-action.dt",[i.button(A),i,A,n])},h=t("<"+A.tag+"/>").addClass(A.className).attr("tabindex",this.s.dt.settings()[0].iTabIndex).attr("aria-controls",this.s.dt.table().node().id).on("click.dtb",function(t){t.preventDefault(),!h.hasClass(A.disabled)&&e.action&&l(t,r,h,e),h.blur()}).on("keyup.dtb",function(t){13===t.keyCode&&!h.hasClass(A.disabled)&&e.action&&l(t,r,h,e)});if("a"===A.tag.toLowerCase()&&h.attr("href","#"),n.tag){var c=t("<"+n.tag+"/>").html(a(e.text)).addClass(n.className);"a"===n.tag.toLowerCase()&&c.attr("href","#"),h.append(c)}else h.html(a(e.text));e.enabled===!1&&h.addClass(A.disabled),e.className&&h.addClass(e.className),e.titleAttr&&h.attr("title",e.titleAttr),e.namespace||(e.namespace=".dt-button-"+o++);var u,d=this.c.dom.buttonContainer;return u=d&&d.tag?t("<"+d.tag+"/>").addClass(d.className).append(h):h,this._addKey(e),{conf:e,node:h.get(0),inserter:u,buttons:[],inCollection:i,collection:null}},_nodeToButton:function(t,e){e||(e=this.s.buttons);for(var i=0,A=e.length;A>i;i++){if(e[i].node===t)return e[i];if(e[i].buttons.length){var n=this._nodeToButton(t,e[i].buttons);if(n)return n}}},_nodeToHost:function(t,e){e||(e=this.s.buttons);for(var i=0,A=e.length;A>i;i++){if(e[i].node===t)return e;if(e[i].buttons.length){var n=this._nodeToHost(t,e[i].buttons);if(n)return n}}},_keypress:function(e,i){var A=function(A,n){if(A.key)if(A.key===e)t(n).click();else if(t.isPlainObject(A.key)){if(A.key.key!==e)return;if(A.key.shiftKey&&!i.shiftKey)return;if(A.key.altKey&&!i.altKey)return;if(A.key.ctrlKey&&!i.ctrlKey)return;if(A.key.metaKey&&!i.metaKey)return;t(n).click()}},n=function(t){for(var e=0,i=t.length;i>e;e++)A(t[e].conf,t[e].node),t[e].buttons.length&&n(t[e].buttons)};n(this.s.buttons)},_removeKey:function(e){if(e.key){var i=t.isPlainObject(e.key)?e.key.key:e.key,A=this.s.listenKeys.split(""),n=t.inArray(i,A);A.splice(n,1),this.s.listenKeys=A.join("")}},_resolveExtends:function(e){var i,n,s=this.s.dt,o=function(i){for(var n=0;!t.isPlainObject(i)&&!t.isArray(i);){if(i===A)return;if("function"==typeof i){if(i=i(s,e),!i)return!1}else if("string"==typeof i){if(!r[i])throw"Unknown button type: "+i;i=r[i]}if(n++,n>30)throw"Buttons: Too many iterations"}return t.isArray(i)?i:t.extend({},i)};for(e=o(e);e&&e.extend;){if(!r[e.extend])throw"Cannot extend unknown button type: "+e.extend;var a=o(r[e.extend]);if(t.isArray(a))return a;if(!a)return!1;var l=a.className;e=t.extend({},a,e),l&&e.className!==l&&(e.className=l+" "+e.className);var h=e.postfixButtons;if(h){for(e.buttons||(e.buttons=[]),i=0,n=h.length;n>i;i++)e.buttons.push(h[i]);e.postfixButtons=null}var c=e.prefixButtons;if(c){for(e.buttons||(e.buttons=[]),i=0,n=c.length;n>i;i++)e.buttons.splice(i,0,c[i]);e.prefixButtons=null}e.extend=a.extend}return e}}),a.background=function(e,i,n){n===A&&(n=400),e?t("<div/>").addClass(i).css("display","none").appendTo("body").fadeIn(n):t("body > div."+i).fadeOut(n,function(){t(this).removeClass(i).remove()})},a.instanceSelector=function(e,i){if(!e)return t.map(i,function(t){return t.inst});var A=[],n=t.map(i,function(t){return t.name}),s=function(e){if(t.isArray(e))for(var o=0,r=e.length;r>o;o++)s(e[o]);else if("string"==typeof e)if(-1!==e.indexOf(","))s(e.split(","));else{var a=t.inArray(t.trim(e),n);-1!==a&&A.push(i[a].inst)}else"number"==typeof e&&A.push(i[e].inst)};return s(e),A},a.buttonSelector=function(e,i){for(var n=[],s=function(t,e,i){for(var n,o,r=0,a=e.length;a>r;r++)n=e[r],n&&(o=i!==A?i+r:r+"",t.push({node:n.node,name:n.conf.name,idx:o}),n.buttons&&s(t,n.buttons,o+"-"))},o=function(e,i){var r,a,l=[];s(l,i.s.buttons);var h=t.map(l,function(t){return t.node});if(t.isArray(e)||e instanceof t)for(r=0,a=e.length;a>r;r++)o(e[r],i);else if(null===e||e===A||"*"===e)for(r=0,a=l.length;a>r;r++)n.push({inst:i,node:l[r].node});else if("number"==typeof e)n.push({inst:i,node:i.s.buttons[e].node});else if("string"==typeof e)if(-1!==e.indexOf(",")){var c=e.split(",");for(r=0,a=c.length;a>r;r++)o(t.trim(c[r]),i)}else if(e.match(/^\d+(\-\d+)*$/)){var u=t.map(l,function(t){return t.idx});n.push({inst:i,node:l[t.inArray(e,u)].node})}else if(-1!==e.indexOf(":name")){var d=e.replace(":name","");for(r=0,a=l.length;a>r;r++)l[r].name===d&&n.push({inst:i,node:l[r].node})}else t(h).filter(e).each(function(){n.push({inst:i,node:this})});else if("object"==typeof e&&e.nodeName){var f=t.inArray(e,h);-1!==f&&n.push({inst:i,node:h[f]})}},r=0,a=e.length;a>r;r++){var l=e[r];o(i,l)}return n},a.defaults={buttons:["copy","excel","csv","pdf","print"],name:"main",tabIndex:0,dom:{container:{tag:"div",className:"dt-buttons"},collection:{tag:"div",className:"dt-button-collection"},button:{tag:"a",className:"dt-button",active:"active",disabled:"disabled"},buttonLiner:{tag:"span",className:""}}},a.version="1.2.2",t.extend(r,{collection:{text:function(t){return t.i18n("buttons.collection","Collection")},className:"buttons-collection",action:function(i,A,n,s){var o=n,r=o.offset(),l=t(A.table().container()),h=!1;t("div.dt-button-background").length&&(h=t("div.dt-button-collection").offset(),t("body").trigger("click.dtb-collection")),s._collection.addClass(s.collectionLayout).css("display","none").appendTo("body").fadeIn(s.fade);var c=s._collection.css("position");if(h&&"absolute"===c)s._collection.css({top:h.top+5,left:h.left+5});else if("absolute"===c){s._collection.css({top:r.top+o.outerHeight(),left:r.left});var u=r.left+s._collection.outerWidth(),d=l.offset().left+l.width();u>d&&s._collection.css("left",r.left-(u-d))}else{var f=s._collection.height()/2;f>t(e).height()/2&&(f=t(e).height()/2),s._collection.css("marginTop",-1*f)}s.background&&a.background(!0,s.backgroundClassName,s.fade),setTimeout(function(){t("div.dt-button-background").on("click.dtb-collection",function(){}),t("body").on("click.dtb-collection",function(e){var i=t.fn.addBack?"addBack":"andSelf";t(e.target).parents()[i]().filter(s._collection).length||(s._collection.fadeOut(s.fade,function(){s._collection.detach()}),t("div.dt-button-background").off("click.dtb-collection"),a.background(!1,s.backgroundClassName,s.fade),t("body").off("click.dtb-collection"),A.off("buttons-action.b-internal"))})},10),s.autoClose&&A.on("buttons-action.b-internal",function(){t("div.dt-button-background").click()})},background:!0,collectionLayout:"",backgroundClassName:"dt-button-background",autoClose:!1,fade:400},copy:function(t,e){return r.copyHtml5?"copyHtml5":r.copyFlash&&r.copyFlash.available(t,e)?"copyFlash":void 0},csv:function(t,e){return r.csvHtml5&&r.csvHtml5.available(t,e)?"csvHtml5":r.csvFlash&&r.csvFlash.available(t,e)?"csvFlash":void 0},excel:function(t,e){return r.excelHtml5&&r.excelHtml5.available(t,e)?"excelHtml5":r.excelFlash&&r.excelFlash.available(t,e)?"excelFlash":void 0},pdf:function(t,e){return r.pdfHtml5&&r.pdfHtml5.available(t,e)?"pdfHtml5":r.pdfFlash&&r.pdfFlash.available(t,e)?"pdfFlash":void 0},pageLength:function(e){var i=e.settings()[0].aLengthMenu,A=t.isArray(i[0])?i[0]:i,n=t.isArray(i[0])?i[1]:i,s=function(t){return t.i18n("buttons.pageLength",{"-1":"Show all rows",_:"Show %d rows"},t.page.len())};return{extend:"collection",text:s,className:"buttons-page-length",autoClose:!0,buttons:t.map(A,function(t,e){return{text:n[e],action:function(e,i){i.page.len(t).draw()},init:function(e,i,A){var n=this,s=function(){n.active(e.page.len()===t)};e.on("length.dt"+A.namespace,s),s()},destroy:function(t,e,i){t.off("length.dt"+i.namespace)}}}),init:function(t,e,i){var A=this;t.on("length.dt"+i.namespace,function(){A.text(s(t))})},destroy:function(t,e,i){t.off("length.dt"+i.namespace)}}}}),n.Api.register("buttons()",function(t,e){e===A&&(e=t,t=A),this.selector.buttonGroup=t;var i=this.iterator(!0,"table",function(i){return i._buttons?a.buttonSelector(a.instanceSelector(t,i._buttons),e):void 0},!0);return i._groupSelector=t,i}),n.Api.register("button()",function(t,e){var i=this.buttons(t,e);return i.length>1&&i.splice(1,i.length),i}),n.Api.registerPlural("buttons().active()","button().active()",function(t){return t===A?this.map(function(t){return t.inst.active(t.node)}):this.each(function(e){e.inst.active(e.node,t)})}),n.Api.registerPlural("buttons().action()","button().action()",function(t){return t===A?this.map(function(t){return t.inst.action(t.node)}):this.each(function(e){e.inst.action(e.node,t)})}),n.Api.register(["buttons().enable()","button().enable()"],function(t){return this.each(function(e){e.inst.enable(e.node,t)})}),n.Api.register(["buttons().disable()","button().disable()"],function(){return this.each(function(t){t.inst.disable(t.node)})}),n.Api.registerPlural("buttons().nodes()","button().node()",function(){var e=t();return t(this.each(function(t){e=e.add(t.inst.node(t.node))})),e}),n.Api.registerPlural("buttons().text()","button().text()",function(t){return t===A?this.map(function(t){return t.inst.text(t.node)}):this.each(function(e){e.inst.text(e.node,t)})}),n.Api.registerPlural("buttons().trigger()","button().trigger()",function(){return this.each(function(t){t.inst.node(t.node).trigger("click")})}),n.Api.registerPlural("buttons().containers()","buttons().container()",function(){var e=t(),i=this._groupSelector;return this.iterator(!0,"table",function(t){if(t._buttons)for(var A=a.instanceSelector(i,t._buttons),n=0,s=A.length;s>n;n++)e=e.add(A[n].container())}),e}),n.Api.register("button().add()",function(t,e){var i=this.context;if(i.length){var A=a.instanceSelector(this._groupSelector,i[0]._buttons);A.length&&A[0].add(e,t)}return this.button(this._groupSelector,t)}),n.Api.register("buttons().destroy()",function(){return this.pluck("inst").unique().each(function(t){t.destroy()}),this}),n.Api.registerPlural("buttons().remove()","buttons().remove()",function(){return this.each(function(t){t.inst.remove(t.node)}),this});var l;n.Api.register("buttons.info()",function(e,i,n){var s=this;return e===!1?(t("#datatables_buttons_info").fadeOut(function(){t(this).remove()}),clearTimeout(l),l=null,this):(l&&clearTimeout(l),t("#datatables_buttons_info").length&&t("#datatables_buttons_info").remove(),e=e?"<h2>"+e+"</h2>":"",t('<div id="datatables_buttons_info" class="dt-button-info"/>').html(e).append(t("<div/>")["string"==typeof i?"html":"append"](i)).css("display","none").appendTo("body").fadeIn(),n!==A&&0!==n&&(l=setTimeout(function(){s.buttons.info(!1)},n)),this)}),n.Api.register("buttons.exportData()",function(t){return this.context.length?c(new n.Api(this.context[0]),t):void 0});var h=t("<textarea/>")[0],c=function(e,i){for(var A=t.extend(!0,{},{rows:null,columns:"",modifier:{search:"applied",order:"applied"},orthogonal:"display",stripHtml:!0,stripNewlines:!0,decodeEntities:!0,trim:!0,format:{header:function(t){return n(t)},footer:function(t){return n(t)},body:function(t){return n(t)}}},i),n=function(t){return"string"!=typeof t?t:(A.stripHtml&&(t=t.replace(/<[^>]*>/g,"")),A.trim&&(t=t.replace(/^\s+|\s+$/g,"")),A.stripNewlines&&(t=t.replace(/\n/g," ")),A.decodeEntities&&(h.innerHTML=t,t=h.value),t)},s=e.columns(A.columns).indexes().map(function(t){var i=e.column(t).header();return A.format.header(i.innerHTML,t,i)}).toArray(),o=e.table().footer()?e.columns(A.columns).indexes().map(function(t){var i=e.column(t).footer();return A.format.footer(i?i.innerHTML:"",t,i)}).toArray():null,r=e.cells(A.rows,A.columns,A.modifier),a=r.render(A.orthogonal).toArray(),l=r.nodes().toArray(),c=s.length,u=c>0?a.length/c:0,d=new Array(u),f=0,p=0,g=u;g>p;p++){for(var m=new Array(c),w=0;c>w;w++)m[w]=A.format.body(a[f],p,w,l[f]),f++;d[p]=m}return{header:s,footer:o,body:d}};return t.fn.dataTable.Buttons=a,t.fn.DataTable.Buttons=a,t(i).on("init.dt plugin-init.dt",function(t,e){if("dt"===t.namespace){var i=e.oInit.buttons||n.defaults.buttons;i&&!e._buttons&&new a(e,i).container()}}),n.ext.feature.push({fnInit:function(t){var e=new n.Api(t),i=e.init().buttons||n.defaults.buttons;return new a(e,i).container()},cFeature:"B"}),a});