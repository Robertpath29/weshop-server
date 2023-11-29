# frozen_string_literal: true

class User < ApplicationRecord
  before_validation :downcase_email
  attr_accessor :remember_token

  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 3, maximum: 20 }

  validate :correct_email, on: :create
  validate :name_not_integer, on: :create

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

  private

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
