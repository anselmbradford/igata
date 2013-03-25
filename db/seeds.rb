`rm -rf #{Rails.root}/git`
`mkdir -p #{Rails.root}/git/development`

account = Account.create(:name => 'Test Account 1', :username => 'test1', :email => 'test_1@igata.io', :password => 'password', :password_confirmation => 'password')
Account.create(:name => 'Test Account 2', :username => 'test2', :email => 'test_2@igata.io', :password => 'password', :password_confirmation => 'password')
template = account.templates.create(:name => 'Test Template', :price => 1.00, :uri => 'git@github.com:dockyard/igata_test.git')
template.clone_repo
