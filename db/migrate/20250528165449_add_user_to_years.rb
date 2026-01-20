# frozen_string_literal: true

# rubocop:disable Rails/NotNullColumn
class AddUserToYears < ActiveRecord::Migration[7.1]
  def change
    add_reference :years, :user, null: false, foreign_key: true
  end
end
# rubocop:enable Rails/NotNullColumn
