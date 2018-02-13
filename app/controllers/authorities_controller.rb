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

  # GET /authorities/1/import
  def start_import
  end

  # POST /authorities/1/import
  # POST /authorities/1/import.json
  def import
    import_params = params.require("authority_import")

    unless @authority.authenticate(import_params["password"])
      @errors = {password: "Invalid Password"}
      return render :start_import
    end

    if encrypt_key_file = import_params["encrypt_key_pem"]
      encrypt_key_pem = encrypt_key_file.read
      begin
        encrypt_key = OpenSSL::PKey.read(encrypt_key_pem, import_params["password"])
      rescue OpenSSL::PKey::PKeyError
        @errors = {encrypt_key_pem: "Password supplied must have encrypted this file"}
        return render :start_import
      end

      @authority.encrypt_key_pem = encrypt_key_pem
    end
    if sign_key_file = import_params["sign_key_pem"]
      sign_key_pem = sign_key_file.read
      begin
        sign_key = OpenSSL::PKey.read(sign_key_pem, import_params["password"])
      rescue OpenSSL::PKey::PKeyError
        @errors = {sign_key_pem: "Password supplied must have encrypted this file"}
        return render :start_import
      end

      @authority.sign_key_pem = sign_key_pem
    end
    @authority.save!

    respond_to do |format|
      format.html { redirect_to @authority, notice: "New private keys have successfully been imported." }
      format.json { render :show, status: :ok, location: @authority }
    end
  end

  # GET /authorities/1/genpkey
  def start_genpkey
  end

  # POST /authorities/1/genpkey
  # POST /authorities/1/genpkey.json
  def genpkey
    genpkey_params = params.require("authority_genpkey")

    unless @authority.authenticate(genpkey_params["password"])
      @errors = {password: "Invalid password"}
      return render :start_genpkey
    end

    def key_generation(genpkey_params)
      case genpkey_params["algorithm"]
      when "RSA" then OpenSSL::PKey::RSA.generate(genpkey_params["keysize"].to_i)
      when "DSA" then OpenSSL::PKey::DSA.generate(genpkey_params["keysize"].to_i)
      when "ECDSA" then OpenSSL::PKey::EC.generate(genpkey_params["curve"])
      end
    end

    if genpkey_params["usage"].include? "encrypt"
      @authority.set_encrypt_key key_generation(genpkey_params["encrypt"]), genpkey_params["password"]
    end

    if genpkey_params["usage"].include? "sign"
      @authority.set_sign_key key_generation(genpkey_params["sign"]), genpkey_params["password"]
    end

    @authority.save!

    respond_to do |format|
      format.html { redirect_to @authority, notice: "New private keys have successfully been generated." }
      format.json { render :show, status: :ok, location: @authority }
    end
  end

  # GET /authorities/1/pkey
  def start_pkey
  end

  # POST /authorities/1/pkey
  # POST /authorities/1/pkey.json
  def pkey
    pkey_params = params.require("authority_pkey")

    unless @authority.authenticate(pkey_params["password"])
      @errors = {password: "Invalid password"}
      return render :start_pkey
    end

    case pkey_params["usage"]
    when ["encrypt", "sign"] then
      buffer = Zip::OutputStream.write_buffer do |out|
        out.put_next_entry("#{@authority.name}_keys/encrypt_key.pem")
        out.write(@authority.encrypt_key_pem)

        out.put_next_entry("#{@authority.name}_keys/sign_key.pem")
        out.write(@authority.sign_key_pem)
      end
      send_data buffer.string, filename: "#{@authority.name}_keys.zip", type: "application/zip"

    when ["encrypt"] then
      send_data @authority.encrypt_key_pem,
                filename: "#{@authority.name}_encrypt_key.pem",
                type: "application/x-pem-file"

    when ["sign"] then
      send_data @authority.sign_key_pem,
                filename: "#{@authority.name}_sign_key.pem",
                type: "application/x-pem-file"

    else
      render :start_pkey
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
