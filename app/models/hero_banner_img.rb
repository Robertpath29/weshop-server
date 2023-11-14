# frozen_string_literal: true

class HeroBannerImg < ApplicationRecord
  before_validation :set_default_placehold

  validates :path, presence: true, uniqueness: true

  private

  def set_default_placehold
    self.placehold ||= 'banner'
  end
end
