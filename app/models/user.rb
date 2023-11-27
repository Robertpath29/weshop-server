# frozen_string_literal: true

class User < ApplicationRecord
  before_validation :downcase_email

  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 3, maximum: 20 }

  validate :correct_email, on: :create
  validate :name_not_integer, on: :create

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
end
