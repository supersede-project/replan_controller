class PlanController < ApplicationController
  before_action :set_plan, :plan_params

  def replan
    week = plan_params[:week]
    dayOfWeek = plan_params[:dayOfWeek]
    beginHour = plan_params[:beginHour]
    Rails.logger.info "::plan #{week}"
    multiple_solutions = !params[:multiple_solutions].nil? && (params[:multiple_solutions] == "true" ||
            params[:multiple_solutions] == "yes")
    if multiple_solutions
      release = ValentinPlanner.replan(@plan, week, dayOfWeek, beginHour, Rails.application.config.x.optimizer_n_endpoints)
    else
      release = ValentinPlanner.replan(@plan, week, dayOfWeek, beginHour, Rails.application.config.x.optimizer_endpoints)
    end
    render json: release.plans
  end

  def set_current
    oldCurrentPlan = @plan.release.plans.where(isCurrent: true).first()
    oldCurrentPlan.isCurrent = false
    oldCurrentPlan.save
    @plan.isCurrent = true
    @plan.save
    render json: @plan
  end

  private

  def set_plan
    @plan = @project.releases.find(params[:releaseId]).plans.find(params[:planId])
  end

  def plan_params
    params.permit(:week, :dayOfWeek, :beginHour)
  end

end
