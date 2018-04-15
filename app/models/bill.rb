class Bill < ApplicationRecord
  include MyOmise
  has_many :toll_fee_records, dependent: :nullify
  belongs_to :user
  before_save :default_values
  has_attached_file :payment_evidence, styles: { :large =>   "500x500>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :payment_evidence, :content_type => %w(image/jpeg image/jpg image/png)

  has_attached_file :barcode_file
  validates_attachment_content_type :barcode_file, content_type: ["image/svg+xml"]

  def exceed_deadline?
    self.payment_deadline < DateTime.now
  end

  def omise_barcode_expired?
    unless self.omise_barcode_expires_at.blank?
      self.omise_barcode_expires_at < DateTime.now
    end
  end

  def update_attributes_omise_barcode
    #if self.omise_source_id.blank?
      src_data = create_bill_source(self.total_amount)
      if src_data.present?
        self.omise_source_id = src_data['id']
      else
        return false # end flow here
      end
    #end

    # self.save

    if self.omise_barcode_url.blank? || self.omise_barcode_expired?
      charge_data = charge_bill_source(self.omise_source_id, self.id, self.total_amount)
      if charge_data.present?
        self.omise_barcode_created_at = DateTime.parse charge_data['created']
        self.omise_barcode_expires_at = DateTime.parse charge_data['source']['references']['expires_at']
        self.omise_barcode_url = charge_data['source']['references']['barcode']
        self.omise_charge_id = charge_data['id'] # use this for trigger callback
        self.barcode_number = charge_data['source']['references']['reference_number_2']
        self.barcode_file = open(self.omise_barcode_url) # download and save svg file
        true
      else
        false
      end
    else
      false
    end

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
