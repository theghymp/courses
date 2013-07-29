# Encoding: utf-8

A = []

File.readlines('QuickSort.txt').each do |line|
  A << line.to_i
end

class Sorter

  attr_accessor :num_comparisons

  def initialize
    @num_comparisons = 0
  end

  def quicksort(array, left_boundary, right_boundary)
    if right_boundary - left_boundary < 1 then return
    else
      @num_comparisons += (right_boundary - left_boundary)
      left_left_boundary, left_right_boundary,
      right_left_boundary, right_right_boundary =
        partition(array, left_boundary, right_boundary)
      quicksort(array, left_left_boundary, left_right_boundary)
      quicksort(array, right_left_boundary, right_right_boundary)
    end
    return @num_comparisons
  end

  def partition(array, left_boundary, right_boundary)

    # puts array[left_boundary..right_boundary].to_s
    pivot = array[left_boundary]
    i = left_boundary + 1
    ((left_boundary + 1)..right_boundary).each do |j|
      if array[j] < pivot
        array[i], array[j] = array[j], array[i]
        i += 1
      end
    end

    array[left_boundary], array[i - 1] = array[i - 1], array[left_boundary]

    left_left_boundary = left_boundary
    left_right_boundary = i - 2

    right_left_boundary = i
    right_right_boundary = right_boundary

    return left_left_boundary, left_right_boundary,
      right_left_boundary, right_right_boundary
  end

  def sort_check(array)
    wrong_elements = {}
    array.each_with_index do |element, i|
      wrong_elements[element] = i + 1 if element != (i + 1)
    end
    return wrong_elements
  end

end

s = Sorter.new

puts s.quicksort(A, 0, A.length - 1).to_s
puts A.to_s

wrong_elements = s.sort_check(A)

puts wrong_elements.to_s
puts wrong_elements.size

