# frozen_string_literal: true

class SemestersController < ApplicationController
  before_action :set_semester, only: %i[show edit update destroy]
  authorize_resource
  skip_authorize_resource only: %i[import_form import]

  # GET /semesters or /semesters.json
  def index
    @semesters = current_user.semesters

    return unless params[:search].present?

    query = "%#{params[:search]}%"
    @semesters = @semesters.where('LOWER(semesters.name) LIKE ?', "%#{query.downcase}%")
  end

  # GET /semesters/1 or /semesters/1.json
  def show
    @uni_modules = @semester.uni_modules
  end

  # GET /semesters/new
  def new
    @semester = Semester.new
    return unless params[:year_id]

    @semester.year_id = params[:year_id]
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
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @semester.errors, status: :unprocessable_content }
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
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @semester.errors, status: :unprocessable_content }
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

  def share
    @semester = Semester.find_by!(share_token: params[:share_token])
  end

  # GET /semesters/import_form/:share_token
  def import_form
    @semester = Semester.find_by!(share_token: params[:share_token])
    @years = current_user.years.order(:name)
  end

  # POST /semesters/import
  def import
    shared_semester = Semester.find_by!(share_token: params[:share_token])
    if params[:year_id].present? && params[:year_id] != 'new'
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

  def import_redirect
    if params[:share_token]
      redirect_to import_form_semester_path(params[:share_token])
    else
      redirect_to new_semester_path, error: 'Invalid share token'
    end
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
