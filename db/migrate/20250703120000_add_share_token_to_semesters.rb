class AddShareTokenToSemesters < ActiveRecord::Migration[7.1]
  def change
    add_column :semesters, :share_token, :string
    add_index :semesters, :share_token, unique: true
  end
end
