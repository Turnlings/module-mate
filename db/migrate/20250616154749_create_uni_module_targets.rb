# frozen_string_literal: true

class CreateUniModuleTargets < ActiveRecord::Migration[7.1]
  def change
    create_table :uni_module_targets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :uni_module, null: false, foreign_key: true
      t.decimal :score

      t.timestamps
    end
  end
end
