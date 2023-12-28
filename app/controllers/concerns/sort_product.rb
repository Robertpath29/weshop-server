# frozen_string_literal: true

module SortProduct
  extend ActiveSupport::Concern
  # rubocop:disable Metrics/BlockLength
  included do
    private

    def sort_product
      products = sort_by
      products = sort_color(products)
      products = sort_category(products)
      products = sort_price(products)
      products = sort_size(products)
      sort_keyword(products)
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

    def sort_price(products)
      if params[:min_price].present? && params[:max_price].present? && params[:max_price].to_i != 0
        products.where(price: params[:min_price]..params[:max_price])
      else
        products
      end
    end

    def sort_size(products)
      if params[:size].present?

        products.where('sizes @> ?', "{#{params[:size]}}")

      else
        products
      end
    end

    def sort_keyword(products)
      if params[:keyword].present?
        keyword = params[:keyword].upcase
        products.where('UPPER(title) = :keyword OR UPPER(category) = :keyword OR UPPER(type_of_clothing) = :keyword OR UPPER(color) = :keyword',
                       keyword:)
      else
        products
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
