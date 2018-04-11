class TollFeeRecord < ApplicationRecord
  belongs_to :toll_booth
  belongs_to :car
  belongs_to :bill, optional: true

end
