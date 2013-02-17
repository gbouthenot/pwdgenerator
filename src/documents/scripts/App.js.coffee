define ["jquery", "PwdGenerator", "Gb"], ($, PwdGeneratorMod, Gb) ->
  PwdGenerator = PwdGeneratorMod.PwdGenerator;

  class App
    $ = null
    resize = null
    _randomSeed = null

    #constructor: (__$) -> $ = __$
    @init: (__$) ->
      $ = __$
      _randomSeed = +new Date()
      $("#resetparambtn").on "click", @setDefaultValuesHandler
      $("body").delegate "input,textarea,select", {"change":@goClickHandler, "keyup":@goClickHandler},

      # Install resize handlers
      $("#input").on "mousedown",  (e) =>
        resize = setInterval resizeEvent, 67  # 15 fps
      $("#input").on "mouseup",  (e) =>
        clearInterval(resize) if resize?
        resizeEvent()  # trigger it one last time

      # generate passwords
      @goClickHandler();

    resizeEvent = =>
      src = $("#input");
      dst = $("#output");
      dst.outerWidth(src.outerWidth())
      dst.outerHeight(src.outerHeight())

    @setDefaultValuesHandler= =>
      $("#nbnumber").val("1");
      $("#nblower").val("1");
      $("#nbupper").val("1");
      $("#nbspecial").val("1");
      $("#nbspecialmax").val("1");
      $("#nbminlen").val("5");
      $("#nbmaxlen").val("8");
      $("#nbttl").val("365");
      $("#nbmaxlogin").val("20");
      # $("#alphabet").val("0123456789abcdefghijklmnopqrstuvwxyzAZERTYUIOPMLKJHGFDSQWXCVBN!&/*+<>-;,.\#()[]{}\\'\"@_$%:?")
      $("#alphabet").val("234789abcdefghijkmnopqrstuvwxyzAZERTYPMLKJHFDQWXCBN234789abcdefghijkmnopqrstuvwxyzAZERTYPMLKJHFDQWXCBN!&/*+<>-;,.()@_$%?")
      @goClickHandler()

    @goClickHandler= =>
      try
        opts = @getOpts()
        PwdGenerator.init($)
        gen = new PwdGenerator(opts)
        msg = gen.checkParams()
        if msg != true
          throw "Erreur dans les contraintes : #{msg}"
        text = @getInput(opts).map (line) =>
          processLine(line, gen, opts)
        @setOutput text

        #text = @getInput()
        #marked = window.marked
        #text = marked(text.join("\n"))
        #$("fieldset").first().html(text);
      catch e
        $("#output").val e

    @getOpts= ->
      opts = {}
      for key in [ "nbnumber", "nblower", "nbupper", "nbspecial", "nbspecialmax", "nbminlen",
                   "nbmaxlen", "alphabet", "selectseparator", "checkboxfirstnamefirst", "nbttl",
                   "nbmaxlogin" ]
        node = $("##{key}");
        if Gb.startsWith(key, "checkbox")
          val = node.is(":checked")
        else
          val = node.val()
          val = parseInt(val, 10) if Gb.startsWith(key, "nb")
        opts[key] = val
        opts.randomSeed = _randomSeed
      return opts

    ###
      Return a [] of the strings in #input, the strings are trimmed
      empty strings removed
    ###
    @getInput= ->
      aIn = $("#input").val().toLowerCase().split("\n").map (s) ->
        Gb.trim(s)
      aIn.filter (line) ->
        return line.length>0

    ###
      Return a [] of the strings in #input, the strings are trimmed
    ###
    @setOutput= (text) ->
      text = text.join("\n")
      $("#output").val(text)


    processLine = (line, gen, opts) =>
      sep = opts.selectseparator
      line = splitInTwo(line, opts).map (s) ->
        Gb.trim(s)

      prenom = line[1-Number(opts.checkboxfirstnamefirst)];
      nom    = line[Number(opts.checkboxfirstnamefirst)];

      prenom ?= ""
      nom    ?= ""
      prenom  = Gb.removeAccents(prenom)
      nom     = Gb.removeAccents(nom)
      # ne garde que les lettres et le tiret
      regexp = /[^a-z\-]/g;
      prenom  = prenom.replace(regexp, "");
      nom     = nom.replace(regexp, "");

      if (prenom.length == 0 && nom.length == 0)
        return "";

      # génère un mot de passe et crée le login
      pass   = gen.createOne()
      if (prenom.length && nom.length)
        login = "#{prenom}.#{nom}"
      else if (prenom.length)
        login = "#{prenom}"
      else if (nom.length)
        login = "#{nom}"

      # Limite le login à 20 caractères
      login = login.substr(0, opts.nbmaxlogin);

      descriptif = $("#descriptif").val();
      groupe = $("#groupe").val();
      descriptif = descriptif.replace(/\"/, "");

      return "#{login} #{pass} #{opts.nbttl} #{groupe} \"#{descriptif}\""

    ###
      return a string split by a separator
    ###
    splitInTwo = (line, opts) ->
      sep = opts.selectseparator
      if (opts.checkboxfirstnamefirst)
        # prénom en premier: commence à gauche
        i = line.indexOf(sep)
      else
        # nom en premier: commence à droite
        i = line.lastIndexOf(sep)
      return [ line ] if (i is -1) or (sep is "")
      return [ line.slice(0,i), line.slice(i+1) ]

  return {"App":App}
