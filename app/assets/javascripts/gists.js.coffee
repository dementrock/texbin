# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

showdown_converter = new Showdown.converter()

#alert($('#gist_content').css('height'))

sync_input = (elem1, elem2, action) ->
  #elem1[0].watch "value", (id, old, current) ->
  #  action elem1, elem2
  act = () -> action elem1, elem2
  elem1[0].onchange = act
  elem1[0].onpropertychange = act
  elem1[0].oninput = act
  elem1[0].onkeyup = act
  elem1[0].onkeydown = act
  elem1[0].onkeypress = act
  elem1[0].textInput = act

adjust_size = () ->
  h_title = $('.title').height()
  h_window = $(window).height()
  h_content = parseInt((h_window - h_title) * 0.3)
  h_content = Math.max(h_content, 200)
  $('#gist_content').css('min-height', h_content + 'px').css('height', h_content + 'px')
  $('.textwrapper').css('min-height', h_content + 'px').css('height', h_content + 'px')
  #$('.preview-wrapper').css('min-height', (h_content) + 'px').css('height', h_content + 'px')
  #$('.content-wrapper').css('min-height', (h_content) + 'px').css('height', h_content + 'px')
  #sync_height()

sync_height = () ->
  new_height = Math.max($('.textwrapper').height(), $('.preview-content').height())
  $('.textwrapper').height(new_height)
  $('.preview-wrapper').height(new_height)

update_height = (h) ->
  $('.textwrapper').height(h)
  sync_height()


$(document).ready () ->
  adjust_size()
  #$(window).resize(adjust_size)

  $.fn.TextAreaExpander = (minHeight, maxHeight) ->
    hCheck = not ($.browser.msie or $.browser.opera)
    ResizeTextarea = (e) ->
      e = e.target or e
      vlen = e.value.length
      ewidth = e.offsetWidth
      sync_height()
      if vlen != e or ewidth != e.boxWidth
          if hCheck and (vlen < e.valLength or ewidth != e.boxWidth)
            e.style.height = "0px"
          h = Math.max(e.expandMin, Math.min(e.scrollHeight, e.expandMax))
          #e.style.overflow = if e.scrollHeight > h then "auto" else "hidden"
          e.style.height = h + "px"

          update_height(h)

          e.valLength = vlen
          e.boxWidth = ewidth
      return true
    this.each () ->
      if this.nodeName.toLowerCase() != "textarea"
        return
      p = this.className.match(/expand(\d+)\-*(\ld+)*/i)
      this.expandMin = minHeight or (if p then parseInt('0'+p[1], 10) else 0)
      this.expandMax = maxHeight or (if p then parseInt('0'+p[2], 10) else 99999)
      ResizeTextarea(this)
      if not this.Initialized
        this.Initialized = true
        $(this).css("padding-top", 0).css("padding-bottom", 0)
        $(this).bind("keyup", ResizeTextarea).bind("keydown", ResizeTextarea)

    return this

  MathJax.Hub.Queue(["Typeset",MathJax.Hub])
  if $("#gist_content")[0] != undefined
    #$("#gist_content").TextAreaExpander()
    $("#gist_content").focus()
    sync_input $("#gist_content"), $(".render-texmd"), (elem1, elem2) ->
      $(".render-texmd").html(showdown_converter.makeHtml($("#gist_content").attr("value")))
      #$(".preview-wrapper").height($(".preview-content").height())
      #sync_height()
      MathJax.Hub.Queue(["Typeset",MathJax.Hub])

