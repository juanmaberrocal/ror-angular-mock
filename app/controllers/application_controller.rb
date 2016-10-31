class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # update devise params stored for users
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :password, :email])
  end

  def authenticate_admin!
    if !current_user.admin.present?
      render json: { errors: "You are not authorized to complete this action!" }, status: 403
    end
  end

end
