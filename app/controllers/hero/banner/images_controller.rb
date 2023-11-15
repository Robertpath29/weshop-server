# frozen_string_literal: true

module Hero
  module Banner
    class ImagesController < ApplicationController
      include BannerImageConcern
      def index
        render json: { images: give_images }
      end

      def create
        if params[:img].present?
          if image?(params[:img])
            img = HeroBannerImg.new params_img
            process_image(img)

          else
            render json: { status: 'error', message: 'Invalid image format' }, status: :unprocessable_entity
          end
        else
          render json: { status: 'error', message: 'No image' }, status: :unprocessable_entity
        end
      end

      def destroy; end

      private

      def params_img
        params.permit(:title, :url, :placeholder, :img)
      end
    end
  end
end
