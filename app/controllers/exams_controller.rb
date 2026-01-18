# frozen_string_literal: true

class ExamsController < ApplicationController
  before_action :set_exam, only: %i[show edit update destroy]
  authorize_resource

  # GET /exams or /exams.json
  def index
    @exams = Exam.all
  end

  # GET /exams/1 or /exams/1.json
  def show
    time_zone = TZInfo::Timezone.get(Rails.application.config.time_zone)
    @time_until_due = @exam.time_until_due(time_zone.now)
    @uni_module = @exam.uni_module
    @semester = @uni_module.semesters.first
  end

  # GET /exams/new
  def new
    @uni_module = UniModule.find(params[:uni_module_id])
    @exam = @uni_module.exams.new
  end

  # GET /exams/1/edit
  def edit
    @uni_module = @exam.uni_module
  end

  # POST /exams or /exams.json
  def create
    @uni_module = UniModule.find(params[:uni_module_id])
    @exam = @uni_module.exams.new(exam_params)

    respond_to do |format|
      if @exam.save
        format.html { redirect_to uni_module_exam_path(@uni_module, @exam), notice: 'Exam was successfully created.' }
        format.json { render :show, status: :created, location: @exam }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @exam.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /exams/1 or /exams/1.json
  def update
    @uni_module = @exam.uni_module

    respond_to do |format|
      if @exam.update(exam_params)
        format.html { redirect_to uni_module_exam_path(@uni_module, @exam), notice: 'Exam was successfully updated.' }
        format.json { render :show, status: :ok, location: @exam }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @exam.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /exams/1 or /exams/1.json
  def destroy
    @uni_module = @exam.uni_module
    @exam.destroy!

    respond_to do |format|
      format.html do
        redirect_to uni_module_path(@uni_module), status: :see_other, notice: 'Exam was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exam
    @exam = Exam.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def exam_params
    params.require(:exam).permit(:weight, :name, :type, :uni_module_id, :due)
  end
end
