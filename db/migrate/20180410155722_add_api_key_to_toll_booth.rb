class AddApiKeyToTollBooth < ActiveRecord::Migration[5.1]
  def change
    add_column :toll_booths, :api_key, :string
  end
end
