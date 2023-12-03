# frozen_string_literal: true

class AddLastNameDateOfBirthCountrySityAddressToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :last_name
      t.date :date_of_birth
      t.string :country
      t.string :city
      t.string :address
    end
  end
end
