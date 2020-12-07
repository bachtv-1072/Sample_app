class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  VALID_EMAIL_REGEX = Settings.validation.user.format.email

  attr_accessor :remember_token

  validates :name, presence: true, length: { maximum: Settings.validation.user.size.name }
  validates :email, presence: true, length: { maximum: Settings.validation.user.size.email },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.validation.user.size.password }

  before_save :downcase_email

  has_secure_password

  class << self
    # Returns the hash digest of the given string.
    def check_dedest
      ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    end

    def digest string
      cost = User.check_dedest
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
