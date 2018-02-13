class Certificate < ApplicationRecord
  belongs_to :issuer, class_name: "Authority", inverse_of: :issued
  belongs_to :subject, polymorphic: true
  belongs_to :profile, class_name: "CertProfile"

  def expires
    3.days.from_now # TODO Certificate#expires
  end
end
