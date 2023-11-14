# frozen_string_literal: true

module Hero
  module Banner
    class ImagesController < ApplicationController
      def index; end

      def create
        nil if params[:img].blank?
      end

      def destroy; end

      private

      def img_params; end
    end
  end
end
