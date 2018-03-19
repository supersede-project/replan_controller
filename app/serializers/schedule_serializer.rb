class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :week, :dayOfWeek, :beginHour, :endHour, :slotStatus, :feature_id, :resource_id

  def slotStatus
    if object.status == 0
      "Free"
    elsif object.status == 1
      "Used"
    else
      "Frozen"
    end
  end

end
