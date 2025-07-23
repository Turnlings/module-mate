# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :years, dependent: :destroy
  has_many :semesters, through: :years
  has_many :uni_modules, through: :semesters
  has_many :exams, through: :uni_modules
  has_many :exam_results, dependent: :destroy
  has_many :uni_module_targets, dependent: :destroy
  has_many :timelogs, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # Add other user info as needed
    end
  end

  def credits
    uni_modules.sum(:credits)
  end

  # Of those exams completed, get the average score
  def average_score
    return 0 if exam_results.empty?

    exam_results.sum(:score) / exam_results.count.to_f
  end

  def achieved_score
    return 0 if years.empty?
    years.sum { |year| year.achieved_score(self) } / years.size
  end

  def pinned_modules
    UniModule.joins(semester: { year: :user })
             .where(pinned: true, years: { user_id: id })
  end
end
