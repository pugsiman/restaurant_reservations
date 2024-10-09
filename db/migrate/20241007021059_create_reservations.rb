class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'btree_gist'

    create_table :reservations do |t|
      t.belongs_to :restaurant, null: false, foreign_key: true
      t.tsrange :duration, null: false
      t.column :party_size, :smallint, null: false

      t.timestamps
    end

    add_index :reservations, :duration, using: :gist
  end
end
