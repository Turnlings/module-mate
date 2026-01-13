# frozen_string_literal: true

class ExamResult < ApplicationRecord
  belongs_to :user
  belongs_to :exam, touch: true
  validates :score, presence: true
end
