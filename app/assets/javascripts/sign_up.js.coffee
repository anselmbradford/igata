$ ->
  $('a.heroku-help').click (event) ->
    event.preventDefault()
    $('#heroku-help-info').slideToggle()
