class StringArrayInput < SimpleForm::Inputs::Base
  include ActionView::Helpers::FormTagHelper
  def input
    array = @builder.object.send(attribute_name)
    input_html = '<ul class="string_array">'
    if array.nil? || array.empty?
      input_html_options.merge!(:id => "#{@builder.object_name}_#{attribute_name}_0", :data => { :index => 0 })
      input_html << '<li>'
      input_html << text_field_tag("#{@builder.object_name}[#{attribute_name}][]",'' ,input_html_options)
      input_html << '</li>'
    else
      array.each_with_index do |value, index|
        input_html_options.merge!(:id => "#{@builder.object_name}_#{attribute_name}_#{index}", :data => { :index => index })
        input_html << '<li>'
        input_html << text_field_tag("#{@builder.object_name}[#{attribute_name}][]", value,input_html_options)
        input_html << '</li>'
      end
    end
    input_html << '</ul>'
    input_html.html_safe
  end
end
