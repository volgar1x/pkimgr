class User < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :authorities
  has_many :requests, class_name: "CertSigningRequest", as: :subject
  has_many :certificates, class_name: "Certificate", as: :subject
end
