# frozen_string_literal: true

class AddModuleReferenceToExams < ActiveRecord::Migration[7.1]
  def change
    add_reference :exams, :uni_module, null: false, foreign_key: true
  end
end
