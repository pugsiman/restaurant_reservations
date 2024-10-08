class CreateTables < ActiveRecord::Migration[7.2]
  def change
    create_table :tables do |t|
      t.column :capacity, :smallint, null: false
      t.belongs_to :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
