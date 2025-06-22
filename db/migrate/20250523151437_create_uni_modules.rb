# frozen_string_literal: true

class CreateUniModules < ActiveRecord::Migration[7.1]
  def change
    create_table :uni_modules do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
