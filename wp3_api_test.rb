require 'uri'
require 'net/http'

url = URI("https://supersede-replan-controller-carlesf.c9users.io/api/wp3/v1/projects/atos/features")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

bad_string = (980..1000).to_a.pack('c*').force_encoding('utf-8')

puts bad_string

id1 = 9105
id2 = 9106

request = Net::HTTP::Post.new(url)
request["Content-Type"] = 'application/json'
request["Cache-Control"] = 'no-cache'
request["Postman-Token"] = 'd0fd6223-3629-fd63-ea7e-48c474f5471a'
request.body = "{\"features\":[{\"id\":#{id1},\"name\":\"New login form\",\"effort\":5,\"priority\":\"5\",\"properties\":[{\"key\":\"description\",\"value\":\"#{bad_string}\",\"format\":\"string\"}],\"hard_dependencies\":[]},{\"id\":#{id2},\"name\":\"#{bad_string}\",\"effort\":23,\"priority\":\"2\",\"properties\":[],\"hard_dependencies\":[]}],\"evaluation_time\":\"2016-10-21\"}"
puts request.body

response = http.request(request)
puts response.read_body