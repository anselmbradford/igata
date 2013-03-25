addCommas = ($) ->
  $.addCommas = (numberString) ->
    numberString += ''
    x = numberString.split('.')
    x1 = x[0]
    if x.length > 1
      x2 = ".#{x[1]}" 
    else
      x2 = ''
    rgx = /(\d+)(\d{3})/
    while (rgx.test(x1))
      x1 = x1.replace(rgx, '$1' + ',' + '$2')
    x1 + x2

addCommas(jQuery)
