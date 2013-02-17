define ["Gb", myMods.Random], (Gb)->
  class thismod
    $ = null
    _Random = null

    @init: (__$) ->
      $ = __$

    ###
      @opts: {"nbnumber", "nblower", "nbupper", "nbspecial", "nbspecialmax", "nbmaxlen", "nbminlen", "alphabet", "nbttl", "selectseparator", "checkboxfirstnamefirst", "nbmaxlogin"}
    ###

    constructor: (@opts) ->
      _Random = new window.Random()
      _Random.seed(@opts.randomSeed)

    ###
      return a random integer between min (inclusive) and max (inclusive)
      static function
    ###
    @randomIntBetween: (min, max) ->
      # Returns a random integer between min and max
      # Using Math.round() will give you a non-uniform distribution!
      # source: https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Math/random
      return Math.floor(_Random.random() * (max - min + 1)) + min;

    ###
      return a random string of provided length
      static function
    ###
    @randomString:  (length, alphabet) ->
      size = alphabet.length - 1
      throw "no alphabet" if (size<=0)
      string = ""

      for i in [0...length]
        rnd = thismod.randomIntBetween(0, size)
        c = alphabet[rnd];
        string += c;

      return string;


    checkParams: () ->
      if !(@opts.nbminlen? && 1<=@opts.nbminlen<=16)
        return "Longueur minimale doit être comprise entre 1 et 16"
      if !(@opts.nbmaxlen? && 3<=@opts.nbmaxlen<=16 && @opts.nbminlen<=@opts.nbmaxlen)
        return "Longueur maximale doit être comprise entre 3 et 16, et supérieur à longueur minimale"

      computedMinLen = 0;
      for cont in [ "nbnumber", "nblower", "nbupper", "nbspecial" ]
        # 0 si non spécifié
        @opts[cont] ?= 0
        @opts[cont] = 0 if @opts[cont] is ""
        if (@opts[cont] > @opts.nbmaxlen)
            # cannot satisfy this constraint: it would break the allowed maxlen
            return "La contrainte #{cont} est supérieur à la longueur maximale"
        if (@opts.nbspecial > @opts.nbspecialmax)
            # cannot satisfy this constraint: it would break the allowed maxlen
            return "La contrainte caractères spéciaux max >= min"
        computedMinLen += @opts[cont]

      if computedMinLen > @opts.nbmaxlen
        # contraints wants a minimum length bigger than the allowed maxlen
        return "La longueur maximale ne permet pas de valider toutes les contraintes"

      if @opts.alphabet.length < @opts.nbminlen
        return "alphabet trop petit"

      return true

    createOne: () ->
      len = thismod.randomIntBetween(@opts.nbminlen, @opts.nbmaxlen);
      alphabet = @opts.alphabet;

      aContraintes = [
          {idname:"nbnumber",  alpha:"0123456789"}
          {idname:"nblower",   alpha:"azertyuiopmlkjhgfdsqwxcvbn"}
          {idname:"nbupper",   alpha:"AZERTYUIOPMLKJHGFDSQWXCVBN"}
          {idname:"nbspecial", alpha:"!&/*+<>-;,.#()[]{}#'\"\\@_$%:?"}
      ];

      isValid = null
      contrainteEnforcer = (contrainte) =>
        num = @opts[contrainte.idname];
        alpha = contrainte.alpha;
        return if (num<=0)

        curnum = 0;
        for i in [0...alpha.length]
          curnum += pass.split(alpha[i]).length - 1;

        if (curnum < num)
          isValid = false;

        # une contrainte avec le même nom avec "max" en plus existe ?
        if (@opts[contrainte.idname+"max"])
          if (curnum > @opts[contrainte.idname+"max"])
            isValid = false;

      for iteration in [1...100]
        pass = thismod.randomString(len, alphabet);
        isValid = true;

        # le premier caractère doit être une lettre
        firstchar = pass.substr(0, 1);
        if (!( (firstchar>="A" && firstchar<="Z") || (firstchar>="a" && firstchar<="z") ))
          isValid = false
        else
          # vérifie les contraintes
          Gb.forEach(aContraintes, contrainteEnforcer);

        if (isValid is true)
          # toutes les contraintes sont respectées
          break;

      if (isValid is false)
        throw "Impossible de générer un mot de passe avec les contraintes demandées"

      return pass

  return {"PwdGenerator":thismod};
