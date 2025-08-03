class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authenticate_admin!

  protected

  def authenticate_admin!
    redirect_to root_path, alert: 'Access denied. Administrator privileges required.' unless current_user&.admin?
  end
end
