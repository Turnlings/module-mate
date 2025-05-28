class Year < ApplicationRecord
  has_many :semesters, dependent: :destroy

  belongs_to :user
end
