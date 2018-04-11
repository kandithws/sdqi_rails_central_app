class CreateCars < ActiveRecord::Migration[5.1]
  def change
    create_table :cars do |t|
      t.string :license_plate_number
      t.string :brand
      t.string :car_model_name
      t.string :car_model_year
      t.string :color
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
