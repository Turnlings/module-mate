# rubocop:disable all
class NewFixTime < ActiveRecord::Migration[7.2]
  def up
    zone = 'Europe/London'
    Exam.reset_column_information
    Exam.find_each do |exam|
      %i[released due].each do |attr|
        ts = exam.read_attribute(attr)
        next if ts.nil?
        ts = ts.utc

        # Treat the stored UTC time as a London local time, then get the correct UTC for that wall time
        new_utc = Time.use_zone(zone) { Time.zone.local(ts.year, ts.month, ts.day, ts.hour, ts.min, ts.sec) }.utc
        # Only update if different
        puts "Updating Exam #{exam.id} #{attr}: #{ts} -> #{new_utc}"
        exam.update_column(attr, new_utc)
        puts "Updated Exam #{exam.id} #{attr}: #{exam.read_attribute(attr).utc}"
      end
    end
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
# rubocop:enable all