def sleep_for(sleep_time, message = 'Sleeping...')
  sleep_time.times do |i|
    print_message = "#{message} #{sleep_time - i} seconds remaining"
    print print_message
    sleep 1
    print ["\b", " ", "\b"].map { |c| c * print_message.length }.join
  end
end
