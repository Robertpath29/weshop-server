# frozen_string_literal: true

class CreateHeroBannerImgs < ActiveRecord::Migration[7.0]
  def change
    create_table :hero_banner_imgs do |t|
      t.string :path, null: false, index: { unique: true }
      t.string :url
      t.string :placeholder

      t.timestamps
    end
  end
end
