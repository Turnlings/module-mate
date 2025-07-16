# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :years, dependent: :destroy
  has_many :exams, through: :exam_results
  has_many :uni_modules, through: :uni_module_targets
  has_many :timelogs, dependent: :destroy

  def credits
    years.sum{|year| year.credits}
  end

  def weighted_average
    return 0 if years.empty?
    total_weight = years.sum { |year| year.semesters.sum(&:credits) }
    weighted_sum = years.sum { |year| year.semesters.sum { |semester| semester.credits * semester.weighted_average(self) } }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  def achieved_score
    return 0 if years.empty?
    years.sum { |year| year.achieved_score(self) } / years.size
  end
end
