class AddIndexToTimelogs < ActiveRecord::Migration[7.2]
  def change
    add_index :timelogs, [:user_id, :uni_module_id, :date]
  end
end
