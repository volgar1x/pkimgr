class CertificatesController < SecureController
  before_action :set_certificate, except: [:index]

  def index
    @certificates = current_user.authorities.map{|a| a.certificates}.flatten
  end

  def show
  end

  def renew
    raise "TODO"
  end

  def download
    data = ""
    if @certificate.signed_by
      it = @certificate
      while it.signed_by
        data << it.x509.to_pem
        data << "\n"
        it = it.signed_by
      end
    else
      data << @certificate.x509.to_pem
    end
    send_data data, type: "application/x-x509-ca-cert",
                    filename: "#{@certificate.name}.crt"
  end

  private
    def set_certificate
      @certificate = Certificate.find(params[:id])
    end
end
