class Table < ApplicationRecord
  belongs_to :restaurant
  has_many :reservation_tables
  has_many :reservations, through: :reservation_tables
end
