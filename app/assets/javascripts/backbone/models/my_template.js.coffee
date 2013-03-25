class Igata.Models.MyTemplate extends Backbone.Model
  url: ->
    "/my_templates/#{@id}/clone_status"

  pollForUpdate: ->
    if @get('state') < 2000
      @fetch()
      setTimeout =>
        @pollForUpdate()
      , 500
    else
      @trigger 'complete'
