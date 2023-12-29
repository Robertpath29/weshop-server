# frozen_string_literal: true

class AddNewColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    change_table :products, bulk: true do |t|
      t.column :users_who_have_rated, :integer, array: true, default: [], unique: true
      t.column :number_all_stars, :integer, default: 0
      t.index :users_who_have_rated, using: :gin
    end
  end
end
