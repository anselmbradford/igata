(
  ($) ->
    removeClick = (event) ->
      event.preventDefault()
      $(event.target).parent().remove()

    addRemoveButton = (node) =>
      $node = $ node
      removeButton = $ '<a>', { href: '#', text: 'Remove', click: removeClick, class: 'btn remove' }
      $node.append removeButton

    addClick = (event) ->
      event.preventDefault()
      $target = $ event.target

      $lastInput = $target.parents('.string_array').find('input').last()
      lastId = $lastInput.attr 'id'
      lastIndex = parseInt $lastInput.attr('data-index'), 10

      newId = lastId.replace lastIndex.toString(), lastIndex + 1
      $newInputNode = $lastInput.parent().clone()
      $newInput = $newInputNode.find 'input'
      $newInput.attr 'data-index', lastIndex + 1
      $newInput.attr 'id', newId
      $newInput.val ''

      $newInputNode.find('a').remove()
      addRemoveButton $newInputNode

      $lastInput.parent().after($newInputNode)

    $.fn.stringArrayField = ->
      for wrapper in @
        for child in wrapper.children
          unless child == wrapper.children[0]
            addRemoveButton child
        $wrapper = $ wrapper
        addButton = $ '<a>', { href: '#', text: 'Add', click: addClick, class: 'btn' }
        $wrapper.append $('<li>', { html: addButton })
)(jQuery)

$ ->
  $('ul.string_array').stringArrayField()
