class AddAttachmentPaymentEvidenceToBills < ActiveRecord::Migration[5.1]
  def self.up
    change_table :bills do |t|
      t.attachment :payment_evidence
    end
  end

  def self.down
    remove_attachment :bills, :payment_evidence
  end
end
