# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ProductsController < ApplicationController
  before_action :set_product!, only: %i[destroy]
  def index
    category = Product.pluck(:category)
    products = sort_product.paginate(page: params[:page], per_page: params[:per_page])
    product_path_img = products.map do |product|
      {
        product:,
        path_img: images_info(product)
      }
    end
    render json: { status: 'success', products: product_path_img, total_pages: products.total_pages,
                   category: }
  end

  def show
    product = Product.find params[:id]
    if product.present?

      render json: { status: 'success', products: product, paths_img: images_info(product) }
    else
      render json: { status: 'error', message: 'product not found' }
    end
  end

  # rubocop:disable Metrics/AbcSize
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

  def sort_product
    products = sort_by
    products = sort_color(products)
    products = sort_category(products)
  end

  def sort_by
    if params[:sort_by] == 'data'
      Product.order(created_at: :desc)
    else
      Product
    end
  end

  def sort_color(products)
    if params[:color].present?
      products.where(color: params[:color])
    else
      products
    end
  end

  def sort_category(products)
    if params[:category].present?
      products.where(category: params[:category])
    else
      products
    end
  end
  # paginate(page: params[:page], per_page: params[:per_page])

  def product_params
    params.permit(
      :title, :description, :category, :type_of_clothing, :color,
      :price, :old_price, sizes: [], images: []
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
