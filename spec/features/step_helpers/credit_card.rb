def fill_in_credit_card
  credit_card = { :number => '4242424242424242', :cvc => '123', :month => 'January', :year => '2014' }
  fill_in 'Card number',       :with => credit_card[:number]
  fill_in 'CVC',               :with => credit_card[:cvc]
  select  credit_card[:month], :from => 'Month'
  select  credit_card[:year],  :from => 'Year'
  credit_card
end
