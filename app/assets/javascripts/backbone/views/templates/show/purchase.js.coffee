class Igata.Views.TemplatesShowPurchase extends Backbone.View
  constructor: ->
    super
    @collection = new Igata.Collections.TemplatePurchases()
    @childViews = []
    @collection.on 'add', (model, collection) =>
      view = new Igata.Views.TemplatePurchase(model: model, form: @$el.find('form'))
      $('ul#deployed_templates').prepend(view.$el)
      $('ul#deployed_templates .purchasing').remove()
      @childViews.push view
    @collection.add(@options.json)
    if window.location.hash == '#purchase'
      $('#new_template_purchase input[value="Purchase"]').click()

  el: 'form.new_template_purchase'

  events:
    'click input[type="submit"]' : 'checkCreditCard'
    'ajax:before'  : 'purchasingSpinner'
    'ajax:success' : 'purchaseTemplate'
    'ajax:error'   : 'handleError'

  checkCreditCard: ->
    $.ajax "#{window.location.pathname}/can_purchase",
      error: @handleError

  purchasingSpinner: ->
    purchasingElement =  $('<li>',
      class: 'purchasing deployed_template deploying'
    ).append($ '<span>',
      class: 'title'
      text: 'Purchasing...'
    ).append($ '<img>',
      src: '/assets/ajax-loader.gif'
    )

    $('ul#deployed_templates').prepend purchasingElement
  flashTemplate: JST['backbone/templates/flash']

  purchaseTemplate: (event, data, status) ->
    @collection.add(data)
    @childViews[@childViews.length - 1].render()
    @displayFlash()

  displayFlash: ->
    flash = $ @flashTemplate
      key: 'notice'
      message: "You have successfully purchased this template"
    $('header').after flash
    setTimeout ->
      flash.slideUp()
    , 7000

    flash.on 'click', ->
      $(@).slideUp()


  handleError: (xhr, e, status) ->
    if xhr.status == 401 || xhr.status == 402
      window.location = xhr.getResponseHeader('location')

  render: ->
    for childView in @childViews
      childView.render()

class Igata.Views.TemplatePurchase extends Backbone.View
  constructor: ->
    super
    @form = @options.form
    @model.pollForUpdate()
    @model.on 'change', =>
      @update()
    @model.on 'complete', =>
      $('#new_template_purchase form input[type="submit"]')
        .attr('disabled', null)
        .removeClass('confirm')
        .removeClass('processing')
        .val('Purchase')
      if @model.get('state') == 'deployed'
        window.open @model.get('web_url'),'_blank'

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

  tagName: 'li'
  id: =>
    "deployed_template_#{@model.id}"
  className: 'deployed_template'

  template: JST['backbone/templates/deployed_template']

  render: ->
    super
    @$el.html(@template @)
    @previousState = @model.get('state')
    @currentStateMessages = @model.get('state_messages') || []
    @$el.addClass @previousState
    $statusDiv = @$('.status')
    $statusDiv.animate({ scrollTop: $statusDiv.prop('scrollHeight') }, 500)
    @
  events:
    'click .remove' : 'remove'

  confirmedDeletion: (enteredValue) =>
    if enteredValue == @model.get('app_name')
      @model.destroy()
      @$el.slideUp()

  remove: (event) ->
    event.preventDefault()
    if @model.get('state') == 'deployed'
      if @confirmationView
        @confirmationView.$el.slideDown()
      else
        @confirmationView = new Igata.Views.TemplatesShowDestroyConfirmation
          model: @model
        @$el.append(@confirmationView.render().$el.hide())
        @confirmationView.$el.slideDown()
        @confirmationView.on 'confirmed', @confirmedDeletion
    else
      @confirmedDeletion @model.get('app_name')
