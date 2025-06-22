# frozen_string_literal: true

class UniModulesController < ApplicationController
  before_action :set_uni_module, only: %i[show edit update destroy]

  # GET /uni_modules or /uni_modules.json
  def index
    @uni_modules = UniModule.all
  end

  # GET /uni_modules/1 or /uni_modules/1.json
  def show
    @exam_data = Exam
                 .where(uni_module: @uni_module)
                 .pluck(:name, :weight)
                 .to_h

    @timelogs = @uni_module.timelogs.for_user(current_user).page(params[:page]).per(5)
  end

  # GET /uni_modules/new
  def new
    @uni_module = UniModule.new
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
  end

  # Only allow a list of trusted parameters through.
  def uni_module_params
    params.require(:uni_module).permit(:code, :name, :credits, :semester_id, :target)
  end
end
