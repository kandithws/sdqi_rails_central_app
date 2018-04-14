class Bill < ApplicationRecord
  has_many :toll_fee_records, dependent: :nullify
  belongs_to :user
  before_save :default_values

  private
  def default_values
    if self.payment_confirm.nil?
      self.payment_confirm = false
    end

    if self.payment_deadline.nil?
      self.payment_deadline = 2.weeks.from_now
    end

    # re calc total amount
    unless self.toll_fee_records.nil?
      amount = 0
      self.toll_fee_records.each do |record|
        amount += record.toll_booth.toll_fee
      end
      self.total_amount = amount
    end
  end

end
