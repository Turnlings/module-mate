# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about, :contact, :help, :privacy, :terms]

  def home
    redirect_to dashboard_path if user_signed_in?
  end

  def dashboard
    @semesters = Semester.joins(:year)
                         .where(years: { user_id: current_user.id })
                         .includes(:uni_modules)

    @year_data = current_user.years.order(weighting: :desc).map do |year|
      {
        year: year,
        weighting: year.weighting,
        progress: year.progress(current_user),
        achieved: year.achieved_score(current_user)
      }
    end

    # Get the cumulative time logged for each module
    @module_data = current_user.uni_modules.map do |mod|
      raw_data = mod.timelogs.for_user(current_user).group_by_day(:date).sum(:minutes)
      cumulative = {}
      total = 0
      raw_data.each do |date, minutes|
        total += minutes
        cumulative[date] = total
      end
      {
        name: mod.name,
        data: cumulative
      }
    end

    @assessment_data = current_user.exam_results
                                   .includes(:exam)
                                   .map { |res| [res.exam.due, res.score] }
  end

  # Allows for the user to give a module code and minutes and get the time quickly logged
  def quick_log
    minutes = params[:minutes].to_i
    if minutes.nil? || minutes <= 0 
      redirect_to root_path, alert: 'Time logged must be positive.'
      return
    end

    # Strip input and find module
    code = params[:module_code].to_s.strip.upcase
    @uni_module = UniModule.where('code LIKE ?', "%#{code}%").first

    # TODO: what if somebody takes like COM101 and MAT101??

    if @uni_module
      @timelog = @uni_module.timelogs.new(minutes: params[:minutes])
      @timelog.user = current_user
      @timelog.date = Date.current

      if @timelog.save
        redirect_to root_path, notice: 'Time logged successfully.'
      else
        redirect_to root_path, alert: 'Failed to log time.'
      end
    else
      redirect_to root_path, alert: 'Module not found.'
    end
  end

  def about; end

  def contact; end

  def help; end

  def privacy; end

  def terms; end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def internal_server_error
    render file: "#{Rails.root}/public/500.html", status: :internal_server_error
  end
end
