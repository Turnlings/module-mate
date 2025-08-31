# frozen_string_literal: true

class YearsController < ApplicationController
  before_action :set_year, only: %i[show edit update destroy]
  authorize_resource

  # GET /years or /years.json
  def index
    @years = current_user.years
  end

  # GET /years/1 or /years/1.json
  def show
    # Get the cumulative time logged for each module
    @module_data = @year.uni_modules.includes(:timelogs).where(timelogs: { user_id: current_user.id }).map do |mod|
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
  
  end

  # GET /years/new
  def new
    @year = Year.new
  end

  # GET /years/1/edit
  def edit; end

  # POST /years or /years.json
  def create
    @year = Year.new(year_params)
    @year.user = current_user

    puts "Current user: #{current_user.inspect}"

    respond_to do |format|
      if @year.save
        format.html { redirect_to @year, notice: 'Year was successfully created.' }
        format.json { render :show, status: :created, location: @year }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @year.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /years/1 or /years/1.json
  def update
    respond_to do |format|
      if @year.update(year_params)
        format.html { redirect_to @year, notice: 'Year was successfully updated.' }
        format.json { render :show, status: :ok, location: @year }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @year.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /years/1 or /years/1.json
  def destroy
    @year.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: 'Year was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_year
    @year = Year.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def year_params
    params.require(:year).permit(:name, :weighting)
  end
end
