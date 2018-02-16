class CertSigningRequest < ApplicationRecord
  attr_accessor :subject_password

  belongs_to :subject, polymorphic: true
  belongs_to :profile, class_name: "CertProfile"
  has_and_belongs_to_many :issuers, class_name: "Authority",
    join_table: "authorities_csr",
    foreign_key: "csr_id",
    association_foreign_key: "authority_id"

  validates :name, presence: true, length: { minimum: 5 }
  validates :profile_id, presence: true
  validates :subject_pubid, presence: true

  def subject_pubid
    self.subject.try(:pubid)
  end

  def subject_pubid=(pubid)
    self.subject = ApplicationRecord.find_by_pubid(pubid, [User, Authority])
  end

  def authenticate
    self.subject.authenticate(self.subject_password)
  end

  def submit_req
    sign_key = self.subject.get_sign_key(self.subject_password)
    return nil unless sign_key

    req = OpenSSL::X509::Request.new
    req.version = 2
    req.subject = self.subject.x509 [["CN", self.name]]
    req.public_key = sign_key.public_key
    req.sign sign_key, Rails.application.config.digest
    self.pem = req.to_pem
    req
  end
end
