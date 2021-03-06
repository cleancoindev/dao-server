# frozen_string_literal: true

module Types
  class ImageType < Types::Base::BaseObject
    description 'Image used for KYC such as jpegs or pngs or pdfs'

    field :filename, String,
          null: false,
          description: 'File name of the image'
    field :file_size, Integer,
          null: false,
          description: 'File size of the image in bytes'
    field :content_type, String,
          null: false,
          description: 'Content type of the image such as `image/png` or `application/pdf`'
    field :data_url, String,
          null: false,
          description: 'Base64 encoded string for the data itself'
  end
end
