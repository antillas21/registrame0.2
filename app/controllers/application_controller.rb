class ApplicationController < ActionController::Base
  include NameBadgeRendering
  protect_from_forgery
  before_action :configure_permitted_parameters, :if => :devise_controller?

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :remember_me])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :password_confirmation, :current_password])
    end

  private
    def authorize_admin!
      authenticate_user!
      unless current_user.admin?
        flash[:alert] = "You must be an admin to do that."
        redirect_to root_path
      end
    end
end
