FactoryBot.define do
  factory :table do
    capacity { 1 }
    restaurant { create(:restaurant) }
  end
end
