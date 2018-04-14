class BillsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :upload_slip]

  def index
    @bills = current_user.bills.order("created_at DESC")
  end

  # Presereved only for admin to create Bills Manually
  def create
    # get all member in the system
    @users = User.find_by_admin(false)

    @users.each do |user|
      unissued_records = TollFeeRecord.where(car: user.cars, bill_id:nil) # get all records that not yet issued
      new_bill = Bill.create({user: user, toll_fee_records: unissued_records, payment_deadline: 2.weeks.from_now})
    end
  end

  def show
  end

  # For manual slip upload & update
  def upload_slip
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @bill = Bill.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bill_params
    params.require(:bill).permit(:user_id)
  end

end
