class AuthoritiesController < SecureController
  before_action :set_authority, except: [:index, :new, :create]

  # GET /authorities
  # GET /authorities.json
  def index
    @authorities = current_user.authorities
  end

  # GET /authorities/1
  # GET /authorities/1.json
  def show
  end

  # GET /authorities/new
  def new
    @authority = Authority.new
  end

  # GET /authorities/1/edit
  def edit
  end

  # POST /authorities
  # POST /authorities.json
  def create
    current_user.transaction do
      authority_params = params.require(:authority).permit(
        :name, :email, :website,
        :country, :state, :city, :zip, :organization,
        :password, :password_confirmation,
      )
      @authority = Authority.new(authority_params)

      respond_to do |format|
        if @authority.save
          current_user.authorities << @authority
          format.html { redirect_to @authority, notice: 'Authority was successfully created.' }
          format.json { render :show, status: :created, location: @authority }
        else
          format.html { render :new }
          format.json { render json: @authority.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /authorities/1
  # PATCH/PUT /authorities/1.json
  def update
    unless @authority.authenticate(params[:authority][:password])
      @authority.errors.add(:password, "is invalid")
      return render :edit
    end

    respond_to do |format|
      authority_params = params.require(:authority).permit(:country, :state, :city, :zip, :organization)
      if @authority.update(authority_params)
        format.html { redirect_to @authority, notice: 'Authority was successfully updated.' }
        format.json { render :show, status: :ok, location: @authority }
      else
        format.html { render :edit }
        format.json { render json: @authority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorities/1
  # DELETE /authorities/1.json
  def destroy
    @authority.destroy
    respond_to do |format|
      format.html { redirect_to authorities_url, notice: 'Authority was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def start_invite_user
  end

  def invite_user
    Authority.transaction do
      fullname = params[:authority][:user_name]
      firstname, lastname = fullname.split(" ", 2)
      user = User.find_by firstname: firstname, lastname: lastname

      unless user
        @error = "Unknown user"
        return render :start_invite_user
      end

      if @authority.users.include? user
        @error = "This user has already access to this authority"
        return render :start_invite_user
      end

      @authority.users << user
      redirect_to @authority, notice: "#{user.name} has been invited."
    end
  end

  def kick_user
    Authority.transaction do
      user = User.find params[:user_id]
      @authority.users.delete user
      redirect_to @authority, notice: "#{user.name} has no longer access to this authority."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authority
      @authority = Authority.find(params[:id])
    end
end
