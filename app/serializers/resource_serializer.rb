class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :skills, :calendar
  
  def skills
    object
      .skills
      .map { |x| SkillSerializer.new(x).as_json }
  end

  def calendar
    object
      .dayslots
      .map { |d| DayslotSerializer.new(d).as_json }
  end
end
