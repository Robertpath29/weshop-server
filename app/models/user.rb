# frozen_string_literal: true

class User < ApplicationRecord
  include Recoverable
  before_validation :downcase_email
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role
  attr_accessor :remember_token, :old_password, :admin_edit

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 3, maximum: 20 }
  validates :password, confirmation: true, allow_blank: true, length: { minimum: 5, maximum: 50 }

  validate :correct_email, on: %i[create update]
  validate :name_not_integer, on: %i[create update]
  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? && !admin_edit }
  validates :role, presence: true

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    self.remember_token_digest = digest(remember_token)
    save
  end

  def forget
    self.remember_token_digest = nil
    self.remember_token = nil
    save
  end

  def remember_token_authenticated?(remember_token)
    return false if remember_token_digest.blank?

    BCrypt::Password.new(remember_token_digest).eql?(remember_token)
  end

  def formatted_created_at
    created_at.strftime('%d-%m-%y / %H:%M:%S')
  end

  private

  def password_presence
    errors.add(:password, :blank) if password_digest.blank?
  end

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

  def correct_email
    address = ValidEmail2::Address.new(email)
    return if address.valid? && address.valid_mx?

    errors.add :email, 'no correct'
  end

  def name_not_integer
    errors.add(:name, 'should not be a number') if name.present? && name.match?(/\A\d+\z/)
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost:)
  end
end
