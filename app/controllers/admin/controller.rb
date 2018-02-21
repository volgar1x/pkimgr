class Admin::Controller < SecureController
  before_action :require_admin

private
  def require_admin
    render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false unless current_user.admin?
  end
end
