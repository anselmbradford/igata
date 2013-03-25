class Igata.Views.MyTemplateEditForm extends Backbone.View
  constructor: ->
    super
    @model.on 'change', =>
      @render()
    @model.on 'complete', =>
      @enableControls()
    @model.pollForUpdate()

  el: '#my_templates_edit'

  events:
    'click .git-action' : 'triggerGitAction'
    'keyup #template_uri' : 'disableGitActions'

  disableGitActions: ->
    @$('.git-action').addClass 'disabled'

  enableControls: =>
    state = @model.get 'state'
    $cloneBtn = @$('#clone-repo')
    $pullBtn  = @$('#pull-repo')
    $uriField = @$('#template_uri')
    if 2000 <= state < 3000
      $cloneBtn.addClass('hidden')
      $uriField.after($('<p>',
        text: $uriField.val()
      ))
      $uriField.remove()
      $pullBtn.removeClass('disabled')
              .removeClass('hidden')
    else if 3000 <= state < 4000
      $cloneBtn.addClass('hidden')
      $pullBtn.addClass('disabled')
              .removeClass('hidden')
    else if 4000 <= state < 6000
      $cloneBtn.removeClass('hidden')
               .removeClass('disabled')
      $uriField.removeAttr('readonly')
      $pullBtn.addClass('disabled')
              .addClass('hidden')
    else
      $cloneBtn.addClass('hidden')
               .addClass('disabled')
      $pullBtn.removeClass('disabled')
              .removeClass('hidden')

  triggerGitAction: (event) =>
    event.preventDefault()
    @$('#template_uri').attr 'readonly', 'readonly'
    $target = $ event.target
    unless $target.hasClass('disabled')
      $target.addClass 'disabled'
      $.ajax
        url:     $target.attr('href')
        success: @gitActionSuccess
        error:   @gitActionError

  gitActionSuccess: (data, textStatus, jqXHR) =>
    @model.set(data)
    @model.pollForUpdate()

  gitActionError: (jqXHR, textStatus, errorThrown) =>

  render: ->
    message = @model.get('summary')
    if @model.get('message')
      message = "#{message} - #{@model.get('message')}"
    @$('.clone-status .message').text message

