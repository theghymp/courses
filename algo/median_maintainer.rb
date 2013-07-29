# Encoding: utf-8

require './heap'

class MedianMaintainer

  attr_accessor :inputs
  attr_accessor :medians

  def initialize(filename)
    @inputs = File.new(filename).read.split("\n")
    @inputs = @inputs.map { |i| i.to_i }
  end

  def calculate_medians
    heap_low = Containers::MaxHeap.new
    heap_high = Containers::MinHeap.new
    @medians = []

    @inputs.each do |input|
      if heap_low.size == 0 && heap_high.size == 0
        heap_low.push(input) 
      elsif input < heap_low.max
        heap_low.push(input)
      else
        heap_high.push(input)
      end

      if heap_high.size > heap_low.size
        heap_low.push(heap_high.min!)
      elsif heap_low.size > heap_high.size + 1
        heap_high.push(heap_low.max!)
      end

      @medians.push(heap_low.max)
    end 

    @medians
  end

  def summarize_medians
    @medians.inject(:+)
  end
end