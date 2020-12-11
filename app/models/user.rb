class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  VALID_EMAIL_REGEX = Settings.validation.user.format.email

  attr_accessor :remember_token, :activation_token

  validates :name, presence: true, length: { maximum: Settings.validation.user.size.name }
  validates :email, presence: true, length: { maximum: Settings.validation.user.size.email },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.validation.user.size.password }

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password

  class << self
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
    update_attribute :remember_digest, User.digest remember_token
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

end
