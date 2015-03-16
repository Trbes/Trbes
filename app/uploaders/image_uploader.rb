class ImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  version :icon do
    process resize_to_fill: [34, 34]
  end

  version :thumbnail do
    process resize_to_fill: [96, 96]
  end

  version :logo do
    process resize_to_fill: [100, 100]
  end

  version :group_logo do
    process resize_to_fill: [138, 115]
  end
end
