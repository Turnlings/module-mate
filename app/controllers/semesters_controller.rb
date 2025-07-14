# frozen_string_literal: true

class SemestersController < ApplicationController
  before_action :set_semester, only: %i[show edit update destroy]

  # GET /semesters or /semesters.json
  def index
    @semesters = Semester.joins(:year).where(years: { user_id: current_user.id })
  end

  # GET /semesters/1 or /semesters/1.json
  def show
    @uni_modules = @semester.uni_modules
    unless @semester.year.user_id == current_user.id
      redirect_to semesters_path, alert: 'You are not authorized to view this semester.'
      return
    end

    # Get the cumulative time logged for each module
    @module_data = @semester.uni_modules.includes(:timelogs).where(timelogs: { user_id: current_user.id }).map do |mod|
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

    @exam_type_data = Exam.joins(:uni_module).group(:type).sum('exams.weight * uni_modules.credits / 100')

    @next_exam = Exam.where('due > ?', Time.current).order(:due).first
  end

  # GET /semesters/new
  def new
    @semester = Semester.new
    if params[:year_id]
      @semester.year_id = params[:year_id]
    end
  end

  # GET /semesters/1/edit
  def edit; end

  # POST /semesters or /semesters.json
  def create
    @semester = Semester.new(semester_params)

    respond_to do |format|
      if @semester.save
        format.html { redirect_to @semester, notice: 'Semester was successfully created.' }
        format.json { render :show, status: :created, location: @semester }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /semesters/1 or /semesters/1.json
  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to @semester, notice: 'Semester was successfully updated.' }
        format.json { render :show, status: :ok, location: @semester }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semesters/1 or /semesters/1.json
  def destroy
    @semester.destroy!

    respond_to do |format|
      format.html { redirect_to semesters_path, status: :see_other, notice: 'Semester was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /semesters/share/:share_token
  def share
    @semester = Semester.find_by!(share_token: params[:share_token])
    # Only show structure, not grades
  end

  # GET /semesters/import_form
  def import_form
    @semester = Semester.find_by!(share_token: params[:share_token])
    @years = current_user.years.order(:name)
  end

  # POST /semesters/import
  def import
    shared_semester = Semester.find_by!(share_token: params[:share_token])
    if params[:year_id].present? && params[:year_id] != "new"
      user_year = current_user.years.find(params[:year_id])
    else
      # Create a new year if requested
      year_name = params[:new_year_name].presence || "Imported Year #{Time.current.year}"
      user_year = current_user.years.create!(name: year_name)
    end
    new_semester = Semester.create!(
      name: shared_semester.name + ' (Imported)',
      year: user_year
    )
    shared_semester.uni_modules.each do |mod|
      new_mod = new_semester.uni_modules.create!(
        name: mod.name,
        code: mod.code,
        credits: mod.credits
      )
      mod.exams.each do |exam|
        new_mod.exams.create!(
          name: exam.name,
          weight: exam.weight,
          due: exam.due,
          type: exam.type
        )
      end
    end
    redirect_to semester_path(new_semester), notice: 'Semester imported! You can now edit it as your own.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_semester
    @semester = Semester.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def semester_params
    params.require(:semester).permit(:name, :year_id)
  end
end
