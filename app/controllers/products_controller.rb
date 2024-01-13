# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ProductsController < ApplicationController
  before_action :set_product!, only: %i[destroy update]
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def index
    oll_category = Product.pluck(:category)
    oll_sizes = Product.pluck(:sizes).flatten
    max_price = Product.maximum(:price)
    best_sale = Product.where.not(old_price: nil).order('RANDOM()').limit(2).to_a.map do |product|
      {
        product:,
        path_img: images_info(product)
      }
    end
    products = sort_product.paginate(page: params[:page], per_page: params[:per_page])
    product_path_img = products.map do |product|
      {
        product:,
        path_img: images_info(product)
      }
    end
    render json: { status: 'success', products: product_path_img, total_pages: products.total_pages,
                   oll_category:, max_price:, oll_sizes:, best_sale: }
  end

  def show
    product = Product.find params[:id]
    if product.present?

      render json: { status: 'success', product:, paths_img: images_info(product) }
    else
      render json: { status: 'error', message: 'product not found' }
    end
  end

  # rubocop:enable Metrics/MethodLength
  # rubocop:disable Metrics/MethodLength
  def create
    product = Product.new product_params
    if params[:images].present?
      params[:images].map do |img|
        return render json: { status: 'error', message: 'Invalid image format' } unless image?(img)
      end
      product.images.attach(params[:images])
    end
    if product.save
      delete_identical_images(product) if params[:images].present?
      render json: { status: 'success', message: 'Product created' }
    else
      render json: { status: 'error', message: product.errors.full_messages.join(', '), warning: product.errors }
    end
  end

  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/Metrics/CyclomaticComplexity
  def update
    if params[:user_id].present? && params[:rating].present?
      return render json: { status: 'error', message: 'User not found!' } unless user_register?(params[:user_id])

      if the_user_rated?(params[:user_id].to_i)
        return render json: { status: 'error',
                              message: 'You have already rated' }
      end
      return render json: { status: 'error', message: 'The score cannot be more than 5!' } if params[:rating].to_i > 5
      return render json: { status: 'error', message: 'The score cannot be less than 1' } if params[:rating].to_i < 1

      save_rating_product
    elsif @product.update product_params
      render json: { status: 'success', message: 'Product updated' }
    else
      render json: { status: 'error', message: @product.errors.full_messages.join(', ') }
    end
  end

  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  def destroy
    if params[:img_id].present?
      destroy_image
    elsif @product.present?
      @product.destroy
      @product.images.purge_later
      render json: { status: 'success', message: 'Product delete' }
    else
      render json: { status: 'error', message: 'Product not found' }
    end
  end

  private

  def save_rating_product
    @product.users_who_have_rated << params[:user_id]
    @product.number_all_stars += params[:rating].to_i
    if @product.save
      render json: { status: 'success', message: 'You have rated it!' }
    else
      render json: { status: 'error', message: @product.errors.full_messages.join(', ') }
    end
  end

  def the_user_rated?(user)
    @product.users_who_have_rated.include?(user)
  end

  def user_register?(user_id)
    User.find_by(id: user_id)
  end

  def product_params
    params.permit(
      :title, :description, :category, :type_of_clothing, :color,
      :price, :old_price, :extended_description, :history, compositions: [], sizes: [], images: []
    )
  end

  def delete_identical_images(product)
    grouped_files = product.images.group_by { |file| File.basename(file.filename.to_s) }
    grouped_files.each_value do |file_group|
      next if file_group.size <= 1

      file_group.first
      file_group[1..].each(&:purge)
    end
  end

  def images_info(product)
    product.images.map do |img|
      {
        id: img.id,
        url: url_for(img)
      }
    end
  end

  def destroy_image
    image = ActiveStorage::Attachment.find_by id: params[:img_id]
    if image.present?
      image.purge_later
      render json: { status: 'success', message: 'Image deleted successfully' }
    else
      render json: { status: 'error', message: 'Image not found' }
    end
  end

  def set_product!
    @product = Product.find_by id: params[:id]
  end
end
# rubocop:enable Metrics/ClassLength
