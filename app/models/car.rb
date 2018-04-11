class Car < ApplicationRecord
  belongs_to :user
  has_many :toll_fee_records
  validates_uniqueness_of :license_plate_number
  has_attached_file :car_img, styles: { :large =>   "500x500>", medium: "300x300>", thumb: "100x100>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :car_img, :content_type => %w(image/jpeg image/jpg image/png)

end
