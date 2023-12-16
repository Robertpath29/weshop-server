# frozen_string_literal: true

module BannerImageConcern
  extend ActiveSupport::Concern
  require 'mini_magick'

  included do
    private

    def attach_image(img)
      img.img.attach(params[:img])
    end

    def title(img)
      img.title = params[:img].original_filename
    end

    def placeholder(img)
      img.placeholder = params[:placeholder] if params[:placeholder].present?
    end

    def url(img)
      img.url = params[:url] if params[:url].present?
    end
  end

  def process_image(img)
    attach_image(img)
    title(img)
    placeholder(img)
    url(img)
    save(img)
  end

  def save(img)
    if img.save
      render json: { status: 'success', message: 'Image attached successfully' }
    else
      render json: { status: 'error', message: img.errors.full_messages.join(', ') }
    end
  end

  def image?(file)
    MiniMagick::Image.read(file)
    true
  rescue MiniMagick::Invalid
    false
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
