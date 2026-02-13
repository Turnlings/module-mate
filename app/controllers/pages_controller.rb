# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home about contact help privacy terms]

  def home
    redirect_to dashboard_path if user_signed_in?
  end

  def dashboard
    @years = current_user.years.order(weighting: :desc)
  end

  def quick_log_form; end

  # Allows for the user to give a module code and minutes and get the time quickly logged
  def quick_log
    minutes = params[:minutes].to_i
    return invalid_minutes unless valid_minutes?(minutes)

    @uni_module = find_module
    return module_not_found unless @uni_module

    @timelog = build_timelog(minutes, params[:description])

    @timelog.save ? respond_success : respond_failed
  end

  def about; end

  def contact; end

  def help; end

  def privacy; end

  def terms; end

  def not_found
    render file: Rails.public_path.join('404.html').to_s, status: :not_found
  end

  def internal_server_error
    render file: Rails.public_path.join('500.html').to_s, status: :internal_server_error
  end

  def close_modal
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back_or_to(root_path) }
    end
  end

  private

  def valid_minutes?(minutes)
    minutes.positive?
  end

  def invalid_minutes
    respond_error(
      'Time logged must be positive.',
      :unprocessable_content
    )
  end

  def find_module
    raw = params[:module_code].to_s.strip
    return if raw.blank?

    normalized = raw.upcase

    # If user typed just the numeric suffix (e.g. "2009"), match codes ending with it.
    if normalized.match?(/\A\d+\z/)
      suffix = normalized

      candidates = UniModule
                   .joins(semesters: :year)
                   .where(years: { user_id: current_user.id })
                   .where('UPPER(uni_modules.code) LIKE ?', "%#{suffix}")
                   .distinct
                   .to_a
                   .select { |m| m.code.to_s.upcase.end_with?(suffix) }

      return candidates.first
    end

    # Full code strict match (e.g. "COM2009")
    UniModule
      .joins(semesters: :year)
      .where(years: { user_id: current_user.id })
      .find_by(code: normalized)
  end

  def module_not_found
    respond_error('Module not found.', :not_found)
  end

  def build_timelog(minutes, description = nil)
    @uni_module.timelogs.new(
      {
        minutes: minutes,
        user: current_user,
        date: Date.current,
        description: description
      }.compact
    )
  end

  def respond_success
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  def respond_failed
    respond_error('Failed to log time.', :unprocessable_content)
  end

  def respond_error(message, status)
    respond_to do |format|
      format.turbo_stream do
        flash.now[:alert] = message
        render 'pages/quick_log_error', status: status
      end
      format.html { redirect_to root_path, alert: message }
    end
  end
end
