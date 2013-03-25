class Igata.Routers.MyTemplateNew extends Backbone.Router
  constructor: ->
    super
    @navigationView    = new Igata.Views.MyTemplateNewNavigation()
    @previewView       = new Igata.Views.MyTemplateNewPreview()
    @repositoryView    = new Igata.Views.MyTemplatesNewRepository()
    @titleAndPriceView = new Igata.Views.MyTemplatesNewTitleAndPrice()
    @screenshotsView   = new Igata.Views.MyTemplatesNewScreenshots()

    @repositoryView.on 'sourceUrlChanged', @sourceUrlChanged
    @titleAndPriceView.on 'infoChanged', @infoChanged

  sourceUrlChanged: (url) =>
    @previewView.trigger 'sourceUrlChanged', url

  infoChanged: (info) =>
    @previewView.trigger 'infoChanged', info

  loaded: false

  views: {}

  routes:
    ''                     : 'index'
    'choose-source'        : 'repository'
    'choose-source/github' : 'repositoryGithub'
    'choose-source/manual' : 'repositoryManual'
    'title-and-price'      : 'titleAndPrice'
    'screenshots'          : 'screenshots'

  index: ->
    @navigate 'choose-source', {trigger: true}

  repository: ->
    @loaded = true
    @navigationView.setActiveNode('choose-source')
    @titleAndPriceView.hide()
    @screenshotsView.hide()
    @repositoryView.render()

  repositoryGithub: ->
    @repository()
    @repositoryView.renderGithubRepos()

  repositoryManual: ->
    @repository()
    @repositoryView.renderManualRepo()

  titleAndPrice: ->
    unless @loaded
      @navigate 'choose-source', {trigger: true}
      return
    @navigationView.setActiveNode('title-and-price')
    @repositoryView.hide()
    @screenshotsView.hide()
    @titleAndPriceView.render()

  screenshots: ->
    unless @loaded
      @navigate 'choose-source', {trigger: true}
      return
    @navigationView.setActiveNode('screenshots')
    @repositoryView.hide()
    @titleAndPriceView.hide()
    @screenshotsView.render()
