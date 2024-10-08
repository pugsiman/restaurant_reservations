# frozen_string_literal: true

module TableAssigners
  class FirstComeFirstServe
    def initialize(party_size, duration, tables)
      @party_size = party_size
      @duration = duration
      @tables = tables.order(:capacity)
    end

    # NOTE: could be decoupled from rails specific logic
    def table_to_assign
      # NOTE: with the combinations approach, this would be a #map returning an array of tables to assign
      @tables.each do |table|
        next unless table.capacity >= @party_size

        # postgres range type overlap check. this could also be enforced on a db constraint level, BTW
        next if table.reservations.where('duration && tsrange (?, ?)', @duration.begin, @duration.end).exists?

        return table
      end

      nil
    end
  end
end
