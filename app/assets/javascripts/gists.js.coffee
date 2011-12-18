# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

showdown_converter = new Showdown.converter()

sync_input = (elem1, elem2, action) ->
  try
    elem1[0].watch "value", (id, old, current) ->
      action elem1, elem2
  catch e
    act = () -> action elem1, elem2
    elem1[0].onchange = act
    elem1[0].onpropertychange = act
    elem1[0].oninput = act
    elem1[0].onmouseover = act
    elem1[0].onkeyup = act

$(document).ready () ->
  MathJax.Hub.Queue(["Typeset",MathJax.Hub])
  if $("#gist_content")[0] != undefined
    sync_input $("#gist_content"), $(".render-texmd"), (elem1, elem2) ->
      $(".render-texmd").html(showdown_converter.makeHtml($("#gist_content").attr("value")))
      MathJax.Hub.Queue(["Typeset",MathJax.Hub])

