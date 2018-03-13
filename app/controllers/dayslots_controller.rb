class DayslotsController < ApplicationController

  def add_new_dayslot_to_project
      @dayslot = @project.dayslots.build(dayslot_params)
      if @dayslot.save
        render json: @dayslot
      else
        render json: @dayslot.errors, status: :unprocessable_entity
      end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def dayslot_params
    params.require(:dayslot).permit(:code, :week, :dayOfWeek, :beginHour, :endHour)
  end

end