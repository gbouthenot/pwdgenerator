(function(){define(["jquery","PwdGenerator","Gb"],function(e,t,n,r){var i,s;return s=t.PwdGenerator,i=function(){function a(){}var t,r,i,o,u=this;return e=null,r=null,a.init=function(t){var n=this;return e=t,e("#resetparambtn").on("click",this.setDefaultValuesHandler),e("#gobtn").on("click",this.goClickHandler),e("#input").on("mousedown",function(e){return r=setInterval(i,67)}),e("#input").on("mouseup",function(e){return r!=null&&clearInterval(r),i()})},i=function(){var t,n;return n=e("#input"),t=e("#output"),t.outerWidth(n.outerWidth()),t.outerHeight(n.outerHeight())},a.setDefaultValuesHandler=function(){return e("#nbnumber").val("1"),e("#nblower").val("1"),e("#nbupper").val("1"),e("#nbspecial").val("1"),e("#nbminlen").val("5"),e("#nbmaxlen").val("8"),e("#alphabet").val("234789abcdefghijkmnopqrstuvwxyzAZERTYPMLKJHFDQWXCBN234789abcdefghijkmnopqrstuvwxyzAZERTYPMLKJHFDQWXCBN!&/*+<>-;,.()@_$%?")},a.goClickHandler=function(){var n,r,i,o;i=a.getOpts(),s.init(e),n=new s(i),r=n.checkParams();if(r!==!0){alert("Erreur dans les contraintes : "+r);return}return o=a.getInput(i).map(function(e){return t(e,n,i)}),a.setOutput(o)},a.getOpts=function(){var t,r,i,s,o,u,a;i={},a=["nbnumber","nblower","nbupper","nbspecial","nbminlen","nbmaxlen","alphabet","selectseparator","checkboxfirstnamefirst"];for(o=0,u=a.length;o<u;o++)t=a[o],r=e("#"+t),n.startsWith(t,"checkbox")?s=r.is(":checked"):(s=r.val(),n.startsWith(t,"nb")&&(s=parseInt(s,10))),i[t]=s;return i},a.getInput=function(){var t;return t=e("#input").val().toLowerCase().split("\n").map(function(e){return n.trim(e)}),t.filter(function(e){return e.length>0})},a.setOutput=function(t){return t=t.join("\n"),e("#output").val(t)},t=function(e,t,r){var i,s,u,a,f,l;return l=r.selectseparator,e=o(e,r).map(function(e){return n.trim(e)}),a=e[1-Number(r.checkboxfirstnamefirst)],s=e[Number(r.checkboxfirstnamefirst)],a==null&&(a=""),s==null&&(s=""),a=n.removeAccents(a),s=n.removeAccents(s),f=/[^a-z\-]/g,a=a.replace(f,""),s=s.replace(f,""),a.length===0&&s.length===0?"":(u=t.createOne(),a.length&&s.length?i=""+a+"."+s:a.length?i=""+a:s.length&&(i=""+s),""+i+" "+u)},o=function(e,t){var n,r;return r=t.selectseparator,t.checkboxfirstnamefirst?n=e.indexOf(r):n=e.lastIndexOf(r),n===-1||r===""?[e]:[e.slice(0,n),e.slice(n+1)]},a}.call(this),{App:i}})}).call(this)