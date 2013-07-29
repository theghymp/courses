# Encoding: utf-8

require 'minitest/autorun'
require './two_sum'

describe TwoSum do 
  
  it "should initialize with a filename, a lower bound and an upper bound" do
    ts = TwoSum.new('HashInt.txt', 2500, 4000)
    ts.must_be_instance_of TwoSum
    ts.ints.size.must_equal 204
  end

  it "should count the number of possible sums within the bounds" do
    ts = TwoSum.new('HashInt.txt', 2500, 4000)
    possible_sums = ts.find_num_two_sums
    possible_sums.size.must_equal 1477
  end
end