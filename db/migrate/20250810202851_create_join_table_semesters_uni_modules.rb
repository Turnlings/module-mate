class CreateJoinTableSemestersUniModules < ActiveRecord::Migration[7.1]
  def change
    create_join_table :semesters, :uni_modules do |t|
      t.index [:semester_id, :uni_module_id]
      t.index [:uni_module_id, :semester_id]
    end
  end
end
