require 'uri'
require 'net/http'

(1335..2157).to_a.each do |rID|
    url = URI("http://supersede.es.atos.net:8280/replan/projects/siemens/resources/#{rID}")
    
    http = Net::HTTP.new(url.host, url.port)
    
    request = Net::HTTP::Delete.new(url)
    request["Accept"] = 'application/json'
    request["Cache-Control"] = 'no-cache'
    request["Postman-Token"] = 'f6433161-6ae7-5e5b-8f47-73aecce5d3c8'
    
    response = http.request(request)
    puts response.read_body
end