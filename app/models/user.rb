class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :authorities
  has_many :requests, class_name: "CertSigningRequest", as: :subject
  has_many :certificates, class_name: "Certificate", as: :subject

  def name
    "#{self.firstname} #{self.lastname}"
  end

  def get_encrypt_key(password)
    OpenSSL::PKey.read(self.encrypt_key_pem, password)
  end

  def set_encrypt_key(e, password)
    self.encrypt_key_pem = e.to_pem(Rails.application.config.cipher, password)
  end

  def get_sign_key(password)
    OpenSSL::PKey.read(self.sign_key_pem, password)
  end

  def set_sign_key(e, password)
    self.sign_key_pem = e.to_pem(Rails.application.config.cipher, password)
  end
end
