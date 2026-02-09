# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_sidebar_content

  # For modals
  layout -> { turbo_frame_request? ? false : 'application' }

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def set_sidebar_content
    return unless current_user

    @pinned_modules = current_user.pinned_modules.order(:code)

    @next_exams = Exam
                  .joins(:uni_module)
                  .where('due > ?', Time.current)
                  .where(uni_module: current_user.uni_modules)
                  .order(:due)
                  .limit(1)
                  .includes(:uni_module)
  end
end
