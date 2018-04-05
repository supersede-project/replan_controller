class PlanSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :release_id, :isCurrent, :solutionQuality, :resources, :resource_usage

  def solutionQuality
    res = {priorityQuality: object.priorityQuality, performanceQuality: object.performanceQuality,
           similarityQuality: object.similarityQuality, globalQuality: object.globalQuality}
    res
  end
  
  def resources
    object.release.resources.map { |r| {
        "id" => r.id,
        "name" => r.name,
        "skills" => r.skills.map { |s| SkillSerializer.new(s)},
        "calendar" => object.schedules.where(resource_id: r.id).map {|s| {
            "begins" => get_time(object.release.starts_at, s.week, s.dayOfWeek, s.beginHour),
            "ends" => get_time(object.release.starts_at, s.week, s.dayOfWeek, s.endHour),
            "slotStatus" => if s.status == 0 then "Free" elsif s.status == 1 then "Used" else "Frozen" end,
            "feature_id" => s.feature_id
          }
        }
      }
    }.as_json
  end
  
  def resource_usage
    object
      .release.resources.order(:name)
      .map { |r| {"resource_id" => r.id,
                  "resource_name" => r.name,
                  "total_available_hours" => (object.schedules.where(resource_id: r.id).map{|s| (s.endHour - s.beginHour)}.sum).to_f,
                  "total_used_hours" => (object.schedules.where(resource_id: r.id).map{|s| s.status == 0 ? 0 : (s.endHour - s.beginHour)}.sum).to_f
                 # "total_available_hours" => (r.available_hours_per_week * nbwks).to_f,
                 # "total_used_hours" => (object.jobs.map{ |j| j.resource.id == r.id ? j.feature.effort_hours : 0}.sum).to_f,
      }.as_json
      }
  end

  private

  def get_time(starts_at, week, dayOfWeek, hour)
    date = starts_at + (hour).hours + (dayOfWeek-1).days + (week-1).weeks
    return date
  end

end
