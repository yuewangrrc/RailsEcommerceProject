class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :street_address, :city, :postal_code, :province_id])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end

  # Admin authentication
  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end

  def admin_required
    authenticate_admin!
  end
end
