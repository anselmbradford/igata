class GithubRepository
  attr_accessor :organization, :git_url, :name, :api_url, :owner_gravatar

  def initialize(repo_json, organization = nil)
    @organization = organization

    @name    = repo_json['name']
    @git_url = repo_json['ssh_url']
    @api_url = repo_json['url']
  end

  def self.retrieve_user_repositories(access_token)
    repos = []


    order = 1
    personal_repos = {:organization => 'Personal', :order => order}
    personal_repos[:repos] = paged_repositories(access_token, 'https://api.github.com/user/repos').sort_by(&:name)
    personal_repos[:image] = access_token.get('https://api.github.com/user').parsed['avatar_url']

    order += 1
    repos << personal_repos

    user_orgs_response  = access_token.get 'https://api.github.com/user/orgs'
    user_orgs_response.parsed.each do |org|
      organization_name = org['login']
      organization_repos = {:organization => org['login'], :order => order, :image => org['avatar_url']}
      organization_repos[:repos] = paged_repositories(access_token, "https://api.github.com/orgs/#{organization_name}/repos", organization_name).sort_by(&:name)

      order +=1
      repos << organization_repos if organization_repos[:repos].count > 0
    end

    repos
  end

  def self.paged_repositories(access_token, url, organization = nil)
    repos_response = access_token.get(url)

    repos = []

    repos_response.parsed.each do |repo|
      repos << self.new(repo, organization)
    end

    if repos_response.headers['link'].present? 
      if next_link = repos_response.headers['link'].split(',').select{|link| link =~ /rel="next"/}.first
        link = next_link.match(/<(.*?)>/)[1]

        repos += paged_repositories(access_token, link, organization)
      end
    end

    repos
  end
end
