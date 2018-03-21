class PlanSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :release_id, :num_features, :num_jobs, :resources, :calendar, :resource_usage
  
  def num_features
    object.release.features.count
  end
  
  def num_jobs
    #object.jobs.count
    0
  end
  
  def resources
    object.release.resources.map { |r| {
        "id" => r.id,
        "name" => r.name,
        "skills" => r.skills.map { |s| SkillSerializer.new(s)}
        #"calendar" => r.dayslots.map { |d| DayslotSerializer.new(d)}
    }}
  end

  def calendar
    object.schedules.map { |s| {
        "id" => s.id,
        "begins" => get_time(object, s.week, s.dayOfWeek, s.beginHour),
        "ends" => get_time(object, s.week, s.dayOfWeek, s.endHour),
        "slotStatus" => if s.status == 0 then "Free" elsif s.status == 1 then "Used" else "Frozen" end,
        "feature_id" => s.feature_id,
        "resource_id" => s.resource_id
      }
    }
  end
  
  def resource_usage
    nbwks = object.release.num_weeks
    object
      .release.resources.order(:name)
      .map { |r| {"resource_id" => r.id,
                  "resource_name" => r.name,
                  "total_available_hours" => (r.available_hours_per_week * nbwks).to_f,
                 # "total_used_hours" => (object.jobs.map{ |j| j.resource.id == r.id ? j.feature.effort_hours : 0}.sum).to_f,
                  "skills" => r.skills.map { |x| SkillSerializer.new(x) }}
      }.as_json
  end

  private

  def get_time(plan, week, dayOfWeek, hour)
    date = plan.release.starts_at + (hour).hours + (dayOfWeek-1).days + (week-1).weeks
    return date
  end

end
