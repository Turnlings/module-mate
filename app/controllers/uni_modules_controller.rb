# frozen_string_literal: true

class UniModulesController < ApplicationController
  before_action :set_uni_module, only: %i[show edit update destroy]
  authorize_resource

  # GET /uni_modules or /uni_modules.json
  def index
    @uni_modules = current_user.uni_modules

    return if params[:search].blank?

    query = "%#{params[:search]}%"
    @uni_modules = @uni_modules.where('LOWER(uni_modules.code) LIKE ? OR LOWER(uni_modules.name) LIKE ?',
                                      query.downcase, query.downcase)
  end

  # GET /uni_modules/1 or /uni_modules/1.json
  def show
    @exam_data = Exam
                 .where(uni_module: @uni_module)
                 .pluck(:name, :weight)
                 .to_h
    @timelogs = @uni_module.timelogs.for_user(current_user).order(date: :desc).page(params[:page]).per(5)
  end

  # GET /uni_modules/new
  def new
    @uni_module = UniModule.new(semester_ids: [params[:semester_id]])
  end

  # GET /uni_modules/1/edit
  def edit
    @uni_module_target = UniModuleTarget.find_by(uni_module: @uni_module,
                                                 user: current_user) || UniModuleTarget.new(
                                                   user: current_user, uni_module: @uni_module
                                                 )
  end

  # POST /uni_modules or /uni_modules.json
  def create
    @uni_module = UniModule.new(uni_module_params)

    respond_to do |format|
      if @uni_module.save
        format.html { redirect_to @uni_module, notice: 'Uni module was successfully created.' }
        format.json { render :show, status: :created, location: @uni_module }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @uni_module.errors, status: :unprocessable_content }
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
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @uni_module.errors, status: :unprocessable_content }
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

  def pin
    @uni_module = UniModule.find(params[:id])
    if @uni_module.update(pinned: !@uni_module.pinned)
      redirect_to uni_module_path(@uni_module), notice: 'Module pin status updated successfully.'
    else
      redirect_to uni_module_path(@uni_module), alert: 'Failed to update pin status.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_uni_module
    @uni_module = UniModule.find(params[:id])

    @semester = @uni_module.semesters.first
  end

  # Only allow a list of trusted parameters through.
  def uni_module_params
    params.require(:uni_module).permit(:code, :name, :credits, :target, semester_ids: [])
  end
end
