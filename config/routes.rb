Rails.application.routes.draw do
=begin
  namespace :admin do
    resources :releases
    resources :skill_resources
    resources :skills
    resources :resources
    resources :projects
  end
=end 

  def add_ui_route http_method, path, opts = {}
    full_path = "/replan" + path.gsub(/{(.*?)}/, ':\1')
    match full_path, to: "#{opts.fetch(:controller_name)}##{opts[:action_name]}", via: http_method
  end
  
  def add_wp3_route http_method, path, opts = {}
    full_path = "/replan" + path.gsub(/{(.*?)}/, ':\1')
    match full_path, to: "#{opts.fetch(:controller_name)}##{opts[:action_name]}", via: http_method
  end

  # new methods
  #add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/plan/{planId}/replan', controller_name: 'plan', action_name: 'replan'
  #add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/plan-n/{planId}/replan', controller_name: 'plan', action_name: 'replan_n'
  #add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/plan-n', controller_name: 'releases', action_name: 'get_release_plan_n'

  #add_ui_route 'PUT', '/projects/{projectId}/releases/{releaseId}/plan', controller_name: 'releases', action_name: 'notify_completed_jobs'
  #add_ui_route 'DELETE', '/projects/{projectId}/releases/{releaseId}/plan', controller_name: 'releases', action_name: 'cancel_last_release_plan'

  #add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/plan', controller_name: 'releases', action_name: 'get_release_plan'
  #add_ui_route 'POST', '/projects/{projectId}/releases/{releaseId}/plan/{planId}/replan', controller_name: 'plan', action_name: 'replan'

  add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/plan', controller_name: 'releases', action_name: 'get_release_plans'
  add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/plan/{planId}', controller_name: 'releases', action_name: 'get_release_plan_by_id'
  add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/current-plan', controller_name: 'releases', action_name: 'get_release_current_plan'

  add_ui_route 'POST', '/projects/{projectId}/releases/{releaseId}/plan', controller_name: 'releases', action_name: 'new_plan'
  add_ui_route 'POST', '/projects/{projectId}/releases/{releaseId}/plan/{planId}/replan', controller_name: 'plan', action_name: 'replan'

  add_ui_route 'POST', '/projects/{projectId}/dayslots', controller_name: 'dayslots', action_name: 'add_new_dayslot_to_project'
  add_ui_route 'GET', '/projects/{projectId}/dayslots', controller_name: 'dayslots', action_name: 'get_dayslots'
  add_ui_route 'GET', '/projects/{projectId}/dayslots/{dayslotId}', controller_name: 'dayslots', action_name: 'get_dayslot'
  add_ui_route 'PUT', '/projects/{projectId}/dayslots/{dayslotId}', controller_name: 'dayslots', action_name: 'modify_dayslot'
  add_ui_route 'DELETE', '/projects/{projectId}/dayslots/{dayslotId}', controller_name: 'dayslots', action_name: 'delete_dayslot'

  add_ui_route 'POST', '/projects/{projectId}/resources/{resourceId}/dayslots', controller_name: 'resources', action_name: 'add_dayslots_to_resource'
  add_ui_route 'DELETE', '/projects/{projectId}/resources/{resourceId}/dayslots', controller_name: 'resources', action_name: 'delete_dayslots_from_resource'
  add_ui_route 'GET', '/projects/{projectId}/resources/{resourceId}/dayslots', controller_name: 'resources', action_name: 'get_dayslots_from_resource'

  # new methods in v.2
  add_ui_route 'GET', '/projects', controller_name: 'project', action_name: 'get_projects'
  add_ui_route 'POST', '/projects', controller_name: 'project', action_name: 'create_project'
  add_ui_route 'DELETE', '/projects/{projectId}', controller_name: 'project', action_name: 'delete_project'
  add_ui_route 'POST', '/projects/{projectId}/features/create_one', controller_name: 'features', action_name: 'create_feature'
  add_ui_route 'DELETE', '/projects/{projectId}/features/{featureId}', controller_name: 'features', action_name: 'delete_feature'
  
  # methods in v.1
  add_wp3_route 'POST', '/projects/{projectId}/features', controller_name: 'wp3_api', action_name: 'receive_wp3_features'
  add_ui_route 'POST', '/projects/{projectId}/releases/{releaseId}/features', controller_name: 'releases', action_name: 'add_features_to_release'
  add_ui_route 'GET', '/projects/{projectId}/features/{featureId}', controller_name: 'features', action_name: 'get_feature'
  add_ui_route 'GET', '/projects/{projectId}/features', controller_name: 'features', action_name: 'get_features'
  add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/features', controller_name: 'releases', action_name: 'get_release_features'
  add_ui_route 'PUT', '/projects/{projectId}/features/{featureId}', controller_name: 'features', action_name: 'modify_feature'
  add_ui_route 'DELETE', '/projects/{projectId}/releases/{releaseId}/features', controller_name: 'releases', action_name: 'remove_features_from_release'
  add_ui_route 'GET', '/projects/{projectId}', controller_name: 'project', action_name: 'get_project'
  add_ui_route 'PUT', '/projects/{projectId}', controller_name: 'project', action_name: 'modify_project'
  add_ui_route 'POST', '/projects/{projectId}/releases/{releaseId}/features', controller_name: 'releases', action_name: 'add_feature_to_release'
  add_ui_route 'POST', '/projects/{projectId}/releases', controller_name: 'releases', action_name: 'add_new_release_to_project'
  add_ui_route 'DELETE', '/projects/{projectId}/releases/{releaseId}', controller_name: 'releases', action_name: 'delete_release'
  add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}/features', controller_name: 'releases', action_name: 'get_release_features'
  add_ui_route 'GET', '/projects/{projectId}/releases', controller_name: 'releases', action_name: 'get_releases'
  add_ui_route 'GET', '/projects/{projectId}/releases/{releaseId}', controller_name: 'releases', action_name: 'get_release'
  add_ui_route 'PUT', '/projects/{projectId}/releases/{releaseId}', controller_name: 'releases', action_name: 'modify_release'
  add_ui_route 'DELETE', '/projects/{projectId}/releases/{releaseId}/features/{featureId}', controller_name: 'releases', action_name: 'remove_feature_from_release'
  add_ui_route 'POST', '/projects/{projectId}/resources', controller_name: 'resources', action_name: 'add_new_resource_to_project'
  add_ui_route 'DELETE', '/projects/{projectId}/resources/{resourceId}', controller_name: 'resources', action_name: 'delete_resource'
  add_ui_route 'GET', '/projects/{projectId}/resources', controller_name: 'resources', action_name: 'get_project_resources'
  add_ui_route 'PUT', '/projects/{projectId}/resources/{resourceId}', controller_name: 'resources', action_name: 'modify_resource'
  add_ui_route 'POST', '/projects/{projectId}/skills', controller_name: 'skills', action_name: 'add_new_skill_to_project'
  add_ui_route 'DELETE', '/projects/{projectId}/skills/{skillId}', controller_name: 'skills', action_name: 'delete_skill'
  add_ui_route 'GET', '/projects/{projectId}/skills', controller_name: 'skills', action_name: 'get_project_skills'
  add_ui_route 'PUT', '/projects/{projectId}/skills/{skillId}', controller_name: 'skills', action_name: 'modify_skill' 
  add_ui_route 'DELETE', '/projects/{projectId}/resources/{resourceId}/skills', controller_name: 'resources', action_name: 'delete_skills_from_resource'
  add_ui_route 'POST', '/projects/{projectId}/resources/{resourceId}/skills', controller_name: 'resources', action_name: 'add_skills_to_resource'
  add_ui_route 'POST', '/projects/{projectId}/releases/{releaseId}/resources', controller_name: 'releases', action_name: 'add_resources_to_release'
  add_ui_route 'DELETE', '/projects/{projectId}/releases/{releaseId}/resources', controller_name: 'releases', action_name: 'delete_resources_from_release'
  add_ui_route 'POST', '/projects/{projectId}/features/{featureId}/skills', controller_name: 'features', action_name: 'add_skills_to_feature'
  add_ui_route 'DELETE', '/projects/{projectId}/features/{featureId}/skills', controller_name: 'features', action_name: 'delete_skills_from_feature'
  add_ui_route 'POST', '/projects/{projectId}/features/{featureId}/dependencies', controller_name: 'features', action_name: 'add_dependencies_to_feature'
  add_ui_route 'DELETE', '/projects/{projectId}/features/{featureId}/dependencies', controller_name: 'features', action_name: 'delete_dependencies_from_feature'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
