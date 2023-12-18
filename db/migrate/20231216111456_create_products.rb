# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :category, null: false
      t.string :type_of_clothing, null: false
      t.string :color
      t.string :sizes, array: true, default: []
      t.decimal :price, null: false
      t.decimal :old_price

      t.timestamps
    end
  end
end
# rubocop:enable Metrics/MethodLength
