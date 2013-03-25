class Igata.Views.Step extends Backbone.View
  constructor: ->
    super
    @hide()

  hide: ->
    @$el.hide()

  render: ->
    @$el.show()
