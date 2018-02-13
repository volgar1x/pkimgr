class AuthoritiesController < SecureController
  before_action :set_authority, only: [:show, :edit, :update, :destroy, :edit_keys, :update_keys]

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
    respond_to do |format|
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

  # GET /authorities/1/keys
  def edit_keys
  end

  # POST /authorities/1/keys
  # POST /authorities/1/keys.json
  def update_keys
    encrypt_key_file, sign_key_file = params.require(:authority).values_at(:encrypt_key_pem, :sign_key_pem)
    if encrypt_key_file
      @authority.encrypt_key_pem = encrypt_key_file.read
    end
    if sign_key_file
      @authority.sign_key_pem = sign_key_file.read
    end
    @authority.save!

    respond_to do |format|
      format.html { redirect_to @authority, notice: "New private keys have successfully been imported." }
      format.json { render :show, status: :ok, location: @authority }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authority
      @authority = Authority.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authority_params
      params.require(:authority).permit(:name, :email, :website, :password, :password_confirmation)
    end
end
