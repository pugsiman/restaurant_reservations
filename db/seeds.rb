# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
restaurant = Restaurant.create!(name: 'test', business_hours: '[08:00:00, 16:00:00]')
[2, 4, 8].each do |seats_number|
  3.times { restaurant.tables.create!(capacity: seats_number) }
end
reservation = restaurant.reservations.create!(
  party_size: 4, duration: DateTime.parse('2024/1/1 11:00')..DateTime.parse('2024/1/1 13:00')
)
reservation.reservation_tables.new(table: Table.last).save!
