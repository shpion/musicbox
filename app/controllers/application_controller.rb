class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :new_requests

  def after_sign_in_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    scope_path = :"#{scope}_root_path"
    respond_to?(scope_path, true) ? send(scope_path) : root_url
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

  def new_requests
    if user_signed_in?
      @new_requests = Friend.where("friend_id=#{current_user.id} AND active=0").count
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar, :avatar_cache) }
  end
end
