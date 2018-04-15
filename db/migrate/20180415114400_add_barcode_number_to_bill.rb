class AddBarcodeNumberToBill < ActiveRecord::Migration[5.1]
  def change
    add_column :bills, :barcode_number, :string
  end
end
