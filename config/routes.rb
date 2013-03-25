Igata::Application.routes.draw do
  root :to => 'landing#show'
  easy_auth_routes
  dismissible_helpers_routes

  # Template Demos
  get     '/template_demos/:id/status' => 'template_demos_status#show', :as => :template_demos_status
  delete  '/template_demos/:id'        => 'template_demos#destroy',     :as => :template_demo

  # Purchased Templates
  get    '/template_purchases/:id/status' => 'template_purchases_status#show', :as => :template_purchase_status
  delete '/template_purchases/:id'       => 'template_purchases#destroy',     :as => :template_purchase
  get    '/my_purchases'                  => 'template_purchases#index',       :as => :purchased_templates

  # Remote repositories
  get '/repositories/readme'   => 'repositories#readme', :as => :readme_repository
  get '/repositories/addons'   => 'repositories#addons', :as => :addons_repository
  get '/repositories/:service' => 'repositories#index', :as => :repositories

  # MyTemplates
  get    '/my_templates'                  => 'my_templates#index',             :as => :my_templates
  get    '/my_templates/new'              => 'my_templates#new',               :as => :new_template
  post   '/my_templates/new'              => 'my_templates#create'
  get    '/my_templates/:id/edit'         => 'my_templates#edit',              :as => :edit_template
  put    '/my_templates/:id/edit'         => 'my_templates#update'
  delete '/my_templates/:id/edit'         => 'my_templates#destroy'
  get    '/my_templates/:id/clone_status' => 'my_templates_clone_status#show', :as => 'my_template_clone_status'
  get    '/my_templates/:template_id/screenshots/new' => 'screenshots#new',     :as => :new_screenshot
  post   '/my_templates/:template_id/screenshots/new' => 'screenshots#create',  :as => :new_screenshot
  delete '/my_templates/:template_id/screenshots/:id' => 'screenshots#destroy', :as => :screenshot

  # Accounts
  get  '/account/edit' => 'accounts#edit',   :as => :edit_account
  put  '/account/edit' => 'accounts#update'
  get  '/sign_up'      => 'accounts#new',    :as => :sign_up
  post '/sign_up'      => 'accounts#create'

  # Dashboard
  get  '/dashboard' => 'dashboard#show', :as => :dashboard


  pages :about, :contact, :legal, :how_it_works
  get  '/:username' => 'profiles#show', :as => :profile
  get  '/:username/:id' => 'templates#show', :as => :template
  post '/:username/:id/purchase'     => 'template_purchases#create',  :as => :purchase_template
  get  '/:username/:id/can_purchase' => 'template_purchases#can_purchase',  :as => :can_purchase_template
  post '/:username/:id/demo'         => 'template_demos#create',      :as => :demo_template
  get  '/:username/:id/can_demo'     => 'template_demos#can_demo',    :as => :can_demo_template
end
