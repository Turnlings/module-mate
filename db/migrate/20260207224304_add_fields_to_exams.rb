class AddFieldsToExams < ActiveRecord::Migration[7.2]
  def change
    add_column :exams, :completed, :boolean, default: false, null: false
    add_column :exams, :released, :datetime
    add_column :exams, :threshold, :decimal
  end
end
