class ValentinPlanner
    include ActiveModel::Model
    
    MAX_TIME = 15 # seconds
    MAX_ITERATIONS = 1

    # Edit here to plan accordingly
    def self.plan(release)
      
      uris = Rails.application.config.x.optimizer_endpoints # as defined in config/initializers/optimizer_endpoints.rb
      
      payload = self.build_payload(release)
      Rails.logger.info "\nCalling replan_optimizer with payload = #{payload}\n"
      response = "";
      sol = Array.new
      ftime = 0
      mutex = Mutex.new
      threads = []
      uris.each do |uri|
        Rails.logger.info "::plan Calling to #{uri}"
        threads << Thread.new do
          ttime = 0
          resourceArray = Array.new
          time = Benchmark.realtime do
            begin
              response = RestClient::Request.execute(method: :post, url: uri, payload: payload,  timeout: MAX_TIME, headers: {content_type: :json, accept: :json})
              #response = RestClient.post uri, payload,  {content_type: :json, accept: :json}
              resourceArray = JSON.parse(response.body)["employees"]
              rescue RestClient::Exceptions::ReadTimeout
              rescue RestClient::Exceptions::OpenTimeout
              rescue RestClient::InternalServerError
              rescue Errno::ECONNREFUSED
            end
          end
          sol = resourceArray
          mutex.synchronize do
            ftime += ttime
          end
        end
      end
      threads.map(&:join)
      #puts "FINAL -> Num jobs/Num features: #{numJobs}/#{numFeatures} in #{ftime} seconds"
      self.build_plan(release, sol)
    end
  
  private

    # Edit to add new data
    def self.build_payload(release)
      project = release.project
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
    
    
    def self.build_plan(release, resources)

      plan = Plan.replan(release, resources)


      #resources.each do |r|
      #  r["calendar"].each do |d|
      #    Rails.logger.info "::plan New DaySlot#{d}"
      #  end
        #dayslots.each do |d|
        #  Rails.logger.info "::plan #{r.as_json}"
        #  new_dayslot = r["calendar"].where(:code => d.code)
        #  Rails.logger.info "::plan #{new_dayslot}\n"
        #  d.update(new_dayslot.to_param)
        #  Rails.logger.info "::plan Updated slot #{Dayslot.where(:id => d.id)}\n"
        #end
        #
      #end
    end
end