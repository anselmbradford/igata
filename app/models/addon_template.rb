class AddonTemplate < ActiveRecord::Base
  belongs_to :addon
  belongs_to :template
end
