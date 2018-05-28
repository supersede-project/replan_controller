class Plan < ApplicationRecord
  belongs_to :release, optional: true
  belongs_to :prev_plan, class_name: "Plan", foreign_key: "plan_id", optional: true, dependent: :destroy
  has_many :schedules, dependent: :destroy

  def self.get_plan(release, multiple_solutions)
    #if force_new
      #if release.starts_at.nil?
       # FakePlanner.plan(release)
      #else
        if multiple_solutions
          ValentinPlanner.plan(release, Rails.application.config.x.optimizer_n_endpoints)
        else
          ValentinPlanner.plan(release, Rails.application.config.x.optimizer_endpoints)
        end
        return release.plans
      #end
    #else
     # if multiple_solutions
      #  return release.plans
      #else
      #  return release.plans.where(isCurrent: true)
      #end
    #end
  end

  #def self.replan(release)
  #  pplan = release.plan
  #  plan = Plan.new(release: release)
  #  unless pplan.nil?
  #    pplan.release = nil
  #    pplan.save
  #    plan.prev_plan = pplan
  #  end
  #  plan.save
  #  return plan
  #end

  def self.replan(release, resources)
    plan = Plan.new(release: release)
    plan.save

    #Rails.logger.info "::plan " + Time.now.strftime("%d/%m/%Y %H:%M:%S")
    values = []
    resources.each do |r|
      r["calendar"].each do |d|
        if d["status"] == "Free" then status = "0" elsif d["status"] == "Used" then status = "1" else status = "2" end
        if d["featureId"] == nil then feature_id = "null" else feature_id = d["featureId"] end
        s = "(" + d['week'].to_s + "," + d['dayOfWeek'].to_s + "," + d['beginHour'].to_s + "," + d['endHour'].to_s + "," + status + "," + r['name'].to_s + "," + feature_id + ", " + plan.id.to_s + ")"
        values.append(s)
      end
    end
    values = values.join(",")
    insert_statement = "INSERT INTO schedules (week, 'dayOfWeek', beginHour, endHour, status, resource_id," +
                                              "feature_id, plan_id) VALUES #{values}";
    Rails.logger.info "::insert statatement into schedules: " + insert_statement
    ActiveRecord::Base.connection.execute(insert_statement)
    #Rails.logger.info "::plan " + Time.now.strftime("%d/%m/%Y %H:%M:%S")

    return plan

  end
  
  def deprecate
    self.destroy
  end
  
  def cancel
    unless self.prev_plan.nil? 
      self.prev_plan.release = self.release
      self.prev_plan.save
    end
    self.destroy
  end
end
