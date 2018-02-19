class CertProfileConstraint < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :profile, class_name: "CertProfile"
end
