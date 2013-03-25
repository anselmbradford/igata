class DashboardController < AuthenticatedController
  def show
    @templates = Template.all
  end
end
