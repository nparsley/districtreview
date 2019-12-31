class Share < ApplicationRecord
  validates :address, :description, presence: true 
  validates :name, length: { minimum: 3 }, presence: true
  
  belongs_to :user
  geocoded_by :address
  after_validation :geocode
end
