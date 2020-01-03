class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :share
  mount_uploader :picture, PictureUploader
end
