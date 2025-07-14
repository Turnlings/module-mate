# frozen_string_literal: true

class Year < ApplicationRecord
  has_many :semesters, dependent: :destroy
  belongs_to :user

  def achieved_score(user)
    return 0 if semesters.empty?
    semesters.sum { |semester| semester.achieved_score(user) } / semesters.size
  end
end
