class Certificate < ApplicationRecord
  belongs_to :signed_by, class_name: "Certificate", required: false
  belongs_to :issuer, class_name: "Authority", inverse_of: :issued
  belongs_to :issuer_key, class_name: "CryptoKey"
  belongs_to :subject, polymorphic: true
  belongs_to :subject_key, class_name: "CryptoKey"
  belongs_to :profile, class_name: "CertProfile"

  def x509
    @_x509 ||= OpenSSL::X509::Certificate.new self.pem
  end

  def name
    self.x509.subject.to_a.assoc("CN").try(:at, 1)
  end

  def expires
    self.x509.not_after
  end
end
