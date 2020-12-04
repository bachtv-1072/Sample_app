class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  VALID_EMAIL_REGEX = Settings.validation.user.format.email

  validates :name, presence: true, length: { maximum: Settings.validation.user.size.name }
  validates :email, presence: true, length: { maximum: Settings.validation.user.size.email },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: Settings.validation.user.size.password }

  before_save :downcase_email
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
