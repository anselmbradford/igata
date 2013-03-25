class ScreenshotsInput < SimpleForm::Inputs::Base
  def input
    html = @builder.template.send(:content_tag, :div, :class => 'screenshots') do
      item_html = ""
      count.times do |num|
        item_html << @builder.template.send(:file_field_tag, input_name, :id => input_id(num + 1), :data => {:index => (num + 1)})
      end
      item_html.html_safe
    end.html_safe
  end

  def input_name
    "#{@builder.object_name}[#{@attribute_name}][][image]"
  end

  def count
    @count ||= options.delete(:count)
  end

  def input_id(value)
    value = value.to_s
    "#{@builder.object_name.gsub('[','_').gsub(']','')}_#{@attribute_name}_#{value.downcase.gsub(/[\s|-|&]/, '_')}".gsub(/_+/, '_')
  end
end
