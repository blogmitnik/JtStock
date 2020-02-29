/*!
 * Ladda
 * http://lab.hakim.se/ladda
 * MIT licensed
 *
 * Copyright (C) 2016 Hakim El Hattab, http://hakim.se
 */
!function(t,A){"object"==typeof exports?module.exports=A(require("spin.js")):"function"==typeof define&&define.amd?define(["spin"],A):t.Ladda=A(t.Spinner)}(this,function(t){"use strict";function A(t){if("undefined"==typeof t)return void console.warn("Ladda button target must be defined.");if(/ladda-button/i.test(t.className)||(t.className+=" ladda-button"),t.hasAttribute("data-style")||t.setAttribute("data-style","expand-right"),!t.querySelector(".ladda-label")){var A=document.createElement("span");A.className="ladda-label",a(t,A)}var e,i=t.querySelector(".ladda-spinner");i||(i=document.createElement("span"),i.className="ladda-spinner"),t.appendChild(i);var n,s={start:function(){return e||(e=o(t)),t.setAttribute("disabled",""),t.setAttribute("data-loading",""),clearTimeout(n),e.spin(i),this.setProgress(0),this},startAfter:function(t){return clearTimeout(n),n=setTimeout(function(){s.start()},t),this},stop:function(){return t.removeAttribute("disabled"),t.removeAttribute("data-loading"),clearTimeout(n),e&&(n=setTimeout(function(){e.stop()},1e3)),this},toggle:function(){return this.isLoading()?this.stop():this.start(),this},setProgress:function(A){A=Math.max(Math.min(A,1),0);var e=t.querySelector(".ladda-progress");0===A&&e&&e.parentNode?e.parentNode.removeChild(e):(e||(e=document.createElement("div"),e.className="ladda-progress",t.appendChild(e)),e.style.width=(A||0)*t.offsetWidth+"px")},enable:function(){return this.stop(),this},disable:function(){return this.stop(),t.setAttribute("disabled",""),this},isLoading:function(){return t.hasAttribute("data-loading")},remove:function(){clearTimeout(n),t.removeAttribute("disabled",""),t.removeAttribute("data-loading",""),e&&(e.stop(),e=null);for(var A=0,i=l.length;i>A;A++)if(s===l[A]){l.splice(A,1);break}}};return l.push(s),s}function e(t,A){for(;t.parentNode&&t.tagName!==A;)t=t.parentNode;return A===t.tagName?t:void 0}function i(t){for(var A=["input","textarea","select"],e=[],i=0;i<A.length;i++)for(var n=t.getElementsByTagName(A[i]),s=0;s<n.length;s++)n[s].hasAttribute("required")&&e.push(n[s]);return e}function n(t,n){n=n||{};var s=[];"string"==typeof t?s=r(document.querySelectorAll(t)):"object"==typeof t&&"string"==typeof t.nodeName&&(s=[t]);for(var o=0,a=s.length;a>o;o++)!function(){var t=s[o];if("function"==typeof t.addEventListener){var r=A(t),a=-1;t.addEventListener("click",function(){var A=!0,s=e(t,"FORM");if("undefined"!=typeof s)if("function"==typeof s.checkValidity)A=s.checkValidity();else for(var o=i(s),l=0;l<o.length;l++)""===o[l].value.replace(/^\s+|\s+$/g,"")&&(A=!1),"checkbox"!==o[l].type&&"radio"!==o[l].type||o[l].checked||(A=!1),"email"===o[l].type&&(A=/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.test(o[l].value));A&&(r.startAfter(1),"number"==typeof n.timeout&&(clearTimeout(a),a=setTimeout(r.stop,n.timeout)),"function"==typeof n.callback&&n.callback.apply(null,[r]))},!1)}}()}function s(){for(var t=0,A=l.length;A>t;t++)l[t].stop()}function o(A){var e,i,n=A.offsetHeight;0===n&&(n=parseFloat(window.getComputedStyle(A).height)),n>32&&(n*=.8),A.hasAttribute("data-spinner-size")&&(n=parseInt(A.getAttribute("data-spinner-size"),10)),A.hasAttribute("data-spinner-color")&&(e=A.getAttribute("data-spinner-color")),A.hasAttribute("data-spinner-lines")&&(i=parseInt(A.getAttribute("data-spinner-lines"),10));var s=.2*n,o=.6*s,r=7>s?2:3;return new t({color:e||"#fff",lines:i||12,radius:s,length:o,width:r,zIndex:"auto",top:"auto",left:"auto",className:""})}function r(t){for(var A=[],e=0;e<t.length;e++)A.push(t[e]);return A}function a(t,A){var e=document.createRange();e.selectNodeContents(t),e.surroundContents(A),t.appendChild(A)}var l=[];return{bind:n,create:A,stopAll:s}});