# frozen_string_literal: true

class ApplicationController < ActionController::API
  include BannerImageConcern
  include Authentication
  include SortProduct
end
