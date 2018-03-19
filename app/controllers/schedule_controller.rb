class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:delete_schedule, :modify_schedule]

  def add_new_schedule_to_plan
      @schedule = @plan.schedules
      if @schedule.save
        render json: @schedule
      else
        render json: @schedule.errors, status: :unprocessable_entity
      end
  end

  def get_schedules
    render json: @plan.schedules
  end

  def get_schedule
    render json: @plan.schedules.find(params[:id])
  end

  def modify_schedule
    if @schedule.update(schedule_params)
      render json: @schedule
    else
      render json: @schedule.errors, status: :unprocessable_entity
    end
  end

  def delete_schedule
    @schedule.destroy
    render json: {"message" => "Schedule removed"}
  end

  private

  # Only allow a trusted parameter "white list" through.
    def schedule_params
      params.require(:schedule).permit(:week, :dayOfWeek, :beginHour, :endHour, :status)
    end

    def set_schedule
      @schedule = @plan.schedules.find(params[:id])
    end

end