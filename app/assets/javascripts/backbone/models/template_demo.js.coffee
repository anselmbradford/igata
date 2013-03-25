class Igata.Models.TemplateDemo extends Backbone.Model
  url: ->
    "/template_demos/#{@id}/status"

  pollForUpdate: ->
    if @.get('state') != 'deployed' and @.get('state') != 'failed' and @get('state') != 'expired' and moment(@.get('created_at')) >= moment().subtract('minutes', 5)
      @fetch()
      setTimeout =>
        @pollForUpdate()
      , 500
    else
      @trigger('complete')
      @url = ->
        "/template_demos/#{@id}"

class Igata.Collections.TemplateDemos extends Backbone.Collection
  model: Igata.Models.TemplateDemo
