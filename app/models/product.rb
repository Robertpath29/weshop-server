# frozen_string_literal: true

class Product < ApplicationRecord
  has_many_attached :images
end
