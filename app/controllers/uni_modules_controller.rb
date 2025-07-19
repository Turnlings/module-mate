# frozen_string_literal: true

class UniModulesController < ApplicationController
  before_action :set_uni_module, only: %i[show edit update destroy]

  # GET /uni_modules or /uni_modules.json
  def index
    @uni_modules = UniModule.joins(semester: :year).where(years: { user_id: current_user.id })

    if params[:search].present?
      query = "%#{params[:search]}%"
      @uni_modules = @uni_modules.where("LOWER(uni_modules.code) LIKE ? OR LOWER(uni_modules.name) LIKE ?", query.downcase, query.downcase)
    end
  end

  # GET /uni_modules/1 or /uni_modules/1.json
  def show
    # TODO: implement better security check using CanCanCan or similar
    unless @uni_module.semester.year.user_id == current_user.id
      redirect_to uni_modules_path, alert: 'You are not authorized to view this module.'
      return
    end
    @exam_data = Exam
                 .where(uni_module: @uni_module)
                 .pluck(:name, :weight)
                 .to_h
    @timelogs = @uni_module.timelogs.for_user(current_user).page(params[:page]).per(5)
  end

  # GET /uni_modules/new
  def new
    @uni_module = UniModule.new(semester_id: params[:semester_id])
  end

  # GET /uni_modules/1/edit
  def edit; end

  # POST /uni_modules or /uni_modules.json
  def create
    @uni_module = UniModule.new(uni_module_params)

    respond_to do |format|
      if @uni_module.save
        format.html { redirect_to @uni_module, notice: 'Uni module was successfully created.' }
        format.json { render :show, status: :created, location: @uni_module }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @uni_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uni_modules/1 or /uni_modules/1.json
  def update
    respond_to do |format|
      if @uni_module.update(uni_module_params)
        format.html { redirect_to @uni_module, notice: 'Uni module was successfully updated.' }
        format.json { render :show, status: :ok, location: @uni_module }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @uni_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uni_modules/1 or /uni_modules/1.json
  def destroy
    @uni_module.destroy!

    respond_to do |format|
      format.html { redirect_to uni_modules_path, status: :see_other, notice: 'Uni module was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_uni_module
    @uni_module = UniModule.find(params[:id])

    unless @uni_module.semester.nil?
      @semester = @uni_module.semester
      @uni_modules = @semester.uni_modules
    end
  end

  # Only allow a list of trusted parameters through.
  def uni_module_params
    params.require(:uni_module).permit(:code, :name, :credits, :semester_id, :target)
  end
end
