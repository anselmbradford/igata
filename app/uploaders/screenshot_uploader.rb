# encoding: utf-8

class ScreenshotUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  process :resize_and_pad => [500, 400] unless Rails.env.test?

  version :thumb do
    process :resize_and_pad => [220, 176] unless Rails.env.test?
  end

  def default_url
    "/assets/#{['screenshot', version_name].compact.join('_')}.png"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end