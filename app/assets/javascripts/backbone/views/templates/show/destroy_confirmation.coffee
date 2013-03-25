class Igata.Views.TemplatesShowDestroyConfirmation extends Backbone.View
  className: 'confirmation'
  template: JST['backbone/templates/destroy_confirmation']
  events:
    'keyup .application-name' : 'toggleDestroyButton'
    'click .cancel' : 'cancelClicked'
    'click .destroy' : 'destroyClicked'


  toggleDestroyButton: (event) =>
    $target = $ event.currentTarget

    if $target.val() == @model.get('app_name')
      @$('.destroy').removeClass 'disabled'
    else
      @$('.destroy').addClass 'disabled'

  cancelClicked: ->
    @$el.slideUp()
  destroyClicked: (event)  =>
    $target = $ event.target
    unless $target.hasClass 'disabled'
      @trigger 'confirmed', @$('.application-name').val()

  render: ->
    @$el.html @template @
    @$('.application-name').keyup()
    @
