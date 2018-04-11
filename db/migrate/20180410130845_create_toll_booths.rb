class CreateTollBooths < ActiveRecord::Migration[5.1]
  def change
    create_table :toll_booths do |t|
      t.string :name
      t.decimal :latitute
      t.decimal :longtitude
      t.decimal :toll_fee

      t.timestamps
    end
  end
end
