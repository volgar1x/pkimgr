class Authority < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :users
  has_many :subject_requests, -> { where certificate: nil },
    class_name: "CertSigningRequest", as: :subject
  has_and_belongs_to_many :issuer_requests, -> { where certificate: nil },
    class_name: "CertSigningRequest",
    join_table: "authorities_csr",
    foreign_key: "authority_id",
    association_foreign_key: "csr_id"
  has_many :certificates, class_name: "Certificate", as: :subject
  has_many :issued, class_name: "Certificate", inverse_of: :issuer
  has_many :keys, class_name: "CryptoKey", as: :owner

  def x509(additionals = [])
    OpenSSL::X509::Name.new [
      ["C", self.country],
      ["ST", self.state],
      ["L", self.city],
      ["O", self.organization],
      ["OU", self.name],
      ["emailAddress", self.email],
      # CN needs to be set by caller
      *additionals,
    ]
  end

  def gen_serial
    Authority.transaction do
      serial = Authority.where(id: self.id).limit(1).pluck(:next_serial)[0]
      self.update!(next_serial: serial + 1)
      serial
    end
  end
end
