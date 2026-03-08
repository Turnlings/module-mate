class AddFinalScoreToUniModulesSemestersYears < ActiveRecord::Migration[7.2]
  def change
    add_column :uni_modules, :final_score, :decimal, precision: 5, scale: 2
    add_column :semesters, :final_score, :decimal, precision: 5, scale: 2
    add_column :years, :final_score, :decimal, precision: 5, scale: 2
  end
end
