module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:current_user])
  end
end
