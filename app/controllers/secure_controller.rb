class SecureController < ApplicationController
  before_action :require_login

protected
  def current_user
    @current_user ||= User.find(session[:current_user])
  end

private
  def require_login
    redirect_to new_session_path unless session[:current_user]
  end
end
