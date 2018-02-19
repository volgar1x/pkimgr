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
    csr_params = params.require(:cert_signing_request).permit(:issuer_password, :profile_id, :validity_duration, :issuer_certificate_id)
    @csr.assign_attributes(csr_params)

    unless @csr.valid? on: :accept
      @profiles = CertProfile.all
      return render :start_accept
    end

    unless @issuer.authenticate(@csr.issuer_password)
      @csr.errors.add :issuer_password, "is invalid"
      @profiles = CertProfile.all
      return render :start_accept
    end

    req = OpenSSL::X509::Request.new @csr.pem
    cert = OpenSSL::X509::Certificate.new
    cert.serial = 0 # TODO generate certificate serial
    cert.version = 2
    cert.not_before = Time.now
    cert.not_after = cert.not_before + @csr.validity_duration.years
    cert.public_key = req.public_key
    cert.subject = req.subject
    cert.issuer = @issuer.x509

    cert_ext = OpenSSL::X509::ExtensionFactory.new
    cert_ext.subject_certificate = cert
    cert_ext.issuer_certificate = @issuer.certificates.find(@csr.issuer_certificate_id)
    @csr.profile.add_extension cert, cert_ext

    sign_key = @issuer.get_sign_key @csr.issuer_password
    cert.sign sign_key, Rails.application.config.digest
    cert_pem = cert.to_pem

    certificate = Certificate.create(
      issuer: @issuer,
      subject: @csr.subject,
      profile: @csr.profile,
      pem: cert_pem,
    )

    redirect_to certificate, notice: "A new certificate has successfully been signed."
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
