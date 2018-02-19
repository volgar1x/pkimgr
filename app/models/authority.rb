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

  def get_encrypt_key(password)
    self.encrypt_key_pem && OpenSSL::PKey.read(self.encrypt_key_pem, password)
  end

  def set_encrypt_key(e, password)
    self.encrypt_key_pem = e.to_pem(Rails.application.config.cipher, password)
  end

  def get_sign_key(password)
    self.sign_key_pem && OpenSSL::PKey.read(self.sign_key_pem, password)
  end

  def set_sign_key(e, password)
    self.sign_key_pem = e.to_pem(Rails.application.config.cipher, password)
  end
end
