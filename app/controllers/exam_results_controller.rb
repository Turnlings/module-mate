# frozen_string_literal: true

class ExamResultsController < ApplicationController
  before_action :set_exam_result, only: [:update]
  authorize_resource

  def create
    @exam = Exam.find(params[:exam_result][:exam_id])
    @uni_module = @exam.uni_module
    @exam_result = @exam.exam_results.new(exam_result_params)
    @exam_result.user = current_user

    if @exam_result.save
      redirect_to uni_module_path(@uni_module), notice: 'Exam result was successfully created.'
    else
      redirect_to uni_module_path(@uni_module), alert: 'Failed to create exam result.'
    end
  end

  def edit
    @exam = Exam.find(params[:id])
    @exam_result = if @exam.result(current_user).nil?
                  ExamResult.new(user: current_user, exam: @exam)
                else
                  @exam.result(current_user)
                end
  end

  def update
    if @exam_result.update(exam_result_params)
      redirect_to uni_module_path(@uni_module), notice: 'Exam result was successfully updated.'
    else
      redirect_to uni_module_path(@uni_module), alert: 'Failed to update exam result.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_exam_result
    @exam_result = ExamResult.find(params[:id])
    @exam = @exam_result.exam
    @uni_module = @exam.uni_module
  end

  # Only allow a list of trusted parameters through.
  def exam_result_params
    params.require(:exam_result).permit(:score, :exam_id, :user_id)
  end
end
