class RemoveSemesterIdFromUniModules < ActiveRecord::Migration[7.1]
  def change
    remove_column :uni_modules, :semester_id, :integer
  end
end
