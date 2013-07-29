# Encoding: utf-8

class TwoSum
  attr_accessor :ints
  attr :lower_bound
  attr :upper_bound

  def initialize(filename, lower_bound, upper_bound)
    @ints = {}
    @lower_bound = lower_bound
    @upper_bound = upper_bound

    File.new(filename).read.split("\n").each do |i|
      i = i.to_i
      @ints[i] = i if i <= upper_bound
    end
  end

  def find_num_two_sums
    keys = @ints.keys
    possible_sums = []

    (@lower_bound..@upper_bound).each do |sum|
      keys.each do |k|
        unless sum - k == k
          if @ints[sum - k]
            unless possible_sums.include? sum
              possible_sums << sum
            end
          end
        end
      end
    end

    possible_sums
  end

end