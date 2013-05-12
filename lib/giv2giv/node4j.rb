require 'net/http'


def getData()
  url  = 'http://localhost:7474/db/data/'
  resp = Net::HTTP.get_response(URI.parse(url)) # get_response takes an URI object
  data = resp.body
end


puts getData()



