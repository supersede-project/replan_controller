class SmallFeatureSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :description, :effort, :deadline, :priority, :release
  
  def effort
    object.effort.to_f
  end
  
  def description
    (object.description.nil? or object.description.valid_encoding?) ? object.description : object.description.scrub
  end
  
  def name
    (object.name.nil? or object.name.valid_encoding?) ? object.name : object.name.scrub
  end
  
  def release
    if not object.release.nil?
      {"release_id" => object.release.id}.as_json
    else
      "pending"
    end
  end
end
