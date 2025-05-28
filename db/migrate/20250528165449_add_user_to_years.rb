class AddUserToYears < ActiveRecord::Migration[7.1]
  def change
    add_reference :years, :user, null: false, foreign_key: true
  end
end
