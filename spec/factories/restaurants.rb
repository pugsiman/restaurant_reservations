FactoryBot.define do
  factory :restaurant do
    name { 'test' }
    business_hours { '[08:00:00, 16:00:00]' }

    factory :restaurant_with_tables do
      transient do
        tables_count { 3 }
      end

      tables do
        Array.new(tables_count) { association(:table) }
      end
    end
  end
end
