# frozen_string_literal: true

class CreateTimelogs < ActiveRecord::Migration[7.1]
  def change
    create_table :timelogs do |t|
      t.references :uni_module, null: false, foreign_key: true
      t.integer :minutes
      t.string :description

      t.timestamps
    end
  end
end
