class MigrateSemesterIdsToJoinTable < ActiveRecord::Migration[7.1]
  def up
    UniModule.reset_column_information

    UniModule.find_each do |mod|
      if mod.semester_id.present?
        semester = Semester.find_by(id: mod.semester_id)
        mod.semesters << semester if semester
      end
    end
  end

  def down
    # undo by picking the first semester from the join table
    UniModule.find_each do |mod|
      first_semester = mod.semesters.first
      mod.update(semester_id: first_semester.id) if first_semester
    end
  end
end
