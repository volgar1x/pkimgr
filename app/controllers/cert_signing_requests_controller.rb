class CertSigningRequestsController < SecureController
  before_action :set_issuer
  before_action :set_cert_signing_request, except: [:index, :new, :create]

  # GET /cert_signing_requests
  # GET /cert_signing_requests.json
  def index
    @csrs = CertSigningRequest.all
  end

  # GET /cert_signing_requests/1
  # GET /cert_signing_requests/1.json
  def show
  end

  # GET /cert_signing_requests/new
  def new
    @csr ||= CertSigningRequest.new
    @subjects = [current_user, *current_user.authorities]
    @profiles = CertProfile.all
  end

  # GET /cert_signing_requests/1/edit
  def edit
  end

  # POST /cert_signing_requests
  # POST /cert_signing_requests.json
  def create
    CertSigningRequest.transaction do
      csr_params = params.require(:cert_signing_request).permit(
        :name,
        :subject_pubid, :subject_password,
        :profile_id,
      )
      @csr = CertSigningRequest.new(csr_params)

      unless @csr.authenticate
        @csr.errors.add(:subject_password, "is invalid")
        self.new
        return render :new
      end

      unless @csr.submit_req
        @csr.errors.add(:subject_pubid, "does not have a signature key yet")
        self.new
        return render :new
      end

      if @csr.save
        @csr.issuers << @issuer if @issuer
        redirect_to @csr, notice: "Your request is being processed and you will be notified of any updates."
      else
        self.new
        render :new
      end
    end
  end

  # PATCH/PUT /cert_signing_requests/1
  # PATCH/PUT /cert_signing_requests/1.json
  def update
    respond_to do |format|
      if @csr.update(cert_signing_request_params)
        format.html { redirect_to @csr, notice: 'Cert signing request was successfully updated.' }
        format.json { render :show, status: :ok, location: @csr }
      else
        format.html { render :edit }
        format.json { render json: @csr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cert_signing_requests/1
  # DELETE /cert_signing_requests/1.json
  def destroy
    @csr.destroy
    respond_to do |format|
      format.html { redirect_to cert_signing_requests_url, notice: 'Cert signing request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def start_accept
    @profiles = CertProfile.all
  end

  def accept
  end

  def start_reject
  end

  def reject
  end

  def start_cancel
  end

  def cancel
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cert_signing_request
      @csr = CertSigningRequest.find(params[:id])
    end

    def set_issuer
      if (issuer_id = params[:authority_id])
        @issuer = Authority.find(issuer_id)
      end
    end
end
