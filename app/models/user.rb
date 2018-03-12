class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :authorities
  has_many :requests, class_name: "CertSigningRequest", as: :subject
  has_many :certificates, class_name: "Certificate", as: :subject
  has_many :keys, class_name: "CryptoKey", as: :owner

  attr_accessor :old_password

  def name
    "#{self.firstname} #{self.lastname}"
  end

  def x509(additionals = [])
    OpenSSL::X509::Name.new [
      ["C", self.country],
      ["ST", self.state],
      ["L", self.city],
      ["O", "#{self.name} Org."], # TODO user's organization
      ["OU", self.name],
      ["emailAddress", self.email],
      # CN needs to be set by caller
      *additionals,
    ]
  end

  def expiring_certificates
    Certificate.select_expired(self.certificates) +
    authorities.collect{|a| a.expiring_certificates}.flatten
  end
end
