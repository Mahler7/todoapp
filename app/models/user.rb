class User < ApplicationRecord
  before_save { self.email = email.downcase }

  has_many :todos

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }
end