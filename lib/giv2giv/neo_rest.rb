require 'net/http'
require 'uri'
require 'json'

def getData()
  url  = 'http://localhost:7474/db/data/'
  resp = Net::HTTP.get_response(URI.parse(url)) # get_response takes an URI object
  data = resp.body
end

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


	def self.put(id, key= "default", value = "poop")
		request = Net::HTTP::Put.new("/db/data/node/#{id}/properties/#{key}")
#		request["content-type"] = "application/json"
		request.body=value
		response = @http.request(request)

	end

	def self.post(key = "id", value = generate_unique_id())
		request = Net::HTTP::Post.new("/db/data/node/")
		request.set_form_data({key=>value})
		response = @http.request(request)
		dehash_attributes(response)
	end

	def self.get(id)
		request = Net::HTTP::Get.new("/db/data/node/"+id.to_s)
		response = @http.request(request)
		dehash_attributes(response)
	end #get

	def self.delete(id)
		request = Net::HTTP::Delete.new("/db/data/node/"+id.to_s)
		response = @http.request(request)
	end #get

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

=begin
the above method call gives a nasty error in the neo4j logs: 

May 13, 2013 11:12:49 PM com.sun.jersey.spi.container.ContainerResponse mapMappableContainerException
SEVERE: The RuntimeException could not be mapped to a response, re-throwing to the HTTP container
java.lang.RuntimeException: Not implemented!
	at org.neo4j.server.rest.repr.formats.UrlFormFormat.readValue(UrlFormFormat.java:78)
	at org.neo4j.server.rest.web.RestfulGraphDatabase.setNodeProperty(RestfulGraphDatabase.java:307)
	at sun.reflect.GeneratedMethodAccessor57.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:616)
	at com.sun.jersey.spi.container.JavaMethodInvokerFactory$1.invoke(JavaMethodInvokerFactory.java:60)
	at com.sun.jersey.server.impl.model.method.dispatch.AbstractResourceMethodDispatchProvider$ResponseOutInvoker._dispatch(AbstractResourceMethodDispatchProvider.java:205)
	at com.sun.jersey.server.impl.model.method.dispatch.ResourceJavaMethodDispatcher.dispatch(ResourceJavaMethodDispatcher.java:75)
	at com.sun.jersey.server.impl.uri.rules.HttpMethodRule.accept(HttpMethodRule.java:288)
	at com.sun.jersey.server.impl.uri.rules.RightHandPathRule.accept(RightHandPathRule.java:147)
	at com.sun.jersey.server.impl.uri.rules.ResourceClassRule.accept(ResourceClassRule.java:108)
	at com.sun.jersey.server.impl.uri.rules.RightHandPathRule.accept(RightHandPathRule.java:147)
	at com.sun.jersey.server.impl.uri.rules.RootResourceClassesRule.accept(RootResourceClassesRule.java:84)
	at com.sun.jersey.server.impl.application.WebApplicationImpl._handleRequest(WebApplicationImpl.java:1469)
	at com.sun.jersey.server.impl.application.WebApplicationImpl._handleRequest(WebApplicationImpl.java:1400)
	at com.sun.jersey.server.impl.application.WebApplicationImpl.handleRequest(WebApplicationImpl.java:1349)
	at com.sun.jersey.server.impl.application.WebApplicationImpl.handleRequest(WebApplicationImpl.java:1339)
	at com.sun.jersey.spi.container.servlet.WebComponent.service(WebComponent.java:416)
	at com.sun.jersey.spi.container.servlet.ServletContainer.service(ServletContainer.java:537)
	at com.sun.jersey.spi.container.servlet.ServletContainer.service(ServletContainer.java:699)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:820)
	at org.mortbay.jetty.servlet.ServletHolder.handle(ServletHolder.java:511)
	at org.mortbay.jetty.servlet.ServletHandler.handle(ServletHandler.java:390)
	at org.mortbay.jetty.servlet.SessionHandler.handle(SessionHandler.java:182)
	at org.mortbay.jetty.handler.ContextHandler.handle(ContextHandler.java:765)
	at org.mortbay.jetty.handler.HandlerCollection.handle(HandlerCollection.java:114)
	at org.mortbay.jetty.handler.HandlerWrapper.handle(HandlerWrapper.java:152)
	at org.mortbay.jetty.Server.handle(Server.java:326)
	at org.mortbay.jetty.HttpConnection.handleRequest(HttpConnection.java:542)
	at org.mortbay.jetty.HttpConnection$RequestHandler.content(HttpConnection.java:943)
	at org.mortbay.jetty.HttpParser.parseNext(HttpParser.java:756)
	at org.mortbay.jetty.HttpParser.parseAvailable(HttpParser.java:218)
	at org.mortbay.jetty.HttpConnection.handle(HttpConnection.java:404)
	at org.mortbay.io.nio.SelectChannelEndPoint.run(SelectChannelEndPoint.java:410)
	at org.mortbay.thread.QueuedThreadPool$PoolThread.run(QueuedThreadPool.java:582)

=end


