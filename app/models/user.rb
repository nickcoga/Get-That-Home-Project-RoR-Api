class User < ApplicationRecord
  has_secure_token
  has_secure_password

  enum role: { admin: 'landlord', user: 'homeseeker' }
  has_many :properties, dependent: :destroy
  validates :username, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/ }
  validates :password, length: { minimum: 6 }, allow_nil: true

  def invalidate_token
    update(token: nil)
  end

  def self.valid_login?(email, password)
    user = find_by(email: email)

    user&.authenticate(password)
  end
end
