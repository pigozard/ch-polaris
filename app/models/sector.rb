class Sector < ApplicationRecord
  belongs_to :unit

  validates :postal_code, presence: true
  validates :city, presence: true
end
