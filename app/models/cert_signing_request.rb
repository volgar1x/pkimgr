class CertSigningRequest < ApplicationRecord
  belongs_to :subject, polymorphic: true, class_name: "Authority"
  belongs_to :profile, class_name: "CertProfile"
end
