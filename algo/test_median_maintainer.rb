# Encoding: utf-8

require 'minitest/autorun'
require './median_maintainer'

describe MedianMaintainer do
  
  it "should load a file of integers" do
    mm = MedianMaintainer.new('MedianTestInts.txt')
    mm.must_be_instance_of MedianMaintainer
    mm.wont_be_nil
    mm.inputs.size.must_equal 9
  end

  it "should calculate the medians as a list of integers is input" do
    mm = MedianMaintainer.new('MedianTestInts.txt')
    median_array = mm.calculate_medians
    median_array[0].must_equal 3
    median_array[1].must_equal 3
    median_array[2].must_equal 8
    median_array[3].must_equal 4
    median_array[4].must_equal 7
  end

  it "should sum the medians" do
    mm = MedianMaintainer.new('MedianTestInts.txt')
    mm.calculate_medians
    mm.summarize_medians.must_equal 47
  end

  it "should answer to the homework problem set" do
    mm = MedianMaintainer.new('Median.txt')
    mm.calculate_medians
    total = mm.summarize_medians
    answer = total % 10000
    puts "total: #{total}"
    puts "answer: #{answer}"
  end
end