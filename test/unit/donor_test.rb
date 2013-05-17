ENV['RACK_ENV'] = 'test'
require 'test/unit'

root_dir = File.expand_path "#{File.dirname(__FILE__)}/../.."
require "#{root_dir}/models/donor"

class DonorTest < Test::Unit::TestCase

  def test_create_donor
    donor = Donor.new(:email => "daniel.h.funk@gmail.com",
                      :name => "dan")
    assert_not_nil donor
  end


end