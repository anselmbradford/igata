require 'spec_helper'

describe Addon, :vcr => { :cassette_name => 'addons', :record => :new_episodes } do
  describe '.retrieve_from_heroku!' do
    it 'retrieves the addons from heroku' do
      Addon.retrieve_from_heroku!

      Addon.count.should eq 375
    end

    context 'some existing records' do
      it 'updates the record instead of creating a new one' do
        Addon.create  "name"=>"exceptional:basic", "description"=>"Exceptional Basic Old Value",
          "url"=>"http://getexceptional.com/", "beta"=>false, "state"=>"public", "cents"=>100,
          "price_units"=>"month", "attachable"=>false, "slug"=>"basic", "consumes_dyno_hours"=>false,
          "plan_description"=>"Basic", "group_description"=>"Exceptional", "selective"=>true

        Addon.retrieve_from_heroku!

        Addon.where(:name => 'exceptional:basic').count.should eq 1
        updated_addon = Addon.find_by_name 'exceptional:basic'
        updated_addon.description.should eq 'Exceptional Basic'
        updated_addon.cents.should eq 0
      end
    end
  end

  describe '#monthly_cost_in_cents' do
    context 'Addon billed by the month' do
      it 'returns the cents of the addon' do
        addon = Addon.new :cents => 200, :price_units => 'month'

        addon.monthly_cost_in_cents.should eq 200
      end
    end
    context 'Addon billed by the dyno_hour' do
      it 'returns the cents of the addon multiplied by 750 (~ a month in hours)' do
        addon = Addon.new :cents => 200, :price_units => 'dyno_hour'

        addon.monthly_cost_in_cents.should eq 150000
      end
    end
  end
end
