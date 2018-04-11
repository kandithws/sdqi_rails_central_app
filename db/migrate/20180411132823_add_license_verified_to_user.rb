class AddLicenseVerifiedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :license_verified, :boolean
  end
end
