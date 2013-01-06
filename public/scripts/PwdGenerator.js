(function(){define(["Gb"],function(e,t){var n;return n=function(){function n(e){this.opts=e}var t;return t=null,n.init=function(e){return t=e},n.randomIntBetween=function(e,t){return Math.floor(Math.random()*(t-e+1))+e},n.randomString=function(e,t){var r,i,s,o,u,a;o=t.length-1;if(o<=0)throw"no alphabet";u="";for(i=a=0;0<=e?a<e:a>e;i=0<=e?++a:--a)s=n.randomIntBetween(0,o),r=t[s],u+=r;return u},n.prototype.checkParams=function(){var e,t,n,r,i,s,o,u,a;if(this.opts.nbminlen!=null&&1<=(s=this.opts.nbminlen)&&s<=16){if(this.opts.nbmaxlen!=null&&3<=(o=this.opts.nbmaxlen)&&o<=16&&this.opts.nbminlen<=this.opts.nbmaxlen){e=0,u=["nbnumber","nblower","nbupper","nbspecial"];for(r=0,i=u.length;r<i;r++){t=u[r],(a=(n=this.opts)[t])==null&&(n[t]=0),this.opts[t]===""&&(this.opts[t]=0);if(this.opts[t]>this.opts.nbmaxlen)return"La contrainte "+t+" est supérieur à la longueur maximale";e+=this.opts[t]}return e>this.opts.nbmaxlen?"La longueur maximale ne permet pas de valider toutes les contraintes":this.opts.alphabet.length<this.opts.nbminlen?"alphabet trop petit":!0}return"Longueur maximale doit être comprise entre 3 et 16, et supérieur à longueur minimale"}return"Longueur minimale doit être comprise entre 1 et 16"},n.prototype.createOne=function(){var t,r,i,s,o,u,a,f,l=this;u=n.randomIntBetween(this.opts.nbminlen,this.opts.nbmaxlen),r=this.opts.alphabet,t=[{idname:"nbnumber",alpha:"0123456789"},{idname:"nblower",alpha:"azertyuiopmlkjhgfdsqwxcvbn"},{idname:"nbupper",alpha:"AZERTYUIOPMLKJHGFDSQWXCVBN"},{idname:"nbspecial",alpha:"!&/*+<>-;,.#()[]{}#'\"\\@_$%:?"}],s=null,i=function(e){var t,n,r,i,o,u;i=l.opts[e.idname],t=e.alpha;if(i<=0)return;n=0;for(r=o=0,u=t.length;0<=u?o<u:o>u;r=0<=u?++o:--o)n+=a.split(t[r]).length-1;if(n<i)return s=!1};for(o=f=1;f<100;o=++f){a=n.randomString(u,r),s=!0,e.forEach(t,i);if(s===!0)break}if(s===!1)throw"Impossible de générer un mot de passe avec les contraintes demandées";return a},n}(),{PwdGenerator:n}})}).call(this)