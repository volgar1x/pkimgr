class Authority < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :users
  has_many :requests, class_name: "CertSigningRequest", as: :subject
  has_many :certificates, class_name: "Certificate", as: :subject
  has_many :issued, class_name: "Certificate", inverse_of: :issuer

  def encrypt_key
    OpenSSL::PKey.read(self.encrypt_key_pem)
  end

  def encrypt_key=(e)
    self.encrypt_key_pem = e.to_pem
  end

  def sign_key
    OpenSSL::PKey.read(self.sign_key_pem)
  end

  def sign_key=(e)
    self.sign_key_pem = e.to_pem
  end
end
