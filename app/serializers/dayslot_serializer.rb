class DayslotSerializer < ActiveModel::Serializer
  attributes :id, :code, :week, :dayOfWeek, :beginHour, :endHour, :slotStatus

end
