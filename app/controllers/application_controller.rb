class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  before_action :authenticate_student!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def authenticate_admin!
    insufficient_privileges! unless current_student && current_student.admin?
  end

  def insufficient_privileges!
    redirect_to root_path, alert: "Insufficient privileges"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
  end

end
