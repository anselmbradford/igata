class Igata.Models.GithubOrganization extends Backbone.Model

class Igata.Collections.GithubRepositories extends Backbone.Collection
  model: Igata.Models.GithubOrganization
  url:   '/repositories/github'
