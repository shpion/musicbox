class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    scope_path = :"#{scope}_root_path"
    respond_to?(scope_path, true) ? send(scope_path) : root_url
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end
end
