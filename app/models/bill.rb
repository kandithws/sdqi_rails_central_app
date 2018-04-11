class Bill < ApplicationRecord
  has_many :toll_fee_records
  belongs_to :user

end
