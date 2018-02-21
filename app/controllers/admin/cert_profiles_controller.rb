class Admin::CertProfilesController < Admin::Controller
  before_action :set_cert_profile, only: [:show, :edit, :update, :destroy]

  # GET /cert_profiles
  # GET /cert_profiles.json
  def index
    @cert_profiles = CertProfile.all
  end

  # GET /cert_profiles/1
  # GET /cert_profiles/1.json
  def show
  end

  # GET /cert_profiles/new
  def new
    @cert_profile = CertProfile.new
  end

  # GET /cert_profiles/1/edit
  def edit
  end

  # POST /cert_profiles
  # POST /cert_profiles.json
  def create
    @cert_profile = CertProfile.new(cert_profile_params)

    respond_to do |format|
      if @cert_profile.save
        format.html { redirect_to @cert_profile, notice: 'Cert profile was successfully created.' }
        format.json { render :show, status: :created, location: @cert_profile }
      else
        format.html { render :new }
        format.json { render json: @cert_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cert_profiles/1
  # PATCH/PUT /cert_profiles/1.json
  def update
    respond_to do |format|
      if @cert_profile.update(cert_profile_params)
        format.html { redirect_to @cert_profile, notice: 'Cert profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @cert_profile }
      else
        format.html { render :edit }
        format.json { render json: @cert_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cert_profiles/1
  # DELETE /cert_profiles/1.json
  def destroy
    @cert_profile.destroy
    respond_to do |format|
      format.html { redirect_to cert_profiles_url, notice: 'Cert profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cert_profile
      @cert_profile = CertProfile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cert_profile_params
      params.require(:cert_profile).permit(:name)
    end
end
