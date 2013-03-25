class Igata.Views.MyTemplateNewNavigation extends Backbone.View
  constructor: ->
    super
    @render()

  events:
    'click .disabled'  : 'preventDefault'

  preventDefault: (event) ->
    event.preventDefault()

  el: '#my_templates_new ol.steps'

  template: JST['backbone/templates/my_templates/new/navigation']

  model:
    [
      {
        location: 'choose-source'
        name:     'Choose source'
        number:   1
      }
      {
        location: 'title-and-price'
        name:     'Title & Price'
        number:   2
      }
      {
        location: 'screenshots'
        name:     'Screenshots'
        number:   3
      }
    ]

  setActiveNode: (location) ->
    $activeNode = @$('.active')
    unless location == $activeNode.attr('data-route')
      $activeNode.removeClass 'active'
      $activeNode = @$("li[data-route='#{location}']").addClass('active')
      $activeNode.find('a').removeClass('disabled')

  render: ->
    @$el.html @template @
