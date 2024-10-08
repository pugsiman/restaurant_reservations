class ReservationsController < ApplicationController
  def create
    # TODO: idealy calculated elswhere
    start_time = DateTime.parse(reservations_params.fetch(:start_time))
    duration_param = reservations_params.fetch(:duration)

    duration = (start_time..start_time + duration_param.to_i.minutes)
    restaurant_id = reservations_params.fetch(:restaurant_id)
    party_size = reservations_params.fetch(:party_size)

    ActiveRecord::Base.transaction do # in the synchronic way, we assume a valid reservation creation must have successfully assigned tables
      reservation = Reservation.create!(restaurant_id:, party_size:, duration:).tap(&:assign_tables!)
      render json: reservation, status: 201
    rescue Reservation::TableAssignmentError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def reservations_params
    params.require(:reservation).permit(:restaurant_id, :party_size, :start_time, :duration)
  end
end
