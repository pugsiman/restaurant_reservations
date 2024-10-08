require 'rails_helper'

RSpec.describe 'Tables', type: :request do
  describe 'GET /index' do
    let(:arbitrary_date) { '2024-10-07T05:13:42+00:00' }

    it 'returns http success' do
      get '/tables/occupied', params: { table: { time: arbitrary_date } }
      expect(response).to have_http_status(:success)
    end
  end
end
