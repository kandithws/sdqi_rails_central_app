class UserDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:update, :upload_license_plate]

  def dashboard
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.id == current_user.id
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to dashboard_path, notice: 'User was successfully updated.' }
        else
          format.html { redirect_to user_dashboard_edit_path }
        end
      end
    else
      flash[:error] = 'Access Denied!'
      redirect_to dashboard_path
    end

  end

  def upload_license_plate
  end

  private

  # def set_user
  #   @user = User.find_by_id(params[:user_id])
  # end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email,
                                           :phone_number, :address)
  end

end
