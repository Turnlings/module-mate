# frozen_string_literal: true

class Exam < ApplicationRecord
  belongs_to :uni_module
  has_many :users, through: :exam_results
  has_many :exam_results, dependent: :destroy

  def score(user)
    result = ExamResult.find_by(user: user, exam: self)
    return nil if result.nil?

    result.score
  end

  def adjusted_score(user)
    score(user)
  end

  def target(user)
    return nil if !score(user).nil? || uni_module.target(user).nil?
    return uni_module.target(user) if uni_module.completion_percentage(user).zero?

    (uni_module.target(user) - uni_module.achieved_score(user)) / (100 - uni_module.completion_percentage(user)) * 100
  end

  def result(user)
    ExamResult.find_by(user: user, exam: self)
  end
end
