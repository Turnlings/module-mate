class AddColorToUniModules < ActiveRecord::Migration[7.2]
  def change
    add_column :uni_modules, :color, :string
  end
end
