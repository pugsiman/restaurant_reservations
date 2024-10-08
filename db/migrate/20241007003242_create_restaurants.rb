class CreateRestaurants < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      CREATE TYPE timerange AS RANGE (subtype = time)
    SQL

    create_table :restaurants do |t|
      t.string :name, null: false, index: true
      t.column :business_hours, :timerange, null: false, index: true

      t.timestamps
      t.text :address
    end
  end

  def down
    drop_table :restaurants
    execute 'DROP TYPE timerange'
  end
end
