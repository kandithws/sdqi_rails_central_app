class CreateTollFeeRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :toll_fee_records do |t|
      t.references :toll_booth, foreign_key: true
      t.datetime :timestamp
      t.references :car, foreign_key: true
      t.references :bill, foreign_key: true

      t.timestamps
    end
  end
end
