class CertProfile < ApplicationRecord
  has_many :constraints, class_name: "CertProfileConstraint"

  def add_extensions(cert, cert_ext)
    # TODO CertProfile#add_extensions(cert, cert_ext)
  end
end
