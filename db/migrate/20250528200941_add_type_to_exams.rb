class AddTypeToExams < ActiveRecord::Migration[7.1]
  def change
    add_column :exams, :type, :string
  end
end
