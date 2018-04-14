class AddAttachmentImageToTollFeeRecords < ActiveRecord::Migration[5.1]
  def self.up
    change_table :toll_fee_records do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :toll_fee_records, :image
  end
end
