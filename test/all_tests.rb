# Relative paths are a BEAST in Ruby, this is about as clear as I could get it.
# __FILE__ is the current file (this file) which is known to be one directory up 
# from the base root directory.
curr_dir = File.expand_path "#{File.dirname(__FILE__)}"
Dir["#{curr_dir}/unit/*.rb"].each {|file| 
  require  file }
