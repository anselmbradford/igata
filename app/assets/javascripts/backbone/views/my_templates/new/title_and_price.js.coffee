class Igata.Views.MyTemplatesNewTitleAndPrice extends Igata.Views.Step
  el: '#new_template .info'

  constructor: ->
    super
    @$el.append @nextStepButton()

  events:
    'change input' : 'inputChanged'
    'keyup textarea' : 'readmeChanged'

  render: ->
    super
    @setTitle()

    github_uri = $('#template_github_api_url').val()
    if github_uri and github_uri != ''
      matches = github_uri.match(/\/([\w\.\-]+)\/([\w\.\-]+)$/)
      @fetchReadme(matches[1], matches[2])

  setTitle: ->
    git_uri = @$el.parent().find('input[name="template[uri]"]').val()
    matches = git_uri.match(/([\w\.\-]+)$/)
    repoName = matches[1] if matches

    if repoName
      repoName = repoName.substr(0, repoName.indexOf('.git')) if repoName.indexOf('.git') > 0
    @$('#template_name').val(repoName).change() if matches

  fetchReadme: (owner, repo) ->
    @$('#template_readme').val('Fetching Readme...').change()
    $.ajax "/repositories/readme?owner=#{owner}&repo=#{repo}",
      success: @fillReadme
      error: =>
        @$('#template_readme').val('')

  fillReadme: (data, status, xhr) =>
    @$('#template_readme').val(data.readme_contents).keyup()




  nextStepButton: ->
    link = $ '<a>',
      href: '#'
      text: 'Upload screenshots'
      class: 'btn btn-info'
      click: @progressToInfo

  inputChanged: (event) =>
    @trigger 'infoChanged',
      title:          @$('#template_name').val()
      developer_cost: @$('#template_developer_cost').val()
      readme:         @$('#template_readme').val()

  readmeChanged: (event) =>
    @trigger 'infoChanged',
      readme: @$('#template_readme').val()

  progressToInfo: (event) =>
    event.preventDefault()
    app.router.navigate '/screenshots ',
      trigger: true
