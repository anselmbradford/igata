class CheckboxListInput < SimpleForm::Inputs::Base
  def input
    lis = collection.inject('') do |html, value|
      html << @builder.template.send(:content_tag, :li) do
        item_html = ''
        item_html << @builder.template.send(:check_box_tag, input_name, value, checked?(value), :id => input_id(value))
        item_html << @builder.template.send(:label_tag, input_id(value), value)
        item_html.html_safe
      end
    end.html_safe
    "<ul>#{lis}</ul>".html_safe
  end

  private

  def collection
    @collection ||= options.delete(:collection)
  end

  def input_name
    "#{@builder.object_name}[#{@attribute_name}][]"
  end

  def input_id(value)
    "#{@builder.object_name.gsub('[','_').gsub(']','')}_#{@attribute_name}_#{value.downcase.gsub(/[\s|-|&|\:]/, '_')}".gsub(/_+/, '_')
  end

  def checked?(value)
    @builder.object.send(@attribute_name).include?(value)
  end
end
