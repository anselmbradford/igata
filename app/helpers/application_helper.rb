module ApplicationHelper
  def can_deploy_template?(template)
    if current_account
      current_account.purchased_template?(template) || current_account.templates.exists?(template)
    end
  end

  def render_markdown(content)
    if content.present?
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
      markdown.render(content).html_safe
    end
  end

  def flash_helper
    flash.keys.inject('') do |html, key|
      html << render(:partial => 'shared/flash', :locals => { :key => key, :message => flash[key] })
    end.html_safe
  end
end
