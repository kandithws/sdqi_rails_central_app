class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name_prefix, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :address, :string
    add_column :users, :phone_number, :string
    add_column :users, :driving_license_number, :string
    add_column :users, :admin, :boolean
  end
end
