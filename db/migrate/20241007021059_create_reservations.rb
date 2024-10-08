class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.belongs_to :restaurant, null: false, foreign_key: true
      t.tsrange :duration, null: false, index: true
      t.column :party_size, :smallint, null: false

      t.timestamps
    end
  end
end
