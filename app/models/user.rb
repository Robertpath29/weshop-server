class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  validate :correct_email, on: :create

  private

  def correct_email
    address = ValidEmail2::Address.new(email)
    return if address.valid? && address.valid_mx?

    errors.add :email, 'no correct'
  end
end
