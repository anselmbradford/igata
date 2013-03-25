$.rails.allowAction = (element) ->
  message = element.data('confirm')
  answer  = false
  return true if !message

  if $.rails.fire(element, 'confirm')
    reset = $("<input type='reset' value='Cancel' class='btn' data-confirm='#{message}' data-submit-value='#{element.val()}'/>")
    element.removeAttr('data-confirm')
    element.parent().siblings().filter('.notice').text(element.data('confirm')).slideDown()
    element.removeData('confirm')
    element.data('ujs:enable-with', element.val())
    element.before(reset)
    reset.on 'click', (event) ->
      element.attr('data-confirm', $(@).data('confirm'))
      element.val($(@).data('submit-value'))
      element.parent().siblings().filter('.notice').slideUp()
      $(@).remove()
      element.unbind('.purchase')
    element.on 'click.purchase', (event) ->
      reset.remove()
      element.parent().siblings().filter('.notice').slideUp()
      setTimeout =>
        $(@).attr('data-confirm', reset.data('confirm'))
      , 13
      $(@).unbind(event)
    element.val('Confirm')
    callback = $.rails.fire(element, 'confirm:complete', [false])

  return false

$.rails.disableFormElements = (form) ->
  form.find($.rails.disableSelector).each ->
    element = $(@)
    method = if element.is('button') then 'html' else 'val'
    unless element.data('ujs:enable-with')
      element.data('ujs:enable-with', element[method]())
    element[method](element.data('disable-with'))
    element.prop('disabled', true)
