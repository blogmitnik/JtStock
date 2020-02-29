/*!
 * Ladda for jQuery
 * http://lab.hakim.se/ladda
 * MIT licensed
 *
 * Copyright (C) 2015 Hakim El Hattab, http://hakim.se
 */
!function(A,t){if(void 0===t)return console.error("jQuery required for Ladda.jQuery");var e=[];t=t.extend(t,{ladda:function(t){"stopAll"===t&&A.stopAll()}}),t.fn=t.extend(t.fn,{ladda:function(i){var n=e.slice.call(arguments,1);return"bind"===i?(n.unshift(t(this).selector),A.bind.apply(A,n)):t(this).each(function(){var e,r=t(this);void 0===i?r.data("ladda",A.create(this)):(e=r.data("ladda"),e[i].apply(e,n))}),this}})}(this.Ladda,this.jQuery);