class Igata.Views.MyTemplatesNewRepository extends Igata.Views.Step
  constructor: ->
    super
    @githubView = new Igata.Views.MyTemplatesNewRepositoryGithub()
    @manualView = new Igata.Views.MyTemplatesNewRepositoryManual()
    @githubView.on 'selectRepository', @sourceUrlChanged
    @manualView.on 'selectRepository', @sourceUrlChanged

  el: '#new_template .repository'

  render: ->
    super
    @githubView.hide()
    @manualView.hide()
    @showButtons()

  events:
    'click .github-btn' : 'githubRepoClick'
    'click .manual-btn' : 'manualRepoClick'

  sourceUrlChanged: (repositoryUrl) =>
    @trigger 'sourceUrlChanged', repositoryUrl

  githubRepoClick: (event) ->
    event.preventDefault()
    $target = $ event.target
    if $target.attr('data-linked') == 'true'
      app.router.navigate('choose-source/github', {trigger: true})
    else
      window.location.href = '/sign_in/oauth2/github'

  manualRepoClick: (event) ->
    event.preventDefault()
    app.router.navigate('choose-source/manual', {trigger: true})

  renderGithubRepos: ->
    @render()
    @hideButtons()
    @manualView.clearInputs()
    @manualView.hide()
    @githubView.render()

  renderManualRepo: ->
    @render()
    @hideButtons()
    @githubView.clearInputs()
    @githubView.hide()
    @manualView.render()

  hideButtons: ->
    @$('.buttons').hide()

  showButtons: ->
    @$('.buttons').show()
