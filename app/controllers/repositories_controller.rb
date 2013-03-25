class RepositoriesController < AuthenticatedController
  def index
    if params[:service] == 'github'
      if current_account.github_identity
        github_access_token = current_account.github_identity.get_access_token
        begin
          repos = GithubRepository.retrieve_user_repositories github_access_token
          render :json => repos
        rescue OAuth2::Error => e
          render :json => { :message => e.message }, :status => 403
        end
      else
        render :json => { :message => 'No Github Identity'}, :status => 412
      end
    end
  end

  def readme
    client = Github.new :oauth_token => current_user.github_identity.token
    readme_response = client.repos.contents.readme params[:owner], params[:repo]

    if readme_response.content.present?
      render :json => {:readme_contents => Base64.decode64(readme_response.content)}
    else
      render :json => {:readme_contents => '' }
    end
  end

  def addons
    client = Github.new :oauth_token => current_user.github_identity.token
    begin
      igata_yml_response = client.repos.contents.get params[:owner], params[:repo], '.igata.yml'
      igata_yml_contents = YAML.safe_load Base64.decode64(igata_yml_response.content)

      if addon_names = igata_yml_contents['addons']

        addons = addon_names.map { |addon_name| Addon.find_by_name! addon_name }

        render :json => {:addons => addons.map { |addon| { :name => addon.name, :cost_in_cents => addon.monthly_cost_in_cents} }, :total_cost_in_cents => addons.map(&:monthly_cost_in_cents).sum }
      else
        render :json => {:addons => [], :cost_in_cents => 0 }
      end
    rescue Github::Error::NotFound
      render :json => {:addons => [], :cost_in_cents => 0 }, :status => :not_found
    end
  end
end
