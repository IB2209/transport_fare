class AddFuriganaToFares < ActiveRecord::Migration[8.0]
  def change
    add_column :fares, :departure_furigana, :string
    add_column :fares, :arrival_furigana, :string
  end
end
