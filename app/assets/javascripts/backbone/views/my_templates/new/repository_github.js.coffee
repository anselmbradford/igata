class Igata.Views.MyTemplatesNewRepositoryGithub extends Igata.Views.Step
  constructor: ->
    super
    @collection = new Igata.Collections.GithubRepositories()
    @collection.on 'sync', @renderRepositories
    @collection.on 'reset', @renderRepositories

  el: '#new_template .repository .github'

  events:
    'click .organization h4 a' : 'toggleOrganization'
    'click li a'               : 'selectRepository'

  render: ->
    @$('#github_uri').attr('name', 'template[uri]')
    @$el.show()
    @collection.fetch
      error: @repositoryFetchFailed


  repositoriesTemplate: JST['backbone/templates/my_templates/new/repositories']

  repositoryFetchFailed: (collection, xhr, options) ->
    if xhr.status == 403
      @$('.repositories').html $('<h3>', {text: 'Access to Github has been revoked'})
        .append($('<a>', {text: 'Reauthenticate', href: '/sign_in/oauth2/github', class: 'btn'}))
    else if xhr.status == 412
      window.location.href = '/sign_in/oauth2/github'
    else
      @$('.repositories').html $('<h3>', {text: 'An error occured retrieving your repoositories from Github'})

  renderRepositories: =>
    $html = $('<div>', {class: 'content'}).append(@repositoriesTemplate(@collection))
    $html.find('.organization ul').hide()
    $html.find('.organization ul').first().show()
    $html.find('.organization').first().addClass 'active'
    @$('.repositories').html $html

  toggleOrganization: (event) ->
    event.preventDefault()
    $target = $ event.target
    $active = @$('.organization.active')

    $parentOrganizationDiv = $target.parents('.organization')
    unless $parentOrganizationDiv.hasClass('active')
      $active.find('ul').slideUp()
      $active.removeClass 'active'
      $parentOrganizationDiv.addClass('active')
      $parentOrganizationDiv.find('ul').slideDown()

  clearInputs: () ->
    @$('input').val('')
    @$('#github_uri').attr('name', '')

  selectRepository: (event) ->
    event.preventDefault()
    $target = $ event.target
    @$('#github_uri').val $target.attr('data-git-url')
    @$('#template_github_organization').val $target.attr('data-organization')
    @$('#template_github_api_url').val $target.attr('data-api-url')

    @trigger 'selectRepository', $target.attr('data-git-url')

    app.router.navigate '/title-and-price',
      trigger: true
