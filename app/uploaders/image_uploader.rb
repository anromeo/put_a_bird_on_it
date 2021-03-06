# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

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

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_limit => [200, 200]
  end

  version :birdified do
    process :birdify
  end

  version :nightified do
    process :nightify
  end

  version :edgified do
    process :edgify
  end

  def birdify
    manipulate! format: "png" do |source|
      overlay_path = Rails.root.join("app/assets/images/bird.png")
      overlay = Magick::Image.read(overlay_path).first
      source = source.resize_to_fill(400, 350)
      source.composite!(overlay, 0, 0, Magick::OverCompositeOp)
    end
  end

  def nightify
    manipulate! format: "png" do |source|
      source = source.resize_to_fill(400, 350).blue_shift(factor=1.5)
    end
  end

  def edgify
    manipulate! format: "png" do |source|
      source = source.resize_to_fill(400, 350).edge(8)
    end
  end
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
