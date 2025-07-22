# frozen_string_literal: true

class UniModuleTargetsController < ApplicationController
  before_action :set_uni_module_target, only: [:update]
  authorize_resource

  def create
    @uni_module = UniModule.find(params[:uni_module_target][:uni_module_id])
    @uni_module_target = @uni_module.uni_module_targets.new(uni_module_target_params)
    @uni_module_target.user = current_user

    if @uni_module_target.save
      redirect_to uni_module_path(@uni_module), notice: 'Target was successfully created.'
    else
      redirect_to uni_module_path(@uni_module), alert: 'Failed to create target.'
    end
  end

  def update
    if @uni_module_target.update(uni_module_target_params)
      redirect_to uni_module_path(@uni_module), notice: 'Target was successfully updated.'
    else
      redirect_to uni_module_path(@uni_module), alert: 'Failed to update target.'
    end
  end

  private

  def set_uni_module_target
    @uni_module_target = UniModuleTarget.find(params[:id])
    @uni_module = @uni_module_target.uni_module
  end

  def uni_module_target_params
    params.require(:uni_module_target).permit(:score, :uni_module_id, :user_id)
  end
end
