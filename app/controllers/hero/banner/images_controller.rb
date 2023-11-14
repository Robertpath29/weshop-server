# frozen_string_literal: true

module Hero
  module Banner
    class ImagesController < ApplicationController
      def index
        render json: { images: give_images }
      end

      def create
        return if params_present?

        if image?(params[:img])
          img = HeroBannerImg.new params_img
          img.img.attach(params[:img])
          img.title = params[:img].original_filename
          save(img)
        else
          render json: { status: 'error', message: 'Invalid image format' }, status: :unprocessable_entity
        end
      end

      def destroy; end

      private

      def params_present?
        params[:img].blank? && params[:title].blank?
      end

      def params_img
        params.permit(:title, :url, :placeholder, :img)
      end

      def save(img)
        img.placeholder = params[:placeholder] if params[:placeholder].present?
        img.url = params[:url] if params[:url].present?
        if img.save
          render json: { status: 'success', message: 'Image attached successfully' }
        else
          render json: { status: 'error', message: img.errors.full_messages.join(', ') },
                 status: :unprocessable_entity
        end
      end

      def image?(file)
        image_format = %w[jpg jpeg gif png]
        extension = File.extname(file).downcase.delete('.')
        image_format.include?(extension)
      end

      def give_images
        images = HeroBannerImg.all.map do |img|
          images = {
            id: img.id,
            path: rails_blob_path(img.img),
            title: img.title,
            url: img.url,
            placeholder: img.placeholder
          }
          images
        end
      end
    end
  end
end
