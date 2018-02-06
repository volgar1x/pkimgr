class Authority < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :users
end
