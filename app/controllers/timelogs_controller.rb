# frozen_string_literal: true

class TimelogsController < ApplicationController
  before_action :set_timelog, only: %i[show edit update destroy]
  authorize_resource

  # GET /timelogs or /timelogs.json
  def index
    @timelogs = Timelog.all
  end

  # GET /timelogs/1 or /timelogs/1.json
  def show
    @uni_module = @timelog.uni_module
  end

  # GET /timelogs/new
  def new
    @uni_module = UniModule.find(params[:uni_module_id])
    @timelog = @uni_module.timelogs.new
    @timelog.date = Date.current
  end

  # GET /timelogs/1/edit
  def edit
    @uni_module = @timelog.uni_module
  end

  # POST /timelogs or /timelogs.json
  def create
    @uni_module = UniModule.find(params[:uni_module_id])
    @timelog = @uni_module.timelogs.new(timelog_params)
    @timelog.user = current_user

    respond_to do |format|
      if @timelog.save
        format.html { redirect_to uni_module_path(@uni_module), notice: 'Timelog was successfully created.' }
        format.json { render :show, status: :created, location: @timelog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /timelogs/1 or /timelogs/1.json
  def update
    respond_to do |format|
      if @timelog.update(timelog_params)
        format.html { redirect_to @timelog, notice: 'Timelog was successfully updated.' }
        format.json { render :show, status: :ok, location: @timelog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @timelog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /timelogs/1 or /timelogs/1.json
  def destroy
    @uni_module = @timelog.uni_module
    @timelog.destroy!

    respond_to do |format|
      format.html { redirect_to uni_module_path(@uni_module), status: :see_other, notice: 'Timelog was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_timelog
    @timelog = Timelog.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def timelog_params
    params.require(:timelog).permit(:uni_module_id, :date, :minutes, :description)
  end
end
