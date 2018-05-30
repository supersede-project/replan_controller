require 'uri'
require 'net/http'

(895..1504).to_a.each do |skillId|
    url = URI("http://supersede.es.atos.net:8280/replan/projects/siemens/skills/#{skillId}")
    
    http = Net::HTTP.new(url.host, url.port)
    
    request = Net::HTTP::Delete.new(url)
    request["Accept"] = 'application/json'
    request["Cache-Control"] = 'no-cache'
    request["Postman-Token"] = 'f6433161-6ae7-5e5b-8f47-73aecce5d3c8'
    
    response = http.request(request)
    puts response.read_body
end