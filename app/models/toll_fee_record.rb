class TollFeeRecord < ApplicationRecord
  belongs_to :toll_booth
  belongs_to :car
  belongs_to :bill, optional: true
  has_attached_file :image, styles: { :large =>   "640x480>", medium: "300x300>", thumb: "100x100>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png)

end
