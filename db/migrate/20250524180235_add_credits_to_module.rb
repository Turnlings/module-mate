class AddCreditsToModule < ActiveRecord::Migration[7.1]
  def change
    add_column :uni_modules, :credits, :integer
  end
end
