require 'net/http'
require 'uri'
require 'json'


class NeoRest
  attr_accessor :data
  @http = Net::HTTP.new("localhost", "7474")

  # Handles both create and update.
  def self.save(node)
    if(node.id.nil?)
       request = Net::HTTP::Post.new("/db/data/node/")
    else
       request = Net::HTTP::Put.new("/db/data/node/#{node.id}/properties")
    end
    request.set_form_data(node.attributes)
    response = @http.request(request)
    if(node.id.nil?)
      node.attributes = dehash_attributes(response) #takes a hash and sets those as actual attributes on the instance, to make each of them callable
    end
    node
  end

  def self.find(id) 
    request  = Net::HTTP::Get.new("/db/data/node/"+id.to_s)
    response = @http.request(request)
    if (response.code == "404")
      raise Exception.new("No node found with an id of #{id}")
    end
    attrs    = dehash_attributes(response)
    # This next line creates an instance of the sub class with the correct attributes based on
    # the "type" attribute.  So "Type" must align with a known sub class of node.
    Object.const_get(attrs[:type]).new(attrs)
  end

  def self.delete(node)
    request = Net::HTTP::Delete.new("/db/data/node/"+ node.id.to_s)
    response = @http.request(request)
  end #get





  def self.put(id, key= "default", value = "poop")
		request = Net::HTTP::Put.new("/db/data/node/#{id}/properties/#{key}")
#		request["content-type"] = "application/json"
		request.body=value
		response = @http.request(request)

	end



	def self.find_by_email(email)
		request = Net::HTTP::Delete.new("/db/data/index/node/my_nodes/DONOR_EMAIL_INDEX/"+email)
		response=@http.request(request)
		dehash_attributes(response)
	end

	def self.find_by_id(unique_id)
		request = Net::HTTP::Delete.new("/db/data/index/node/my_nodes/DONOR_ID_INDEX/"+unique_id.to_s)
		response=@http.request(request)
		dehash_attributes(response)
	end

	def self.dehash_attributes(response)
          response_hash = JSON.parse(response.body)
          attrs = response_hash["data"]
          # Convert all keys to hashes
          attrs = attrs.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

          response_hash["self"].match(/(\d*)$/)

          attrs[:id] = $1.to_i
          attrs
	end

	def self.add_to_index(node, index)
		"y"
	end





end #class

