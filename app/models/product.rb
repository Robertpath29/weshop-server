# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :images

  validates :title, presence: true, length: { minimum: 10, maximum: 50 }
  validates :price, presence: true, format: { with: /\A\d{1,10}(\.\d{1,2})?\z/, message: 'not valid' }
  validates :old_price, format: { with: /\A\d{1,10}(\.\d{1,2})?\z/, message: 'not valid' }, if: lambda {
                                                                                                  old_price.present?
                                                                                                }
  validates :category,
            presence: true
  validates :type_of_clothing,
            presence: true
  validate :non_zero_price
  validate :non_zero_old_price, if: -> { old_price.present? }

  private

  def non_zero_price
    errors.add(:price, 'zero') if price.to_f.zero?
  end

  def non_zero_old_price
    errors.add(:old_price, 'zero') if old_price.to_f.zero?
  end
end
