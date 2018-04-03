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

    resources.each do |r|
      r["calendar"].each do |d|
        s = Schedule.new(week: d["week"], dayOfWeek: d["dayOfWeek"], beginHour: d["beginHour"], endHour: d["endHour"],
                     status: if d["status"] == "Free" then 0 elsif d["status"] == "Used" then 1 else 2 end, feature_id: d["featureId"], resource_id: r["name"])
        plan.schedules << s
      end
    end

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
