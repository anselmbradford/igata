class Igata.Views.TemplatesShowDemo extends Backbone.View
  constructor: ->
    super
    @collection = new Igata.Collections.TemplateDemos()
    @childViews = []
    @collection.on 'add', (model, collection) =>
      view = new Igata.Views.TemplateDemo(model: model, form: @$el.find('form'))
      $('ul#deployed_demos').prepend(view.$el)
      @childViews.push view
    @collection.add(@options.json)
    if window.location.hash == '#demo'
      $('#new_template_demo input[value="Demo"]').click()

  el: 'form.new_template_demo'

  events:
    'click input[type="submit"]' : 'assertSignedIn'
    'ajax:success' : 'purchaseTemplate'
    'ajax:error'   : 'handleError'

  assertSignedIn: ->
    $.ajax "#{window.location.pathname}/can_demo",
      error: @handleError

  purchaseTemplate: (event, data, status) ->
    @collection.add(data)
    @childViews[@childViews.length - 1].render()

  handleError: (xhr, e, status) ->
    if xhr.status == 401
      window.location = xhr.getResponseHeader('location')

  render: ->
    for childView in @childViews
      childView.render()

class Igata.Views.TemplateDemo extends Backbone.View
  constructor: ->
    super
    @form = @options.form
    @model.pollForUpdate()
    @model.on 'change', =>
      @update()
    @model.on 'complete', =>
      $('#new_template_demo form input [type="submit"]')
      if @model.get('state') == 'deployed'
        window.open @model.get('web_url'),'_blank'
      @setTimer()

  update: ->
    if @previousState != @model.get('state')
      @render()
    else if @model.get('state') == 'deploying'
      @$('.title').text @model.get('app_name') if @model.get('app_name')
      $statusDiv = @$('.status')
      atBottom = !(20 + $statusDiv.height() + $statusDiv.prop('scrollTop') - $statusDiv.prop('scrollHeight'))
      messages = _.difference @model.get('state_messages'), @currentStateMessages
      @currentStateMessages = @model.get('state_messages')
      for message in messages
        @$('.status ul').append $ '<li>',
          text: message
      $statusDiv.animate({ scrollTop: $statusDiv.prop('scrollHeight') }, 500) if atBottom

  setTimer: =>
    $time_left = @$el.find('.time_left')
    if moment() < moment(new Date @model.get('valid_until'))
      $time_left.countdown
        format: 'MS'
        until: new Date(@model.get('valid_until'))
        layout: '{mn}:{snn} left'
        onExpiry: @setExpiredState
    else
      $time_left.text 'Expired'

  setExpiredState: =>
    $time_left = @$el.find('.time_left')
    @$el.removeClass('deployed').addClass('expired')
    $time_left.text('Expired')

    $app = @$el.find('.app')
    $app.find('a').removeAttr 'href'
    $app.prepend $('<a>',
      class: 'remove'
      html: '&times;'
    )

  tagName: 'li'
  id: =>
    "deployed_demo_#{@model.id}"
  className: 'deployed_demo'

  events:
    'click .remove' : 'remove'

  template: JST['backbone/templates/deployed_demo']

  remove: (event) =>
    event.preventDefault()
    @model.destroy()
    @$el.slideUp()

  render: ->
    super
    @$el.html(@template @)
    @previousState = @model.get('state')
    @currentStateMessages = @model.get('state_messages') || []
    @$el.addClass @previousState
    @setTimer()
    $statusDiv = @$('.status')
    $statusDiv.animate({ scrollTop: $statusDiv.prop('scrollHeight') }, 500)
    @
