class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  before_action :authenticate_student!
  before_action :configure_permitted_parameters, if: :devise_controller?


  private

  def authenticate_admin!
    unless current_student && current_student.email == "emanolova@gmail.com"
      redirect_to root_path, alert: "Insufficient privileges"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :password_confirmation])
  end

end
