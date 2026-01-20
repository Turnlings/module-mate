# rubocop:disable Rails/ThreeStateBooleanColumn
class AddPinnedToUniModules < ActiveRecord::Migration[7.1]
  def change
    add_column :uni_modules, :pinned, :boolean, default: false
  end
end
# rubocop:enable Rails/ThreeStateBooleanColumn
