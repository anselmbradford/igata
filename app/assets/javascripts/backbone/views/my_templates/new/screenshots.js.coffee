class Igata.Views.MyTemplatesNewScreenshots extends Igata.Views.Step
  el: '#new_template .screenshots'

  constructor: ->
    super
    $fileInputs = @$('input[type="file"]')
    $fileInputs.hide()
    $fileInputs.first().show()

  events:
    'change input[type="file"]' : 'fileUploadChanged'

  fileUploadChanged: (event) ->
    $target = $ event.target
    index = parseInt $target.attr('data-index'), 10

    if $target.val() != ''
      @$("input[type='file'][data-index='#{index + 1}']").show()
