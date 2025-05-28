class AddSemesterToUniModules < ActiveRecord::Migration[7.1]
  def change
    add_reference :uni_modules, :semester, null: true, foreign_key: true
  end
end
