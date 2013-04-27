root = ::File.dirname(__FILE__)
require ::File.join( root, 'app' )

set :run, false
set :raise_errors, true
 
run Sinatra::Application.new
