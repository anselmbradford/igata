RSpec.configure do |config|
  config.after(:suite) do
    puts 'Cleaning up the Stripe customers'
    Stripe::Customer.all.data.select { |customer| customer.email == 'other@igata.io' }.each do |customer|
      customer.delete
    end
  end
end
