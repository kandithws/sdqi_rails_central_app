class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :update_sanitized_params, if: :devise_controller?
  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password,
                                                       :firstname, :lastname, :phone_number, :address])
  end


  def after_sign_in_path_for(resource)
      dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_path
  end
end
