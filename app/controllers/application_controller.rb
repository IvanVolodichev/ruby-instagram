class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :email, :bio,  :password, :password_confirmation ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :email, :bio, :password, :password_confirmation, :current_password ])
  end
end
