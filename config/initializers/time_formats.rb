{
 :month_and_year => '%m/%Y'
}.each do |format_name, format_string|
  Time::DATE_FORMATS[format_name] = format_string
end
