require 'rails_helper'

RSpec.describe 'Reservations', type: :request do
  describe 'POST /reservations' do
    let(:restaurant) { create(:restaurant) }
    let(:arbitrary_date) { '2024-10-07T05:13:42+00:00' }

    before do
      create(:table, capacity: 2, restaurant_id: restaurant.id)
      create(:table, capacity: 4, restaurant_id: restaurant.id)
    end

    it 'returns http success' do
      post '/reservations',
           params: {
             reservation: {
               restaurant_id: restaurant.id, start_time: arbitrary_date, duration: 40, party_size: 4
             }
           }, as: :json

      expect(response).to have_http_status(:created)
    end

    context 'when could not assign table' do
      before do
        Table.destroy_all
      end

      it 'returns an error' do
        post '/reservations',
             params: {
               reservation: {
                 restaurant_id: restaurant.id, start_time: arbitrary_date, duration: 40, party_size: 4
               }
             }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
