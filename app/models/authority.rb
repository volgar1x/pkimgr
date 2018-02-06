class Authority < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :users
  has_many :requests, class_name: "CertSigningRequest", as: :subject
end
