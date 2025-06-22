# frozen_string_literal: true

class AddUserConstraintsToTimelogs < ActiveRecord::Migration[7.1]
  def change
    change_column_null :timelogs, :user_id, false
  end
end
