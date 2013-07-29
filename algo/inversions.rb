# Encoding: utf-8

A = []

File.readlines('IntegerArray.txt').each do |line|
  A << line.to_i
end

def sort_and_count(integer_array)

  if integer_array.length == 1
    return integer_array, 0
  else
    total_inversions = 0

    midpoint = integer_array.length / 2
    left_array = integer_array[0...midpoint]
    right_array = integer_array[(midpoint)..(integer_array.length - 1)]
    left_sorted_array, num_left_inversions = sort_and_count(left_array)
    right_sorted_array, num_right_inversions = sort_and_count(right_array)

    sorted_array, num_split_inversions =
      merge_and_count_split_inv(left_sorted_array, right_sorted_array)


    if num_left_inversions
      total_inversions = num_left_inversions
    end

    if num_right_inversions
      total_inversions = total_inversions + num_right_inversions
    end

    if num_split_inversions
      total_inversions = total_inversions + num_split_inversions
    end

    return sorted_array, total_inversions
  end
end

def merge_and_count_split_inv(orig_left_array, orig_right_array)

  left_array = orig_left_array.dup
  right_array = orig_right_array.dup

  sorted_array = []
  num_split_inversions = 0

  total_size = left_array.size + right_array.size

  (0..(total_size - 1)).each do |i|
    case
    when left_array[0] && right_array[0] && left_array[0] < right_array[0]
      sorted_array[i] = left_array[0]
      left_array.delete_at(0)
    when !left_array[0].nil? && !right_array[0].nil?
      sorted_array[i] = right_array[0]
      num_split_inversions = num_split_inversions + left_array.size
      right_array.delete_at(0)
    when left_array[0].nil? && right_array[0]
      sorted_array[i] = right_array[0]
      right_array.delete_at(0)
    when right_array[0].nil? && left_array[0]
      sorted_array[i] = left_array[0]
      left_array.delete_at(0)
    end
  end

  return sorted_array, num_split_inversions
end

sorted_array, total_inversions = sort_and_count(A)

# puts sorted_array.to_s
puts total_inversions
