# frozen_string_literal: true

class CreateExams < ActiveRecord::Migration[7.1]
  def change
    create_table :exams do |t|
      t.decimal :weight
      t.string :name
      t.decimal :score

      t.timestamps
    end
  end
end
