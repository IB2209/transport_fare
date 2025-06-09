class CreateFares < ActiveRecord::Migration[8.0]
  def change
    create_table :fares do |t|
      t.string :departure
      t.string :arrival
      t.float :distance
      t.integer :fare_small
      t.integer :fare_medium
      t.integer :fare_large

      t.timestamps
    end
  end
end
