class ChartsController < ApplicationController
  def time_dashboard
    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, current_user, cumulative: cumulative)
    data = service.call

    render json: data
  end

  def time_year
    year = Year.find(params[:year_id])
    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, year, cumulative: cumulative)
    data = service.call

    render json: data
  end

  def time_semester
    semester = Semester.find(params[:semester_id])
    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, semester, cumulative: cumulative)
    data = service.call

    render json: data
  end

  def time_module
    uni_module = UniModule.find(params[:uni_module_id])
    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, uni_module, cumulative: cumulative)
    data = service.call

    render json: data
  end
end
