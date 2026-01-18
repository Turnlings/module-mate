class ChartsController < ApplicationController
  def time_dashboard
    cumulative = params[:cumulative] != "false"
    service = TimelogGraphService.new(current_user, current_user, cumulative: cumulative)
    data = service.call

    render json: data
  end

  def time_year
  end

  def time_semester
  end

  def time_module
  end
end
