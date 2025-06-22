# frozen_string_literal: true

class AddDueToExams < ActiveRecord::Migration[7.1]
  def change
    add_column :exams, :due, :datetime
  end
end
