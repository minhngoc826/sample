class User < ApplicationRecord
  attr_accessor :remember_token

  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: 30}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 50},
  format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, length: {minimum: 6, maximum: 20}, presence: true

  def User.digest new_token
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create new_token, cost: cost
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticate? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def current_user? current_user
    self == current_user
  end

end
