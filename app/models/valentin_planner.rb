class ValentinPlanner
    include ActiveModel::Model
    
    MAX_TIME = 15 # seconds
    MAX_ITERATIONS = 1

    def self.replan(plan, week, dayOfWeek, beginHour, uris)
      release = plan.release
      payload = build_replan_payload(plan, week, dayOfWeek, beginHour, )
      sol = call(payload, uris)
      self.build_plan(release, sol)
      return release
    end

    # Edit here to plan accordingly
    def self.plan(release, uris)
      payload = self.build_payload(release)
      sol = call(payload, uris)
      self.build_plan(release, sol)
    end
  
  private

    def self.call(payload, uris)
      Rails.logger.info "\nCalling replan_optimizer with payload = #{payload}\n"
      response = "";
      sol = Array.new
      ftime = 0
      mutex = Mutex.new
      threads = []
      Rails.logger.info "::plan #{uris}"
      uris.each do |uri|
        Rails.logger.info "::plan Calling to #{uri}"
        threads << Thread.new do
          ttime = 0
          time = Benchmark.realtime do
            begin
              response = RestClient::Request.execute(method: :post, url: uri, payload: payload,  timeout: MAX_TIME, headers: {content_type: :json, accept: :json})
              Rails.logger.info "::plan response #{response}"
              sol = JSON.parse(response.body)
            rescue RestClient::Exceptions::ReadTimeout
            rescue RestClient::Exceptions::OpenTimeout
            rescue RestClient::InternalServerError
            rescue Errno::ECONNREFUSED
            end
          end
          mutex.synchronize do
            ftime += ttime
          end
        end
      end
      threads.map(&:join)
      return sol
    end

    # Edit to add new data
    def self.build_payload(release)
      nrp = Hash.new
      nrp[:features] = release.features.map {|f| self.build_feature(f) }
      nrp[:resources] = release.resources.map do |r|
        { name: r.id.to_s, 
          skills: r.skills.map {|s| {name: s.id.to_s} },
          calendar: r.dayslots.map {|d| {id: d.id,
                                         week: d.week,
                                         dayOfWeek: d.dayOfWeek,
                                         beginHour: d.beginHour,
                                         endHour: d.endHour,
                                         status: "Free"
          }
          }
        }
      end

      nrp[:resources].each do |r|
        if r[:calendar] == nil || r[:calendar].count.zero?
          r[:calendar] = generate_dayslots(release, Resource.where(id: r[:name]).first())
        end
      end

      nrp.to_json
    end

    def self.generate_dayslots(release, r)
      dayslots = []
      nbWeeks = release.num_weeks
      availability = r.availability
      nbWeeks.times do |i|
        5.times do |n|
          dayslots << {id: (i)*5 + (n+1),
                       week: i+1,
                       dayOfWeek: (n+1)%6,
                       beginHour: 8.0,
                       endHour: 8.0 + availability / 100 * 8.0,
                       status: "Free"
          }
        end
      end
      return dayslots
    end

    def self.build_replan_payload(plan, week, dayOfWeek, beginHour)
      ## filter schedules plan by resource
      release = plan.release
      nrp = Hash.new
      nrp[:features] = release.features.map {|f| self.build_feature(f) }
      nrp[:resources] = release.resources.map do |r|
        { name: r.id.to_s,
          skills: r.skills.map {|s| {name: s.id.to_s} },
          calendar: plan.schedules.where(resource_id: r.id).map {|d| {id: d.id,
                                         week: d.week,
                                         dayOfWeek: d.dayOfWeek,
                                         beginHour: d.beginHour,
                                         endHour: d.endHour,
                                         status: if d.status == 0 then "Free" elsif d.status == 1 then "Used" else "Frozen" end,
                                         featureId: d.feature_id
          }
          }
        }
      end
      nrp[:replanTime] = {week: week, dayOfWeek: dayOfWeek, beginHour: beginHour}
      nrp.to_json
    end
    
    def self.build_feature(feature)
      self.build_plain_feature(feature).merge(
        { 
          depends_on: feature.depends_on.map {|d| self.build_plain_feature(d) unless d.release.nil? || d.release != feature.release}.compact
        }
      )
    end
    
    def self.build_plain_feature(feature)
      { name: feature.id.to_s,
        duration: feature.effort_hours,
        priority: { level: feature.priority, score: feature.priority },
        required_skills: feature.required_skills.map {|s| {name: s.id.to_s} }
      }
    end
    
    
    def self.build_plan(release, sol)

      Rails.logger.info "::plan Destroying previous plans"
      #Destroy all plans before updating them
      release.plans.destroy_all

      begin
        Rails.logger.info "::plan Creating plan"
        plan = Plan.replan(release, sol["employees"])
        plan.isCurrent = true
        plan.priorityQuality = sol["priorityQuality"]
        plan.performanceQuality = sol["performanceQuality"]
        plan.similarityQuality = sol["similarityQuality"]
        plan.globalQuality = sol["globalQuality"]
        release.plans << plan
      rescue TypeError
        #array result
        isCurrent = true
        sol.each do |res|
          Rails.logger.info "::plan Creating plan-n"
          plan = Plan.replan(release, res["employees"])
          plan.isCurrent = isCurrent
          plan.priorityQuality = res["priorityQuality"]
          plan.performanceQuality = res["performanceQuality"]
          plan.similarityQuality = res["similarityQuality"]
          plan.globalQuality = res["globalQuality"]
          if (isCurrent == true)
            isCurrent = false
          end
          release.plans << plan
        end
      end


    end
end