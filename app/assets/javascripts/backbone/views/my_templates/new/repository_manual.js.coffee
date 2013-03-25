class Igata.Views.MyTemplatesNewRepositoryManual extends Igata.Views.Step
  constructor: ->
    super
    @$el.append @nextStepButton()

  progressToInfo: (event) =>
    event.preventDefault()

    @trigger 'selectRepository', @$('#manual_uri').val()

    app.router.navigate '/title-and-price',
      trigger: true

  clearInputs: ->
    @$('#manual_uri').attr('name', '')

  nextStepButton: ->
    link = $ '<a>',
      href: '#'
      text: 'Set Title and Price'
      class: 'btn btn-info'
      click: @progressToInfo

  el: '.manual'

  render: ->
    super
    @$('#manual_uri').attr('name', 'template[uri]')
    @$('.error').remove()
