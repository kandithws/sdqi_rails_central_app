class AddOmiseChargeToBill < ActiveRecord::Migration[5.1]
  def change
    add_column :bills, :omise_charge_id, :string
  end
end
