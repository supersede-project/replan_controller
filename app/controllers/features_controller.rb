=begin
SUPERSEDE ReleasePlanner API to UI

OpenAPI spec version: 1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=end
class FeaturesController < ApplicationController
  before_action :set_feature, only: [:delete_feature,
                                     :get_feature, :modify_feature, 
                                     :remove_feature_from_release,
                                     :add_skills_to_feature,
                                     :delete_skills_from_feature,
                                     :add_dependencies_to_feature,
                                     :delete_dependencies_from_feature]

  # New in v.2
  def create_feature
    if @project.features.find_by(code: params[:code]).nil?
      @feature = @project.features.build(feature_params_with_code)
      if @feature.save
        render json: @feature
      else
        render json: @feature.errors, status: :unprocessable_entity
      end
    else
      error = Error.new(code:400,
                message: "Already exists feature with code = #{params[:code]}", 
                fields: "feature.code")
      render json: error, status: 400
    end
  end
  
  def delete_feature
    @feature.destroy
    render json: {"message" => "Feature removed"}
  end

  #--------------
  def get_feature
    render json: @feature
  end

  def get_features
    filter = params[:status]
    unless params[:code].nil?
      feature_list = @project.features.where(code: params[:code].split(','))
    else
      feature_list = @project.features
    end
    if not filter.nil?
      case filter
      when "any"
        @features = feature_list
      when "pending" 
        @features = feature_list.select{|f| f.release.nil?}
      when "in_release"
        @features = feature_list.select{|f| !f.release.nil?}
      when "scheduled" 
        @features = feature_list.select{|f| !f.current_job.nil?}
      else
        render(status: :bad_request) and return
      end
    else
      @features = feature_list
    end
    render json: @features
  end

  def modify_feature
    if @feature.update(feature_params)
      render json: @feature
    else
      render json: @feature.errors, status: :unprocessable_entity
    end
  end
  
  def add_skills_to_feature
    params[:_json].each do |s|
        skill = @project.skills.find_by(id: s[:skill_id])
          if skill and not @feature.required_skills.exists?(id: s[:skill_id])
            @feature.required_skills << skill
          end
    end
    render json: @feature
  end

  def delete_skills_from_feature
    params[:skill_id].each do |i|
        skill = @feature.required_skills.find_by(id: i)
          if skill
            @feature.required_skills.delete(skill)
          end
      end
    render json: @feature
  end

  def add_dependencies_to_feature
    params[:_json].each do |f|
        feature = @project.features.find_by(id: f[:feature_id])
          if feature and not @feature.depends_on.exists?(id: f[:feature_id]) \
                     and @feature.id != feature.id
            @feature.depends_on << feature
          end
    end
    render json: @feature
  end

  def delete_dependencies_from_feature
    params[:feature_id].split(",").each do |i|
        feature = @feature.depends_on.find_by(id: i)
          if feature
            @feature.depends_on.delete(feature)
          end
      end
    render json: @feature
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = @project.features.find(params[:featureId])
    end
    
    def feature_params
      params.require(:feature).permit(:name, :description, :effort, :deadline,
                                      :priority)
    end
    
    def feature_params_with_code
      params.require(:feature).permit(:code, :name, :description, :effort, :deadline,
                                      :priority)
    end
end
