# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_sidebar_content

  private

  def set_sidebar_content
    return unless current_user

    @pinned_modules = current_user.pinned_modules.order(:code)

    @uni_modules = UniModule.joins(semester: :year)
                            .where(years: { user_id: current_user.id })
                            .includes(:timelogs, semester: :year)
                            
    @next_exams = Exam.joins(:uni_module)
                      .where('due > ?', Time.current)
                      .where(uni_modules: { id: @uni_modules.map(&:id) })
                      .order(:due)
                      .limit(3)
  end
end
