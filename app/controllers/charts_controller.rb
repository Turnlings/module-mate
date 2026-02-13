class ChartsController < ApplicationController
  def time_dashboard
    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, current_user, cumulative: cumulative, date_since_s: params[:date_since])
    data = service.call

    render json: data
  end

  def time_year
    year = Year.find(params[:id])
    authorize! :read, year

    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, year, cumulative: cumulative, date_since_s: params[:date_since])
    data = service.call

    render json: data
  end

  def time_semester
    semester = Semester.find(params[:id])
    authorize! :read, semester

    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, semester, cumulative: cumulative, date_since_s: params[:date_since])
    data = service.call

    render json: data
  end

  def time_module
    uni_module = UniModule.find(params[:id])
    authorize! :read, uni_module

    cumulative = params[:cumulative] != 'false'
    service = TimelogGraphService.new(current_user, uni_module, cumulative: cumulative, date_since_s: params[:date_since])
    data = service.call

    render json: data
  end
end
