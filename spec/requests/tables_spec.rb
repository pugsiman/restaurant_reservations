require 'rails_helper'

RSpec.describe 'Tables', type: :request do
  describe 'GET /index' do
    let(:arbitrary_date) { '2024-10-07T05:13:42+00:00' }

    before do
      restaurant = create(:restaurant_with_tables)
      date = DateTime.parse(arbitrary_date)
      reservation = create(:reservation, restaurant_id: restaurant.id, duration: date..date + 30.minutes)
      reservation.reservation_tables.create!(table: restaurant.tables.sample)
    end

    it 'returns http success' do
      get '/tables/occupied', params: { table: { time: arbitrary_date } }
      expect(response).to have_http_status(:success)
    end

    it 'returns json with appropriate fields' do
      get '/tables/occupied', params: { table: { time: arbitrary_date } }
      data = JSON.parse(response.body)
      expect(data).to include(
        hash_including('party_size', 'table_id', 'reservation_id')
      )
    end
  end
end
