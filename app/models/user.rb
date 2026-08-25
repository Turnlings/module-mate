# frozen_string_literal: true

class User < ApplicationRecord
  include Hashid::Rails

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Encrypt email deterministically so Devise can query it
  # encrypts :email, deterministic: true

  has_many :years, dependent: :destroy
  has_many :semesters, through: :years
  has_many :uni_modules, -> { distinct }, through: :semesters
  has_many :exams, through: :uni_modules
  has_many :exam_results, dependent: :destroy
  has_many :uni_module_targets, dependent: :destroy
  has_many :timelogs, dependent: :destroy

  # For ToS and Privacy Policy
  attr_accessor :terms_of_service

  validates :terms_of_service, acceptance: { accept: '1' }
  before_create :set_terms_agreed_at, if: -> { terms_of_service == '1' }

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

  def correct_weight_sum?
    years.sum(:weighting) == 100
  end

  # Of those exams completed, get the average score
  def average_score
    return 0 if exam_results.empty?

    exam_results.sum(:score) / exam_results.count.to_f
  end

  def total_credits
    years.sum { |year| year.credits * year.weighting_non_null }
  end

  def completed_credits
    years.sum { |year| year.completed_credits(self) * year.weighting_non_null }
  end

  def achieved_score
    dashboard_stats[:achieved_score]
  end

  def predicted_score
    dashboard_stats[:predicted_score]
  end

  def required_score_for_threshold(threshold)
    stats = dashboard_stats
    p = stats[:progress] / 100.0
    a = stats[:achieved_score]

    return threshold if p.zero?
    return 0 if p == 1 && a >= threshold
    return nil if p == 1 && a < threshold

    (threshold - a) / (1 - p)
  end

  def pinned_modules
    uni_modules.where(pinned: true).distinct
  end

  def total_minutes(since_string = 'all')
    since = TimelogGraphService.date_of(since_string)

    scope = timelogs
    scope = scope.where(date: since..) if since.present?

    scope.sum(:minutes)
  end

  def minutes_today
    timelogs.where(date: Time.zone.today).sum(:minutes)
  end

  def study_streak(as_of: Date.yesterday)
    days = timelogs
           .where(date: ..as_of)
           .distinct
           .order(date: :desc)
           .pluck(:date)

    streak = 0
    expected = as_of

    days.each do |day|
      break if day != expected

      streak += 1
      expected -= 1.day
    end

    streak += 1 if timelogs.exists?(date: Time.zone.today)

    streak
  end

  def progress
    dashboard_stats[:progress]
  end

  private

  def dashboard_stats
    @dashboard_stats ||= calculate_dashboard_stats
  end

  def calculate_achieved_score
    return 0 if years.empty?

    @ys ||= years.includes(semesters: { uni_modules: { exams: :exam_results } })

    total = @ys.sum do |year|
      year.achieved_score(self) * year.weighting_non_null
    end

    total / 100.0
  end

  def calculate_predicted_score
    return 0 if years.empty?

    @ys ||= years.includes(semesters: { uni_modules: { exams: :exam_results } })

    total_weight = @ys.sum { |y| y.weight * y.progress(self) / 100.0 }
    weighted_sum = @ys.sum { |y| y.weight * y.progress(self) / 100.0 * y.predicted_score(self) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  def calculate_progress
    return 0 if uni_modules.empty?

    @ys ||= years.includes(semesters: { uni_modules: { exams: :exam_results } })

    total_progress = @ys.sum { |year| year.progress(self) * year.weighting_non_null }
    total_progress / 100.0
  end

  def calculate_dashboard_stats
    return { achieved_score: 0, predicted_score: 0, progress: 0 } if years.empty?

    @ys ||= years.includes(semesters: { uni_modules: { exams: :exam_results } })

    {
      achieved_score: calculate_achieved_score,
      predicted_score: calculate_predicted_score,
      progress: calculate_progress
    }
  end

  def set_terms_agreed_at
    self.terms_of_service_agreed_at = Time.current
  end
end
