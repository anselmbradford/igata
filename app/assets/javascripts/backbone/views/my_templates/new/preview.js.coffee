class Igata.Views.MyTemplateNewPreview extends Backbone.View
  constructor: ->
    super
    @on 'sourceUrlChanged', @updateSourceUrl
    @on 'infoChanged', @infoChanged
    @render()


  el: '#my_templates_new .preview'

  template: JST['backbone/templates/my_templates/new/preview']

  updateSourceUrl: (url) ->
    @$('.source').text(url)
    matches = url.match(/([\w\.\-]+)\/([\w\.\-]+)(\.git)$/)
    @fetchAddons(matches[1], matches[2])

  infoChanged: (info) ->
    if info.title
      @$('.title').text info.title

    if info.developer_cost
      developer_cost = (parseFloat(info.developer_cost, 10)).toFixed(2)
      dynoCost = $('meta[name=dyno_cost]').attr('content')
      addons_cost = if @addons then @addons.total_cost_in_cents else 0

      @$('.price').html "((2 dynos - 1 free) * $#{$.addCommas (dynoCost / 100)} + $#{addons_cost} )* 1.10 + $#{$.addCommas developer_cost} ="
      @$('.price').append $('<div>',
        text: ('$' + (Math.ceil(parseFloat((2 - 1) * (dynoCost) + addons_cost) * 1.10 + (developer_cost * 100))/100).toFixed(2))
      )

    if info.readme
      if info.readme == ""
        @$('.readme').html $('<p>',
          text: 'Will be parsed from readme.md if present'
        )
      else
        @$('.readme').html markdown.toHTML(info.readme)

  fetchAddons: (owner, repo) ->
    $.ajax "/repositories/addons?owner=#{owner}&repo=#{repo}",
      success: (data, status, xhr) =>
        @addons = data

  render: ->
    @$el.html @template @
