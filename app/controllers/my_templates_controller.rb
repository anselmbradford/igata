class MyTemplatesController < AuthenticatedController
  before_filter :find_template, :only => [:edit, :update, :destroy]

  def index
    @templates = current_account.templates
  end

  def new
    @template = Template.new
  end

  def update
    if @template.update_attributes(params[:template])
      redirect_to [:edit, @template]
    else
      render :edit
    end
  end

  def create
    @template = current_account.templates.build(params[:template])

    if @template.save
      @template.update_column :state, 1001
      Resque.enqueue(Template, 'clone_repo', @template.id)
      redirect_to my_templates_path, :notice => "Your template, #{@template.name}, has been created"
    else
      render :new
    end
  end

  def destroy
    if @template.destroy
      redirect_to my_templates_path, :notice => "Your template, #{@template.name}, has been deleted"
    else
      render :edit
    end
  end

  private

  def find_template
    @template ||= current_account.templates.find_by_slug!(params[:id])
  end
end
