class BillsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :upload_slip]

  def index
  end

  # Callback from the tollgate system to create
  def create
  end

  def show
  end

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
