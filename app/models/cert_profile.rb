class CertProfile < ApplicationRecord
  has_many :constraints, class_name: "CertProfileConstraint"
end
