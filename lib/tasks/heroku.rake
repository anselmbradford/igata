namespace :heroku do
  task :update_addons => :environment do
    Addon.retrieve_from_heroku!
  end
end
