class CertProfileConstraint < ApplicationRecord
  belongs_to :profile, class_name: "CertProfile"
end
