class AddAttachmentBarcodeFileToBills < ActiveRecord::Migration[5.1]
  def self.up
    change_table :bills do |t|
      t.attachment :barcode_file
    end
  end

  def self.down
    remove_attachment :bills, :barcode_file
  end
end
