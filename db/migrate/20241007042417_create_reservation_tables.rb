class CreateReservationTables < ActiveRecord::Migration[7.2]
  def change
    create_table :reservation_tables do |t|
      t.belongs_to :table, null: false, foreign_key: true
      t.belongs_to :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
