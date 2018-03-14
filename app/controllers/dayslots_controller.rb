class DayslotsController < ApplicationController
  before_action :set_dayslot, only: [:delete_dayslot, :modify_dayslot]

  def add_new_dayslot_to_project
      @dayslot = @project.dayslots.build(dayslot_params)
      if @dayslot.save
        render json: @dayslot
      else
        render json: @dayslot.errors, status: :unprocessable_entity
      end
  end

  def get_dayslots
    render json: @project.dayslots
  end

  def get_dayslot
    render json: @project.dayslots.find(params[:dayslotId])
  end

  def modify_dayslot
    if @dayslot.update(dayslot_params)
      render json: @dayslot
    else
      render json: @dayslot.errors, status: :unprocessable_entity
    end
  end

  def delete_dayslot
    @dayslot.destroy
    render json: {"message" => "DaySlot removed"}
  end

  private

  # Only allow a trusted parameter "white list" through.
    def dayslot_params
      params.require(:dayslot).permit(:code, :week, :dayOfWeek, :beginHour, :endHour, :slotStatus)
    end

    def set_dayslot
      @dayslot = @project.dayslots.find(params[:dayslotId])
    end

end