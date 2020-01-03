class Share < ApplicationRecord
  validates :address, :description, presence: true 
  validates :name, length: { minimum: 3 }, presence: true
  
  belongs_to :user
  has_many :comments
  has_many :photos
  
  geocoded_by :address
  after_validation :geocode
end
