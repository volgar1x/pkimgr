module CertSigningRequestsHelper
  def csr_text(csr)
    content_tag :code, @csr.x509.to_text, style: "white-space: pre;"
  end
end
