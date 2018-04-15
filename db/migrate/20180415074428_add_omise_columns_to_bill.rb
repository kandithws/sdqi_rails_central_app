class AddOmiseColumnsToBill < ActiveRecord::Migration[5.1]
  def change
    add_column :bills, :omise_barcode_url, :string
    add_column :bills, :omise_barcode_expires_at, :datetime
    add_column :bills, :omise_barcode_created_at, :datetime
    add_column :bills, :omise_source_id, :string
  end
end
