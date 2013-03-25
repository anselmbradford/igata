class MyTemplatesGitController < AuthenticatedController
  before_filter :find_template

  def create
    @template.update_column(:state, 1001)
    Resque.enqueue(Template, 'clone_repo', @template.id)
    render :json => { :state => @template.state, :summary => @template.state_summary, :message => @template.state_message }
  end

  def update
    @template.update_column(:state, 1002)
    Resque.enqueue(Template, 'pull_repo', @template.id)
    render :json => { :state => @template.state, :summary => @template.state_summary, :message => @template.state_message }
  end

  private

  def find_template
    @template ||= current_account.templates.find(params[:id])
  end
end
