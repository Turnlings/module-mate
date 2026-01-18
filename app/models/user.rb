# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # Encrypt email deterministically so Devise can query it
  # encrypts :email, deterministic: true

  has_many :years, dependent: :destroy
  has_many :semesters, through: :years
  has_many :uni_modules, through: :semesters
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

  def achieved_score
    return 0 if years.empty?

    total = years.sum { |year| year.achieved_score(self) * year.weighting_non_null }
    total_weight = years.sum(&:weighting_non_null)
    total / total_weight
  end

  def pinned_modules
    uni_modules.where(pinned: true)
  end

  def total_minutes
    timelogs.sum(:minutes)
  end

  private

  def set_terms_agreed_at
    self.terms_of_service_agreed_at = Time.current
  end
end
