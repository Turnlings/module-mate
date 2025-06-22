# frozen_string_literal: true

class AddUserToTimelogs < ActiveRecord::Migration[7.1]
  def change
    add_reference :timelogs, :user, foreign_key: true
  end
end
