class SessionController < ApplicationController
  before_action :require_unlogged
  layout false

  def new
  end

  def create
    if (@user = User.find_by_email params[:session][:email])
      if @user.authenticate(params[:session][:password])
        session[:current_user] = @user.id
        redirect_to root_path
      else
        @error = "Invalid e-mail address or password"
        render :new
      end
    else
      @error = "Invalid e-mail address or password"
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

private
  def require_unlogged
    redirect_to root_path if session[:current_user]
  end
end
