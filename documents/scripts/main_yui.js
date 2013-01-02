/*jshint maxerr:9999 evil:true browser:true prototypejs:false devel:false white:false*/

(function(){
    "use strict";

    if(!('forEach' in Array.prototype)){Array.prototype.forEach=function(a,t){for(var i=0,n=this.length;i<n;i++)if(i in this)a.call(t,this[i],i,this);};}
    if(!('trim' in String.prototype)){String.prototype.trim=function(){return this.replace(/^\s+/,'').replace(/\s+$/,'');};}
    if("undefined"!==typeof(window) && !('console' in window)){window.console={log:function(){}};}

    if (!Array.prototype.forEach || !String.prototype.trim) {
        alert("Cette page utilise des fonctionnalités non prises en charge par votre navigateur. Nous vous conseillons d'utiliser Firefox ou Chrome.");
    }
})();

var Main  = (function () { // doit être lié au constructeur
    "use strict";

    var _params = null;              // private static variable
    var Y = null;

    /**
     * return a random integer between min (inclusive) and max (inclusive)
     */
    var randomIntBetween = function(min, max) {
        // Returns a random integer between min and max
        // Using Math.round() will give you a non-uniform distribution!
        // source: https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Math/random
        return Math.floor(Math.random() * (max - min + 1)) + min;
    };
    
    var randomString = function(length, alphabet) {
        var size = alphabet.length - 1;
        if (size<0) {
            throw "no alphabet";
        }
        var i, rnd, c, string="";
        
        for (i=0; i<length; i++) {
            rnd = randomIntBetween(0, size);
            c = alphabet[rnd];
            string += c;
        }

        return string;
    };
    
    var __construct = function (params) {   // doit être lié à l'initialisateur
        _params = params;    // save the static parameter
        var ulmenu;
    };
    
    __construct.init = function(myY) {
        Y = myY;
    };
    
    __construct.go = function() {
        var gobtn = Y.one("#gobtn");
        gobtn.on("click", function(e){
            var params = {};
            var aIds = [
                {idname:"minlen", type:"i"},
                {idname:"maxlen", type:"i"},
                {idname:"alphabet", type:"s"},
                {idname:"contnumber", type:"i"},
                {idname:"contlower", type:"i"},
                {idname:"contupper", type:"i"},
                {idname:"contspecial", type:"i"}
            ];
            aIds.forEach(function(desc){
                var elem = Y.one("#" + desc.idname);
                var value = elem.get("value");
                if ("i" == desc.type) {
                    value = parseInt(value);
                    if (!Y.Lang.isNumber(value)) {
                        throw desc.idname + " n'est pas un nombre";
                    }
                }
                params[desc.idname] = value;
            });
            if (params.minlen > params.maxlen) {
                throw "minimale est supérieur à maximal";
            }
            var sumCont = params.contnumber + params.contlower + params.contupper + params.contspecial;
            if (params.minlen < sumCont) {
                throw "la taille minimale doit faire au moins " + sumCont + " caractères";
            }
            
            var generator = new Generator(params);
            generator.createOne();
        })
    };
    __construct.randomString     = randomString;
    __construct.randomIntBetween = randomIntBetween;

    return __construct;
})(); // Main



var Generator = (function(){
    "use strict";

    var __construct = function(params) {
        params.minlen = parseInt(params.minlen);
        params.maxlen = parseInt(params.maxlen);
        this.params = params;
        
    };
    
    __construct.prototype.createOne = function() {
        var iteration;
        var pass;
        var p = this.params;
        var len = Main.randomIntBetween(p.minlen, p.maxlen);
        var alphabet = p.alphabet;
        var aContraintes = [
            {idname:"contnumber",  alpha:"0123456789"},
            {idname:"contlower",   alpha:"azertyuiopmlkjhgfdsqwxcvbn"},
            {idname:"contupper",   alpha:"AZERTYUIOPMLKJHGFDSQWXCVBN"},
            {idname:"contspecial", alpha:"!&/*+<>-;,.#()[]{}#'\"\\@_$%:?"}
        ];
        var isValid;

        var contrainteEnforcer = function(contrainte){
            var num = p[contrainte.idname];
            var alpha = contrainte.alpha;
            var curnum = 0;
            var i;
            if (num<=0) { return; }
            
            for (i=0; i<alpha.length; i++) {
                curnum += pass.split(alpha[i]).length - 1;
            }
            if (curnum < num) {
                isValid = false;
            }
        };

        for (iteration=0; iteration<100; iteration++) {
            pass = Main.randomString(len, alphabet);
            isValid = true;
            
            // vérifie les contraintes
            aContraintes.forEach(contrainteEnforcer);
            
            if (true === isValid) {
                break;
            }
        }
        
        if (true !== isValid) {
            throw "Impossible de générer un mot de passe avec les contraintes demandées"
        }
        
        console.log(iteration, pass);
    };
    
    return __construct;
})();


/*
var i,r;
var alpha = "234789abcdefhjkmnpqrstwxyz";
for (i=0; i<10; i++) {
    r = Main.test(5, alpha);
    console.log(r);
}
*/
