class window.Main
  $ = null
  resize = null
  #constructor: (__$) -> $ = __$
  @init: (__$) ->
    $ = __$
    $("#resetparambtn").on "click", @setDefaultValuesHandler
    $("#gobtn").on "click", @goClickHandler

    # Install resize handlers
    $("#input").on "mousedown",  (e) =>
      resize = setInterval resizeEvent, 67  # 15 fps
    $("#input").on "mouseup",  (e) =>
      clearInterval(resize) if resize?
      resizeEvent()  # trigger it one last time

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
    $("#nbminlen").val("5");
    $("#nbmaxlen").val("8");
    # $("#alphabet").val("0123456789abcdefghijklmnopqrstuvwxyzAZERTYUIOPMLKJHGFDSQWXCVBN!&/*+<>-;,.\#()[]{}\\'\"@_$%:?")
    $("#alphabet").val("234789abcdefghijkmnopqrstuvwxyzAZERTYPMLKJHFDQWXCBN234789abcdefghijkmnopqrstuvwxyzAZERTYPMLKJHFDQWXCBN!&/*+<>-;,.()@_$%?")

  @goClickHandler= =>
    opts = @getOpts()
    PwdGenerator.init($)
    gen = new PwdGenerator(opts)
    msg = gen.checkParams()
    if msg != true
      alert("Erreur dans les contraintes : #{msg}")
      return
    text = @getInput().map (line) =>
      processLine(line, gen, opts)
    @setOutput text

    #text = @getInput()
    #marked = window.marked
    #text = marked(text.join("\n"))
    #$("fieldset").first().html(text);

  @getOpts= ->
    opts = {}
    for key in [ "nbnumber", "nblower", "nbupper", "nbspecial", "nbminlen",
                 "nbmaxlen", "alphabet", "selectseparator", "checkboxfirstnamefirst" ]
      node = $("##{key}");
      if key.startsWith("checkbox")
        val = node.is(":checked")
      else
        val = node.val()
        val = parseInt(val) if key.startsWith("nb")
      opts[key] = val
    return opts

  ###
    Return a [] of the strings in #input, the strings are trimmed
    empty strings removed
  ###
  @getInput= ->
    aIn = $("#input").val().toLowerCase().split("\n").map(String.trim)
    aIn.filter (line) ->
      return line.length>0

  ###
    Return a [] of the strings in #input, the strings are trimmed
  ###
  @setOutput= (text) ->
    text = text.join("\n")
    $("#output").val(text)


  processLine = (line, gen, opts) =>
    sep = opts["selectseparator"]
    line = splitInTwo(line, sep).map(String.trim)

    # ne garde que les lettres et le tiret
    regexp = /[^a-z\-]/g;
    prenom = line[1-Number(opts["checkboxfirstnamefirst"])];
    nom    = line[Number(opts["checkboxfirstnamefirst"])];
    pass   = gen.createOne()

    prenom ?= ""
    nom    ?= ""
    prenom  = removeAccents(prenom)
    nom     = removeAccents(nom)
    prenom  = prenom.replace(regexp, "");
    nom     = nom.replace(regexp, "");

    return "#{prenom}.#{nom} #{pass}"

  ###
    return a string split by a separator
  ###
  splitInTwo = (line, sep) ->
    i = line.indexOf(sep)
    return [ line ] if (i is -1) or (sep is "")
    return [ line.slice(0,i), line.slice(i+1) ]
