class CertSigningRequestsController < SecureController
  before_action :set_issuer
  before_action :set_subject
  before_action :set_cert_signing_request, except: [:new, :start_create, :create]

  def new
    @subjects = [current_user, *current_user.authorities]
  end

  def start_create
    @csr ||= CertSigningRequest.new
    @csr.subject = @subject
    @profiles = CertProfile.all
    @crypto_keys = @subject.keys
  end

  def create
    CertSigningRequest.transaction do
      csr_params = params.require(:cert_signing_request).permit(
        :name,
        :subject_pubid, :subject_key_id, :subject_password,
        :profile_id,
      )
      @csr = CertSigningRequest.new(csr_params)

      unless @csr.authenticate
        @csr.errors.add(:subject_password, "is invalid")
        self.start_create
        return render :start_create
      end

      unless @csr.submit_req
        @csr.errors.add(:subject_pubid, "does not have a signature key yet")
        self.start_create
        return render :start_create
      end

      if @csr.save
        @csr.issuers << @issuer if @issuer
        redirect_to @issuer, notice: "Your request is being processed and you will be notified of any updates."
      else
        console
        self.start_create
        render :start_create
      end
    end
  end

  def start_accept
    @profiles = CertProfile.all
  end

  def accept
    CertSigningRequest.transaction do
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

      issuer_certificate = unless @csr.issuer_certificate_id.empty?
        @issuer.certificates.find(@csr.issuer_certificate_id)
      end

      req = OpenSSL::X509::Request.new @csr.pem
      cert = OpenSSL::X509::Certificate.new
      cert.serial = @issuer.gen_serial
      cert.version = 2
      cert.not_before = Time.now
      cert.not_after = cert.not_before + @csr.validity_duration.to_i.years
      cert.public_key = req.public_key
      cert.subject = req.subject
      cert.issuer = issuer_certificate.try(:x509).try(:subject) || cert.subject

      cert_ext = OpenSSL::X509::ExtensionFactory.new
      cert_ext.subject_certificate = cert
      cert_ext.issuer_certificate = issuer_certificate.try(:x509) || cert
      @csr.profile.add_extensions cert, cert_ext

      sign_key = if issuer_certificate
        issuer_certificate.issuer_key
      else
        @csr.subject_key
      end
      cert.sign sign_key.get_private_key(@csr.issuer_password), Rails.application.config.digest
      cert_pem = cert.to_pem

      certificate = Certificate.create!(
        signed_by: issuer_certificate,
        issuer: @issuer,
        issuer_key: sign_key,
        subject: @csr.subject,
        profile: @csr.profile,
        pem: cert_pem,
      )
      @csr.update!(certificate: certificate)

      redirect_to certificate, notice: "A new certificate has successfully been signed."
    end
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
      issuer_id = params[:issuer_id] || params[:authority_id]
      if issuer_id && !issuer_id.empty?
        @issuer = Authority.find(issuer_id)
      end
    end

    def set_subject
      if (subject_pubid = params[:subject_pubid])
        @subject = ApplicationRecord.find_by_pubid(subject_pubid, [Authority, User])
      end
    end
end
