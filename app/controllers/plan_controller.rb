class PlanController < ApplicationController
  before_action :set_plan

  def replan
    multiple_solutions = !params[:multiple_solutions].nil? && (params[:multiple_solutions] == "true" ||
            params[:multiple_solutions] == "yes")
    if multiple_solutions
      release = ValentinPlanner.replan(@plan, Rails.application.config.x.optimizer_n_endpoints)
    else
      release = ValentinPlanner.replan(@plan, Rails.application.config.x.optimizer_endpoints)
    end
    render json: release.plans
  end

  private

  def set_plan
    @plan = @project.releases.find(params[:releaseId]).plans.find(params[:planId])
  end

end
