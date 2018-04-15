class Bill < ApplicationRecord
  has_many :toll_fee_records, dependent: :nullify
  belongs_to :user
  before_save :default_values
  has_attached_file :payment_evidence, styles: { :large =>   "500x500>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :payment_evidence, :content_type => %w(image/jpeg image/jpg image/png)

  def exceed_deadline?
    self.payment_deadline < DateTime.now
  end

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
