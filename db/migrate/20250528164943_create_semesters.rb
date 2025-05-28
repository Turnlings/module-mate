class CreateSemesters < ActiveRecord::Migration[7.1]
  def change
    create_table :semesters do |t|
      t.string :name
      t.references :year, null: false, foreign_key: true

      t.timestamps
    end
  end
end
