class CreateBills < ActiveRecord::Migration[5.1]
  def change
    create_table :bills do |t|
      t.decimal :total_amount
      t.date :payment_deadline
      t.boolean :payment_confirm

      t.timestamps
    end
  end
end
