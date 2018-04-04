class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :resources
  
  def resources
    object
      .resources
      .map { |x| ResourceSerializer.new(x).as_json }
  end
end
