class Authority < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :users
  has_many :requests, class_name: "CertSigningRequest", as: :subject
  has_many :certificates, class_name: "Certificate", as: :subject
  has_many :issued, class_name: "Certificate", inverse_of: :issuer
end
