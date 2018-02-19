class CertProfile < ApplicationRecord
  has_many :constraints, class_name: "CertProfileConstraint", foreign_key: "profile_id"

  def is_valid_subject?(subject)
    # TODO CertProfile#is_valid_subject?(subject)
    # self.constraints.each do |cnst|
    #   case cnsts
    #   when "subject_key_type" then
    #   when "subject_key_size" then
    #   end
    # end
  end

  def add_extensions(cert, cert_ext)
    self.constraints.where(type: "add_extension").each do |cnst|
      cert.add_extension cert_ext.create_extension cnst.value
    end
  end
end
