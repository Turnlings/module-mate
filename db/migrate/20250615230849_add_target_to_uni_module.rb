class AddTargetToUniModule < ActiveRecord::Migration[7.1]
  def change
    add_column :uni_modules, :target, :decimal
  end
end
