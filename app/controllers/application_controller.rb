# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_sidebar_content
  before_action :configure_permitted_parameters, if: :devise_controller?

  # For modals
  layout -> { turbo_frame_request? ? false : 'application' }

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:terms_of_service])
    devise_parameter_sanitizer.permit(:account_update, keys: [:terms_of_service])
  end

  private

  def set_sidebar_content
    return unless current_user

    @pinned_modules = current_user.pinned_modules.order(:code)

    @next_exams = Exam
                  .joins(:uni_module)
                  .where('due > ?', Time.current)
                  .where(uni_module: current_user.uni_modules)
                  .where(completed: false)
                  .order(:due)
                  .limit(1)
                  .includes(:uni_module)
  end
end
