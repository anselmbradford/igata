class MyTemplatesCloneStatusController < AuthenticatedController
  def show
    @template = Template.find params[:id]

    render :json => { :state => @template.state, :summary => @template.state_summary, :message => @template.state_message }
  end
end
