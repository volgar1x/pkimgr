def get_public_key(private_key)
  if private_key.is_a? OpenSSL::PKey::EC
    public_key = OpenSSL::PKey::EC.new private_key
    public_key.private_key = nil
    public_key
  else
    private_key.public_key
  end
end

class CryptoKey < ApplicationRecord
  belongs_to :owner, polymorphic: true

  attr_accessor :algorithm, :key_size, :curve_name, :compute_public_pem, :owner_password, :export_type
  validates :private_pem, presence: true, on: :import
  validates :algorithm, presence: true, inclusion: { in: ["RSA", "DSA", "ECDSA"] }, on: :generate
  validates :key_size, presence: true, numericality: { only_integer: true }, on: :generate
  validates :curve_name, presence: true, inclusion: { in: OpenSSL::PKey::EC.builtin_curves.map{|x| x[0]} }, on: :generate
  validates :export_type, presence: true, inclusion: { in: ["Private", "Public"] }, on: :export
  validate on: :generate do |crypto_key|
    unless crypto_key.owner.authenticate(crypto_key.owner_password)
      crypto_key.errors.add(:owner_password, "is invalid")
    end
  end

  def get_private_key(password)
    @_private_key ||= begin
      res = OpenSSL::PKey.read self.private_pem, password
      raise "expected a private key" unless res.private?
      res
    end

  end

  def set_private_key(private_key, password)
    raise "expected a private key" unless private_key.private?

    self.public_key = get_public_key(private_key)

    @_private_key = private_key
    self.private_pem = private_key.to_pem(Rails.application.config.cipher, password)
  end

  def public_key
    @_public_key ||= begin
      res = OpenSSL::PKey.read self.public_pem
      raise "expected a public key" if res.private?
      raise "expected a public key" unless res.public?
      res
    end
  end

  def public_key=(public_key)
    raise "expected a public key" if public_key.private?
    raise "expected a public key" unless public_key.public?
    @_public_key = public_key
    self.public_pem = public_key.to_pem
  end

  def generate!
    private_key = case self.algorithm
    when "RSA" then OpenSSL::PKey::RSA.generate self.key_size.to_i
    when "DSA" then OpenSSL::PKey::DSA.generate self.key_size.to_i
    when "ECDSA" then
      key = OpenSSL::PKey::EC.new self.curve_name
      key.generate_key
      key
    end

    self.set_private_key private_key, self.owner_password
  end
end
