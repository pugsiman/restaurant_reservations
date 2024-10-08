class TablesController < ApplicationController
  def index
    period = DateTime.parse(tables_params.fetch(:time))
    reservations_in_period = Reservation.during(period)

    collection = ReservationTable.where(reservation: reservations_in_period).includes(:reservation).map do |reservation_table|
      {
        table_id: reservation_table.table_id,
        reservation_id: reservation_table.reservation_id,
        party_size: reservation_table.reservation.party_size
      }
    end

    render json: collection, status: 200
  end

  private

  def tables_params
    params.require(:table).permit(:time)
  end
end
