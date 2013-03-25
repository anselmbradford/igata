class ScreenshotsController < AuthenticatedController
  before_filter :find_template
  before_filter :find_screenshot, :only => [:edit, :update, :destroy]
  def index
    @template = current
  end
  def new
    @screenshot = @template.screenshots.build
  end
  def create
    @screenshot = @template.screenshots.build(params[:screenshot])

    if @screenshot.save
      redirect_to edit_template_path(@template)
    end
  end

  def destroy
    if @screenshot.destroy
      redirect_to edit_template_path(@template)
    end
  end

  private

  def find_template
    @template ||= current_account.templates.find_by_slug!(params[:template_id])
  end

  def find_screenshot
    @screenshot ||= @template.screenshots.find(params[:id])
  end
end
