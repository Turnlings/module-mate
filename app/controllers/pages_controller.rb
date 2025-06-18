class PagesController < ApplicationController
  def home
    @uni_modules = UniModule.all
    @semesters = Semester.all

    # Get the cumulative time logged for each module
    @module_data = UniModule.includes(:timelogs).where(timelogs: { user_id: current_user.id }).map do |mod|
      raw_data = mod.timelogs.for_user(current_user).group_by_day(:created_at).sum(:minutes)
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

    @exam_type_data = Exam.joins(:uni_module).group(:type).sum('exams.weight * uni_modules.credits / 100')

    @next_exam = Exam.where('due > ?', Time.current).order(:due).first
  end

  # Allows for the user to give a module code and minutes and get the time quickly logged
  def quick_log
    # Strip input and find module
    raw_input = params[:module_code].to_s.strip.upcase
    code_number = raw_input[/\d+/]
    @uni_module = UniModule.where("code LIKE ?", "%#{code_number}").first

    # TODO: what if somebody takes like COM101 and MAT101??

    if @uni_module
      @timelog = @uni_module.timelogs.new(minutes: params[:minutes])
      @timelog.user = current_user

      if @timelog.save
        redirect_to root_path, notice: "Time logged successfully."
      else
        redirect_to root_path, alert: "Failed to log time."
      end
    else
      redirect_to root_path, alert: "Module not found."
    end
  end

  def about
  end

  def contact
  end

  def help
  end

  def privacy
  end

  def terms
  end

  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def internal_server_error
    render file: "#{Rails.root}/public/500.html", status: :internal_server_error
  end
end