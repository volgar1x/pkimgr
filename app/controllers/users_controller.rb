class UsersController < SecureController
  before_action :set_user, except: [:index, :new, :create]

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
