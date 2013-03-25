$ ->
  $flash = $('.flash')
  setTimeout ->
    $flash.slideUp()
  , 7000

  $flash.on 'click', ->
    $(@).slideUp()
