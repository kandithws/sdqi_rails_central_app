class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :cars, dependent: :destroy
  validates_presence_of :email, :firstname, :lastname, :phone_number
  validates_uniqueness_of :email, :phone_number
  has_attached_file :driving_license_img, styles: { :large =>   "500x500>", medium: "300x300>", thumb: "100x100>" },
                    default_url: "/images/missing.png"
  validates_attachment_content_type :driving_license_img, :content_type => %w(image/jpeg image/jpg image/png)
  before_save :default_values

  def admin?
    self.admin
  end

  def member?
    !self.admin
  end

  private
  def default_values
    self.license_verified = false
  end

end
