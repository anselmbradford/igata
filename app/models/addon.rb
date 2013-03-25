class Addon < ActiveRecord::Base
  attr_accessible :name, :description, :url, :beta, :state, :cents,
    :price_units, :attachable, :slug, :consumes_dyno_hours, :plan_description, :group_description, :selective

  validates :name, :uniqueness => true

  has_many :addon_templates
  has_many :templates, :through => :addon_templates

  def self.retrieve_from_heroku!
    heroku_client = Heroku::API.new(:api_key => Settings['heroku']['api_key'])
    response = heroku_client.get_addons

    response.body.each do |addon_hash|
      addon_hash[:price_units] = addon_hash['price']['unit']
      addon_hash[:cents] = addon_hash['price']['cents']
      addon_hash.keys.each do |key|
        unless [:name, :description, :url, :beta, :state, :cents,
                :price_units, :attachable, :slug, :consumes_dyno_hours,
                :plan_description, :group_description, :selective].include? key.to_sym
          addon_hash.delete key
        end
      end
      if addon = self.find_by_name(addon_hash['name'])
        addon.update_attributes addon_hash
      else
        addon = self.create addon_hash
      end
    end
  end

  def monthly_cost_in_cents
    price_units == 'month' ? cents : 750 * cents
  end
end
