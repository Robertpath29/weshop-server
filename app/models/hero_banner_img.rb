# frozen_string_literal: true

class HeroBannerImg < ApplicationRecord
  has_one_attached :img
  before_validation :set_default_placeholder

  validates :title, presence: true, uniqueness: true

  private

  def set_default_placeholder
    self.placeholder = 'banner' if placeholder.blank?
  end
end
