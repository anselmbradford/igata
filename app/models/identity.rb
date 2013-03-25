class Identity < ActiveRecord::Base
  include EasyAuth::Models::Identity

  belongs_to :account, :polymorphic => true
end
