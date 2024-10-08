class Reservation < ApplicationRecord
  class TableAssignmentError < StandardError; end

  belongs_to :restaurant
  has_many :reservation_tables
  has_many :tables, through: :reservation_tables

  scope :during, ->(date) { where('duration @> ?::timestamp', date) }

  def assign_tables!(strategy = TableAssigners::FirstComeFirstServe)
    table_to_assign = strategy.new(party_size, duration, restaurant.tables).table_to_assign
    raise TableAssignmentError if table_to_assign.nil?

    reservation_tables.create!(table: table_to_assign)
  end
end
