class Screenshot < ActiveRecord::Base
  belongs_to :template
  attr_accessible :image
  mount_uploader :image, ScreenshotUploader
  validates :image, :presence => true
end
