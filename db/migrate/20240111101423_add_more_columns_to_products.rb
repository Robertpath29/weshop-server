# frozen_string_literal: true

class AddMoreColumnsToProducts < ActiveRecord::Migration[6.0]
  def change
    change_table :products, bulk: true do
      add_column :products, :extended_description, :text
      add_column :products, :compositions, :string, array: true, default: []
      add_column :products, :history, :text
    end
  end
end
