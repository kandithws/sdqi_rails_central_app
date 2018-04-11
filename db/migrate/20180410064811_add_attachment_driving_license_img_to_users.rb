class AddAttachmentDrivingLicenseImgToUsers < ActiveRecord::Migration[5.1]
  def self.up
    change_table :users do |t|
      t.attachment :driving_license_img
    end
  end

  def self.down
    remove_attachment :users, :driving_license_img
  end
end
