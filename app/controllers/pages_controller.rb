class PagesController < ApplicationController
  def home
    @uni_modules = UniModule.all

    @module_data = UniModule.includes(:timelogs).map do |mod|
      {
        name: mod.name,
        data: mod.timelogs.group_by_day(:created_at).sum(:minutes)
      }
    end
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