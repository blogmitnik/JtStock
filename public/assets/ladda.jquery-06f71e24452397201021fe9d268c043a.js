/*!
 * Ladda for jQuery
 * http://lab.hakim.se/ladda
 * MIT licensed
 *
 * Copyright (C) 2015 Hakim El Hattab, http://hakim.se
 */
!function(t,A){if(void 0===A)return console.error("jQuery required for Ladda.jQuery");var e=[];A=A.extend(A,{ladda:function(A){"stopAll"===A&&t.stopAll()}}),A.fn=A.extend(A.fn,{ladda:function(i){var n=e.slice.call(arguments,1);return"bind"===i?(n.unshift(A(this).selector),t.bind.apply(t,n)):A(this).each(function(){var e,s=A(this);void 0===i?s.data("ladda",t.create(this)):(e=s.data("ladda"),e[i].apply(e,n))}),this}})}(this.Ladda,this.jQuery);