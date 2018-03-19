class DayslotSerializer < ActiveModel::Serializer
  attributes :id, :week, :dayOfWeek, :beginHour, :endHour

end
