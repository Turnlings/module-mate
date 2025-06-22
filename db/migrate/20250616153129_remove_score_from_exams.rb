# frozen_string_literal: true

class RemoveScoreFromExams < ActiveRecord::Migration[7.1]
  def change
    remove_column :exams, :score, :decimal
  end
end
