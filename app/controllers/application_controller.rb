# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, :set_sidebar_content

  private

  def set_sidebar_content
    return unless current_user

    @pinned_modules = current_user.pinned_modules.order(:code)
  end
end
