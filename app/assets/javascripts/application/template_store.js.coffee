$ ->
  window.fancyButton = (e) ->
    e.preventDefault()
    $input = $(this)
    text = $input.val()
    oldWidth = $input.outerWidth()
    $input.val('Processing...')
    newWidth = $input.outerWidth()
    $input.val(text)
    .css('width', "#{oldWidth}px")
    setTimeout ->
      $input.addClass('animate')
      .addClass('confirm')
      .css('width', "#{newWidth}px")
      setTimeout ->
        $input.addClass('hideText')
        setTimeout ->
          $input.val('Confirm')
          .removeClass('hideText')
          setTimeout ->
            $input.removeClass('animate')
            .parent('form').one('submit', processForm)
          , 250
        , 250
        $('span.notice').removeClass('hidden')
      , 490
    , 10

  window.processForm = (e) ->
    $input = $(this).find('input[type="submit"]')
    .addClass('processing hideText')
    .attr('disabled', 'disabled')
    setTimeout ->
      $input.val('Processing...')
      .removeClass('hideText')
    , 250

  $('form input.fancy[type="submit"]').one('click', fancyButton)
