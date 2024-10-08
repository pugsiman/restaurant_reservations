FactoryBot.define do
  factory :restaurant do
    name { 'test' }
    business_hours { '[08:00:00, 16:00:00]' }
  end
end
