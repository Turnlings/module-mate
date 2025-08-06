# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  authorize_resource

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @exam_data = @user.exam_results
      .includes(:exam)
      .select { |res| res.exam&.due.present? && res.score.present? }
      .map do |res|
        {
          name: res.exam.name,
          data: [[res.exam.due.to_date, res.score.to_f]]
        }
      end

    @exam_type_data = Exam.joins(:uni_module)
                          .where(uni_module: current_user.uni_modules)
                          .group(:type)
                          .sum('exams.weight * uni_modules.credits / 100')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email)
  end
end
