class SecureController < ApplicationController
  before_action :require_login

private
  def require_login
    redirect_to new_session_path unless session[:current_user]
  end
end
