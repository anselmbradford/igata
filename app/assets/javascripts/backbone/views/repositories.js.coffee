class Igata.Views.Repositories extends Backbone.View
  el: '.repositories'

  render: ->
    for div in @$el
      unless div == @$el[0]
        $(div).find('ul').hide()

  events:
    'click h4'           : 'titleClick'
    'click a.repository' : 'repositoryClick'

  titleClick: (event) ->
    $div = $(event.target).parent()
    $('.repositories ul').slideUp().removeClass('active')
    $div.find('ul').slideDown().addClass('active')

  repositoryClick: (event) ->
    #event.preventDefault()
    #$form = $('form#new_template')
    #$link = $(event.target)

    #$form.find('#template_name').val($link.text())

    #$form.find('#template_uri').val($link.attr('data-git'))
