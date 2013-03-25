class Igata.Models.TemplatePurchase extends Backbone.Model
  url: ->
    "/template_purchases/#{@id}/status"

  pollForUpdate: ->
    if @.get('state') != 'deployed' and @.get('state') != 'failed' and moment(@.get('created_at')) >= moment().subtract('minutes', 5)
      @fetch()
      setTimeout =>
        @pollForUpdate()
      , 500
    else
      @trigger('complete')
      @url = ->
        "/template_purchases/#{@id}"

class Igata.Collections.TemplatePurchases extends Backbone.Collection
  model: Igata.Models.TemplatePurchase
