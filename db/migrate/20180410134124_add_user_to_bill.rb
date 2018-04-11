class AddUserToBill < ActiveRecord::Migration[5.1]
  def change
    add_reference :bills, :user_dashboard, foreign_key: true
  end
end
