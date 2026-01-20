# rubocop:disable Rails/SkipsModelValidations
class AddDateToTimelogs < ActiveRecord::Migration[7.2]
  def change
    add_column :timelogs, :date, :date

    reversible do |dir|
      dir.up do
        Timelog.reset_column_information
        Timelog.find_each do |timelog|
          timelog.update_column(:date, timelog.created_at.to_date)
        end
      end
    end
  end
end
# rubocop:enable Rails/SkipsModelValidations
