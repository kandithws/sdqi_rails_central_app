class UserDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:update, :update_driving_license]

  def dashboard
    @user = current_user
    if @user.license_verified?
      flash[:success] = 'Your Driving License is verified by Admin'
    else
      flash[:alert] = 'Your Driving License is not verified by Admin.'
    end
  end

  def edit
    @user = current_user
  end

  def update
    # @user = current_user
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

  def upload_driving_license
    @user=current_user
  end

  def update_driving_license
    p = driving_license_params
    if @user.id == current_user.id
      if p[:driving_license_number].nil? || p[:driving_license_img].nil?
        flash[:error] = 'Please upload both field to proceed'
        redirect_to upload_driving_license_path
      else
        respond_to do |format|
          if @user.update(p)
            format.html { redirect_to dashboard_path, notice: 'You have successfully upload driving license attachment, please wait for admin to verify.' }
          else
            format.html { redirect_to upload_driving_license_path }
          end
        end
      end
    else
      flash[:error] = 'Access Denied!'
      redirect_to dashboard_path
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:user_id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email,
                                           :phone_number, :address)
  end

  def driving_license_params
    params.require(:user).permit(:driving_license_number, :driving_license_img)
  end

end
