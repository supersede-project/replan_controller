class ApplicationController < ActionController::API
  
  before_action :set_project
  
  def set_project
      if params.has_key?(:projectId)
        id = params[:projectId]
        case id
          when "siemens"
            id = 1
          when "senercon"
            id = 2
          when "atos"
            id = 3
          when "review"
            id = 4
        end
        @project = Project.find(id)
      end
  end
  
end