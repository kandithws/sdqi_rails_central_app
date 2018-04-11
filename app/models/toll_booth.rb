class TollBooth < ApplicationRecord
  has_many :toll_fee_records
  before_create :generate_api_key

  private
  def generate_api_key
    token = SecureRandom.base64.tr('+/=', 'Qrt')
    while TollBooth.exists?(api_key: token)
      token = SecureRandom.base64.tr('+/=', 'Qrt')
    end
    self.api_key = token
  end

end
