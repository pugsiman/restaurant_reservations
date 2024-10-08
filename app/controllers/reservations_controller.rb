class ReservationsController < ApplicationController
  def create
    # TODO: idealy calculated elswhere
    start_time = DateTime.parse(reservations_params.fetch(:start_time))
    duration = reservations_params.fetch(:duration)
    duration_timerange = (start_time..start_time + duration.to_i.minutes)

    reservation = ActiveRecord::Base.transaction do # in the synchronic way, we assume a valid reservation creation must have successfully assigned tables
      Reservation.create!(
        restaurant_id: reservations_params.fetch(:restaurant_id),
        party_size: reservations_params.fetch(:party_size),
        duration: duration_timerange
      ).tap(&:assign_tables!)
    end

    if reservation
      render json: reservation, status: 201
    else
      render status: :unprocessable_entity
    end
  end

  private

  def reservations_params
    params.require(:reservation).permit(:restaurant_id, :party_size, :start_time, :duration)
  end
end
