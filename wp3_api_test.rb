require 'uri'
require 'net/http'

#url = URI("http://supersede.es.atos.net:8280/replan/projects/atos/features/create_one")

url = URI("https://195ebd341379412eaf7e915b143b86d5.vfs.cloud9.eu-west-1.amazonaws.com/api/ui/v1/projects/atos/features/create_one")

http = Net::HTTP.new(url.host, url.port)

http.use_ssl = true

bad_string = (980..1000).to_a.pack('c*').force_encoding('utf-8')

puts bad_string

id1 = 9107
id2 = 9106

request = Net::HTTP::Post.new(url)
request["Content-Type"] = 'application/json'
request["Cache-Control"] = 'no-cache'
request["Postman-Token"] = 'd0fd6223-3629-fd63-ea7e-48c474f5471a'
#request.body = "{\"features\":[{\"id\":#{id1},\"name\":\"New login form\",\"effort\":5,\"priority\":\"5\",\"properties\":[{\"key\":\"description\",\"value\":\"#{bad_string}\",\"format\":\"string\"}],\"hard_dependencies\":[]},{\"id\":#{id2},\"name\":\"#{bad_string}\",\"effort\":23,\"priority\":\"2\",\"properties\":[],\"hard_dependencies\":[]}],\"evaluation_time\":\"2016-10-21\"}"
request.body = "{\"code\":#{id1},\"name\":\"Iwantyoutofail\",\"description\":\"#{bad_string}\",\"effort\":40,\"deadline\":\"2018-03-18T18:46:25.655Z\",\"priority\":1}"
puts request.body

response = http.request(request)
puts response.read_body