require 'spec_helper'

describe Template do
  it { should     have_valid(:name).when('Test') }
  it { should_not have_valid(:name).when(nil, '') }
  it { should     have_valid(:developer_cost).when(100) }
  it { should_not have_valid(:developer_cost).when(nil, '', 'some price') }
  it { should     have_valid(:uri).when('git@github.com:test/test.git') }
  it { should_not have_valid(:uri).when(nil, '') }

  describe '#stripe_plan_id' do
    it 'test' do
      template = create :test_template, :account => create(:template_account)
      template.stripe_plan_id.should eq "#{template.id} #{template.account.slug} #{template.slug}"
    end
  end

  it 'always adds the igata config variable' do
    template = build(:test_template)
    template.config_vars['igata'].should be_nil
    template.save
    template.config_vars['igata'].should be_true
  end

  it 'clones the repo', :git => true do
    template = create(:test_template)
    expected_dir = File.expand_path(template.id.to_s, GitDirectory)
    Dir.exist?(expected_dir).should_not be_true
    template.clone_repo
    Dir.exist?(expected_dir).should be_true
  end

  it 'imports the description.md', :git => true do
    template = create(:test_template)
    template.clone_repo
    template.reload
    template.readme.should eq <<-DESCRIPTION
# Igata Test

This information is imported into Igata as the description.
DESCRIPTION
  end

  it 'parses the .igata.yml', :git => true do
    sendgrid_addon = create :sendgrid_addon
    redistogo_addon = create :redistogo_addon
    template = create(:test_template)
    template.clone_repo
    template.reload
    template.addons.should include redistogo_addon
    template.addons.should include sendgrid_addon
    template.addons.count.should eq 2
    template.post_deploy_processes.should eq ['rake db:migrate','sh some_task.sh']
  end

  it 'returns the git repo', :git => true do
    template = create(:test_template)
    template.clone_repo
    repo = template.repo
    repo.should be_an_instance_of Git::Base
  end

  it '#developer_cost_in_cents' do
    template = Template.new(:developer_cost => 1)
    template.developer_cost_in_cents.should eq 100
  end

  describe '#formatted_price' do
    context '#developer_cost is nil' do
      it 'returns "$38.51"' do
        template = Template.new(:developer_cost => nil)
        template.formatted_price.should eq '$38.51'
      end
    end
    context '#developer_cost is 0' do
      it 'returns "$38.51"' do
        template = Template.new(:developer_cost => 0)
        template.formatted_price.should eq '$38.51'
      end
    end
    context '#developer_cost is 10.50' do
      it 'returns no decimal places' do
        template = Template.new(:developer_cost => 10.50)
        template.formatted_price.should eq '$49'
      end
    end
    context '#developer_cost is 10.25' do
      it 'returns 75 cents' do
        template = Template.new(:developer_cost => 10.25)
        template.formatted_price.should eq '$48.75'
      end
    end
    context '#developer_cost is 48.70' do
      it 'returns 70 cents' do
        template = Template.new(:developer_cost => 10.20)
        template.formatted_price.should eq '$48.70'
      end
    end
    context '#developer_cost contains more than 2 decimals' do
      it 'returns "$39.74"' do
        template = Template.new(:developer_cost => 1.234)
        template.formatted_price.should eq '$39.74'
      end
    end
  end

  describe '#monthly_cost_in_cents' do
    context 'without developer_cost, without addons' do
      it 'returns "3851"' do
        template = Template.new(:developer_cost => 0)
        template.monthly_cost_in_cents.should eq 3851
      end
    end
    context 'with developer_cost, without addons' do
      it 'returns "14250"' do
        template = Template.new(:developer_cost => 104)
        template.monthly_cost_in_cents.should eq 14250
      end
    end
    context 'without developer_cost, with addons' do
      it 'returns "4071"' do
        template = Template.new(:developer_cost => 0)
        addon = Addon.new(:cents => 200, :price_units => 'month')
        template.addons = [addon]
        template.monthly_cost_in_cents.should eq 4071
      end
    end
    context 'with developer_cost, with addons (:price_unit => "month")' do
      it 'returns "14800"' do
        template = Template.new(:developer_cost => 104)
        addon1 = Addon.new(:cents => 200, :price_units => 'month')
        addon2 = Addon.new(:cents => 300, :price_units => 'month')
        template.addons = [addon1, addon2]
        template.monthly_cost_in_cents.should eq 14800
      end
    end
  end
end
